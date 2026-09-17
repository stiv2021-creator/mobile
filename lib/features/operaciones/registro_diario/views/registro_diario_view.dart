import 'package:flutter/material.dart';

class RegistroDiarioView extends StatelessWidget {
  const RegistroDiarioView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro Diario')),
      body: const Center(child: Text('Vista de Registro Diario')),
    );
  }
}