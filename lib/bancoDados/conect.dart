import 'package:mysql1/mysql1.dart';

class ConexaoMysql {
  static Future<MySqlConnection> obterConexao() async {
    final settings = ConnectionSettings(
      host: '10.0.2.2',
      user: 'root',
      password: '12345',
      db: 'SENACHAT',
    );

    return await MySqlConnection.connect(settings);
  }
}

void main() async {
  print('Tentando conectar ao MySQL...');
  try {
    var conn = await ConexaoMysql.obterConexao();
    print('BOA!');

    var result = await conn.query(
      'INSERT INTO USUARIOS (NOME, SENHA, EMAIL) VALUES (?, ?, ?)',
      ['admin', 'admin', 'admin@gmail.com'],
    );


    await conn.close();
    print('Conexão encerrada com sucesso.');
  } catch (e) {
    print('ERRO AO CONECTAR:');
    print(e);
  }
}