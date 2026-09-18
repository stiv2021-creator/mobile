import 'package:flutter/material.dart';
import 'widgets/sidebar.dart';
import 'widgets/top_bar.dart';
import 'views/proveedores_view.dart';

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
  String _seccionSeleccionada = 'Proveedores';
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
                  Navigator.pop(context); // Cierra el menú móvil al seleccionar
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
                    if (esPantallaGrande) {
                      // Opcional si quisieras colapsarlo en grande
                    } else {
                      _scaffoldKey.currentState?.openDrawer();
                    }
                  },
                ),
                Expanded(
                  child: _seccionSeleccionada == 'Proveedores'
                      ? const ProveedoresView()
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

