import 'package:flutter/material.dart';

class ProveedoresView extends StatelessWidget {
  const ProveedoresView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proveedores')),
      body: const Center(child: Text('Vista de Proveedores')),
    );
  }
}