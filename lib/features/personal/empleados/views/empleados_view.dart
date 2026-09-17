import 'package:flutter/material.dart';

class EmpleadosView extends StatelessWidget {
  const EmpleadosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Empleados')),
      body: const Center(child: Text('Vista de Empleados')),
    );
  }
}