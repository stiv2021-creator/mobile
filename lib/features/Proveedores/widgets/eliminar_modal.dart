import 'package:flutter/material.dart';

class EliminarModal extends StatelessWidget {
  final VoidCallback onConfirmar;

  const EliminarModal({super.key, required this.onConfirmar});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subtitleColor = isDark ? Colors.white54 : Colors.black54;
    final Color boxBg = isDark ? const Color(0xFF2C1515) : Colors.red[50]!;
    final Color boxBorder = isDark ? const Color(0xFF5A2A2A) : Colors.red[200]!;

    return AlertDialog(
      backgroundColor: bgColor,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.red.withOpacity(0.3)),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFE03131),
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '¿Eliminar registro?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Esta acción es permanente y no se puede deshacer.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: subtitleColor),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: boxBg,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: boxBorder),
              ),
              child: Row(
                children: const [
                  Icon(Icons.error_outline, color: Color(0xFFE03131), size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'El registro se eliminará permanentemente del sistema.',
                      style: TextStyle(fontSize: 12, color: Color(0xFFE03131)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // SOLUCIÓN: Botones envueltos en un Row
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: isDark
                      ? const Color(0xFF2A2A2A)
                      : Colors.grey[200],
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancelar',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE03131),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  onConfirmar();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Sí, eliminar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
