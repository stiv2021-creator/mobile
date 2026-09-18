// lib/main.dart

import 'package:flutter/material.dart';
import 'widgets/sidebar.dart';
import 'widgets/top_bar.dart';
import 'views/ordenes_pedido_view.dart';

void main() => runApp(const EslabonApp());

class EslabonApp extends StatelessWidget {
  const EslabonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eslabón - Taller',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF141414),
        primaryColor: const Color(0xFFECC159),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFECC159),
          brightness: Brightness.dark,
        ),
      ),
      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  String _seccionSeleccionada = 'Órdenes de Pedido';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final bool esPantallaGrande = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      key: _scaffoldKey,
      drawer: !esPantallaGrande
          ? Drawer(
              backgroundColor: const Color(0xFF111111),
              child: Sidebar(
                seccionSeleccionada: _seccionSeleccionada,
                onSelectSection: (seccion) {
                  setState(() {
                    _seccionSeleccionada = seccion;
                  });
                  Navigator.pop(context);
                },
              ),
            )
          : null,
      body: Row(
        children: [
          if (esPantallaGrande)
            Sidebar(
              seccionSeleccionada: _seccionSeleccionada,
              onSelectSection: (seccion) {
                setState(() {
                  _seccionSeleccionada = seccion;
                });
              },
            ),
          Expanded(
            child: Column(
              children: [
                TopBar(
                  onMenuPressed: () {
                    if (!esPantallaGrande) {
                      _scaffoldKey.currentState?.openDrawer();
                    }
                  },
                ),
                Expanded(
                  child: _seccionSeleccionada == 'Órdenes de Pedido'
                      ? const OrdenesPedidoView()
                      : Center(
                          child: Text(
                            'Vista de $_seccionSeleccionada en desarrollo',
                            style: const TextStyle(fontSize: 16, color: Colors.white70),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
