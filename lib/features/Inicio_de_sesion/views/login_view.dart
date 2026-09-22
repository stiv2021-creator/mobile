import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends StatefulWidget {
  final VoidCallback? onLoginSuccess;

  const LoginView({super.key, this.onLoginSuccess});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Estado local para alternar manualmente el modo oscuro/claro con el botón de sol/luna
  bool _isManualDark = true;

  @override
  void dispose() {
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = _isManualDark
        ? const Color(0xFF121212)
        : Colors.white;
    final Color textColor = _isManualDark
        ? Colors.white
        : const Color(0xFF121212);
    final Color subtitleColor = _isManualDark
        ? Colors.grey[400]!
        : const Color(0xFF6B6B6B);
    final Color containerBg = _isManualDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFF8F9FA);
    final Color borderColor = _isManualDark
        ? Colors.white24
        : const Color(0xFFE0E0E0);
    const Color primaryGold = Color(0xFFD4AF37);

    // Ruta de los logos según la ubicación vista en tu proyecto (lib/images/)
    final String logoPath = _isManualDark
        ? 'lib/images/logo_negro.jpg'
        : 'lib/images/logo_blanco.jpg';

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Botón flotante para cambiar entre modo claro y oscuro (Sol / Luna)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: containerBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor),
                ),
                child: IconButton(
                  icon: Icon(
                    _isManualDark
                        ? Icons.wb_sunny_rounded
                        : Icons.nights_stay_rounded,
                    color: primaryGold,
                  ),
                  onPressed: () {
                    setState(() {
                      _isManualDark = !_isManualDark;
                    });
                  },
                  tooltip: 'Cambiar Modo',
                ),
              ),
            ),

            // Contenido principal del Login
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo dinámico según el modo (Claro / Oscuro) con protección por errorBuilder
                    Center(
                      child: Image.asset(
                        logoPath,
                        height: 80,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: primaryGold.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: primaryGold.withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.factory_rounded,
                              color: primaryGold,
                              size: 36,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Sistema de Gestión — Eslabón',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: primaryGold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Título de bienvenida
                    Text(
                      'Bienvenido de nuevo',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ingresa las credenciales asignadas por el administrador',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: subtitleColor,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Campo Correo Electrónico
                    _buildLabel('CORREO ELECTRÓNICO *', subtitleColor),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _correoController,
                      style: GoogleFonts.montserrat(
                        color: textColor,
                        fontSize: 14,
                      ),
                      decoration: _inputDecoration(
                        hint: 'admin@eslabon.com',
                        icon: Icons.mail_outline,
                        containerBg: containerBg,
                        borderColor: borderColor,
                        subtitleColor: subtitleColor,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo Contraseña
                    _buildLabel('CONTRASEÑA *', subtitleColor),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: GoogleFonts.montserrat(
                        color: textColor,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: GoogleFonts.montserrat(
                          color: subtitleColor.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: subtitleColor,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: subtitleColor,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: containerBg,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
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
                            color: primaryGold,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Botón Iniciar Sesión
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGold,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          if (widget.onLoginSuccess != null) {
                            widget.onLoginSuccess!();
                          } else {
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                        child: Text(
                          'Iniciar Sesión',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        color: color,
        letterSpacing: 0.5,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    required Color containerBg,
    required Color borderColor,
    required Color subtitleColor,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.montserrat(
        color: subtitleColor.withValues(alpha: 0.6),
        fontSize: 14,
      ),
      prefixIcon: Icon(icon, color: subtitleColor, size: 20),
      filled: true,
      fillColor: containerBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 1.5),
      ),
    );
  }
}
