import 'package:flutter/material.dart';
import 'chart.dart';


class EntradaDinamic extends StatefulWidget {
  const EntradaDinamic({super.key});

  @override
  State<EntradaDinamic> createState() => _EntradaDinamicState();
}

class _EntradaDinamicState extends State<EntradaDinamic> {

  final TextEditingController _nomeController = TextEditingController();

  final List<Map<String, String>> _usuarios = [];


  void _adicionarUsuario() {
    if (_nomeController.text.isNotEmpty) {
      setState(() {
        _usuarios.add({
          'nome': _nomeController.text,


        });
      });

      // Limpa os campos após salvar
      _nomeController.clear();

    }
  }

  // Função para limpar os campos
  void _limpar() {
    _nomeController.clear();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text("Criar Novo Usuário"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- FORMULÁRIO (MINI CONTAINER COM 2 CAMPOS E 2 BOTÕES) ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Campo 1: Nome
                    TextField(
                      controller: _nomeController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: "Nome do Usuário",
                        labelStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),


                    Row(
                      children: [

                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                            ),
                            onPressed: _limpar,
                            child: const Text("Limpar"),
                          ),
                        ),
                        const SizedBox(width: 12),


                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: _adicionarUsuario,
                            child: const Text("Criar"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                "Usuários Cadastrados:",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 12),


              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _usuarios.length,
                itemBuilder: (context, index) {
                  final usuario = _usuarios[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    // Corrigido: O clique vai no onTap do ListTile
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Chat(),
                          ),
                        );
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          'https://thumbs.dreamstime.com/b/vetor-de-%C3%ADcone-perfil-do-avatar-padr%C3%A3o-foto-usu%C3%A1rio-m%C3%ADdia-social-183042379.jpg',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                      title: Text(
                        usuario['nome']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),





            ],
          ),
        ),
      ),
    );
  }
}