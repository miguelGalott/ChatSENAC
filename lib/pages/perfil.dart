import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:primeiro_app/servicos/AuthService.dart';

class Perfil extends StatefulWidget {
  final int meuId; // ID do usuário logado, vem de quem chamou essa tela

  const Perfil({super.key, required this.meuId});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _campoEditavelController =
  TextEditingController();

  Map<String, dynamic>? _usuario; // dados carregados do banco
  bool _carregando = true;

  // Controla a caixinha de escolha: "NOME" ou "EMAIL"
  String _campoSelecionado = 'NOME';

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
  }

  @override
  void dispose() {
    _campoEditavelController.dispose();
    super.dispose();
  }

  Future<void> _carregarUsuario() async {
    final dados = await AuthService.buscarUsuarioPorId(widget.meuId);
    setState(() {
      _usuario = dados;
      _carregando = false;
      // já deixa o campo de texto preenchido com o valor atual do NOME
      _campoEditavelController.text = dados?['NOME'] ?? '';
    });
  }

  // Troca o valor mostrado no campo de texto quando o usuário
  // muda a escolha no dropdown (NOME <-> EMAIL)
  void _aoTrocarCampoSelecionado(String? novoValor) {
    if (novoValor == null) return;
    setState(() {
      _campoSelecionado = novoValor;
      _campoEditavelController.text = novoValor == 'NOME'
          ? (_usuario?['NOME'] ?? '')
          : (_usuario?['EMAIL'] ?? '');
    });
  }

  Future<void> _selecionarFotoDaGaleria() async {
    final XFile? imagemSelecionada = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (imagemSelecionada == null) return;

    bool sucesso =
    await AuthService.atualizarFoto(widget.meuId, imagemSelecionada.path);

    if (!mounted) return;

    if (sucesso) {
      setState(() {
        _usuario!['FOTO'] = imagemSelecionada.path;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto atualizada!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar a foto.')),
      );
    }
  }

  Future<void> _salvarCampoEditavel() async {
    String novoValor = _campoEditavelController.text.trim();

    if (novoValor.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O campo não pode ficar vazio.')),
      );
      return;
    }

    bool sucesso;
    if (_campoSelecionado == 'NOME') {
      sucesso = await AuthService.atualizarNome(widget.meuId, novoValor);
    } else {
      sucesso = await AuthService.atualizarEmail(widget.meuId, novoValor);
    }

    if (!mounted) return;

    if (sucesso) {
      setState(() {
        _usuario![_campoSelecionado] = novoValor; // atualiza na tela na hora
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _campoSelecionado == 'NOME'
                ? 'Nome atualizado!'
                : 'Email atualizado!',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar. Tente de novo.')),
      );
    }
  }

  // Mesma lógica de exibição de foto que você já usa em outras telas:
  // se for URL usa NetworkImage, se for caminho local usa FileImage
  ImageProvider? _imagemDoUsuario(String? caminhoFoto) {
    if (caminhoFoto == null || caminhoFoto.isEmpty) return null;
    if (caminhoFoto.startsWith('http://') ||
        caminhoFoto.startsWith('https://')) {
      return NetworkImage(caminhoFoto);
    }
    return FileImage(File(caminhoFoto));
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        backgroundColor: Colors.black87,
        body: Center(
          child: CircularProgressIndicator(color: Colors.blue),
        ),
      );
    }

    if (_usuario == null) {
      return const Scaffold(
        backgroundColor: Colors.black87,
        body: Center(
          child: Text(
            'Não foi possível carregar o perfil.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final String id = _usuario!['ID'].toString();
    final String nome = _usuario!['NOME'] ?? '';
    final String email = _usuario!['EMAIL'] ?? '';
    final String? foto = _usuario!['FOTO'];

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Meu Perfil",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Linha de cima: foto grande à direita + ID/Nome/Email ----
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Textos (ID, Nome, Email) ficam à esquerda
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ID: $id",
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        nome,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        email,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Foto grande, clicável, no canto superior direito
                GestureDetector(
                  onTap: _selecionarFotoDaGaleria,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey[800],
                        backgroundImage: _imagemDoUsuario(foto),
                        child: _imagemDoUsuario(foto) == null
                            ? const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 50,
                        )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 36),
            const Divider(color: Colors.white24),
            const SizedBox(height: 16),

            const Text(
              "O que você quer editar?",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 10),


            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _campoSelecionado,
                  isExpanded: true,
                  dropdownColor: Colors.grey[900],
                  style: const TextStyle(color: Colors.white),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  items: const [
                    DropdownMenuItem(value: 'NOME', child: Text('Nome')),
                    DropdownMenuItem(value: 'EMAIL', child: Text('Email')),
                  ],
                  onChanged: _aoTrocarCampoSelecionado,
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _campoEditavelController,
              style: const TextStyle(color: Colors.white),
              keyboardType: _campoSelecionado == 'EMAIL'
                  ? TextInputType.emailAddress
                  : TextInputType.text,
              decoration: InputDecoration(
                hintText: _campoSelecionado == 'NOME'
                    ? 'Digite o novo nome'
                    : 'Digite o novo email',
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _salvarCampoEditavel,
                child: const Text(
                  "Salvar",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}