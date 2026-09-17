import 'package:flutter/material.dart';

class RemisionMobileView extends StatelessWidget {
  const RemisionMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Remisiones')),
      body: const Center(child: Text('Vista de Remisiones')),
    );
  }
}