import 'package:sqflite/sqflite.dart';
import 'package:primeiro_app/bancoDados/conect.dart';

class AuthService {


  static Future<List<Map<String, dynamic>>> listarUsuarios() async {
    try {
      Database db = await ConexaoSqflite.obterConexao();

      return await db.rawQuery('SELECT ID, NOME, EMAIL, FOTO FROM USUARIOS');
    } catch (e) {
      print("Erro ao listar usuários no SQLite: $e");
      return [];
    }
  }






  static Future<bool> cadastrarUsuario(String usu, String senha, String email, String foto) async {
    try {
      Database db = await ConexaoSqflite.obterConexao();


      int idGerado = await db.rawInsert(
        'INSERT INTO USUARIOS (NOME, SENHA, EMAIL, FOTO) VALUES (?, ?, ?, ?)',
        [usu, senha, email, foto],
      );

      print("Usuário cadastrado no SQLite com ID: $idGerado");
      return idGerado > 0;
    } catch (e) {
      print("Erro ao cadastrar no SQLite: $e");
      return false;
    }
  }







  static Future<void> listarMensagens() async {
    try {
      Database db = await ConexaoSqflite.obterConexao();


      List<Map<String, dynamic>> mensagens = await db.rawQuery('SELECT * FROM MENSAGENS');

      print(" MENSAGENS NO BANCO ---");
      for (var m in mensagens) {
        print("ID: ${m['ID']} | De: ${m['DE']} -> Para: ${m['PARA']} | Conteúdo: ${m['CONTEUDO']} | Horário: ${m['HORARIO']}");
      }
      print("----------------------------");
    } catch (e) {
      print("Erro ao ler mensagens: $e");
    }
  }


  static Future<List<Map<String, dynamic>>> buscarMensagens(int meuId, int outroId) async {
    try {
      Database db = await ConexaoSqflite.obterConexao();
      return await db.rawQuery('''
      SELECT * FROM MENSAGENS 
      WHERE (DE = ? AND PARA = ?) OR (DE = ? AND PARA = ?)
      ORDER BY ID ASC
    ''', [meuId, outroId, outroId, meuId]);
    } catch (e) {
      print("Erro ao buscar mensagens: $e");
      return [];
    }
  }





  static Future<bool> cadastrarMensagem(String conteudo, int deId, int paraId) async {
    try {
      Database db = await ConexaoSqflite.obterConexao();
      int id = await db.rawInsert(
        'INSERT INTO MENSAGENS (CONTEUDO, DE, PARA) VALUES (?, ?, ?)',
        [conteudo, deId, paraId],
      );
      return id > 0;
    } catch (e) {
      print("Erro ao enviar mensagem: $e");
      return false;
    }
  }
  static Future<bool> atualizarSenha(String email, String novaSenha) async {
    try {
      Database db = await ConexaoSqflite.obterConexao();

      int quantidadeLinhasAfetadas = await db.rawUpdate(
        'UPDATE USUARIOS SET SENHA = ? WHERE EMAIL = ?',
        [novaSenha, email],
      );

      return quantidadeLinhasAfetadas > 0;
    } catch (e) {
      print("Erro ao redefinir a senha: $e");
      return false;
    }
  }
}


