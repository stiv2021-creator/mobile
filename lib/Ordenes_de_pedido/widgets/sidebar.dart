// lib/widgets/sidebar.dart

import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final String seccionSeleccionada;
  final Function(String) onSelectSection;

  const Sidebar({
    super.key,
    required this.seccionSeleccionada,
    required this.onSelectSection,
  });

  Widget _buildSidebarItem(BuildContext context, IconData icon, String titulo) {
    final bool esSeleccionado = seccionSeleccionada == titulo;
    final dorado = const Color(0xFFECC159);
    return InkWell(
      onTap: () => onSelectSection(titulo),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: esSeleccionado ? Border.all(color: dorado.withOpacity(0.6)) : null,
          color: esSeleccionado ? dorado.withOpacity(0.08) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon, color: esSeleccionado ? dorado : Colors.white70, size: 20),
            const SizedBox(width: 12),
            Text(
              titulo,
              style: TextStyle(
                color: esSeleccionado ? dorado : Colors.white70,
                fontWeight: esSeleccionado ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: const Color(0xFF111111),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.link, color: Color(0xFFC5A059), size: 24),
                  SizedBox(width: 8),
                  Text('ESLABÓN', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2)),
                ],
              ),
            ),
          ),
          const Divider(color: Color(0xFF222222), height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildSidebarItem(context, Icons.grid_view_rounded, 'Dashboard'),
                _buildSidebarItem(context, Icons.people_outline, 'Clientes'),
                _buildSidebarItem(context, Icons.badge_outlined, 'Proveedores'),
                _buildSidebarItem(context, Icons.local_shipping_outlined, 'Remisiones'),
                _buildSidebarItem(context, Icons.receipt_long_outlined, 'Órdenes de Pedido'),
                _buildSidebarItem(context, Icons.trending_up, 'Ventas'),
                _buildSidebarItem(context, Icons.local_shipping, 'Envíos'),
                _buildSidebarItem(context, Icons.label_outline, 'Tipo de Insumos'),
                _buildSidebarItem(context, Icons.inventory_2_outlined, 'Insumos'),
              ],
            ),
          ),
          const Divider(color: Color(0xFF222222), height: 1),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: const [
                CircleAvatar(
                  backgroundColor: Color(0xFFECC159),
                  child: Text('A', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Admin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('Admin', style: TextStyle(color: Colors.white54, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
