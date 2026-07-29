import 'package:flutter/material.dart';
import 'package:primeiro_app/servicos/AuthService.dart';

class Chat extends StatefulWidget {
  final String nome;
  final int idUsuarioDestino;
  final int meuId;

  const Chat({
    super.key,
    required this.nome,
    required this.idUsuarioDestino,
    required this.meuId,
  });

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _mensagemController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _futureMensagens;

  @override
  void initState() {
    super.initState();
    _carregarMensagens();
  }

  void _carregarMensagens() {
    _futureMensagens = AuthService.buscarMensagens(
      widget.meuId,
      widget.idUsuarioDestino,
    );
  }

  @override
  void dispose() {
    _mensagemController.dispose();
    super.dispose();
  }

  void _enviarMensagem() async {
    String conteudo = _mensagemController.text.trim();

    if (conteudo.isEmpty) return;

    bool sucesso = await AuthService.cadastrarMensagem(
      conteudo,
      widget.idUsuarioDestino,
      widget.meuId,
    );

    if (sucesso) {
      _mensagemController.clear();
      setState(() {
        // Recarrega as mensagens do banco de dados na tela, trem insuportavel de fazer
        _carregarMensagens();
      });
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao enviar mensagem.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(
          widget.nome,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _futureMensagens,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.blue),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "Nenhuma mensagem ainda... Poxa :(",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                final mensagens = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: mensagens.length,
                  itemBuilder: (context, index) {
                    final msg = mensagens[index];
                    bool souEu = msg['DE'] == widget.meuId;

                    return Align(
                      alignment: souEu ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: souEu ? Colors.blue[600] : Colors.grey[800],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          msg['CONTEUDO'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _mensagemController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Digite sua mensagem...",
                        hintStyle: TextStyle(color: Colors.white38),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: _enviarMensagem,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}