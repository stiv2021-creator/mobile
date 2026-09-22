import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/produccion_model.dart';
import '../views/editar_produccion_screen.dart'; // ¡Asegúrate de que esta ruta sea correcta hacia tu nuevo archivo!

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
                        final insumoNombre =
                            (det.idInsumosEnviadosXCliente.isNotEmpty &&
                                det.idInsumosEnviadosXCliente != 'N/A')
                            ? det.idInsumosEnviadosXCliente
                            : det.idInsumos;

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
                                'Pieza',
                                det.idTipoPieza,
                                isDarkMode,
                              ),
                              const SizedBox(height: 8),
                              _buildDetalleFila(
                                Icons.settings_suggest_outlined,
                                'Máquina',
                                det.idTipoMaquina,
                                isDarkMode,
                              ),
                              const SizedBox(height: 8),
                              _buildDetalleFila(
                                Icons.inventory_2_outlined,
                                'Insumo',
                                insumoNombre,
                                isDarkMode,
                              ),
                              const SizedBox(height: 8),
                              _buildDetalleFila(
                                Icons.calendar_today_outlined,
                                'Fecha Asig.',
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

  void _navegarAEdicion(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EditarProduccionScreen(
              produccion: widget.produccion,
              onUpdate: widget.onUpdate,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Animación de deslizamiento de derecha a izquierda al entrar
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          // Agregamos también un ligero desvanecimiento (fade) para que se vea más profesional
          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        transitionDuration: const Duration(
          milliseconds: 350,
        ), // Duración de la animación de salida
        reverseTransitionDuration: const Duration(
          milliseconds: 350,
        ), // Duración de la animación al devolverse
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorEstado = _obtenerColorEstado(widget.produccion.estado);

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
            color: Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.02),
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
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.5),
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
                    color: colorEstado.withValues(
                      alpha: isDarkMode ? 0.2 : 0.1,
                    ),
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
                  onPressed: () => _navegarAEdicion(context),
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
