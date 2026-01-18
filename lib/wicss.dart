import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 🎨 ===== COLORES & ESTILOS =====
class WiColors {
  static const primary = Color(0xFF6C63FF);
  static const secondary = Color(0xFF3F3D56);
  static const accent = Color(0xFFFF6584);
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFA726);
  static const background = Color(0xFFF5F7FA);
  static const cardBg = Colors.white;
  static const textDark = Color(0xFF2C2C2C);
  static const textLight = Color(0xFF757575);
}

class WiStyles {
  static TextStyle titulo = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: WiColors.textDark,
  );

  static TextStyle subtitulo = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: WiColors.textDark,
  );

  static TextStyle normal = GoogleFonts.roboto(
    fontSize: 16,
    color: WiColors.textDark,
  );

  static TextStyle pequeno = GoogleFonts.roboto(
    fontSize: 14,
    color: WiColors.textLight,
  );

  static BoxDecoration tarjeta = BoxDecoration(
    color: WiColors.cardBg,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static ButtonStyle botonPrimario = ElevatedButton.styleFrom(
    backgroundColor: WiColors.primary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 4,
  );

  static ButtonStyle botonSecundario = ElevatedButton.styleFrom(
    backgroundColor: WiColors.secondary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 4,
  );
}