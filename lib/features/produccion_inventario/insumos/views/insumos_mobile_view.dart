import 'package:flutter/material.dart';

class InsumosMobileView extends StatefulWidget {
  const InsumosMobileView({super.key});

  @override
  State<InsumosMobileView> createState() => _InsumosMobileViewState();
}

class _InsumosMobileViewState extends State<InsumosMobileView> {
  final TextEditingController _searchController = TextEditingController();
  String _filtroBusqueda = '';

  final List<Map<String, dynamic>> _insumos = [
    {
      'codigo': 'INS-001',
      'nombre': 'Hilo Algodón Blanco',
      'tipo': 'Armado',
      'categoria': 'Hilos',
      'unidad': 'Carretes',
      'cantidad': '12',
      'stockMinimo': '5',
      'stockBajo': false,
      'notas': 'Proveedor principal: Hilos y más...',
      'icon': Icons.hourglass_empty_rounded,
    },
    {
      'codigo': 'INS-002',
      'nombre': 'Botones Nácar 20mm',
      'tipo': 'Detalle',
      'categoria': 'Botones',
      'unidad': 'Docenas',
      'cantidad': '3',
      'stockMinimo': '5',
      'stockBajo': true,
      'notas': 'Color perlado brillante',
      'icon': Icons.radio_button_checked_rounded,
    },
    {
      'codigo': 'INS-003',
      'nombre': 'Cierre Metálico 15cm',
      'tipo': 'Armado',
      'categoria': 'Cierres',
      'unidad': 'Unidades',
      'cantidad': '25',
      'stockMinimo': '10',
      'stockBajo': false,
      'notas': 'Cierres metálicos resistentes',
      'icon': Icons.view_stream_rounded,
    },
    {
      'codigo': 'INS-004',
      'nombre': 'Tela Lino Natural',
      'tipo': 'Materia prima',
      'categoria': 'Telas',
      'unidad': 'Metros',
      'cantidad': '45',
      'stockMinimo': '15',
      'stockBajo': false,
      'notas': 'Ideal para camisas',
      'icon': Icons.texture_rounded,
    },
    {
      'codigo': 'INS-005',
      'nombre': 'Elástico Reforzado 1cm',
      'tipo': 'Detalle',
      'categoria': 'Elásticos',
      'unidad': 'Rolos',
      'cantidad': '5',
      'stockMinimo': '8',
      'stockBajo': true,
      'notas': 'Color negro y blanco',
      'icon': Icons.all_inclusive_rounded,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    final doradoColor = const Color(0xFFD4AF37);
    final circleBackgroundColor = isDarkMode ? doradoColor.withValues(alpha: 0.08) : doradoColor.withValues(alpha: 0.05);

    // Filtrado dinámico según el texto ingresado en el buscador
    final insumosFiltrados = _insumos.where((item) {
      final query = _filtroBusqueda.toLowerCase();
      final nombre = item['nombre'].toString().toLowerCase();
      final codigo = item['codigo'].toString().toLowerCase();
      final categoria = item['categoria'].toString().toLowerCase();
      return nombre.contains(query) || codigo.contains(query) || categoria.contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Insumos', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
                      const SizedBox(height: 2),
                      Text('${insumosFiltrados.length} de ${_insumos.length} registros', style: TextStyle(fontSize: 12, color: subTextColor)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _filtroBusqueda = value),
                style: TextStyle(color: textColor, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre, código o categoría...',
                  hintStyle: TextStyle(color: subTextColor, fontSize: 13),
                  prefixIcon: Icon(Icons.search, color: subTextColor),
                  suffixIcon: _filtroBusqueda.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, size: 18, color: subTextColor),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _filtroBusqueda = '';
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: isDarkMode ? const Color(0xFF252525) : const Color(0xFFF1F3F5),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: insumosFiltrados.isEmpty
                    ? Center(
                        child: Text('No se encontraron insumos', style: TextStyle(color: subTextColor, fontSize: 13)),
                      )
                    : ListView.builder(
                        itemCount: insumosFiltrados.length,
                        itemBuilder: (context, index) {
                          final item = insumosFiltrados[index];
                          // Encontramos el índice real en la lista principal para actualizar o eliminar correctamente
                          final realIndex = _insumos.indexOf(item);

                          return _buildInsumoCard(
                            cardColor: cardColor,
                            textColor: textColor,
                            subTextColor: subTextColor,
                            doradoColor: doradoColor,
                            circleBackgroundColor: circleBackgroundColor,
                            item: item,
                            isDarkMode: isDarkMode,
                            onEditPressed: () {
                              _mostrarModalEditar(context, item, isDarkMode, doradoColor, (datosActualizados) {
                                setState(() {
                                  _insumos[realIndex] = datosActualizados;
                                });
                              });
                            },
                            onDeletePressed: () {
                              setState(() {
                                _insumos.removeAt(realIndex);
                              });
                            },
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

  Widget _buildInsumoCard({
    required Color cardColor,
    required Color textColor,
    required Color subTextColor,
    required Color doradoColor,
    required Color circleBackgroundColor,
    required Map<String, dynamic> item,
    required bool isDarkMode,
    required VoidCallback onEditPressed,
    required VoidCallback onDeletePressed,
  }) {
    final String codigo = item['codigo'];
    final String nombre = item['nombre'];
    final String categoria = item['categoria'];
    final String tipo = item['tipo'] ?? 'General';
    final String cantidad = '${item['cantidad']} ${item['unidad']}';
    final bool stockBajo = item['stockBajo'];
    final String notas = item['notas'] ?? '';
    final IconData icon = item['icon'];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: doradoColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(codigo, style: TextStyle(color: doradoColor, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: doradoColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('Tipo: $tipo', style: TextStyle(color: doradoColor, fontWeight: FontWeight.w600, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(shape: BoxShape.circle, color: circleBackgroundColor),
                child: Icon(icon, color: doradoColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nombre, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor)),
                    const SizedBox(height: 2),
                    Text(categoria, style: TextStyle(fontSize: 12, color: subTextColor)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: stockBajo ? Colors.red.withValues(alpha: 0.1) : doradoColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: stockBajo ? Colors.red.withValues(alpha: 0.3) : doradoColor.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      cantidad,
                      style: TextStyle(
                        fontSize: 13,
                        color: stockBajo ? Colors.red : doradoColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('Stock actual', style: TextStyle(fontSize: 9, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          if (stockBajo) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, size: 14, color: Colors.orange),
                const SizedBox(width: 4),
                const Text('Stock bajo mínimo', style: TextStyle(fontSize: 11, color: Colors.orange, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
          if (notas.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Descripción: $notas',
              style: TextStyle(fontSize: 12, color: subTextColor, fontStyle: FontStyle.italic),
            ),
          ],
          const SizedBox(height: 14),
          Divider(height: 1, color: isDarkMode ? Colors.grey[800] : Colors.black12),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _HoverActionButton(
                icon: Icons.edit_outlined,
                doradoColor: doradoColor,
                onTap: onEditPressed,
              ),
              const SizedBox(width: 8),
              _HoverActionButton(
                icon: Icons.delete_outline_rounded,
                doradoColor: doradoColor,
                onTap: onDeletePressed,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _mostrarModalEditar(BuildContext context, Map<String, dynamic> itemActual, bool isDarkMode, Color doradoColor, ValueChanged<Map<String, dynamic>> onGuardar) {
    final TextEditingController nombreController = TextEditingController(text: itemActual['nombre']);
    final TextEditingController stockActualController = TextEditingController(text: itemActual['cantidad']);
    final TextEditingController stockMinimoController = TextEditingController(text: itemActual['stockMinimo']);
    final TextEditingController notasController = TextEditingController(text: itemActual['notas'] ?? '');

    String categoriaSeleccionada = itemActual['categoria'];
    String unidadSeleccionada = itemActual['unidad'];
    String tipoSeleccionado = itemActual['tipo'] ?? 'Armado';

    final List<String> categorias = ['Hilos', 'Botones', 'Cierres', 'Telas', 'Elásticos', 'Mercería', 'Cintas'];
    final List<String> unidades = ['Carretes', 'Docenas', 'Unidades', 'Metros', 'Rolos', 'Paquetes'];
    final List<String> tipos = ['Armado', 'Detalle', 'Materia prima'];

    final dialogBg = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final inputBg = isDarkMode ? const Color(0xFF2D2D2D) : const Color(0xFFF1F3F5);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              backgroundColor: dialogBg,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Editar Insumo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                  IconButton(
                    icon: Icon(Icons.close, size: 20, color: textColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              content: SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('NOMBRE DEL INSUMO *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: nombreController,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: inputBg,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: doradoColor, width: 1.5)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('TIPO DE INSUMO *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: inputBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: doradoColor, width: 1.5),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: tipoSeleccionado,
                            isExpanded: true,
                            dropdownColor: dialogBg,
                            style: TextStyle(color: textColor, fontSize: 13),
                            items: tipos.map((t) => DropdownMenuItem(
                              value: t, 
                              child: Text(t, style: TextStyle(color: textColor, fontSize: 13)),
                            )).toList(),
                            onChanged: (val) => setStateModal(() => tipoSeleccionado = val!),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('CATEGORÍA *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: inputBg,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: doradoColor, width: 1.5),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: categoriaSeleccionada,
                                      isExpanded: true,
                                      dropdownColor: dialogBg,
                                      style: TextStyle(color: textColor, fontSize: 13),
                                      items: categorias.map((cat) => DropdownMenuItem(
                                        value: cat, 
                                        child: Text(cat, style: TextStyle(color: textColor, fontSize: 13)),
                                      )).toList(),
                                      onChanged: (val) => setStateModal(() => categoriaSeleccionada = val!),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('UNIDAD *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: inputBg,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: doradoColor, width: 1.5),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: unidadSeleccionada,
                                      isExpanded: true,
                                      dropdownColor: dialogBg,
                                      style: TextStyle(color: textColor, fontSize: 13),
                                      items: unidades.map((uni) => DropdownMenuItem(
                                        value: uni, 
                                        child: Text(uni, style: TextStyle(color: textColor, fontSize: 13)),
                                      )).toList(),
                                      onChanged: (val) => setStateModal(() => unidadSeleccionada = val!),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('STOCK ACTUAL *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: stockActualController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(color: textColor, fontSize: 14),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: inputBg,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: doradoColor, width: 1.5)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('STOCK MÍNIMO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: stockMinimoController,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(color: textColor, fontSize: 14),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: inputBg,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: doradoColor, width: 1.5)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text('DESCRIPCIÓN / NOTAS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: notasController,
                        maxLines: 2,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Proveedor, color, observaciones...',
                          hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                          filled: true,
                          fillColor: inputBg,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: doradoColor, width: 1.5)),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancelar', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: doradoColor,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          int actual = int.tryParse(stockActualController.text) ?? 0;
                          int minimo = int.tryParse(stockMinimoController.text) ?? 0;
                          bool stockBajoNuevo = actual <= minimo;

                          final datosNuevos = {
                            ...itemActual,
                            'nombre': nombreController.text,
                            'tipo': tipoSeleccionado,
                            'categoria': categoriaSeleccionada,
                            'unidad': unidadSeleccionada,
                            'cantidad': stockActualController.text,
                            'stockMinimo': stockMinimoController.text,
                            'stockBajo': stockBajoNuevo,
                            'notas': notasController.text,
                          };

                          onGuardar(datosNuevos);
                          Navigator.pop(context);
                        },
                        child: const Text('Guardar cambios', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _HoverActionButton extends StatefulWidget {
  final IconData icon;
  final Color doradoColor;
  final VoidCallback onTap;

  const _HoverActionButton({required this.icon, required this.doradoColor, required this.onTap});

  @override
  State<_HoverActionButton> createState() => _HoverActionButtonState();
}

class _HoverActionButtonState extends State<_HoverActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isHovered ? widget.doradoColor.withValues(alpha: 0.15) : Colors.transparent,
            border: Border.all(
              color: widget.doradoColor,
              width: _isHovered ? 1.5 : 1.2,
            ),
          ),
          child: Icon(
            widget.icon,
            size: 18,
            color: widget.doradoColor,
          ),
        ),
      ),
    );
  }
}