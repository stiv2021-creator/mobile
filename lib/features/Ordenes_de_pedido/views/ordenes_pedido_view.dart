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
    OrdenPedido(
      id: 'ORDP-001',
      idRemision: 'REM-001',
      fecha: '2026-06-24',
      estado: 'Pendiente',
    ),
    OrdenPedido(
      id: 'ORDP-002',
      idRemision: 'REM-002',
      fecha: '2026-06-29',
      estado: 'Pendiente',
    ),
    OrdenPedido(
      id: 'ORDP-003',
      idRemision: 'REM-003',
      fecha: '2026-06-30',
      estado: 'Completado',
    ),
  ];

  late List<OrdenPedido> _ordenesFiltradas;
  final TextEditingController _searchController = TextEditingController();

  // Filtro de estado actual
  String _filtroActual = 'Todos';
  final List<String> _opcionesFiltro = [
    'Todos',
    'Pendiente',
    'Completado',
    'Cancelado',
  ];

  @override
  void initState() {
    super.initState();
    _aplicarFiltros();
  }

  void _aplicarFiltros() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _ordenesFiltradas = _ordenes.where((o) {
        final coincideTexto =
            o.id.toLowerCase().contains(query) ||
            o.idRemision.toLowerCase().contains(query) ||
            o.fecha.contains(query);
        final coincideEstado =
            _filtroActual == 'Todos' || o.estado == _filtroActual;
        return coincideTexto && coincideEstado;
      }).toList();
    });
  }

  // Cambio de estado directo al tocar la etiqueta
  void _cambiarEstadoDirecto(OrdenPedido o, String nuevoEstado) {
    setState(() {
      o.estado = nuevoEstado;
      _aplicarFiltros(); // Refrescar lista si el filtro oculta el nuevo estado
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
            _aplicarFiltros();
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
            _aplicarFiltros();
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
            _aplicarFiltros();
          });
        },
      ),
    );
  }

  Widget _buildBadgeEstado(String estado, bool isDark) {
    Color bgColor;
    Color textColor;

    switch (estado) {
      case 'Completado':
        bgColor = isDark ? const Color(0xFF13381F) : Colors.green[100]!;
        textColor = isDark ? const Color(0xFF81C995) : Colors.green[800]!;
        break;
      case 'Cancelado':
        bgColor = isDark ? const Color(0xFF3B1C1C) : Colors.red[100]!;
        textColor = isDark ? const Color(0xFFF28B82) : Colors.red[800]!;
        break;
      case 'Pendiente':
      default:
        bgColor = isDark ? const Color(0xFF3B2E16) : Colors.orange[100]!;
        textColor = isDark ? const Color(0xFFECC159) : Colors.orange[800]!;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            estado,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down, size: 14, color: textColor),
        ],
      ),
    );
  }

  // ... (Deja todo tu código anterior de variables y funciones igual) ...

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = isDark ? Colors.white : const Color(0xFF121212);
    final Color subtitleColor = isDark ? Colors.grey[400]! : Colors.grey[600]!;
    final Color cardColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final Color borderColor = isDark
        ? const Color(0xFF2C2C2E)
        : Colors.grey[300]!;
    final Color searchBgColor = isDark
        ? const Color(0xFF1C1C1E)
        : Colors.grey[100]!;
    const Color primaryGold = Color(0xFFECC159);

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryGold,
        onPressed: _abrirModalNueva,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      // SOLUCIÓN AL DISEÑO MONTADO: SafeArea
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Texto "Gestión de Comercial" ELIMINADO.
              Row(
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    color: primaryGold,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Órdenes de Pedido',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${_ordenesFiltradas.length} registros encontrados',
                style: TextStyle(fontSize: 13, color: subtitleColor),
              ),
              const SizedBox(height: 16),

              // Buscador
              SizedBox(
                height: 48,
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => _aplicarFiltros(),
                  style: TextStyle(color: textColor, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Buscar por código o remisión...',
                    hintStyle: TextStyle(color: subtitleColor, fontSize: 14),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: primaryGold,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: searchBgColor,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: primaryGold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Filtros (Chips) horizontales
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _opcionesFiltro.map((opcion) {
                    final isSelected = _filtroActual == opcion;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _filtroActual = opcion;
                            _aplicarFiltros();
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? primaryGold.withOpacity(0.15)
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected ? primaryGold : borderColor,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            opcion,
                            style: TextStyle(
                              color: isSelected ? primaryGold : subtitleColor,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Lista de Tarjetas (Diseño Cuadrado)
              Expanded(
                child: ListView.builder(
                  itemCount: _ordenesFiltradas.length,
                  itemBuilder: (context, index) {
                    final o = _ordenesFiltradas[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icono Cuadrado a la izquierda
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: primaryGold.withOpacity(0.5),
                                  ),
                                  color: primaryGold.withOpacity(0.05),
                                ),
                                child: const Icon(
                                  Icons.receipt_long_outlined,
                                  color: primaryGold,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Información Central
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            o.id,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: textColor,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        // Cambio de estado directo
                                        PopupMenuButton<String>(
                                          initialValue: o.estado,
                                          tooltip: 'Cambiar Estado',
                                          onSelected: (nuevoEstado) =>
                                              _cambiarEstadoDirecto(
                                                o,
                                                nuevoEstado,
                                              ),
                                          color: isDark
                                              ? const Color(0xFF252525)
                                              : Colors.white,
                                          itemBuilder: (context) =>
                                              [
                                                    'Pendiente',
                                                    'Completado',
                                                    'Cancelado',
                                                  ]
                                                  .map(
                                                    (e) => PopupMenuItem(
                                                      value: e,
                                                      child: Text(
                                                        e,
                                                        style: TextStyle(
                                                          color: textColor,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                          child: _buildBadgeEstado(
                                            o.estado,
                                            isDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Remisión → ${o.idRemision}',
                                      style: TextStyle(
                                        color: subtitleColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Fecha registrada: ${o.fecha}',
                                      style: TextStyle(
                                        color: subtitleColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Divider(color: borderColor, height: 1),
                          const SizedBox(height: 12),
                          // Botones de acción inferiores
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: borderColor),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    color: primaryGold,
                                    size: 18,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 36,
                                    minHeight: 36,
                                  ),
                                  padding: EdgeInsets.zero,
                                  tooltip: 'Editar',
                                  onPressed: () => _abrirModalEditar(o),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: borderColor),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: primaryGold,
                                    size: 18,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 36,
                                    minHeight: 36,
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
