import 'package:flutter/material.dart';

// ============================================================
// COLORES GENERALES DEL MÓDULO (LIGADOS A LA PALETA COMPARTIDA)
// ============================================================
const Color kGoldLight = Color(0xFFD4AF37);
const Color kGoldDark = Color(0xFFE5B800);
const Color kDarkBackground = Color(0xFF101010);
const Color kDarkCard = Color(0xFF1E1E1E);
const Color kDarkInput = Color(0xFF292929);
const Color kDarkBorder = Color(0xFF383838);
const Color kLightBackground = Color(0xFFF7F7F7);
const Color kLightCard = Color(0xFFFFFFFF);
const Color kLightInput = Color(0xFFF1F1F1);
const Color kLightBorder = Color(0xFFE2E2E2);
const Color kBlueColor = Color(0xFF4A90E2);
const Color kRedColor = Color(0xFFDC3545);
const Color kSuccessColor = Color(0xFF28A745);

// ============================================================
// MODELOS
// ============================================================
class RemisionItem {
  String id;
  String idCliente;
  String fichaTecnicaNombre;
  String fechaEntrega;
  List<FilaMatriz> filasAdulto;
  List<FilaMatriz> filasNinos;
  List<FilaMatriz> filasLetras;
  List<FilaPiezaSinTalla> filasPiezas;
  List<ResumenItem> resumen;

  RemisionItem({
    required this.id,
    required this.idCliente,
    required this.fichaTecnicaNombre,
    required this.fechaEntrega,
    required this.filasAdulto,
    required this.filasNinos,
    required this.filasLetras,
    required this.filasPiezas,
    required this.resumen,
  });
}

class FilaMatriz {
  String idCliente;
  String idInsumo;
  Map<String, int> cantidades;

  FilaMatriz({
    required this.idCliente,
    required this.idInsumo,
    required this.cantidades,
  });
}

class FilaPiezaSinTalla {
  String idTipoPieza;
  int cantidad;

  FilaPiezaSinTalla({required this.idTipoPieza, required this.cantidad});
}

class ResumenItem {
  String codigo;
  String nombre;
  int total;

  ResumenItem({
    required this.codigo,
    required this.nombre,
    required this.total,
  });
}

// ============================================================
// COMPONENTE HOVER ACTION BUTTON (Coherente con Clientes)
// ============================================================
class _HoverActionButton extends StatefulWidget {
  final IconData icon;
  final Color doradoColor;
  final VoidCallback onTap;
  const _HoverActionButton({
    required this.icon,
    required this.doradoColor,
    required this.onTap,
  });
  @override
  State<_HoverActionButton> createState() => _HoverActionButtonState();
}

class _HoverActionButtonState extends State<_HoverActionButton> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.doradoColor.withValues(alpha: 0.15)
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(widget.icon, size: 18, color: widget.doradoColor),
        ),
      ),
    );
  }
}

// ============================================================
// PANTALLA PRINCIPAL MOBILE: REMISIONES MOBILE VIEW
// ============================================================
class RemisionMobileView extends StatefulWidget {
  const RemisionMobileView({super.key});

  @override
  State<RemisionMobileView> createState() => _RemisionMobileViewState();
}

class _RemisionMobileViewState extends State<RemisionMobileView> {
  String _busqueda = '';

  // Lista de ejemplo inicial sincronizada
  final List<RemisionItem> _remisiones = [
    RemisionItem(
      id: 'REM-001',
      idCliente: '00-1',
      fichaTecnicaNombre: 'IMG-01.jpg',
      fechaEntrega: '2026-05-22',
      filasAdulto: [
        FilaMatriz(
          idCliente: '00-1',
          idInsumo: '00-1',
          cantidades: {'36': 39, '38': 63, '40': 130},
        ),
      ],
      filasNinos: [],
      filasLetras: [],
      filasPiezas: [FilaPiezaSinTalla(idTipoPieza: 'P-01', cantidad: 20)],
      resumen: [
        ResumenItem(codigo: 'id_insumo: 00-1', nombre: 'Camisa', total: 232),
        ResumenItem(
          codigo: 'id_tipo_pieza: P-01',
          nombre: 'Botones',
          total: 20,
        ),
      ],
    ),
  ];

  List<RemisionItem> get _remisionesFiltradas {
    if (_busqueda.trim().isEmpty) return _remisiones;
    final query = _busqueda.toLowerCase().trim();
    return _remisiones.where((r) {
      return r.id.toLowerCase().contains(query) ||
          r.idCliente.toLowerCase().contains(query) ||
          r.fichaTecnicaNombre.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Detección automática del brillo del tema idéntica al módulo de Clientes
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? kDarkBackground : kLightBackground;
    final cardColor = isDarkMode ? kDarkCard : kLightCard;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    final doradoColor = kGoldLight;
    final searchBgColor = isDarkMode ? kDarkInput : kLightInput;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ENCABEZADO SUPERIOR (Sin el botón "Nueva remisión")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Remisiones',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_remisionesFiltradas.length} de ${_remisiones.length} registros',
                    style: TextStyle(fontSize: 12, color: subTextColor),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // BUSCADOR ADAPTATIVO
              TextField(
                onChanged: (val) => setState(() => _busqueda = val),
                style: TextStyle(color: textColor, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Buscar por ID, cliente o ficha...',
                  hintStyle: TextStyle(color: subTextColor, fontSize: 13),
                  prefixIcon: Icon(Icons.search, color: subTextColor),
                  suffixIcon: _busqueda.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: subTextColor,
                          ),
                          onPressed: () => setState(() => _busqueda = ''),
                        )
                      : null,
                  filled: true,
                  fillColor: searchBgColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
              const SizedBox(height: 16),
              // LISTA DE REMISIONES
              Expanded(
                child: _remisionesFiltradas.isEmpty
                    ? _sinResultados(subTextColor, doradoColor)
                    : ListView.builder(
                        itemCount: _remisionesFiltradas.length,
                        itemBuilder: (context, index) {
                          final remision = _remisionesFiltradas[index];
                          return _buildRemisionCard(
                            remision: remision,
                            cardColor: cardColor,
                            textColor: textColor,
                            subTextColor: subTextColor,
                            doradoColor: doradoColor,
                            isDarkMode: isDarkMode,
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

  // ============================================================
  // TARJETA DE REMISIÓN MÓVIL
  // ============================================================
  Widget _buildRemisionCard({
    required RemisionItem remision,
    required Color cardColor,
    required Color textColor,
    required Color subTextColor,
    required Color doradoColor,
    required bool isDarkMode,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDarkMode ? kDarkBorder : kLightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila Superior: ID Remisión y ID Cliente
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: doradoColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  remision.id,
                  style: TextStyle(
                    fontSize: 11,
                    color: doradoColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    'CLIENTE: ',
                    style: TextStyle(
                      fontSize: 10,
                      color: subTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: doradoColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      remision.idCliente,
                      style: TextStyle(
                        fontSize: 10,
                        color: doradoColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Ficha Técnica
          Row(
            children: [
              Icon(Icons.image_outlined, size: 16, color: subTextColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  remision.fichaTecnicaNombre,
                  style: const TextStyle(
                    fontSize: 12,
                    color: kBlueColor,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(height: 1, color: isDarkMode ? kDarkBorder : Colors.black12),
          const SizedBox(height: 12),
          // Botón de Muestra Remisión + Acción de Eliminación
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Botón requerido "Muestra Remisión"
              ElevatedButton.icon(
                onPressed: () => _mostrarModalResumen(
                  remision,
                  isDarkMode,
                  textColor,
                  subTextColor,
                  doradoColor,
                ),
                icon: const Icon(Icons.description_outlined, size: 14),
                label: const Text(
                  'Ver Resumen Insumos',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode
                      ? const Color(0xFF252525)
                      : const Color(0xFFEFF6FF),
                  foregroundColor: kBlueColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: kBlueColor.withValues(alpha: 0.4)),
                  ),
                ),
              ),
              // Botón de acción directo (Eliminar)
              _HoverActionButton(
                icon: Icons.delete_outline_rounded,
                doradoColor: Colors.redAccent,
                onTap: () => _confirmarEliminar(
                  remision,
                  isDarkMode,
                  textColor,
                  subTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // WIDGET SIN RESULTADOS
  // ============================================================
  Widget _sinResultados(Color subTextColor, Color doradoColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: doradoColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.description_outlined,
              size: 30,
              color: doradoColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No se encontraron remisiones',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: subTextColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MODAL DE MUESTRA REMISIÓN (RESUMEN)
  // ============================================================
  void _mostrarModalResumen(
    RemisionItem remision,
    bool isDarkMode,
    Color textColor,
    Color subTextColor,
    Color doradoColor,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final cardBg = isDarkMode ? kDarkCard : kLightCard;
        final tieneInsumos = remision.resumen.any(
          (r) => r.codigo.startsWith('id_insumo'),
        );

        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Resumen — ${remision.id}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: textColor, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Cliente: ${remision.idCliente} | Entrega: ${remision.fechaEntrega}',
                  style: TextStyle(fontSize: 12, color: subTextColor),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      Table(
                        border: TableBorder.all(
                          color: isDarkMode ? kDarkBorder : Colors.grey[300]!,
                          width: 1,
                        ),
                        columnWidths: const {
                          0: FlexColumnWidth(1.2),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: isDarkMode ? kDarkInput : Colors.grey[100],
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'CÓDIGO',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: doradoColor,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'NOMBRE',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: doradoColor,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'CANTIDAD',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: doradoColor,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                          ...remision.resumen.map((item) {
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item.codigo,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontFamily: 'monospace',
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item.nombre,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${item.total}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: doradoColor,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: tieneInsumos
                              ? (isDarkMode
                                    ? const Color(0xFF133221)
                                    : const Color(0xFFDCF7E6))
                              : (isDarkMode
                                    ? const Color(0xFF441C20)
                                    : const Color(0xFFFDECEA)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Entrega insumos',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            Text(
                              tieneInsumos ? 'Sí' : 'No',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: tieneInsumos ? kSuccessColor : kRedColor,
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
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: doradoColor,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Cerrar Vista Previa',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // DIÁLOGO DE CONFIRMACIÓN ELIMINAR
  // ============================================================
  void _confirmarEliminar(
    RemisionItem remision,
    bool isDarkMode,
    Color textColor,
    Color subTextColor,
  ) {
    final dialogBg = isDarkMode ? kDarkCard : Colors.white;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: dialogBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          content: SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: kRedColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    color: kRedColor,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '¿Eliminar remisión?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kRedColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kRedColor.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    '¿Deseas eliminar ${remision.id} de forma permanente?',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: kRedColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: isDarkMode
                              ? const Color(0xFF2A2A2A)
                              : const Color(0xFFEFEFEF),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kRedColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _remisiones.remove(remision);
                          });
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Sí, eliminar',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
