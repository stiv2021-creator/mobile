// lib/views/ordenes_pedido_view.dart

import 'package:flutter/material.dart';
import '../models/orden_pedido.dart';
import '../widgets/orden_modal.dart';
import '../widgets/eliminar_modal.dart';

class OrdenesPedidoView extends StatefulWidget {
  const OrdenesPedidoView({super.key});

  @override
  State<OrdenesPedidoView> createState() => _OrdenesPedidoViewState();
}

class _OrdenesPedidoViewState extends State<OrdenesPedidoView> {
  final List<OrdenPedido> _ordenes = [
    OrdenPedido(id: 'ORDP-001', idRemision: 'REM-001', fecha: '2026-06-24', estado: 'Pendiente'),
    OrdenPedido(id: 'ORDP-002', idRemision: 'REM-002', fecha: '2026-06-29', estado: 'Pendiente'),
    OrdenPedido(id: 'ORDP-003', idRemision: 'REM-003', fecha: '2026-06-30', estado: 'Pendiente'),
  ];

  late List<OrdenPedido> _ordenesFiltradas;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ordenesFiltradas = List.from(_ordenes);
  }

  void _filtrar(String query) {
    setState(() {
      _ordenesFiltradas = _ordenes.where((o) =>
        o.id.toLowerCase().contains(query.toLowerCase()) ||
        o.idRemision.toLowerCase().contains(query.toLowerCase()) ||
        o.fecha.contains(query)
      ).toList();
    });
  }

  void _abrirModalNueva() {
    showDialog(
      context: context,
      builder: (context) => OrdenModal(
        idSugerido: 'ORDP-00${_ordenes.length + 1}',
        onGuardar: (nuevaOrden) {
          setState(() {
            _ordenes.add(nuevaOrden);
            _ordenesFiltradas = List.from(_ordenes);
          });
        },
      ),
    );
  }

  void _abrirModalEditar(OrdenPedido orden) {
    showDialog(
      context: context,
      builder: (context) => OrdenModal(
        orden: orden,
        idSugerido: orden.id,
        onGuardar: (ordenActualizada) {
          setState(() {
            orden.idRemision = ordenActualizada.idRemision;
            orden.fecha = ordenActualizada.fecha;
            orden.estado = ordenActualizada.estado;
            _ordenesFiltradas = List.from(_ordenes);
          });
        },
      ),
    );
  }

  void _abrirModalEliminar(OrdenPedido orden) {
    showDialog(
      context: context,
      builder: (context) => EliminarModal(
        onConfirmar: () {
          setState(() {
            _ordenes.removeWhere((item) => item.id == orden.id);
            _ordenesFiltradas = List.from(_ordenes);
          });
        },
      ),
    );
  }

  Widget _buildBadgeEstado(String estado) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF3B2E16),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            estado.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFFECC159),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down, size: 14, color: Color(0xFFECC159)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Órdenes de Pedido', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(height: 2),
                  Text('Registro de órdenes vinculadas a remisiones', style: TextStyle(fontSize: 12, color: Colors.white54)),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFECC159),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _abrirModalNueva,
                icon: const Icon(Icons.add, size: 14, color: Colors.black),
                label: const Text('Nueva orden', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: TextField(
              controller: _searchController,
              onChanged: _filtrar,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Buscar...',
                hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: Colors.white54, size: 18),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: const Color(0xFFECC159).withValues(alpha: 0.3))),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: const Color(0xFFECC159).withValues(alpha: 0.3))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: const Color(0xFFECC159))),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: _ordenesFiltradas.length,
              itemBuilder: (context, index) {
                final o = _ordenesFiltradas[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF2A2A2A)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFF2A2518), borderRadius: BorderRadius.circular(4)),
                            child: Text(o.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFECC159))),
                          ),
                          _buildBadgeEstado(o.estado),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text('Remisión: ', style: TextStyle(color: Colors.white54, fontSize: 12)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: const Color(0xFF2A2518), borderRadius: BorderRadius.circular(4)),
                            child: Text(o.idRemision, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFECC159))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Text('Fecha: ', style: TextStyle(color: Colors.white54, fontSize: 12)),
                          Text(o.fecha, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                      const Divider(color: Color(0xFF2A2A2A), height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFECC159))),
                            child: IconButton(
                              icon: const Icon(Icons.edit_outlined, color: Color(0xFFECC159), size: 16),
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              padding: EdgeInsets.zero,
                              tooltip: 'Editar',
                              onPressed: () => _abrirModalEditar(o),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFECC159))),
                            child: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Color(0xFFECC159), size: 16),
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              padding: EdgeInsets.zero,
                              tooltip: 'Eliminar',
                              onPressed: () => _abrirModalEliminar(o),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          Text('${_ordenesFiltradas.length} registros', style: const TextStyle(color: Colors.white54, fontSize: 11)),
        ],
      ),
    );
  }
}
