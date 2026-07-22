import 'package:flutter/material.dart';
import 'package:primeiro_app/pages/login.dart';

void main() {
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