import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:primeiro_app/bancoDados/conect.dart';
import 'pessoas.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final TextEditingController controllerUsu = TextEditingController();
  final TextEditingController controllerSenha = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();


  String? _caminhoFoto;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    controllerUsu.dispose();
    controllerSenha.dispose();
    controllerEmail.dispose();
    super.dispose();
  }


  Future<void> _selecionarFotoDaGaleria() async {
    final XFile? imagemSelecionada = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (imagemSelecionada != null) {
      setState(() {
        _caminhoFoto = imagemSelecionada.path;
      });
    }
  }

  static Future<bool> cadastrarUsuario(
      String usu,
      String senha,
      String email,
      String foto,
      ) async {
    try {
      Database db = await ConexaoSqflite.obterConexao();

      int idGerado = await db.rawInsert(
        'INSERT INTO USUARIOS (NOME, SENHA, EMAIL, FOTO) VALUES (?, ?, ?, ?)',
        [usu, senha, email, foto],
      );

      print("Usuário cadastrado com sucesso! ID: $idGerado");
      return idGerado > 0;
    } catch (e) {
      print("Erro ao cadastrar no SQLite: $e");
      return false;
    }
  }

  void cadastrar() async {
    String usuarioDig = controllerUsu.text;
    String senhaDig = controllerSenha.text;
    String emailDig = controllerEmail.text;


    String fotoParaSalvar = _caminhoFoto ?? "";

    if (usuarioDig.isEmpty || senhaDig.isEmpty || emailDig.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha os campos obrigatórios!')),
      );
      return;
    }

    bool cadastradoValido = await cadastrarUsuario(
      usuarioDig,
      senhaDig,
      emailDig,
      fotoParaSalvar,
    );

    if (cadastradoValido) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário cadastrado com sucesso!')),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Entrada()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Algo deu errado ao cadastrar, desculpe.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Criar Login",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    'Preencha as informações abaixo',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 20),

                // Seletor de foto redondo
                Center(
                  child: GestureDetector(
                    onTap: _selecionarFotoDaGaleria,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.grey[800],
                      backgroundImage: _caminhoFoto != null
                          ? FileImage(File(_caminhoFoto!))
                          : null,
                      child: _caminhoFoto == null
                          ? const Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                        size: 30,
                      )
                          : null,
                    ),
                  ),
                ),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Toque para selecionar foto (opcional)",
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const Text("Nome", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                TextField(
                  controller: controllerUsu,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Nome de usuário",
                    hintStyle: const TextStyle(color: Colors.white38),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Email", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                TextField(
                  controller: controllerEmail,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "seuemail@exemplo.com",
                    hintStyle: const TextStyle(color: Colors.white38),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Senha", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                TextField(
                  controller: controllerSenha,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Sua senha",
                    hintStyle: const TextStyle(color: Colors.white38),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: cadastrar,
                    child: const Text(
                      "Criar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}