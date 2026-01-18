import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';
import '../../wicss.dart';

class PantallaSalidas extends StatefulWidget {
  const PantallaSalidas({super.key});

  @override
  State<PantallaSalidas> createState() => _PantallaSalidasState();
}

class _PantallaSalidasState extends State<PantallaSalidas> {
  List<AudioFile> _audios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarAudios();
  }

  Future<void> _cargarAudios() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    final dir = await getDownloadsDirectory();
    if (dir == null) return;

    final audios = <AudioFile>[];
    final files = Directory(dir.path).listSync().where((f) => f.path.endsWith('.mp3'));

    for (var file in files) {
      final stat = await file.stat();
      audios.add(AudioFile(
        nombre: p.basename(file.path),
        ruta: file.path,
        tamano: stat.size,
        fechaModificado: stat.modified,
      ));
    }

    audios.sort((a, b) => b.fechaModificado.compareTo(a.fechaModificado));

    if (mounted) setState(() {
      _audios = audios;
      _isLoading = false;
    });
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1073741824) return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    return '${(bytes / 1073741824).toStringAsFixed(2)} GB';
  }

  void _abrirArchivo(String path) => Process.start('cmd', ['/c', 'start', '', path]);

  void _eliminarArchivo(String path) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: WiColors.warning, size: 28),
            const SizedBox(width: 12),
            Text('Confirmar eliminación', style: WiStyles.subtitulo.copyWith(fontSize: 18)),
          ],
        ),
        content: Text('¿Estás seguro de eliminar este archivo?\nEsta acción no se puede deshacer.', style: WiStyles.normal),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.delete_forever, size: 18),
            label: const Text('Eliminar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: WiColors.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await File(path).delete();
      _cargarAudios();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('✅ Archivo eliminado correctamente'),
              ],
            ),
            backgroundColor: WiColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: WiColors.background,
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  children: [
                    Text('🎵 Archivos de salida: ${_audios.length} archivos', style: WiStyles.subtitulo.copyWith(fontSize: 16)),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: _cargarAudios,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Actualizar', style: TextStyle(fontSize: 13)),
                      style: WiStyles.botonPrimario.copyWith(
                        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // CONTENIDO
                if (_audios.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(60),
                    decoration: BoxDecoration(
                      color: WiColors.cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.music_off, size: 80, color: Colors.grey.shade400),
                          const SizedBox(height: 20),
                          Text('No hay archivos de audio', style: WiStyles.subtitulo.copyWith(color: WiColors.textLight)),
                          const SizedBox(height: 8),
                          Text('Convierte algunos videos primero en la sección de Convertidor', style: WiStyles.pequeno.copyWith(color: WiColors.textLight)),
                        ],
                      ),
                    ),
                  )
                else
                  // TABLA
                  Container(
                    decoration: BoxDecoration(
                      color: WiColors.cardBg,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      children: [
                        // HEADER DE TABLA
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: WiColors.primary.withOpacity(0.1),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 140, child: Text('📅 Fecha', style: WiStyles.pequeno.copyWith(fontWeight: FontWeight.bold))),
                              Expanded(child: Text('🎵 Audio (Salida)', style: WiStyles.pequeno.copyWith(fontWeight: FontWeight.bold))),
                              SizedBox(width: 120, child: Text('⚡ Acciones', style: WiStyles.pequeno.copyWith(fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),
                        // FILAS DE DATOS
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _audios.length,
                          separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
                          itemBuilder: (_, i) => _buildTableRow(_audios[i]),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
  );

  Widget _buildTableRow(AudioFile audio) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // FECHA
          SizedBox(
            width: 140,
            child: Text(
              DateFormat('dd/MM/yyyy HH:mm').format(audio.fechaModificado),
              style: WiStyles.pequeno,
            ),
          ),
          // AUDIO (NOMBRE + TAMAÑO)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  audio.nombre,
                  style: WiStyles.pequeno.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _formatBytes(audio.tamano),
                  style: WiStyles.pequeno.copyWith(color: WiColors.textLight, fontSize: 11),
                ),
              ],
            ),
          ),
          // ACCIONES
          SizedBox(
            width: 140,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _abrirArchivo(audio.ruta),
                  icon: const Icon(Icons.play_circle_filled, size: 20),
                  tooltip: 'Reproducir',
                  style: IconButton.styleFrom(foregroundColor: WiColors.success),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: () => Process.run('explorer', ['/select,', audio.ruta]),
                  icon: const Icon(Icons.folder_open, size: 20),
                  tooltip: 'Abrir carpeta',
                  style: IconButton.styleFrom(foregroundColor: WiColors.primary),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: () => _eliminarArchivo(audio.ruta),
                  icon: const Icon(Icons.delete, size: 20),
                  tooltip: 'Eliminar',
                  style: IconButton.styleFrom(foregroundColor: WiColors.accent),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AudioFile {
  final String nombre, ruta;
  final int tamano;
  final DateTime fechaModificado;

  AudioFile({required this.nombre, required this.ruta, required this.tamano, required this.fechaModificado});
}