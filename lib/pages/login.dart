import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:primeiro_app/bancoDados/conect.dart';
import 'criar.dart';
import 'pessoas.dart';

class AuthService {
  static Future<bool> validarLogin(String usu, String senha) async {
    try {
      var conn = await ConexaoMysql.obterConexao();

      var resultados = await conn.query(
        'SELECT ID FROM USUAARIOS WHERE NOME = ? AND SENHA = ?',
        [usu, senha],
      );
      await conn.close();

      return resultados.isNotEmpty;
    } catch (e) {
      print('Erro ao validar Sorry: $e');
      return false;
    }
  }
}


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // 1. Criamos os controllers para ler os textos digitados
  final TextEditingController controllerUsu = TextEditingController();
  final TextEditingController controllerSenha = TextEditingController();

  //  Função de autenticação bem ajustada
  void autenticar() async {
    String usuarioDig = controllerUsu.text;
    String senhaDig = controllerSenha.text;

    bool loginValido = await AuthService.validarLogin(usuarioDig, senhaDig);

    if (loginValido) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Entrada(),
        ),
      );
    } else {
      print('Algo esta errado desculpe');
      // Opcional: Aqui você pode colocar um SnackBar ou Alerta avisando o usuário na tela!
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
                  "Ô só, faz o Login aí vai",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Preenche aí embaixo vai",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 30),
                const Text("Email", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                TextField(
                  controller: controllerUsu, // Conectado aqui!
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Dantesoufoda@exemplo.com",
                    hintStyle: const TextStyle(color: Colors.white38),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Senha:", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                TextField(
                  controller: controllerSenha,
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "••••••••",
                    hintStyle: const TextStyle(color: Colors.white38),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Esqueceu a senha?",
                    style: TextStyle(
                      color: Colors.blue[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
                    onPressed: autenticar,
                    child: const Text(
                      "Entrar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text("Ou", style: TextStyle(color: Colors.white60)),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 10),
                      Text(
                        'Com o Google',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 10),
                      Text(
                        'Com o Trem de velho la',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Cadastro(),
                        ),
                      );
                    },
                    child: const Text(
                      "Criar nova conta",
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