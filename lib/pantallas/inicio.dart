import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../wicss.dart';
import '../wii.dart';
import 'entrada.dart';
import 'salida.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  int _currentStep = 0;
  String? _selectedFile;
  String _selectedQuality = '192k';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WiColors.background,
      appBar: AppBar(
        backgroundColor: WiColors.primary,
        foregroundColor: Colors.white,
        title: Text(wii.app, style: WiStyles.subtitulo.copyWith(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _mostrarInfo,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // HEADER
              Text('Conversor de Video a MP3', style: WiStyles.titulo).animate().fadeIn().slideX(),
              const SizedBox(height: 8),
              Text('Convierte tus videos a audio de alta calidad', style: WiStyles.pequeno),
              const SizedBox(height: 32),

              // STEPPER
              _buildStepper(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Column(
      children: [
        // PASO 1: SELECCIONAR ARCHIVO
        if (_currentStep == 0)
          PantallaEntrada(
            onFileSelected: (path) {
              setState(() {
                _selectedFile = path;
                _currentStep = 1;
              });
            },
          ),

        // PASO 2: CONVERTIR
        if (_currentStep == 1)
          PantallaSalida(
            filePath: _selectedFile!,
            quality: _selectedQuality,
            onQualityChanged: (q) => setState(() => _selectedQuality = q),
            onBack: () => setState(() => _currentStep = 0),
          ),
      ],
    );
  }

  void _mostrarInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(wii.app, style: WiStyles.subtitulo),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Versión: ${wii.version}', style: WiStyles.normal),
            Text('Año: ${wii.lanzamiento}', style: WiStyles.normal),
            Text('Autor: ${wii.autor}', style: WiStyles.normal),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}