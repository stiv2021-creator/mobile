// lib/widgets/top_bar.dart

import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final VoidCallback onMenuPressed;

  const TopBar({super.key, required this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF181818),
        border: Border(bottom: BorderSide(color: Color(0xFF252525))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white70),
            onPressed: onMenuPressed,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 38,
              child: TextField(
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Buscar en el sistema...',
                  hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54, size: 18),
                  filled: true,
                  fillColor: const Color(0xFF222222),
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.notifications_outlined, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          const CircleAvatar(
            radius: 12,
            backgroundColor: Color(0xFFECC159),
            child: Text('A', style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
