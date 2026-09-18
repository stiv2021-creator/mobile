import 'package:flutter/material.dart';

// Importaciones de tus vistas basadas en tu estructura
import '../../produccion_inventario/insumos/views/insumos_mobile_view.dart';
import '../../produccion_inventario/compras/views/compras_mobile_view.dart';
import '../../catalogos/clientes/views/clientes_view.dart';
import '../../catalogos/proveedores/views/proveedores_view.dart';
import '../../produccion_inventario/remision/views/remision_mobile_view.dart';
import '../../operaciones/orden_de_pedido/views/orden_pedido_view.dart';
import '../../operaciones/ventas/views/ventas_view.dart';
import '../../produccion_inventario/produccion/views/produccion_view.dart';
import '../../operaciones/registro_diario/views/registro_diario_view.dart';
import '../../personal/empleados/views/empleados_view.dart';
import '../../Principal/Dashboard/Dashboard.dart';

import '../widgets/theme_dropdown_widget.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Lista completa con las vistas del sistema mapeadas por índice
  final List<Widget> _pages = [
    const DashboardPage(), // 0: Dashboard
    const ClientesView(), // 1: Clientes
    const ProveedoresView(), // 2: Proveedores
    const RemisionMobileView(), // 3: Remisiones
    const OrdenPedidoView(), // 4: Órdenes de Pedido
    const VentasView(), // 5: Ventas
    const InsumosMobileView(), // 6: Insumos
    const ComprasMobileView(), // 7: Compras
    const ProduccionView(), // 8: Gestión de Producción
    const RegistroDiarioView(), // 9: Registro Diario
    const EmpleadosView(), // 10: Empleados
  ];

  // Método auxiliar para cambiar de vista desde el Drawer y cerrarlo automáticamente
  void _navigateToPage(int index) {
    Navigator.pop(context); // Cierra el menú lateral
    setState(() {
      _currentIndex = index; // Cambia la vista activa en el body
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : Colors.white;
    final selectedColor = const Color(0xFFD4AF37);
    final unselectedColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;

    return Scaffold(
      key: _scaffoldKey,

      endDrawer: Drawer(
        backgroundColor: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              // Encabezado con Logo, Selector de Tema y Botón Cerrar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ESLABÓN',
                      style: TextStyle(
                        color: Color(0xFFD4AF37),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Row(
                      children: [
                        const ThemeDropdownWidget(),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                color: isDarkMode ? Colors.white24 : Colors.black12,
                height: 1,
              ),

              // Lista de opciones del menú lateral vinculadas por índice
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    _buildSectionTitle('PRINCIPAL'),
                    _buildDrawerItem(
                      Icons.grid_view_rounded,
                      'Dashboard',
                      _currentIndex == 0,
                      () => _navigateToPage(0),
                      isDarkMode,
                    ),

                    _buildSectionTitle('COMERCIAL'),
                    _buildDrawerItem(
                      Icons.person_outline,
                      'Clientes',
                      _currentIndex == 1,
                      () => _navigateToPage(1),
                      isDarkMode,
                    ),
                    _buildDrawerItem(
                      Icons.inventory_2_outlined,
                      'Proveedores',
                      _currentIndex == 2,
                      () => _navigateToPage(2),
                      isDarkMode,
                    ),
                    _buildDrawerItem(
                      Icons.local_offer_outlined,
                      'Remisiones',
                      _currentIndex == 3,
                      () => _navigateToPage(3),
                      isDarkMode,
                    ),
                    _buildDrawerItem(
                      Icons.shopping_cart_outlined,
                      'Órdenes de Pedido',
                      _currentIndex == 4,
                      () => _navigateToPage(4),
                      isDarkMode,
                    ),
                    _buildDrawerItem(
                      Icons.trending_up,
                      'Ventas',
                      _currentIndex == 5,
                      () => _navigateToPage(5),
                      isDarkMode,
                    ),

                    _buildSectionTitle('ALMACÉN'),
                    _buildDrawerItem(
                      Icons.inventory_2_outlined,
                      'Insumos',
                      _currentIndex == 6,
                      () => _navigateToPage(6),
                      isDarkMode,
                    ),
                    _buildDrawerItem(
                      Icons.shopping_cart_outlined,
                      'Compras',
                      _currentIndex == 7,
                      () => _navigateToPage(7),
                      isDarkMode,
                    ),

                    _buildSectionTitle('PRODUCCIÓN'),
                    _buildDrawerItem(
                      Icons.precision_manufacturing_outlined,
                      'Gestión de Producción',
                      _currentIndex == 8,
                      () => _navigateToPage(8),
                      isDarkMode,
                    ),
                    _buildDrawerItem(
                      Icons.tune_outlined,
                      'Registro Diario',
                      _currentIndex == 9,
                      () => _navigateToPage(9),
                      isDarkMode,
                    ),

                    _buildSectionTitle('ADMINISTRACIÓN'),
                    _buildDrawerItem(
                      Icons.badge_outlined,
                      'Empleados',
                      _currentIndex == 10,
                      () => _navigateToPage(10),
                      isDarkMode,
                    ),
                  ],
                ),
              ),

              // Pie de página (Perfil y Cerrar sesión)
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color(0xFF252525)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDarkMode ? Colors.white12 : Colors.black12,
                        ),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xFFD4AF37),
                            child: Text(
                              'MG',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'María García',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Ver mi perfil →',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF8B263E)),
                          foregroundColor: const Color(0xFFFF5252),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => false,
                          );
                        },
                        icon: const Icon(Icons.logout_rounded, size: 18),
                        label: const Text(
                          'Cerrar sesión',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Muestra la vista seleccionada dentro del contenedor principal
      body: _pages[_currentIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex > 3 ? 0 : _currentIndex,
          onTap: (index) {
            if (index == 4) {
              _scaffoldKey.currentState
                  ?.openEndDrawer(); // Abre el menú lateral
            } else {
              if (index == 0) setState(() => _currentIndex = 0); // Inicio
              if (index == 1)
                setState(() => _currentIndex = 6); // Stock (Insumos)
              if (index == 2) setState(() => _currentIndex = 1); // Clientes
              if (index == 3) setState(() => _currentIndex = 5); // Ventas
            }
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: backgroundColor,
          selectedItemColor: selectedColor,
          unselectedItemColor: unselectedColor,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded, size: 20),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined, size: 20),
              label: 'Stock',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 20),
              label: 'Clientes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up, size: 20),
              label: 'Ventas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu, size: 20),
              label: 'Menú',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    bool isSelected,
    VoidCallback onTap,
    bool isDarkMode,
  ) {
    return ListTile(
      dense: true,
      leading: Icon(
        icon,
        size: 16,
        color: isSelected
            ? const Color(0xFFD4AF37)
            : (isDarkMode ? Colors.white70 : Colors.black87),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected
              ? const Color(0xFFD4AF37)
              : (isDarkMode ? Colors.white70 : Colors.black87),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
      ),
      tileColor: isSelected ? const Color(0xFFD4AF37).withOpacity(0.15) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: onTap,
    );
  }
}
