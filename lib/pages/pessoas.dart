import 'dart:io';
import 'package:flutter/material.dart';
import 'package:primeiro_app/servicos/AuthService.dart';
import 'chart.dart';
import 'criar.dart';

class Entrada extends StatefulWidget {
  const Entrada({super.key});

  @override
  State<Entrada> createState() => _EntradaState();
}

class _EntradaState extends State<Entrada> {
  late Future<List<Map<String, dynamic>>> _futureUsuarios;

  @override
  void initState() {
    super.initState();
    _futureUsuarios = AuthService.listarUsuarios();
  }

  Widget _construirImagemPerfil(String caminhoFoto) {
    if (caminhoFoto.isEmpty) {
      return const Icon(Icons.person, color: Colors.white, size: 40);
    }

    if (caminhoFoto.startsWith('http://') || caminhoFoto.startsWith('https://')) {
      return Image.network(
        caminhoFoto,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.person, color: Colors.white),
      );
    }

    return Image.file(
      File(caminhoFoto),
      width: 40,
      height: 40,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
      const Icon(Icons.person, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        toolbarHeight: 100,
        title: Column(
          children: const [
            Text(
              "SenaChat",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Por favor escolha um dos usuários abaixo para conversar",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _futureUsuarios,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        "Nenhum usuário cadastrado ainda.",
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }

                  final usuarios = snapshot.data!;

                  return ListView.builder(
                    itemCount: usuarios.length,
                    itemBuilder: (context, index) {
                      final usuario = usuarios[index];
                      final String nomeUsuario = usuario['NOME'] ?? 'Usuário';
                      final String fotoPerfil = usuario['FOTO'] ?? '';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Chat(
                                    nome: nomeUsuario,
                                    idUsuarioDestino: usuario['ID'],
                                    meuId: 1,
                                  ),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: _construirImagemPerfil(fotoPerfil),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  nomeUsuario,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Cadastro(),
                    ),
                  );

                  setState(() {
                    _futureUsuarios = AuthService.listarUsuarios();
                  });
                },
                child: const Text(
                  "Adicionar Usuários",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Se não tiver um por favor crie",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}