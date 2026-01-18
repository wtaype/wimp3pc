import 'package:flutter/material.dart';
import '../wicss.dart';
import '../wii.dart';
import 'pantalla1/convertidor.dart';
import 'pantalla2/salidas.dart';
import 'pantalla3/acerca.dart';
import 'pantalla4/version.dart';
import 'pantalla5/mensajes.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  final List<Widget> _pantallas = const [
    PantallaConvertidor(),
    PantallaSalidas(),
    PantallaAcerca(),
    PantallaVersion(),
    PantallaMensajes(),
  ];

  int _indice = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: WiColors.background,
    appBar: AppBar(
      backgroundColor: WiColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          const Icon(Icons.audiotrack, size: 28),
          const SizedBox(width: 12),
          Text(wii.app, style: WiStyles.subtitulo.copyWith(color: Colors.white)),
        ],
      ),
      actions: [
        _buildNavButton(0, Icons.video_file, 'Convertidor'),
        _buildNavButton(1, Icons.library_music, 'Salidas'),
        _buildNavButton(2, Icons.info, 'Acerca'),
        _buildNavButton(3, Icons.badge, 'Versión'),
        _buildNavButton(4, Icons.message, 'Mensajes'),
        const SizedBox(width: 16),
      ],
    ),
    body: IndexedStack(
      index: _indice,
      children: _pantallas,
    ),
  );

  Widget _buildNavButton(int index, IconData icon, String label) {
    final isActive = _indice == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton.icon(
        onPressed: () => setState(() => _indice = index),
        icon: Icon(icon, color: isActive ? Colors.white : Colors.white70, size: 20),
        label: Text(label, style: TextStyle(color: isActive ? Colors.white : Colors.white70, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
        style: TextButton.styleFrom(
          backgroundColor: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }
}