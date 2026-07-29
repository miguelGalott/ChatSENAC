import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ConexaoSqflite {
  static Database? _db;

  static Future<Database> obterConexao() async {
    if (_db != null) return _db!;

    String caminhoBanco = await getDatabasesPath();
    String path = join(caminhoBanco, 'meu_banco_local.db');


    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE USUARIOS (
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            NOME INTEGER TEXT NOT NULL UNIQUE,
            EMAIL INTEGER TEXT NOT NULL,
            SENHA INTEGER TEXT NUT NULL UNIQUE,
            FOTO INTERGER TEXT 
          );
          ''');

        await db.execute('''

    CREATE TABLE MENSAGENS(
       ID INTEGER PRIMARY KEY AUTOINCREMENT,
       CONTEUDO TEXT NOT NULL,
       HORARIO TEXT DEFAULT CURRENT_TIMESTAMP,
       ESTADO TEXT DEFAULT 'ENVIANDO' CHECK (ESTADO IN ('VISTO', 'NÃO VISTO', 'ENVIANDO', 'ENVIADO MAS NÃO VISTO')),
       PARA INTEGER NOT NULL,
       DE INTEGER NOT NULL,
       
       FOREIGN KEY (PARA) REFERENCES USUARIOS(ID),
       FOREIGN KEY (DE) REFERENCES USUARIOS(ID)
);

          
        ''');
      },
    );

    return _db!;
  }
}