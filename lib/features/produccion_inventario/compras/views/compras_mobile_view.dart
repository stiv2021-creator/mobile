import 'package:flutter/material.dart';

class DetalleCompraMock {
  final String idDetalle;
  String nombreInsumo;
  int cantidad;
  double valorUnitario;

  DetalleCompraMock({
    required this.idDetalle,
    required this.nombreInsumo,
    required this.cantidad,
    required this.valorUnitario,
  });

  double get subtotal => cantidad * valorUnitario;
}

class CompraMasterMock {
  final String idCompra;
  String idProveedor;
  String fecha;
  String descripcion;
  String estado; // Pendiente, Recibida, En tránsito, Cancelada
  final List<DetalleCompraMock> detalles;

  CompraMasterMock({
    required this.idCompra,
    required this.idProveedor,
    required this.fecha,
    required this.descripcion,
    required this.estado,
    required this.detalles,
  });

  double get total => detalles.fold(0, (sum, item) => sum + item.subtotal);
}

class ComprasMobileView extends StatefulWidget {
  const ComprasMobileView({super.key});

  @override
  State<ComprasMobileView> createState() => _ComprasMobileViewState();
}

class _ComprasMobileViewState extends State<ComprasMobileView> {
  final TextEditingController _searchController = TextEditingController();
  String _filtroBusqueda = '';

  final List<CompraMasterMock> _compras = [
    CompraMasterMock(
      idCompra: 'COM-001',
      idProveedor: 'PROV-001',
      fecha: '2026-05-22',
      descripcion: 'Compra de hilos y marquillas',
      estado: 'Recibida',
      detalles: [
        DetalleCompraMock(idDetalle: 'DC-001', nombreInsumo: 'Hilo', cantidad: 50, valorUnitario: 4000),
        DetalleCompraMock(idDetalle: 'DC-002', nombreInsumo: 'Marquillas', cantidad: 12, valorUnitario: 8000),
      ],
    ),
    CompraMasterMock(
      idCompra: 'COM-002',
      idProveedor: 'PROV-002',
      fecha: '2026-05-20',
      descripcion: 'Compra de botones metálicos',
      estado: 'Pendiente',
      detalles: [
        DetalleCompraMock(idDetalle: 'DC-001', nombreInsumo: 'Botones Metálicos', cantidad: 60, valorUnitario: 6000),
      ],
    ),
    CompraMasterMock(
      idCompra: 'COM-003',
      idProveedor: 'PROV-001',
      fecha: '2026-05-24',
      descripcion: 'Compra general de insumos textiles',
      estado: 'En tránsito',
      detalles: [],
    ),
    CompraMasterMock(
      idCompra: 'COM-004',
      idProveedor: 'PROV-003',
      fecha: '2026-05-18',
      descripcion: 'Adquisición de cierres y cremalleras',
      estado: 'Recibida',
      detalles: [
        DetalleCompraMock(idDetalle: 'DC-001', nombreInsumo: 'Cremallera 20cm', cantidad: 100, valorUnitario: 2500),
      ],
    ),
    CompraMasterMock(
      idCompra: 'COM-005',
      idProveedor: 'PROV-002',
      fecha: '2026-05-15',
      descripcion: 'Rollos de tela lino',
      estado: 'Cancelada',
      detalles: [
        DetalleCompraMock(idDetalle: 'DC-001', nombreInsumo: 'Tela Lino Blanco', cantidad: 30, valorUnitario: 25000),
      ],
    ),
    CompraMasterMock(
      idCompra: 'COM-006',
      idProveedor: 'PROV-004',
      fecha: '2026-05-14',
      descripcion: 'Insumos de empaque y etiquetas',
      estado: 'Recibida',
      detalles: [
        DetalleCompraMock(idDetalle: 'DC-001', nombreInsumo: 'Bolsas Ecológicas', cantidad: 200, valorUnitario: 1200),
        DetalleCompraMock(idDetalle: 'DC-002', nombreInsumo: 'Etiquetas de cartón', cantidad: 500, valorUnitario: 300),
      ],
    ),
    CompraMasterMock(
      idCompra: 'COM-007',
      idProveedor: 'PROV-001',
      fecha: '2026-05-10',
      descripcion: 'Compra urgente de agujas industriales',
      estado: 'Pendiente',
      detalles: [
        DetalleCompraMock(idDetalle: 'DC-001', nombreInsumo: 'Agujas DBx1 #14', cantidad: 10, valorUnitario: 15000),
      ],
    ),
    CompraMasterMock(
      idCompra: 'COM-008',
      idProveedor: 'PROV-005',
      fecha: '2026-05-08',
      descripcion: 'Elásticos y cintas decorativas',
      estado: 'Recibida',
      detalles: [
        DetalleCompraMock(idDetalle: 'DC-001', nombreInsumo: 'Elástico de 1 pulgada', cantidad: 40, valorUnitario: 5000),
      ],
    ),
  ];

  final Set<String> _expandidas = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildCircleIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
        ),
      ),
    );
  }

  void _mostrarConfirmacion({
    required BuildContext context,
    required String titulo,
    required String mensaje,
    required VoidCallback onConfirmar,
  }) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg = isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
    final Color textColor = isDarkMode ? const Color(0xFFF8F9FA) : const Color(0xFF121212);
    const Color goldColor = Color(0xFFC9A227);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: goldColor.withOpacity(0.3)), // <--- CORREGIDO AQUÍ
        ),
        title: Text(
          titulo,
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, fontSize: 16, color: textColor),
        ),
        content: Text(
          mensaje,
          style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: textColor.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(fontFamily: 'Montserrat', color: textColor.withOpacity(0.6))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC3545),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
              onConfirmar();
            },
            child: const Text('Eliminar', style: TextStyle(fontFamily: 'Montserrat', color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final Color cardBg = isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
    final Color textColor = isDarkMode ? const Color(0xFFF8F9FA) : const Color(0xFF121212);
    final Color subtleColor = isDarkMode ? const Color(0xFF9A9A9A) : const Color(0xFF6B6B6B);
    const Color goldColor = Color(0xFFC9A227);

    final comprasFiltradas = _compras.where((c) {
      final query = _filtroBusqueda.toLowerCase();
      return c.idCompra.toLowerCase().contains(query) ||
          c.idProveedor.toLowerCase().contains(query) ||
          c.descripcion.toLowerCase().contains(query);
    }).toList();

    int totalDetallesCount = comprasFiltradas.fold(0, (sum, c) => sum + c.detalles.length);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        title: Text(
          'Compras',
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, fontSize: 20, color: textColor),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _filtroBusqueda = value),
              decoration: InputDecoration(
                hintText: 'Buscar por ID, proveedor o descripción...',
                hintStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: subtleColor),
                prefixIcon: const Icon(Icons.search, color: goldColor),
                suffixIcon: _filtroBusqueda.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _filtroBusqueda = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: cardBg,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: goldColor)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, color: textColor),
            ),
          ),
          Expanded(
            child: comprasFiltradas.isEmpty
                ? Center(
                    child: Text(
                      'No se encontraron compras',
                      style: TextStyle(fontFamily: 'Montserrat', color: subtleColor, fontSize: 13),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: comprasFiltradas.length,
                    itemBuilder: (context, index) {
                      final compra = comprasFiltradas[index];
                      final isExpanded = _expandidas.contains(compra.idCompra);
                      return _buildCompraCard(compra, isExpanded, cardBg, textColor, subtleColor, goldColor);
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: cardBg,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${comprasFiltradas.length} compras · $totalDetallesCount detalles',
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 12, color: subtleColor, fontWeight: FontWeight.w600),
                ),
                const Icon(Icons.info_outline, size: 16, color: goldColor),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarModalNuevaCompra(context),
        backgroundColor: goldColor,
        icon: const Icon(Icons.add, color: Color(0xFF121212)),
        label: const Text(
          'Nueva Compra',
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, color: Color(0xFF121212)),
        ),
      ),
    );
  }

  Widget _buildCompraCard(
    CompraMasterMock compra,
    bool isExpanded,
    Color cardBg,
    Color textColor,
    Color subtleColor,
    Color goldColor,
  ) {
    Color estadoColor;
    if (compra.estado == 'Recibida') {
      estadoColor = const Color(0xFF28A745);
    } else if (compra.estado == 'Pendiente') {
      estadoColor = const Color(0xFFFFC107);
    } else if (compra.estado == 'En tránsito') {
      estadoColor = const Color(0xFFFD7E14);
    } else {
      estadoColor = const Color(0xFFDC3545);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: goldColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: goldColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            compra.idCompra,
                            style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700, fontSize: 11, color: goldColor),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: goldColor.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${compra.detalles.length} ${compra.detalles.length == 1 ? 'ítem' : 'ítems'}',
                            style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w600, fontSize: 10, color: goldColor),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildCircleIconButton(
                          icon: Icons.visibility_outlined,
                          color: const Color(0xFF007BFF),
                          tooltip: 'Ver Detalle',
                          onPressed: () {
                            setState(() {
                              if (isExpanded) {
                                _expandidas.remove(compra.idCompra);
                              } else {
                                _expandidas.add(compra.idCompra);
                              }
                            });
                          },
                        ),
                        const SizedBox(width: 6),
                        _buildCircleIconButton(
                          icon: Icons.edit_outlined,
                          color: goldColor,
                          tooltip: 'Editar Compra',
                          onPressed: () => _mostrarModalEditarCompra(context, compra),
                        ),
                        const SizedBox(width: 6),
                        _buildCircleIconButton(
                          icon: Icons.delete_outline,
                          color: const Color(0xFFDC3545),
                          tooltip: 'Eliminar Compra',
                          onPressed: () {
                            _mostrarConfirmacion(
                              context: context,
                              titulo: 'Eliminar Compra',
                              mensaje: '¿Deseas confirmar la eliminación de la orden ${compra.idCompra}?',
                              onConfirmar: () {
                                setState(() {
                                  _compras.removeWhere((c) => c.idCompra == compra.idCompra);
                                });
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Proveedor: ${compra.idProveedor}',
                      style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 13, color: textColor),
                    ),
                    Text(
                      compra.fecha,
                      style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: subtleColor),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  compra.descripcion,
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 12, color: subtleColor),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: estadoColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        compra.estado.toUpperCase(),
                        style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 9, color: estadoColor),
                      ),
                    ),
                    Text(
                      compra.detalles.isEmpty ? '—' : '\$${compra.total.toStringAsFixed(0)}',
                      style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, fontSize: 15, color: goldColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isExpanded)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: goldColor.withOpacity(0.04),
                border: Border(top: BorderSide(color: goldColor.withOpacity(0.2))),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'DETALLE_COMPRA — ${compra.idCompra}',
                        style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, fontSize: 11, color: goldColor, letterSpacing: 0.5),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () => _mostrarModalAgregarDetalle(context, compra),
                        icon: Icon(Icons.add_circle_outline, size: 14, color: goldColor),
                        label: Text('Agregar Ítem', style: TextStyle(fontFamily: 'Montserrat', fontSize: 11, fontWeight: FontWeight.w700, color: goldColor)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (compra.detalles.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          'No hay insumos registrados en esta compra.',
                          style: TextStyle(fontFamily: 'Montserrat', fontSize: 11, color: subtleColor, fontStyle: FontStyle.italic),
                        ),
                      ),
                    )
                  else
                    ...compra.detalles.map((det) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: goldColor.withOpacity(0.15)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(det.idDetalle, style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w700, fontSize: 10, color: goldColor)),
                                        const SizedBox(width: 6),
                                        Text(det.nombreInsumo, style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 12, color: textColor)),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text('Cant: ${det.cantidad} x \$${det.valorUnitario.toStringAsFixed(0)}', style: TextStyle(fontFamily: 'Montserrat', fontSize: 11, color: subtleColor)),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '\$${det.subtotal.toStringAsFixed(0)}',
                                    style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 12, color: goldColor),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildCircleIconButton(
                                    icon: Icons.edit_outlined,
                                    color: goldColor,
                                    tooltip: 'Editar Ítem',
                                    onPressed: () => _mostrarModalEditarDetalle(context, compra, det),
                                  ),
                                  const SizedBox(width: 6),
                                  _buildCircleIconButton(
                                    icon: Icons.delete_outline,
                                    color: const Color(0xFFDC3545),
                                    tooltip: 'Eliminar Ítem',
                                    onPressed: () {
                                      _mostrarConfirmacion(
                                        context: context,
                                        titulo: 'Eliminar Ítem',
                                        mensaje: '¿Deseas confirmar la eliminación de "${det.nombreInsumo}"?',
                                        onConfirmar: () {
                                          setState(() {
                                            compra.detalles.removeWhere((d) => d.idDetalle == det.idDetalle);
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                  if (compra.detalles.isNotEmpty) ...[
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('TOTAL COMPRA', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 11, color: subtleColor)),
                        Text('\$${compra.total.toStringAsFixed(0)}', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, fontSize: 14, color: goldColor)),
                      ],
                    ),
                  ]
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _mostrarModalNuevaCompra(BuildContext context) {
    final TextEditingController proveedorController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    String estadoSeleccionado = 'Pendiente';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final Color cardBg = isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
        final Color textColor = isDarkMode ? const Color(0xFFF8F9FA) : const Color(0xFF121212);
        const Color goldColor = Color(0xFFC9A227);

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                border: Border.all(color: goldColor.withOpacity(0.4)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 10,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.white24 : Colors.black26,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Nueva Compra', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, fontSize: 18, color: textColor)),
                        IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context))
                      ],
                    ),
                    const Divider(color: Color(0x40C9A227)),
                    const SizedBox(height: 12),
                    _buildModalField('PROVEEDOR', 'Ej. PROV-001', proveedorController),
                    const SizedBox(height: 12),
                    _buildModalField('DESCRIPCIÓN', 'Descripción general de la compra', descController),
                    const SizedBox(height: 12),
                    Text('ESTADO', style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF9A9A9A))),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: estadoSeleccionado,
                      dropdownColor: cardBg,
                      items: ['Pendiente', 'Recibida', 'En tránsito', 'Cancelada']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: textColor))))
                          .toList(),
                      onChanged: (val) => setModalState(() => estadoSeleccionado = val!),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[100],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goldColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          if (proveedorController.text.isNotEmpty) {
                            setState(() {
                              String nuevoId = 'COM-00${_compras.length + 1}';
                              _compras.add(CompraMasterMock(
                                idCompra: nuevoId,
                                idProveedor: proveedorController.text,
                                fecha: DateTime.now().toString().substring(0, 10),
                                descripcion: descController.text.isEmpty ? 'Compra general' : descController.text,
                                estado: estadoSeleccionado,
                                detalles: [],
                              ));
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Guardar', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF121212))),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _mostrarModalEditarCompra(BuildContext context, CompraMasterMock compra) {
    final TextEditingController proveedorController = TextEditingController(text: compra.idProveedor);
    final TextEditingController descController = TextEditingController(text: compra.descripcion);
    String estadoSeleccionado = compra.estado;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final Color cardBg = isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
        final Color textColor = isDarkMode ? const Color(0xFFF8F9FA) : const Color(0xFF121212);
        const Color goldColor = Color(0xFFC9A227);

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                border: Border.all(color: goldColor.withOpacity(0.4)),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 10,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.white24 : Colors.black26,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Editar Compra (${compra.idCompra})', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, fontSize: 18, color: textColor)),
                        IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context))
                      ],
                    ),
                    const Divider(color: Color(0x40C9A227)),
                    const SizedBox(height: 12),
                    _buildModalField('PROVEEDOR', 'Proveedor', proveedorController),
                    const SizedBox(height: 12),
                    _buildModalField('DESCRIPCIÓN', 'Descripción', descController),
                    const SizedBox(height: 12),
                    Text('ESTADO', style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF9A9A9A))),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: estadoSeleccionado,
                      dropdownColor: cardBg,
                      items: ['Pendiente', 'Recibida', 'En tránsito', 'Cancelada']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontFamily: 'Montserrat', fontSize: 13, color: textColor))))
                          .toList(),
                      onChanged: (val) => setModalState(() => estadoSeleccionado = val!),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.grey[100],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goldColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          setState(() {
                            compra.idProveedor = proveedorController.text;
                            compra.descripcion = descController.text;
                            compra.estado = estadoSeleccionado;
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Guardar Cambios', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF121212))),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _mostrarModalAgregarDetalle(BuildContext context, CompraMasterMock compra) {
    final TextEditingController insumoController = TextEditingController();
    final TextEditingController cantController = TextEditingController();
    final TextEditingController valorController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final Color cardBg = isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
        final Color textColor = isDarkMode ? const Color(0xFFF8F9FA) : const Color(0xFF121212);
        const Color goldColor = Color(0xFFC9A227);

        return Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(color: goldColor.withOpacity(0.4)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 10,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(2))),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Agregar Ítem a ${compra.idCompra}', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, fontSize: 16, color: textColor)),
                    IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context))
                  ],
                ),
                const Divider(color: Color(0x40C9A227)),
                const SizedBox(height: 12),
                _buildModalField('NOMBRE DEL INSUMO', 'Ej. Cierre metálico', insumoController),
                const SizedBox(height: 12),
                _buildModalField('CANTIDAD', 'Ej. 25', cantController, isNumber: true),
                const SizedBox(height: 12),
                _buildModalField('VALOR UNITARIO', 'Ej. 3500', valorController, isNumber: true),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: goldColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      if (insumoController.text.isNotEmpty && cantController.text.isNotEmpty && valorController.text.isNotEmpty) {
                        setState(() {
                          String idDetalle = 'DC-00${compra.detalles.length + 1}';
                          compra.detalles.add(DetalleCompraMock(
                            idDetalle: idDetalle,
                            nombreInsumo: insumoController.text,
                            cantidad: int.tryParse(cantController.text) ?? 1,
                            valorUnitario: double.tryParse(valorController.text) ?? 0.0,
                          ));
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Agregar al Detalle', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF121212))),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  void _mostrarModalEditarDetalle(BuildContext context, CompraMasterMock compra, DetalleCompraMock detalle) {
    final TextEditingController insumoController = TextEditingController(text: detalle.nombreInsumo);
    final TextEditingController cantController = TextEditingController(text: detalle.cantidad.toString());
    final TextEditingController valorController = TextEditingController(text: detalle.valorUnitario.toStringAsFixed(0));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final Color cardBg = isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
        final Color textColor = isDarkMode ? const Color(0xFFF8F9FA) : const Color(0xFF121212);
        const Color goldColor = Color(0xFFC9A227);

        return Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(color: goldColor.withOpacity(0.4)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 10,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(2))),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Editar Ítem (${detalle.idDetalle})', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w800, fontSize: 16, color: textColor)),
                    IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context))
                  ],
                ),
                const Divider(color: Color(0x40C9A227)),
                const SizedBox(height: 12),
                _buildModalField('NOMBRE DEL INSUNO', 'Nombre', insumoController),
                const SizedBox(height: 12),
                _buildModalField('CANTIDAD', 'Cantidad', cantController, isNumber: true),
                const SizedBox(height: 12),
                _buildModalField('VALOR UNITARIO', 'Valor unitario', valorController, isNumber: true),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: goldColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      setState(() {
                        detalle.nombreInsumo = insumoController.text;
                        detalle.cantidad = int.tryParse(cantController.text) ?? detalle.cantidad;
                        detalle.valorUnitario = double.tryParse(valorController.text) ?? detalle.valorUnitario;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Actualizar Ítem', style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF121212))),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModalField(String label, String hint, TextEditingController controller, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF9A9A9A)),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFF2A2A2A),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFC9A227))),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          style: const TextStyle(fontFamily: 'Montserrat', fontSize: 14, color: Colors.white),
        ),
      ],
    );
  }
}