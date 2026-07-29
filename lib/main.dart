import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:primeiro_app/pages/login.dart';

import 'bancoDados/conect.dart';

Future<void> main() async {
  var url = Uri.http("10.112.4.33","api/status");
  var response = await http.get(url);
  print(response);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PagUsu(),
    );
  }
}

class PagUsu extends StatelessWidget {
  const PagUsu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Login(),
      ),
    );
  }
}