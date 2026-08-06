import 'package:flutter/material.dart';
import 'package:primeiro_app/pages/login.dart';
import 'package:primeiro_app/servicos/gerenciador.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, modoAtual, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: modoAtual,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            colorSchemeSeed: Colors.blue,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.black87,
            colorSchemeSeed: Colors.blue,
          ),
          home: const PagUsu(),
        );
      },
    );
  }
}

class PagUsu extends StatelessWidget {
  const PagUsu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Login(),
      ),
    );
  }
}