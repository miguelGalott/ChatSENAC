import 'package:shared_preferences/shared_preferences.dart';

class Sessao {
  static const String _chaveIdUsuario = 'ID_USUARIO_LOGADO';


  static Future<void> salvarUsuarioLogado(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_chaveIdUsuario, id);
  }


  static Future<int?> obterUsuarioLogado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_chaveIdUsuario);
  }


  static Future<void> sair() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chaveIdUsuario);
  }
}



