import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:process_run/shell.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:intl/intl.dart';
import '../../wicss.dart';

class PantallaConvertidor extends StatefulWidget {
  const PantallaConvertidor({super.key});

  @override
  State<PantallaConvertidor> createState() => _PantallaConvertidorState();
}

class _PantallaConvertidorState extends State<PantallaConvertidor> {
  List<ConversionItem> _conversiones = [];
  String _selectedQuality = '192k';
  String _outputDirectory = '';
  bool _isConverting = false;
  bool _isDragging = false;
  bool _isProcessingClick = false;

  @override
  void initState() {
    super.initState();
    _cargarDirectorioSalida();
  }

  Future<void> _cargarDirectorioSalida() async {
    final dir = await getDownloadsDirectory();
    if (mounted) setState(() => _outputDirectory = dir?.path ?? '');
  }

  Future<void> _procesarArchivos(List<String> paths) async {
    if (_isProcessingClick) return;
    _isProcessingClick = true;

    for (var path in paths) {
      final ext = p.extension(path).toLowerCase();
      if (['.mp4', '.mkv', '.avi', '.mov', '.wmv', '.flv', '.webm'].contains(ext)) {
        final bytes = await File(path).length();
        if (mounted) {
          setState(() => _conversiones.add(ConversionItem(
            nombre: p.basename(path),
            rutaEntrada: path,
            tamano: bytes,
            estado: EstadoConversion.pendiente,
            fechaAgregado: DateTime.now(),
          )));
        }
      }
    }

    await Future.delayed(const Duration(milliseconds: 300));
    _isProcessingClick = false;
  }

  Future<void> _seleccionarArchivos() async {
    if (_isProcessingClick) return;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'mkv', 'avi', 'mov', 'wmv', 'flv', 'webm'],
      allowMultiple: true,
    );
    if (result != null) await _procesarArchivos(result.paths.whereType<String>().toList());
  }

  Future<void> _seleccionarCarpetaSalida() async {
    final dir = await FilePicker.platform.getDirectoryPath();
    if (dir != null && mounted) setState(() => _outputDirectory = dir);
  }

  Future<void> _convertirTodos() async {
    setState(() => _isConverting = true);

    final ffmpegPath = p.join(Directory.current.path, 'data', 'flutter_assets', 'assets', 'ffmpeg', 'ffmpeg.exe');
    final shell = Shell();

    for (int i = 0; i < _conversiones.length; i++) {
      if (_conversiones[i].estado != EstadoConversion.pendiente) continue;

      setState(() => _conversiones[i] = _conversiones[i].copyWith(estado: EstadoConversion.procesando, progreso: 0.0));

      try {
        final outputPath = p.join(_outputDirectory, '${p.basenameWithoutExtension(_conversiones[i].nombre)}_${DateTime.now().millisecondsSinceEpoch}.mp3');

        for (double prog = 0.1; prog <= 0.9; prog += 0.2) {
          await Future.delayed(const Duration(milliseconds: 100));
          if (mounted) setState(() => _conversiones[i] = _conversiones[i].copyWith(progreso: prog));
        }

        await shell.run('"$ffmpegPath" -i "${_conversiones[i].rutaEntrada}" -vn -ab $_selectedQuality -ar 44100 -y "$outputPath"');

        if (mounted) {
          setState(() => _conversiones[i] = _conversiones[i].copyWith(
            estado: EstadoConversion.completado,
            rutaSalida: outputPath,
            tamanoSalida: File(outputPath).lengthSync(),
            progreso: 1.0,
          ));
        }
      } catch (e) {
        if (mounted) setState(() => _conversiones[i] = _conversiones[i].copyWith(estado: EstadoConversion.error, error: e.toString()));
      }
    }

    if (mounted) setState(() => _isConverting = false);
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1073741824) return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    return '${(bytes / 1073741824).toStringAsFixed(2)} GB';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: WiColors.background,
    body: DropTarget(
      onDragEntered: (_) => setState(() => _isDragging = true),
      onDragExited: (_) => setState(() => _isDragging = false),
      onDragDone: (details) async {
        setState(() => _isDragging = false);
        await _procesarArchivos(details.files.map((f) => f.path).toList());
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              children: [
                Text('🎬 Convierte de video a MP3', style: WiStyles.normal.copyWith(fontSize: 14)),
                const Spacer(),
                Text('Salida:', style: WiStyles.pequeno.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Flexible(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 350),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: WiColors.cardBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(_outputDirectory, style: WiStyles.pequeno, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _seleccionarCarpetaSalida,
                  icon: const Icon(Icons.folder_open, size: 18),
                  padding: const EdgeInsets.all(8),
                  style: IconButton.styleFrom(backgroundColor: WiColors.primary),
                  tooltip: 'Cambiar carpeta',
                ),
              ],
            ),
            const SizedBox(height: 12),

            // DROP ZONE
            GestureDetector(
              onTap: _seleccionarArchivos,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _isDragging ? WiColors.primary.withOpacity(0.1) : WiColors.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _isDragging ? WiColors.primary : Colors.grey.shade300, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_upload_rounded, size: 60, color: _isDragging ? WiColors.primary : Colors.grey.shade400),
                    const SizedBox(height: 12),
                    Text(
                      _isDragging ? '¡Suelta los archivos aquí!' : 'Arrastra y suelta videos aquí',
                      style: WiStyles.normal.copyWith(fontWeight: FontWeight.bold, color: _isDragging ? WiColors.primary : WiColors.textDark),
                    ),
                    const SizedBox(height: 4),
                    Text('o haz clic para seleccionar', style: WiStyles.pequeno.copyWith(color: WiColors.textLight)),
                    const SizedBox(height: 2),
                    Text('Formatos: MP4, MKV, AVI, MOV, WMV, FLV, WebM', style: WiStyles.pequeno.copyWith(fontSize: 11)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // CONTROLES
            if (_conversiones.isNotEmpty) ...[
              Row(
                children: [
                  Text('📋 Archivos listos para convertir', style: WiStyles.subtitulo.copyWith(fontSize: 16)),
                  const Spacer(),
                  Text('Calidad:', style: WiStyles.pequeno.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: WiColors.cardBg,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedQuality,
                      underline: const SizedBox(),
                      isDense: true,
                      items: ['128k', '192k', '256k', '320k'].map((q) => DropdownMenuItem(value: q, child: Text(q, style: WiStyles.pequeno))).toList(),
                      onChanged: _isConverting ? null : (q) => setState(() => _selectedQuality = q!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: (_isConverting || !_conversiones.any((c) => c.estado == EstadoConversion.pendiente)) ? null : _convertirTodos,
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: Text('CONVERTIR TODOS ${_conversiones.where((c) => c.estado == EstadoConversion.pendiente).length}', style: const TextStyle(fontSize: 13)),
                    style: WiStyles.botonPrimario.copyWith(
                      backgroundColor: WidgetStateProperty.all(WiColors.success),
                      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _isConverting ? null : () => setState(() => _conversiones.clear()),
                    icon: const Icon(Icons.delete_forever, size: 18),
                    label: const Text('Eliminar todo', style: TextStyle(fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WiColors.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // TABLA
              Container(
                decoration: BoxDecoration(
                  color: WiColors.cardBg,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: WiColors.primary.withOpacity(0.1),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 120, child: Text('📅 Fecha', style: WiStyles.pequeno.copyWith(fontWeight: FontWeight.bold))),
                          Expanded(flex: 2, child: Text('🎬 Video (Entrada)', style: WiStyles.pequeno.copyWith(fontWeight: FontWeight.bold))),
                          Expanded(flex: 2, child: Text('🎵 Audio (Salida)', style: WiStyles.pequeno.copyWith(fontWeight: FontWeight.bold))),
                          SizedBox(width: 140, child: Text('📊 Progreso', style: WiStyles.pequeno.copyWith(fontWeight: FontWeight.bold))),
                          SizedBox(width: 90, child: Text('⚡ Acciones', style: WiStyles.pequeno.copyWith(fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _conversiones.length,
                      separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
                      itemBuilder: (_, i) => _buildTableRow(_conversiones[i]),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );

  Widget _buildTableRow(ConversionItem item) {
    final colors = {
      EstadoConversion.procesando: (WiColors.primary, Icons.sync),
      EstadoConversion.completado: (WiColors.success, Icons.check_circle),
      EstadoConversion.error: (WiColors.accent, Icons.error),
      EstadoConversion.pendiente: (WiColors.warning, Icons.pending),
    };
    final (color, icon) = colors[item.estado]!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(DateFormat('dd/MM HH:mm').format(item.fechaAgregado), style: WiStyles.pequeno)),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.nombre, style: WiStyles.pequeno.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(_formatBytes(item.tamano), style: WiStyles.pequeno.copyWith(color: WiColors.textLight, fontSize: 11)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.rutaSalida != null ? p.basename(item.rutaSalida!) : '--', style: WiStyles.pequeno.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(item.tamanoSalida != null ? _formatBytes(item.tamanoSalida!) : '--', style: WiStyles.pequeno.copyWith(color: WiColors.textLight, fontSize: 11)),
              ],
            ),
          ),
          SizedBox(
            width: 140,
            child: item.estado == EstadoConversion.procesando
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(icon, size: 14, color: color),
                          const SizedBox(width: 4),
                          Text('${(item.progreso * 100).toInt()}%', style: WiStyles.pequeno.copyWith(color: color, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(value: item.progreso, backgroundColor: Colors.grey[200], color: color, minHeight: 5, borderRadius: BorderRadius.circular(3)),
                    ],
                  )
                : Row(
                    children: [
                      Icon(icon, size: 16, color: color),
                      const SizedBox(width: 6),
                      Text(['Pendiente', 'Procesando', 'Completado', 'Error'][item.estado.index], style: WiStyles.pequeno.copyWith(color: color, fontWeight: FontWeight.bold)),
                    ],
                  ),
          ),
          SizedBox(
            width: 90,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item.estado == EstadoConversion.completado)
                  IconButton(onPressed: () => Process.run('explorer', ['/select,', item.rutaSalida!]), icon: const Icon(Icons.visibility, size: 18), tooltip: 'Ver archivo', style: IconButton.styleFrom(foregroundColor: WiColors.primary)),
                if (item.estado == EstadoConversion.error)
                  IconButton(onPressed: () => setState(() => _conversiones[_conversiones.indexOf(item)] = item.copyWith(estado: EstadoConversion.pendiente, error: null)), icon: const Icon(Icons.refresh, size: 18), tooltip: 'Reintentar', style: IconButton.styleFrom(foregroundColor: WiColors.warning)),
                if (item.estado != EstadoConversion.procesando)
                  IconButton(onPressed: () => setState(() => _conversiones.remove(item)), icon: const Icon(Icons.delete, size: 18), tooltip: 'Eliminar', style: IconButton.styleFrom(foregroundColor: WiColors.accent)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum EstadoConversion { pendiente, procesando, completado, error }

class ConversionItem {
  final String nombre, rutaEntrada;
  final int tamano;
  final EstadoConversion estado;
  final String? rutaSalida, error;
  final int? tamanoSalida;
  final double progreso;
  final DateTime fechaAgregado;

  ConversionItem({required this.nombre, required this.rutaEntrada, required this.tamano, required this.estado, required this.fechaAgregado, this.rutaSalida, this.tamanoSalida, this.error, this.progreso = 0.0});

  ConversionItem copyWith({EstadoConversion? estado, String? rutaSalida, int? tamanoSalida, String? error, double? progreso}) =>
      ConversionItem(nombre: nombre, rutaEntrada: rutaEntrada, tamano: tamano, estado: estado ?? this.estado, fechaAgregado: fechaAgregado, rutaSalida: rutaSalida ?? this.rutaSalida, tamanoSalida: tamanoSalida ?? this.tamanoSalida, error: error, progreso: progreso ?? this.progreso);
}