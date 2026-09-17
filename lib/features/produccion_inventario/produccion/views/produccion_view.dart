import 'package:flutter/material.dart';

class ProduccionView extends StatelessWidget {
  const ProduccionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Producción')),
      body: const Center(child: Text('Vista de Producción')),
    );
  }
}