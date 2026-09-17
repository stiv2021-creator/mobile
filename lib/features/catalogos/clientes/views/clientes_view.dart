import 'package:flutter/material.dart';

class ClientesView extends StatelessWidget {
  const ClientesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      body: const Center(child: Text('Vista de Clientes')),
    );
  }
}