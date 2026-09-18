import 'package:flutter/material.dart';

class RegistroEmpresaView extends StatefulWidget {
  const RegistroEmpresaView({super.key});

  @override
  State<RegistroEmpresaView> createState() => _RegistroEmpresaViewState();
}

class _RegistroEmpresaViewState extends State<RegistroEmpresaView> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos
  final TextEditingController _nitController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nitController.dispose();
    _nombreController.dispose();
    _direccionController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFFD4AF37); // Color dorado característico

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black87),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ENCABEZADO: Ícono circular con borde dorado y título "Crear cuenta"
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: primaryColor, width: 1.5),
                          color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.grey[50],
                        ),
                        child: Icon(
                          Icons.person_add_outlined,
                          size: 32,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Crear cuenta',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // 1. NIT DE EMPRESA
                _buildTextField(
                  controller: _nitController,
                  label: 'NIT DE EMPRESA *',
                  hint: '900.123.456-7',
                  icon: Icons.tag,
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 16),

                // 2. NOMBRE COMPLETO
                _buildTextField(
                  controller: _nombreController,
                  label: 'NOMBRE COMPLETO *',
                  hint: 'Tu nombre',
                  icon: Icons.person_outline,
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 16),

                // 3. DIRECCIÓN
                _buildTextField(
                  controller: _direccionController,
                  label: 'DIRECCIÓN *',
                  hint: 'Calle 123, Ciudad',
                  icon: Icons.location_on_outlined,
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 16),

                // 4. CORREO ELECTRÓNICO
                _buildTextField(
                  controller: _correoController,
                  label: 'CORREO ELECTRÓNICO *',
                  hint: 'correo@ejemplo.com',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 16),

                // 5. TELÉFONO
                _buildTextField(
                  controller: _telefonoController,
                  label: 'TELÉFONO *',
                  hint: '+57 300 000 0000',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 16),

                // 6. CONTRASEÑA
                _buildTextField(
                  controller: _passwordController,
                  label: 'CONTRASEÑA *',
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 16),

                // 7. CONFIRMAR CONTRASEÑA
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: 'CONFIRMAR CONTRASEÑA *',
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  obscureText: _obscureConfirmPassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(height: 32),

                // BOTÓN CREAR CUENTA
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () {
                      // Valida que todos los campos cumplan con los requisitos
                      if (_formKey.currentState!.validate()) {
                        // Validar si las contraseñas coinciden
                        if (_passwordController.text != _confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Las contraseñas no coinciden', style: TextStyle(color: Colors.white)),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        // Muestra el SnackBar verde con el estilo solicitado
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Row(
                              children: [
                                Icon(Icons.check_circle_outline, color: Color(0xFF2E7D32)),
                                SizedBox(width: 12),
                                Text(
                                  'El registro se guardo correctamente.',
                                  style: TextStyle(
                                    color: Color(0xFF1B5E20),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: Color(0xFFC8E6C9), // Verde claro exacto a la imagen
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                          ),
                        );
                        
                        // Redirige al inicio de sesión (removiendo historial o regresando)
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) {
                            // Opción A: Si usas rutas nombradas descomenta la línea de abajo:
                            // Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                            
                            // Opción B: Regresar a la pantalla anterior (Login)
                            Navigator.pop(context);
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Crear cuenta',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para construir cada campo de texto uniformemente
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
    required bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
            prefixIcon: Icon(icon, color: Colors.grey[500], size: 20),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: Colors.grey[500],
                      size: 20,
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
            filled: true,
            fillColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.white12 : Colors.black12,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 1.5),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Este campo es obligatorio';
            }
            return null;
          },
        ),
      ],
    );
  }
}