import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main.dart'; // Ajusta la ruta a tu ThemeProvider

class ThemeDropdownWidget extends StatelessWidget {
  const ThemeDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Determinar icono, texto y acción alternando únicamente entre dark y light
    IconData currentIcon;
    String currentText;
    ThemeMode nextMode;

    if (isDarkMode) {
      currentIcon = Icons.nightlight_outlined;
      currentText = 'Modo oscuro';
      nextMode = ThemeMode.light; // Si está oscuro, al hacer tap pasa a claro
    } else {
      currentIcon = Icons.wb_sunny_outlined;
      currentText = 'Modo claro';
      nextMode = ThemeMode.dark; // Si está claro, al hacer tap pasa a oscuro
    }

    // Colores basados en el diseño del botón circular
    final circleBgColor = const Color(0xFFD4AF37).withValues(alpha: 0.15);
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return InkWell(
      onTap: () => themeProvider.setThemeMode(nextMode),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Círculo con el ícono
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: circleBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                currentIcon,
                color: const Color(0xFFD4AF37), // Ícono dorado
                size: 20,
              ),
            ),
            const SizedBox(height: 6),
            // Texto descriptivo debajo
            Text(
              currentText,
              style: TextStyle(
                color: textColor,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
