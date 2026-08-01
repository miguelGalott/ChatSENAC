import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:primeiro_app/bancoDados/conect.dart';
import 'pessoas.dart';
import 'package:primeiro_app/servicos/AuthService.dart';


class EsqueciSenha extends StatefulWidget {
  const EsqueciSenha({super.key});

  @override
  State<EsqueciSenha> createState() => _EsqueciSenhaState();
}

class _EsqueciSenhaState extends State<EsqueciSenha> {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerNovaSenha = TextEditingController();

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerNovaSenha.dispose();
    super.dispose();
  }

  void alterarSenha() async {
    String emailDig = controllerEmail.text.trim();
    String novaSenhaDig = controllerNovaSenha.text.trim();

    if (emailDig.isEmpty || novaSenhaDig.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha o e-mail e a nova senha!')),
      );
      return;
    }

    bool alteradoComSucesso = await AuthService.atualizarSenha(
      emailDig,
      novaSenhaDig,
    );

    if (!mounted) return;

    if (alteradoComSucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha alterada com sucesso! Faça login.'),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('E-mail não encontrado! Verifique e tente de novo.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Esqueceu a senha, né?",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Relaxa, digita seu e-mail e cria uma nova aí embaixo",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 30),
                const Text("E-mail cadastrado",
                    style: TextStyle(color: Colors.white)),
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
                const Text("Nova Senha", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                TextField(
                  controller: controllerNovaSenha,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "••••••••",
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
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: alterarSenha,
                    child: const Text(
                      "Alterar Senha",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Voltar",
                      style: TextStyle(
                        color: Colors.black,
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