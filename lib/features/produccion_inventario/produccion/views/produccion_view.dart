import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Importa el modelo de producción (Ajusta la ruta según la carpeta de tu compañero)
import '../models/produccion_model.dart';
// Importa el widget de la tarjeta (Ajusta la ruta si lo pusiste en una carpeta widgets compartida)
import '../widgets/produccion_card.dart';

class ProduccionView extends StatefulWidget {
  const ProduccionView({super.key});

  @override
  State<ProduccionView> createState() => _ProduccionViewState();
}

class _ProduccionViewState extends State<ProduccionView> {
  String _filtroEstado = 'Todos';
  String _busqueda = '';

  final List<ProduccionModel> _producciones = [
    ProduccionModel(
      idProduccion: "PROD-001",
      idOrdenPedido: "ORD-1045",
      fechaInicio: "2026-09-01",
      fechaEntrega: "2026-09-15",
      estado: "En proceso",
      detalles: [
        DetalleProduccionModel(
          idDetalleProduccion: "DET-001",
          idEmpleado: "EMP-012",
          idTipoPieza: "PZA-003",
          idTipoMaquina: "MAQ-001",
          idInsumosEnviadosXCliente: "N/A",
          idInsumos: "INS-005", // Tela de algodón (Empresa)
          cantidadAsignada: "30",
          fechaAsignada: "2026-09-05",
          detalleRem: "",
        ),
        DetalleProduccionModel(
          idDetalleProduccion: "DET-002",
          idEmpleado: "EMP-015",
          idTipoPieza: "PZA-004",
          idTipoMaquina: "MAQ-002",
          idInsumosEnviadosXCliente:
              "CLI-001", // Cierres personalizados (Cliente)
          idInsumos: "N/A",
          cantidadAsignada: "15",
          fechaAsignada: "2026-09-06",
          detalleRem: "",
        ),
      ],
    ),
    ProduccionModel(
      idProduccion: "PROD-002",
      idOrdenPedido: "ORD-1046",
      fechaInicio: "2026-09-10",
      fechaEntrega: "2026-09-25",
      estado: "Pendiente",
      detalles: [
        DetalleProduccionModel(
          idDetalleProduccion: "DET-003",
          idEmpleado: "EMP-018",
          idTipoPieza: "PZA-001",
          idTipoMaquina: "MAQ-003",
          idInsumosEnviadosXCliente: "N/A",
          idInsumos: "INS-001", // Tela lona (Empresa)
          cantidadAsignada: "50",
          fechaAsignada: "2026-09-11",
          detalleRem: "",
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Detectamos si la app está en Modo Oscuro o Claro
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Adaptamos colores según el tema
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF121212);
    final Color subtitleColor = isDarkMode
        ? Colors.grey[400]!
        : const Color(0xFF6B6B6B);
    final Color inputFillColor = isDarkMode
        ? const Color(0xFF252525)
        : Colors.white;
    final Color borderColor = isDarkMode
        ? Colors.white24
        : const Color(0xFFE0E0E0);
    final Color chipBgColor = isDarkMode
        ? const Color(0xFF252525)
        : Colors.white;

    final produccionesFiltradas = _producciones.where((p) {
      final coincideEstado =
          _filtroEstado == 'Todos' || p.estado == _filtroEstado;
      final coincideBusqueda =
          p.idProduccion.toLowerCase().contains(_busqueda.toLowerCase()) ||
          p.idOrdenPedido.toLowerCase().contains(_busqueda.toLowerCase());
      return coincideEstado && coincideBusqueda;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent, // Hereda el color del MainNavigation
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Gestión de Producción',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.factory_outlined,
                  color: Color(0xFFD4AF37),
                  size: 28,
                ), // <-- Icono de fábrica exacto al de su menú
                const SizedBox(width: 8),
                Text(
                  'Producción',
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${produccionesFiltradas.length} registros encontrados',
              style: GoogleFonts.montserrat(fontSize: 13, color: subtitleColor),
            ),
            const SizedBox(height: 16),

            TextField(
              onChanged: (val) => setState(() => _busqueda = val),
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'Buscar por código o pedido...',
                hintStyle: GoogleFonts.montserrat(
                  color: subtitleColor,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFD4AF37)),
                filled: true,
                fillColor: inputFillColor,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
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
                  borderSide: const BorderSide(
                    color: Color(0xFFD4AF37),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    [
                      'Todos',
                      'En proceso',
                      'Pendiente',
                      'Completado',
                      'Cancelado',
                    ].map((estado) {
                      final isSelected = _filtroEstado == estado;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(estado),
                          selected: isSelected,
                          showCheckmark: false,
                          selectedColor: const Color(0xFFD4AF37)
                              .withOpacity(0.15),
                          backgroundColor: chipBgColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? const Color(0xFFD4AF37)
                                : borderColor,
                          ),
                          labelStyle: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? const Color(0xFFD4AF37)
                                : subtitleColor,
                          ),
                          onSelected: (val) =>
                              setState(() => _filtroEstado = estado),
                        ),
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: produccionesFiltradas.length,
                itemBuilder: (context, index) {
                  return ProduccionCard(
                    produccion: produccionesFiltradas[index],
                    onUpdate: (updatedProd) {
                      setState(() {
                        final pIndex = _producciones.indexWhere(
                          (p) => p.idProduccion == updatedProd.idProduccion,
                        );
                        if (pIndex != -1) _producciones[pIndex] = updatedProd;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
