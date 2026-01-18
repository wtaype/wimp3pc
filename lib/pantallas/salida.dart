import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:process_run/shell.dart';
import '../wicss.dart';
import '../widev.dart';

class PantallaSalida extends StatefulWidget {
  final String filePath;
  final String quality;
  final Function(String) onQualityChanged;
  final VoidCallback onBack;

  const PantallaSalida({
    super.key,
    required this.filePath,
    required this.quality,
    required this.onQualityChanged,
    required this.onBack,
  });

  @override
  State<PantallaSalida> createState() => _PantallaSalidaState();
}

class _PantallaSalidaState extends State<PantallaSalida> {
  bool _isConverting = false;
  String _status = 'Listo para convertir';
  String? _outputPath;

  Future<void> _convertir() async {
    setState(() {
      _isConverting = true;
      _status = 'Convirtiendo...';
    });

    try {
      final outputDir = await getDownloadsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final outputFileName = 'wimp3_$timestamp.mp3';
      _outputPath = p.join(outputDir!.path, outputFileName);

      // Ruta de FFmpeg incluido en assets
      final ffmpegPath = p.join(Directory.current.path, 'data', 'flutter_assets', 'assets', 'ffmpeg', 'ffmpeg.exe');

      final shell = Shell();
      await shell.run('''
        "$ffmpegPath" -i "${widget.filePath}" -vn -ab ${widget.quality} -ar 44100 -y "$_outputPath"
      ''');

      setState(() {
        _status = '✅ Conversión completada';
        _isConverting = false;
      });

      _mostrarExito();
    } catch (e) {
      setState(() {
        _status = '❌ Error: $e';
        _isConverting = false;
      });
    }
  }

  void _mostrarExito() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: WiColors.success, size: 32),
            const SizedBox(width: 12),
            Text('¡Listo!', style: WiStyles.subtitulo),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Archivo guardado en:', style: WiStyles.pequeno),
            const SizedBox(height: 8),
            Text(_outputPath!, style: WiStyles.normal),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Process.run('explorer', ['/select,', _outputPath!]);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.folder_open),
            label: const Text('Abrir carpeta'),
            style: WiStyles.botonPrimario,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WiCard(
          child: Column(
            children: [
              Icon(Icons.audiotrack, size: 80, color: WiColors.accent),
              const SizedBox(height: 24),
              QualitySelector(
                selectedQuality: widget.quality,
                onChanged: widget.onQualityChanged,
              ),
              const SizedBox(height: 24),
              if (_isConverting)
                ProgressWidget(status: _status)
              else
                ElevatedButton.icon(
                  onPressed: _convertir,
                  icon: const Icon(Icons.transform),
                  label: const Text('Convertir a MP3'),
                  style: WiStyles.botonPrimario.copyWith(
                    backgroundColor: WidgetStateProperty.all(WiColors.success),
                  ),
                ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Cambiar archivo'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}