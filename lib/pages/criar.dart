import 'package:flutter/material.dart';
import 'package:primeiro_app/bancoDados/conect.dart';
import 'pessoas.dart';

class AuthService {

  static Future<bool> cadastrarUsuario(String usu, String senha, String email) async {
    try {
      var conn = await ConexaoMysql.obterConexao();

      var resultados = await conn.query(
        'INSERT INTO USUARIOS (NOME, SENHA, EMAIL) VALUES (?, ?, ?)',
        [usu, senha, email],
      );

      await conn.close();

      return resultados.affectedRows! > 0;
    } catch (e) {
      print("Erro ao cadastrar: $e");
      return false;
    }
  }
}

// Convertido para StatefulWidget
class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  // Controllers mantidos dentro da classe do estado
  final TextEditingController controllerUsu = TextEditingController();
  final TextEditingController controllerSenha = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();

  // Função para executar o cadastro
  void cadastrar() async {
    String usuarioDig = controllerUsu.text;
    String senhaDig = controllerSenha.text;
    String emailDig = controllerEmail.text;

    if (usuarioDig.isEmpty || senhaDig.isEmpty || emailDig.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Preencha todos os campos!')));
      return;
    }

    bool cadastradoValido = await AuthService.cadastrarUsuario(
      usuarioDig,
      senhaDig,
      emailDig,
    );

    if (cadastradoValido) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Usuário cadastrado com sucesso!')));

      // Navega para a tela principal (Entrada)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Entrada(),
        ),
      );
    } else {
      print('Algo deu errado ao cadastrar, desculpe.');
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
                const SizedBox(height: 30),
                const Text("Nome", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                TextField(
                  controller: controllerUsu, // Conectado!
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
                  controller: controllerEmail, // Conectado!
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
                  controller: controllerSenha, // Conectado!
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
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Essas informações vão ser usadas para você acessar o App, grave bem.",
                    style: TextStyle(
                      color: Colors.white60,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
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
                    onPressed: cadastrar, // Chamando a função cadastrar!
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
                const SizedBox(height: 20),
                const Center(
                  child: Text("Ou", style: TextStyle(color: Colors.white60)),
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
                      Navigator.pop(contexto);
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