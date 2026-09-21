import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const Color dorado = Color(0xFFC9A227);
  static const Color doradoSuave = Color(0xFFE5C65A);
  static const Color verde = Color(0xFF42C95A);
  static const Color rojo = Color(0xFFFF453A);
  static const Color naranja = Color(0xFFFFB300);
  static const Color azul = Color(0xFF4D8DFF);
  static const Color morado = Color(0xFF9B6DFF);

  @override
  Widget build(BuildContext context) {
    final bool oscuro = Theme.of(context).brightness == Brightness.dark;

    final Color fondo =
        oscuro ? const Color(0xFF121212) : const Color(0xFFF5F5F5);

    final Color tarjeta =
        oscuro ? const Color(0xFF1E1E1E) : Colors.white;

    final Color tarjetaSecundaria =
        oscuro ? const Color(0xFF252525) : const Color(0xFFF8F8F8);

    final Color texto =
        oscuro ? Colors.white : const Color(0xFF181818);

    final Color textoSecundario =
        oscuro ? Colors.white70 : const Color(0xFF777777);

    final Color borde =
        oscuro ? Colors.white12 : Colors.black12;

    return Scaffold(
      backgroundColor: fondo,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------------------------------------------------
              // ENCABEZADO
              // ---------------------------------------------------------
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: dorado.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.dashboard_rounded,
                      color: dorado,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dashboard',
                          style: TextStyle(
                            color: texto,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Resumen general',
                          style: TextStyle(
                            color: textoSecundario,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: verde.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 8,
                          color: verde,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Activo',
                          style: TextStyle(
                            color: verde,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ---------------------------------------------------------
              // TITULO KPI
              // ---------------------------------------------------------
              Text(
                'Indicadores',
                style: TextStyle(
                  color: texto,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // ---------------------------------------------------------
              // KPI 1 Y 2
              // ---------------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: MiniStatCard(
                      titulo: 'Insumos',
                      valor: '24',
                      subtitulo: 'Registrados',
                      icono: Icons.inventory_2_rounded,
                      color: dorado,
                      fondo: tarjeta,
                      texto: texto,
                      textoSecundario: textoSecundario,
                      borde: borde,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MiniStatCard(
                      titulo: 'Stock bajo',
                      valor: '3',
                      subtitulo: 'Por revisar',
                      icono: Icons.warning_amber_rounded,
                      color: rojo,
                      fondo: tarjeta,
                      texto: texto,
                      textoSecundario: textoSecundario,
                      borde: borde,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ---------------------------------------------------------
              // KPI 3 Y 4
              // ---------------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: MiniStatCard(
                      titulo: 'Ventas',
                      valor: '128',
                      subtitulo: 'Este mes',
                      icono: Icons.shopping_cart_rounded,
                      color: verde,
                      fondo: tarjeta,
                      texto: texto,
                      textoSecundario: textoSecundario,
                      borde: borde,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MiniStatCard(
                      titulo: 'Ingresos',
                      valor: '\$18.4M',
                      subtitulo: 'Este mes',
                      icono: Icons.attach_money_rounded,
                      color: dorado,
                      fondo: tarjeta,
                      texto: texto,
                      textoSecundario: textoSecundario,
                      borde: borde,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ---------------------------------------------------------
              // KPI 5 Y 6
              // ---------------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: MiniStatCard(
                      titulo: 'Compras',
                      valor: '56',
                      subtitulo: 'Este mes',
                      icono: Icons.shopping_bag_rounded,
                      color: azul,
                      fondo: tarjeta,
                      texto: texto,
                      textoSecundario: textoSecundario,
                      borde: borde,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MiniStatCard(
                      titulo: 'Registros',
                      valor: '32',
                      subtitulo: 'Hoy',
                      icono: Icons.people_alt_rounded,
                      color: morado,
                      fondo: tarjeta,
                      texto: texto,
                      textoSecundario: textoSecundario,
                      borde: borde,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              // ---------------------------------------------------------
              // GRAFICA VENTAS
              // ---------------------------------------------------------
              GraficaCard(
                titulo: 'Ventas',
                valor: '\$18.450.000',
                porcentaje: '+12.5%',
                color: dorado,
                fondo: tarjeta,
                texto: texto,
                textoSecundario: textoSecundario,
                grafica: CustomPaint(
                  painter: VentasGraficoPainter(
                    oscuro: oscuro,
                  ),
                  child: const SizedBox(
                    height: 210,
                    width: double.infinity,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ---------------------------------------------------------
              // GRAFICA COMPRAS
              // ---------------------------------------------------------
              GraficaCard(
                titulo: 'Compras',
                valor: '\$8.750.000',
                porcentaje: '+8.4%',
                color: azul,
                fondo: tarjeta,
                texto: texto,
                textoSecundario: textoSecundario,
                grafica: CustomPaint(
                  painter: ComprasGraficoPainter(
                    oscuro: oscuro,
                  ),
                  child: const SizedBox(
                    height: 210,
                    width: double.infinity,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ---------------------------------------------------------
              // GRAFICA REGISTROS
              // ---------------------------------------------------------
              GraficaCard(
                titulo: 'Registros diarios',
                valor: '32',
                porcentaje: '+6.2%',
                color: morado,
                fondo: tarjeta,
                texto: texto,
                textoSecundario: textoSecundario,
                grafica: CustomPaint(
                  painter: RegistrosGraficoPainter(
                    oscuro: oscuro,
                  ),
                  child: const SizedBox(
                    height: 210,
                    width: double.infinity,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ---------------------------------------------------------
              // GRAFICA INSUMOS
              // ---------------------------------------------------------
              GraficaCard(
                titulo: 'Insumos',
                valor: '24',
                porcentaje: 'Actualizado',
                color: dorado,
                fondo: tarjeta,
                texto: texto,
                textoSecundario: textoSecundario,
                grafica: CustomPaint(
                  painter: InsumosGraficoPainter(
                    oscuro: oscuro,
                  ),
                  child: const SizedBox(
                    height: 230,
                    width: double.infinity,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ---------------------------------------------------------
              // ULTIMAS VENTAS
              // ---------------------------------------------------------
              UltimasVentasMobileCard(
                fondo: tarjeta,
                texto: texto,
                textoSecundario: textoSecundario,
                borde: borde,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// KPI
// =====================================================================

class MiniStatCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final String subtitulo;
  final IconData icono;
  final Color color;
  final Color fondo;
  final Color texto;
  final Color textoSecundario;
  final Color borde;

  const MiniStatCard({
    super.key,
    required this.titulo,
    required this.valor,
    required this.subtitulo,
    required this.icono,
    required this.color,
    required this.fondo,
    required this.texto,
    required this.textoSecundario,
    required this.borde,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borde),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icono,
              color: color,
              size: 21,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            titulo,
            style: TextStyle(
              color: textoSecundario,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            valor,
            style: TextStyle(
              color: texto,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            subtitulo,
            style: TextStyle(
              color: textoSecundario,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// CARD DE GRAFICA
// =====================================================================

class GraficaCard extends StatelessWidget {
  final String titulo;
  final String valor;
  final String porcentaje;
  final Color color;
  final Color fondo;
  final Color texto;
  final Color textoSecundario;
  final Widget grafica;

  const GraficaCard({
    super.key,
    required this.titulo,
    required this.valor,
    required this.porcentaje,
    required this.color,
    required this.fondo,
    required this.texto,
    required this.textoSecundario,
    required this.grafica,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        color: textoSecundario,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      valor,
                      style: TextStyle(
                        color: texto,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  porcentaje,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          grafica,
        ],
      ),
    );
  }
}

// =====================================================================
// GRAFICA DE VENTAS
// =====================================================================

class VentasGraficoPainter extends CustomPainter {
  final bool oscuro;

  VentasGraficoPainter({
    required this.oscuro,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double left = 38;
    final double right = size.width - 15;
    final double top = 15;
    final double bottom = size.height - 38;

    final Paint gridPaint = Paint()
      ..color = oscuro
          ? Colors.white.withValues(alpha: 0.10)
          : Colors.black.withValues(alpha: 0.08)
      ..strokeWidth = 1;

    final Paint axisPaint = Paint()
      ..color = oscuro ? Colors.white70 : Colors.black54
      ..strokeWidth = 1.5;

    final Paint linePaint = Paint()
      ..color = DashboardPage.dorado
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final Paint pointPaint = Paint()
      ..color = DashboardPage.dorado
      ..style = PaintingStyle.fill;

    // ---------------------------------------------------------------
    // CUADRICULA
    // ---------------------------------------------------------------

    for (int i = 0; i <= 4; i++) {
      final double y =
          top + ((bottom - top) / 4) * i;

      canvas.drawLine(
        Offset(left, y),
        Offset(right, y),
        gridPaint,
      );
    }

    for (int i = 0; i <= 3; i++) {
      final double x =
          left + ((right - left) / 3) * i;

      canvas.drawLine(
        Offset(x, top),
        Offset(x, bottom),
        gridPaint,
      );
    }

    // ---------------------------------------------------------------
    // EJE Y
    // ---------------------------------------------------------------

    canvas.drawLine(
      Offset(left, bottom),
      Offset(left, top),
      axisPaint,
    );

    // FLECHA DEL EJE Y
    final Path arrowY = Path();

    arrowY.moveTo(left, top);
    arrowY.lineTo(left - 5, top + 10);
    arrowY.moveTo(left, top);
    arrowY.lineTo(left + 5, top + 10);

    canvas.drawPath(arrowY, axisPaint);

    // ---------------------------------------------------------------
    // EJE X
    // ---------------------------------------------------------------

    canvas.drawLine(
      Offset(left, bottom),
      Offset(right, bottom),
      axisPaint,
    );

    // FLECHA DEL EJE X
    final Path arrowX = Path();

    arrowX.moveTo(right, bottom);
    arrowX.lineTo(right - 10, bottom - 5);
    arrowX.moveTo(right, bottom);
    arrowX.lineTo(right - 10, bottom + 5);

    canvas.drawPath(arrowX, axisPaint);

    // ---------------------------------------------------------------
    // DATOS
    // ---------------------------------------------------------------

    final List<double> datos = [
      0.35,
      0.52,
      0.42,
      0.72,
      0.65,
      0.88,
      0.78,
    ];

    final Path path = Path();

    for (int i = 0; i < datos.length; i++) {
      final double x =
          left + ((right - left) / (datos.length - 1)) * i;

      final double y =
          bottom - ((bottom - top) * datos[i]);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, linePaint);

    // ---------------------------------------------------------------
    // PUNTOS
    // ---------------------------------------------------------------

    for (int i = 0; i < datos.length; i++) {
      final double x =
          left + ((right - left) / (datos.length - 1)) * i;

      final double y =
          bottom - ((bottom - top) * datos[i]);

      canvas.drawCircle(
        Offset(x, y),
        4,
        pointPaint,
      );
    }

    _dibujarTexto(
      canvas,
      'Sem 1',
      Offset(left - 8, bottom + 12),
      oscuro,
    );

    _dibujarTexto(
      canvas,
      'Sem 2',
      Offset(left + 55, bottom + 12),
      oscuro,
    );

    _dibujarTexto(
      canvas,
      'Sem 3',
      Offset(left + 120, bottom + 12),
      oscuro,
    );

    _dibujarTexto(
      canvas,
      'Sem 4',
      Offset(right - 35, bottom + 12),
      oscuro,
    );
  }

  void _dibujarTexto(
    Canvas canvas,
    String texto,
    Offset posicion,
    bool oscuro,
  ) {
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: texto,
        style: TextStyle(
          color: oscuro ? Colors.white60 : Colors.black54,
          fontSize: 10,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    painter.layout();
    painter.paint(canvas, posicion);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// =====================================================================
// GRAFICA DE COMPRAS
// =====================================================================

class ComprasGraficoPainter extends CustomPainter {
  final bool oscuro;

  ComprasGraficoPainter({
    required this.oscuro,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double left = 38;
    final double right = size.width - 15;
    final double top = 15;
    final double bottom = size.height - 38;

    final Paint gridPaint = Paint()
      ..color = oscuro
          ? Colors.white.withValues(alpha: 0.10)
          : Colors.black.withValues(alpha: 0.08)
      ..strokeWidth = 1;

    final Paint axisPaint = Paint()
      ..color = oscuro ? Colors.white70 : Colors.black54
      ..strokeWidth = 1.5;

    final Paint linePaint = Paint()
      ..color = DashboardPage.azul
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final Paint pointPaint = Paint()
      ..color = DashboardPage.azul;

    // CUADRICULA

    for (int i = 0; i <= 4; i++) {
      final double y =
          top + ((bottom - top) / 4) * i;

      canvas.drawLine(
        Offset(left, y),
        Offset(right, y),
        gridPaint,
      );
    }

    for (int i = 0; i <= 3; i++) {
      final double x =
          left + ((right - left) / 3) * i;

      canvas.drawLine(
        Offset(x, top),
        Offset(x, bottom),
        gridPaint,
      );
    }

    // EJE Y

    canvas.drawLine(
      Offset(left, bottom),
      Offset(left, top),
      axisPaint,
    );

    // FLECHA Y

    final Path arrowY = Path();

    arrowY.moveTo(left, top);
    arrowY.lineTo(left - 5, top + 10);

    arrowY.moveTo(left, top);
    arrowY.lineTo(left + 5, top + 10);

    canvas.drawPath(arrowY, axisPaint);

    // EJE X

    canvas.drawLine(
      Offset(left, bottom),
      Offset(right, bottom),
      axisPaint,
    );

    // FLECHA X

    final Path arrowX = Path();

    arrowX.moveTo(right, bottom);
    arrowX.lineTo(right - 10, bottom - 5);

    arrowX.moveTo(right, bottom);
    arrowX.lineTo(right - 10, bottom + 5);

    canvas.drawPath(arrowX, axisPaint);

    // DATOS

    final List<double> datos = [
      0.25,
      0.40,
      0.34,
      0.55,
      0.48,
      0.68,
      0.60,
    ];

    final Path path = Path();

    for (int i = 0; i < datos.length; i++) {
      final double x =
          left + ((right - left) / (datos.length - 1)) * i;

      final double y =
          bottom - ((bottom - top) * datos[i]);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, linePaint);

    for (int i = 0; i < datos.length; i++) {
      final double x =
          left + ((right - left) / (datos.length - 1)) * i;

      final double y =
          bottom - ((bottom - top) * datos[i]);

      canvas.drawCircle(
        Offset(x, y),
        4,
        pointPaint,
      );
    }

    _texto(canvas, 'Sem 1', left - 8, bottom + 12);
    _texto(canvas, 'Sem 2', left + 55, bottom + 12);
    _texto(canvas, 'Sem 3', left + 120, bottom + 12);
    _texto(canvas, 'Sem 4', right - 35, bottom + 12);
  }

  void _texto(
    Canvas canvas,
    String texto,
    double x,
    double y,
  ) {
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: texto,
        style: TextStyle(
          color: oscuro ? Colors.white60 : Colors.black54,
          fontSize: 10,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    painter.layout();
    painter.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// =====================================================================
// GRAFICA REGISTROS DIARIOS
// =====================================================================

class RegistrosGraficoPainter extends CustomPainter {
  final bool oscuro;

  RegistrosGraficoPainter({
    required this.oscuro,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double left = 38;
    final double right = size.width - 15;
    final double top = 15;
    final double bottom = size.height - 38;

    final Paint gridPaint = Paint()
      ..color = oscuro
          ? Colors.white.withValues(alpha: 0.10)
          : Colors.black.withValues(alpha: 0.08)
      ..strokeWidth = 1;

    final Paint axisPaint = Paint()
      ..color = oscuro ? Colors.white70 : Colors.black54
      ..strokeWidth = 1.5;

    final Paint barPaint = Paint()
      ..color = DashboardPage.morado;

    // CUADRICULA

    for (int i = 0; i <= 4; i++) {
      final double y =
          top + ((bottom - top) / 4) * i;

      canvas.drawLine(
        Offset(left, y),
        Offset(right, y),
        gridPaint,
      );
    }

    // EJE Y

    canvas.drawLine(
      Offset(left, bottom),
      Offset(left, top),
      axisPaint,
    );

    // FLECHA Y

    final Path arrowY = Path();

    arrowY.moveTo(left, top);
    arrowY.lineTo(left - 5, top + 10);

    arrowY.moveTo(left, top);
    arrowY.lineTo(left + 5, top + 10);

    canvas.drawPath(arrowY, axisPaint);

    // EJE X

    canvas.drawLine(
      Offset(left, bottom),
      Offset(right, bottom),
      axisPaint,
    );

    // FLECHA X

    final Path arrowX = Path();

    arrowX.moveTo(right, bottom);
    arrowX.lineTo(right - 10, bottom - 5);

    arrowX.moveTo(right, bottom);
    arrowX.lineTo(right - 10, bottom + 5);

    canvas.drawPath(arrowX, axisPaint);

    // BARRAS

    final List<double> datos = [
      0.35,
      0.55,
      0.42,
      0.70,
      0.62,
      0.82,
      0.58,
    ];

    final List<String> dias = [
      'Lun',
      'Mar',
      'Mié',
      'Jue',
      'Vie',
      'Sáb',
      'Dom',
    ];

    final double anchoDisponible =
        right - left;

    final double anchoBarra =
        anchoDisponible / datos.length * 0.55;

    for (int i = 0; i < datos.length; i++) {
      final double centro =
          left +
          (anchoDisponible / datos.length) * i +
          (anchoDisponible / datos.length) / 2;

      final double altura =
          (bottom - top) * datos[i];

      final double x =
          centro - anchoBarra / 2;

      final double y =
          bottom - altura;

      final Rect rect = Rect.fromLTWH(
        x,
        y,
        anchoBarra,
        altura,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect,
          const Radius.circular(5),
        ),
        barPaint,
      );

      _texto(
        canvas,
        dias[i],
        centro - 10,
        bottom + 12,
      );
    }
  }

  void _texto(
    Canvas canvas,
    String texto,
    double x,
    double y,
  ) {
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: texto,
        style: TextStyle(
          color: oscuro ? Colors.white60 : Colors.black54,
          fontSize: 10,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    painter.layout();
    painter.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// =====================================================================
// GRAFICA INSUMOS
// =====================================================================

class InsumosGraficoPainter extends CustomPainter {
  final bool oscuro;

  InsumosGraficoPainter({
    required this.oscuro,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset centro = Offset(
      size.width / 2,
      size.height / 2 - 5,
    );

    final double radio = 65;

    final Paint fondoPaint = Paint()
      ..color = oscuro
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.black.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24;

    canvas.drawCircle(
      centro,
      radio,
      fondoPaint,
    );

    final List<double> valores = [
      35,
      25,
      20,
      20,
    ];

    final List<Color> colores = [
      DashboardPage.dorado,
      DashboardPage.azul,
      DashboardPage.verde,
      DashboardPage.naranja,
    ];

    double inicio = -1.5708;

    for (int i = 0; i < valores.length; i++) {
      final double barrido =
          (valores[i] / 100) * 6.28318;

      final Paint paint = Paint()
        ..color = colores[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 24
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(
          center: centro,
          radius: radio,
        ),
        inicio,
        barrido,
        false,
        paint,
      );

      inicio += barrido;
    }

    // CENTRO

    final Paint centroPaint = Paint()
      ..color = oscuro
          ? const Color(0xFF1E1E1E)
          : Colors.white;

    canvas.drawCircle(
      centro,
      47,
      centroPaint,
    );

    _textoCentro(
      canvas,
      '24',
      centro,
      oscuro,
    );

    // LEYENDA

    final double leyendaY =
        size.height - 48;

    _leyenda(
      canvas,
      'Hilos',
      DashboardPage.dorado,
      10,
      leyendaY,
      oscuro,
    );

    _leyenda(
      canvas,
      'Botones',
      DashboardPage.azul,
      95,
      leyendaY,
      oscuro,
    );

    _leyenda(
      canvas,
      'Cierres',
      DashboardPage.verde,
      190,
      leyendaY,
      oscuro,
    );

    _leyenda(
      canvas,
      'Telas',
      DashboardPage.naranja,
      280,
      leyendaY,
      oscuro,
    );
  }

  void _textoCentro(
    Canvas canvas,
    String texto,
    Offset centro,
    bool oscuro,
  ) {
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: texto,
        style: TextStyle(
          color: oscuro ? Colors.white : Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    painter.layout();

    painter.paint(
      canvas,
      Offset(
        centro.dx - painter.width / 2,
        centro.dy - painter.height / 2,
      ),
    );
  }

  void _leyenda(
    Canvas canvas,
    String texto,
    Color color,
    double x,
    double y,
    bool oscuro,
  ) {
    final Paint punto = Paint()
      ..color = color;

    canvas.drawCircle(
      Offset(x, y + 5),
      5,
      punto,
    );

    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: texto,
        style: TextStyle(
          color: oscuro ? Colors.white70 : Colors.black54,
          fontSize: 10,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    painter.layout();

    painter.paint(
      canvas,
      Offset(x + 9, y - 1),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// =====================================================================
// ULTIMAS VENTAS
// =====================================================================

class UltimasVentasMobileCard extends StatelessWidget {
  final Color fondo;
  final Color texto;
  final Color textoSecundario;
  final Color borde;

  const UltimasVentasMobileCard({
    super.key,
    required this.fondo,
    required this.texto,
    required this.textoSecundario,
    required this.borde,
  });

  @override
  Widget build(BuildContext context) {
    final List<VentaItem> ventas = [
      VentaItem(
        cliente: 'Carlos Pérez',
        producto: 'Camisa clásica',
        precio: '\$180.000',
        estado: 'Completada',
      ),
      VentaItem(
        cliente: 'María Gómez',
        producto: 'Pantalón formal',
        precio: '\$220.000',
        estado: 'Completada',
      ),
      VentaItem(
        cliente: 'Juan Rodríguez',
        producto: 'Camisa Oxford',
        precio: '\$195.000',
        estado: 'Pendiente',
      ),
      VentaItem(
        cliente: 'Laura Martínez',
        producto: 'Pantalón ejecutivo',
        precio: '\$250.000',
        estado: 'Completada',
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borde),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Últimas ventas',
            style: TextStyle(
              color: texto,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          ...ventas.map(
            (venta) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: DashboardPage.dorado.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: DashboardPage.dorado,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          venta.cliente,
                          style: TextStyle(
                            color: texto,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          venta.producto,
                          style: TextStyle(
                            color: textoSecundario,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        venta.precio,
                        style: TextStyle(
                          color: texto,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        venta.estado,
                        style: TextStyle(
                          color: venta.estado == 'Completada'
                              ? DashboardPage.verde
                              : DashboardPage.naranja,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// MODELO VENTA
// =====================================================================

class VentaItem {
  final String cliente;
  final String producto;
  final String precio;
  final String estado;

  VentaItem({
    required this.cliente,
    required this.producto,
    required this.precio,
    required this.estado,
  });
}