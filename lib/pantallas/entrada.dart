import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../wicss.dart';
import '../widev.dart';

class PantallaEntrada extends StatefulWidget {
  final Function(String) onFileSelected;

  const PantallaEntrada({super.key, required this.onFileSelected});

  @override
  State<PantallaEntrada> createState() => _PantallaEntradaState();
}

class _PantallaEntradaState extends State<PantallaEntrada> {
  String? _filePath;
  String _fileSize = '';

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'mkv', 'avi', 'mov', 'wmv', 'flv'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final bytes = await file.length();
      setState(() {
        _filePath = result.files.single.path;
        _fileSize = _formatBytes(bytes);
      });
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WiCard(
          child: Column(
            children: [
              Icon(Icons.video_library, size: 80, color: WiColors.primary),
              const SizedBox(height: 24),
              Text('Selecciona un video', style: WiStyles.subtitulo),
              const SizedBox(height: 8),
              Text(
                'Formatos soportados: MP4, MKV, AVI, MOV, WMV, FLV',
                style: WiStyles.pequeno,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.folder_open),
                label: const Text('Seleccionar Video'),
                style: WiStyles.botonPrimario,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (_filePath != null) ...[
          FileInfoCard(
            filename: _filePath!.split('\\').last,
            size: _fileSize,
            onRemove: () => setState(() => _filePath = null),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => widget.onFileSelected(_filePath!),
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Continuar'),
            style: WiStyles.botonSecundario,
          ),
        ],
      ],
    );
  }
}