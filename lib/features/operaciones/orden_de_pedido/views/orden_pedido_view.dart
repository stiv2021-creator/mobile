import 'package:flutter/material.dart';

class OrdenPedidoView extends StatelessWidget {
  const OrdenPedidoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Órdenes de Pedido')),
      body: const Center(child: Text('Vista de Órdenes de Pedido')),
    );
  }
}