import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/produccion_model.dart';

class ProduccionCard extends StatefulWidget {
  final ProduccionModel produccion;
  final Function(ProduccionModel) onUpdate;

  const ProduccionCard({
    super.key,
    required this.produccion,
    required this.onUpdate,
  });

  @override
  State<ProduccionCard> createState() => _ProduccionCardState();
}

class _ProduccionCardState extends State<ProduccionCard> {
  bool _isActionExecuting = false;

  // Catálogo temporal de insumos.
  static const Map<String, String> _catalogoInsumos = {
    'INS-001': 'Tela lona',
    'INS-005': 'Tela de algodón',
    'INS-010': 'Hilo resistente negro',
    'CLI-001': 'Cierres metálicos personalizados',
    'CLI-002': 'Botones de metal grabados',
  };

  String _obtenerNombreInsumo(String idInsumo, String idInsumoCliente) {
    final idSeleccionado =
        (idInsumoCliente.isNotEmpty && idInsumoCliente != 'N/A')
        ? idInsumoCliente
        : idInsumo;

    if (idSeleccionado.isEmpty || idSeleccionado == 'N/A') {
      return 'Sin insumo seleccionado';
    }

    return _catalogoInsumos[idSeleccionado] ?? 'Insumo registrado';
  }

  Color _obtenerColorEstado(String estado) {
    switch (estado) {
      case 'En proceso':
        return const Color(0xFFFD7E14);
      case 'Pendiente':
        return const Color(0xFFF1C40F);
      case 'Completado':
        return const Color(0xFF28A745);
      case 'Cancelado':
        return const Color(0xFFDC3545);
      default:
        return const Color(0xFF6B6B6B);
    }
  }

  Future<void> _mostrarDetalles(BuildContext context) async {
    if (_isActionExecuting) return;

    setState(() => _isActionExecuting = true);

    // Adaptación a Modo Oscuro / Claro del compañero
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color modalBg = isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
    final Color subtitleColor = isDarkMode
        ? Colors.grey[400]!
        : const Color(0xFF6B6B6B);
    final Color containerBg = isDarkMode
        ? const Color(0xFF252525)
        : const Color(0xFFF8F9FA);
    final Color borderColor = isDarkMode
        ? Colors.white24
        : const Color(0xFFE0E0E0);
    final Color dividerColor = isDarkMode
        ? Colors.white12
        : const Color(0xFFE0E0E0);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: modalBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Detalles de ${widget.produccion.idProduccion}',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFD4AF37),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: subtitleColor),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),

            Divider(height: 24, color: dividerColor),

            Expanded(
              child: widget.produccion.detalles.isEmpty
                  ? Center(
                      child: Text(
                        'No hay detalles asignados.',
                        style: GoogleFonts.montserrat(color: subtitleColor),
                      ),
                    )
                  : ListView.builder(
                      itemCount: widget.produccion.detalles.length,
                      itemBuilder: (c, i) {
                        final det = widget.produccion.detalles[i];

                        final insumoNombre = _obtenerNombreInsumo(
                          det.idInsumos,
                          det.idInsumosEnviadosXCliente,
                        );

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: containerBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    det.idDetalleProduccion,
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: const Color(0xFFD4AF37),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFD4AF37)
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Cant: ${det.cantidadAsignada}',
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: const Color(0xFFD4AF37),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Divider(height: 16, color: dividerColor),

                              _buildDetalleFila(
                                Icons.badge_outlined,
                                'Empleado',
                                det.idEmpleado,
                                isDarkMode,
                              ),

                              const SizedBox(height: 8),

                              _buildDetalleFila(
                                Icons.extension_outlined,
                                'Tipo de Pieza',
                                det.idTipoPieza,
                                isDarkMode,
                              ),

                              const SizedBox(height: 8),

                              _buildDetalleFila(
                                Icons.settings_suggest_outlined,
                                'Tipo de Máquina',
                                det.idTipoMaquina,
                                isDarkMode,
                              ),

                              const SizedBox(height: 8),

                              _buildDetalleFila(
                                Icons.inventory_2_outlined,
                                'Insumo a utilizar',
                                insumoNombre,
                                isDarkMode,
                              ),

                              const SizedBox(height: 8),

                              _buildDetalleFila(
                                Icons.calendar_today_outlined,
                                'Fecha Asignada',
                                det.fechaAsignada,
                                isDarkMode,
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
    );

    if (mounted) {
      setState(() => _isActionExecuting = false);
    }
  }

  Widget _buildDetalleFila(
    IconData icono,
    String etiqueta,
    String valor,
    bool isDarkMode,
  ) {
    return Row(
      children: [
        Icon(
          icono,
          size: 16,
          color: isDarkMode ? Colors.grey[500] : const Color(0xFF9E9E9E),
        ),
        const SizedBox(width: 8),
        Text(
          '$etiqueta: ',
          style: GoogleFonts.montserrat(
            fontSize: 13,
            color: isDarkMode ? Colors.grey[400] : const Color(0xFF6B6B6B),
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            valor,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              color: isDarkMode ? Colors.white : const Color(0xFF121212),
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Future<void> _mostrarEdicion(BuildContext context) async {
    if (_isActionExecuting) return;

    setState(() => _isActionExecuting = true);

    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color modalBg = isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF121212);
    final Color containerBg = isDarkMode
        ? const Color(0xFF252525)
        : const Color(0xFFF8F9FA);
    final Color borderColor = isDarkMode
        ? Colors.white24
        : const Color(0xFFE0E0E0);
    final Color dividerColor = isDarkMode
        ? Colors.white12
        : const Color(0xFFE0E0E0);

    final ordenPedidoCtrl = TextEditingController(
      text: widget.produccion.idOrdenPedido,
    );

    final fechaInicioCtrl = TextEditingController(
      text: widget.produccion.fechaInicio,
    );

    final fechaEntregaCtrl = TextEditingController(
      text: widget.produccion.fechaEntrega,
    );

    String estadoSeleccionado = widget.produccion.estado;

    final List<Map<String, dynamic>> detallesState = widget.produccion.detalles
        .map<Map<String, dynamic>>((d) {
          final insumoActual =
              (d.idInsumosEnviadosXCliente.isNotEmpty &&
                  d.idInsumosEnviadosXCliente != 'N/A')
              ? d.idInsumosEnviadosXCliente
              : d.idInsumos;

          return {
            'idEmpleado': TextEditingController(text: d.idEmpleado),
            'idTipoPieza': TextEditingController(text: d.idTipoPieza),
            'idTipoMaquina': TextEditingController(text: d.idTipoMaquina),
            'cantidad': TextEditingController(text: d.cantidadAsignada),
            'fechaAsignada': TextEditingController(text: d.fechaAsignada),
            'insumoSeleccionado': _catalogoInsumos.containsKey(insumoActual)
                ? insumoActual
                : null,
          };
        })
        .toList();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: modalBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              padding: EdgeInsets.only(
                top: 24,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Editar ${widget.produccion.idProduccion}',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFD4AF37),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: isDarkMode
                              ? Colors.grey[400]
                              : const Color(0xFF6B6B6B),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Datos de Producción',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),

                          const SizedBox(height: 12),

                          TextField(
                            controller: ordenPedidoCtrl,
                            style: TextStyle(color: textColor),
                            decoration: _inputDecoration(
                              'Orden de Pedido',
                              isDarkMode,
                            ),
                          ),

                          const SizedBox(height: 12),

                          DropdownButtonFormField<String>(
                            decoration: _inputDecoration('Estado', isDarkMode),
                            value: estadoSeleccionado,
                            dropdownColor: containerBg,
                            items:
                                [
                                  'Pendiente',
                                  'En proceso',
                                  'Completado',
                                  'Cancelado',
                                ].map((e) {
                                  return DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: GoogleFonts.montserrat(
                                        color: textColor,
                                      ),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setModalState(() => estadoSeleccionado = val);
                              }
                            },
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: fechaInicioCtrl,
                                  style: TextStyle(color: textColor),
                                  decoration: _inputDecoration(
                                    'Fecha Inicio',
                                    isDarkMode,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: fechaEntregaCtrl,
                                  style: TextStyle(color: textColor),
                                  decoration: _inputDecoration(
                                    'Fecha Entrega',
                                    isDarkMode,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),
                          Divider(color: dividerColor),
                          const SizedBox(height: 12),

                          Text(
                            'Detalles Asignados',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),

                          const SizedBox(height: 12),

                          ...List.generate(widget.produccion.detalles.length, (
                            index,
                          ) {
                            final state = detallesState[index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: containerBg,
                                border: Border.all(color: borderColor),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget
                                        .produccion
                                        .detalles[index]
                                        .idDetalleProduccion,
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFD4AF37),
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: state['idEmpleado'],
                                          style: TextStyle(color: textColor),
                                          decoration: _inputDecoration(
                                            'Empleado',
                                            isDarkMode,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: TextField(
                                          controller: state['cantidad'],
                                          style: TextStyle(color: textColor),
                                          decoration: _inputDecoration(
                                            'Cantidad',
                                            isDarkMode,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: state['idTipoPieza'],
                                          style: TextStyle(color: textColor),
                                          decoration: _inputDecoration(
                                            'Pieza',
                                            isDarkMode,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: TextField(
                                          controller: state['idTipoMaquina'],
                                          style: TextStyle(color: textColor),
                                          decoration: _inputDecoration(
                                            'Máquina',
                                            isDarkMode,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  DropdownButtonFormField<String>(
                                    decoration: _inputDecoration(
                                      'Insumo a utilizar',
                                      isDarkMode,
                                    ),
                                    value: state['insumoSeleccionado'],
                                    dropdownColor: containerBg,
                                    items: _catalogoInsumos.entries.map((
                                      entry,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: entry.key,
                                        child: Text(
                                          entry.value,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 12,
                                            color: textColor,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setModalState(() {
                                        state['insumoSeleccionado'] = val;
                                      });
                                    },
                                  ),

                                  const SizedBox(height: 8),

                                  TextField(
                                    controller: state['fechaAsignada'],
                                    style: TextStyle(color: textColor),
                                    decoration: _inputDecoration(
                                      'Fecha Asignada',
                                      isDarkMode,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        widget.produccion.idOrdenPedido = ordenPedidoCtrl.text;

                        widget.produccion.fechaInicio = fechaInicioCtrl.text;

                        widget.produccion.fechaEntrega = fechaEntregaCtrl.text;

                        widget.produccion.estado = estadoSeleccionado;

                        for (
                          int i = 0;
                          i < widget.produccion.detalles.length;
                          i++
                        ) {
                          final detalle = widget.produccion.detalles[i];

                          detalle.idEmpleado =
                              detallesState[i]['idEmpleado']!.text;

                          detalle.idTipoPieza =
                              detallesState[i]['idTipoPieza']!.text;

                          detalle.idTipoMaquina =
                              detallesState[i]['idTipoMaquina']!.text;

                          detalle.cantidadAsignada =
                              detallesState[i]['cantidad']!.text;

                          detalle.fechaAsignada =
                              detallesState[i]['fechaAsignada']!.text;

                          detalle.detalleRem = '';

                          final String? insumoElegido =
                              detallesState[i]['insumoSeleccionado'];

                          if (insumoElegido == null || insumoElegido.isEmpty) {
                            detalle.idInsumos = 'N/A';
                            detalle.idInsumosEnviadosXCliente = 'N/A';
                          } else if (insumoElegido.startsWith('CLI-')) {
                            detalle.idInsumos = 'N/A';
                            detalle.idInsumosEnviadosXCliente = insumoElegido;
                          } else {
                            detalle.idInsumos = insumoElegido;

                            detalle.idInsumosEnviadosXCliente = 'N/A';
                          }
                        }

                        widget.onUpdate(widget.produccion);

                        Navigator.pop(context);
                      },
                      child: Text(
                        'Guardar Cambios',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (mounted) {
      setState(() => _isActionExecuting = false);
    }
  }

  InputDecoration _inputDecoration(String label, bool isDarkMode) {
    final Color borderColor = isDarkMode
        ? Colors.white24
        : const Color(0xFFE0E0E0);
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.montserrat(
        fontSize: 12,
        color: isDarkMode ? Colors.grey[500] : const Color(0xFF9E9E9E),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD4AF37)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorEstado = _obtenerColorEstado(widget.produccion.estado);

    // Colores dinámicos integrados con el theme provider de tu compañero
    final cardColor = isDarkMode ? const Color(0xFF252525) : Colors.white;
    final iconBgColor = isDarkMode ? const Color(0xFF333333) : Colors.white;
    final borderColor = isDarkMode ? Colors.white12 : const Color(0xFFE0E0E0);
    final textColorPrimary = isDarkMode
        ? Colors.white
        : const Color(0xFF121212);
    final textColorSecondary = isDarkMode
        ? Colors.grey[400]!
        : const Color(0xFF6B6B6B);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFD4AF37).withOpacity(0.5),
                  ),
                ),
                child: const Icon(
                  Icons.factory_outlined,
                  color: Color(0xFFD4AF37),
                  size: 24,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.produccion.idProduccion,
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColorPrimary,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${widget.produccion.fechaInicio} ➔ ${widget.produccion.fechaEntrega}',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: textColorSecondary,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      '${widget.produccion.detalles.length} detalles (empleados asignados)',
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        color: isDarkMode
                            ? Colors.grey[500]
                            : const Color(0xFF9E9E9E),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorEstado.withOpacity(isDarkMode ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.produccion.estado,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: colorEstado,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Divider(color: isDarkMode ? Colors.white12 : const Color(0xFFF0F0F0)),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.remove_red_eye_outlined,
                    size: 16,
                    color: Color(0xFFD4AF37),
                  ),
                  onPressed: _isActionExecuting
                      ? null
                      : () => _mostrarDetalles(context),
                  tooltip: 'Ver Detalles',
                ),
              ),

              const SizedBox(width: 12),

              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: Color(0xFFD4AF37),
                  ),
                  onPressed: _isActionExecuting
                      ? null
                      : () => _mostrarEdicion(context),
                  tooltip: 'Editar Producción',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
