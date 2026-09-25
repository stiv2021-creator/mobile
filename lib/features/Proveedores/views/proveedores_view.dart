import 'package:flutter/material.dart';

import '../models/proveedor.dart';
import '../widgets/proveedor_modal.dart';
import '../widgets/eliminar_modal.dart';

class ProveedoresView extends StatefulWidget {
  const ProveedoresView({super.key});

  @override
  State<ProveedoresView> createState() => _ProveedoresViewState();
}

class _ProveedoresViewState extends State<ProveedoresView> {
  final List<Proveedor> _proveedores = [
    Proveedor(
      id: 'PROV-001',
      nit: '1923091231',
      nombre: 'TextilsCOL',
      contacto: 'Andres Cadavid',
      telefono: '23032193',
      estado: 'Activo',
    ),
    Proveedor(
      id: 'PROV-002',
      nit: '1923091231',
      nombre: 'INSUMOMED',
      contacto: 'Axebiel Gayvils',
      telefono: '31239903',
      estado: 'Activo',
    ),
    Proveedor(
      id: 'PROV-003',
      nit: '1923091231',
      nombre: 'HILOSAS',
      contacto: 'Emerson Aguemaya',
      telefono: '39138913',
      estado: 'Inactivo',
    ),
  ];

  late List<Proveedor> _proveedoresFiltrados;
  final TextEditingController _searchController = TextEditingController();

  // Filtro de estado actual (Todos, Activo, Inactivo)
  String _filtroActual = 'Todos';
  final List<String> _opcionesFiltro = ['Todos', 'Activo', 'Inactivo'];

  @override
  void initState() {
    super.initState();
    _aplicarFiltros();
  }

  void _aplicarFiltros() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _proveedoresFiltrados = _proveedores.where((p) {
        final coincideTexto =
            p.nombre.toLowerCase().contains(query) ||
            p.nit.contains(query) ||
            p.id.toLowerCase().contains(query);
        final coincideEstado =
            _filtroActual == 'Todos' || p.estado == _filtroActual;
        return coincideTexto && coincideEstado;
      }).toList();
    });
  }

  void _cambiarEstadoDirecto(Proveedor p, String nuevoEstado) {
    setState(() {
      p.estado = nuevoEstado;
      _aplicarFiltros(); // Refrescar lista si el filtro oculta el nuevo estado
    });
  }

  void _abrirModalNuevo() {
    showDialog(
      context: context,
      builder: (context) => ProveedorModal(
        idSugerido: 'PROV-00${_proveedores.length + 1}',
        onGuardar: (nuevoProveedor) {
          setState(() {
            _proveedores.add(nuevoProveedor);
            _aplicarFiltros();
          });
        },
      ),
    );
  }

  void _abrirModalEditar(Proveedor proveedor) {
    showDialog(
      context: context,
      builder: (context) => ProveedorModal(
        proveedor: proveedor,
        idSugerido: proveedor.id,
        onGuardar: (proveedorActualizado) {
          setState(() {
            proveedor.nit = proveedorActualizado.nit;
            proveedor.nombre = proveedorActualizado.nombre;
            proveedor.contacto = proveedorActualizado.contacto;
            proveedor.telefono = proveedorActualizado.telefono;
            proveedor.estado = proveedorActualizado.estado;
            _aplicarFiltros();
          });
        },
      ),
    );
  }

  void _abrirModalEliminar(Proveedor proveedor) {
    showDialog(
      context: context,
      builder: (context) => EliminarModal(
        onConfirmar: () {
          setState(() {
            _proveedores.removeWhere((item) => item.id == proveedor.id);
            _aplicarFiltros();
          });
        },
      ),
    );
  }

  Widget _buildBadgeEstado(String estado, bool isDark) {
    final activo = estado == 'Activo';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: activo
            ? (isDark ? const Color(0xFF13381F) : Colors.green[100])
            : (isDark ? const Color(0xFF3B1C1C) : Colors.red[100]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            estado.toUpperCase(),
            style: TextStyle(
              color: activo
                  ? (isDark ? const Color(0xFF81C995) : Colors.green[800])
                  : (isDark ? const Color(0xFFF28B82) : Colors.red[800]),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.keyboard_arrow_down,
            size: 14,
            color: activo
                ? (isDark ? const Color(0xFF81C995) : Colors.green[800])
                : (isDark ? const Color(0xFFF28B82) : Colors.red[800]),
          ),
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
        onPressed: _abrirModalNuevo,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      // SOLUCIÓN: SafeArea protege contra la barra superior del celular
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Texto "Gestión de Proveedores" ELIMINADO
              Row(
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    color: primaryGold,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Proveedores',
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
                '${_proveedoresFiltrados.length} registros encontrados',
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
                    hintText: 'Buscar por nombre o NIT...',
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
                  itemCount: _proveedoresFiltrados.length,
                  itemBuilder: (context, index) {
                    final p = _proveedoresFiltrados[index];
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
                                  Icons.storefront_outlined,
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
                                            p.nombre,
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
                                          initialValue: p.estado,
                                          tooltip: 'Cambiar Estado',
                                          onSelected: (nuevoEstado) =>
                                              _cambiarEstadoDirecto(
                                                p,
                                                nuevoEstado,
                                              ),
                                          color: isDark
                                              ? const Color(0xFF252525)
                                              : Colors.white,
                                          itemBuilder: (context) =>
                                              ['Activo', 'Inactivo']
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
                                            p.estado,
                                            isDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${p.id} → NIT: ${p.nit}',
                                      style: TextStyle(
                                        color: subtitleColor,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Contacto: ${p.contacto} (${p.telefono})',
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
                                  onPressed: () => _abrirModalEditar(p),
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
                                  onPressed: () => _abrirModalEliminar(p),
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
