import 'package:flutter/material.dart';
import '../../wicss.dart';

class PantallaAcerca extends StatelessWidget {
  const PantallaAcerca({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        // HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 40, color: WiColors.primary),
            const SizedBox(width: 16),
            Text('WIMP3 - Conversor Profesional', style: WiStyles.titulo.copyWith(fontSize: 24)),
          ],
        ),
        const SizedBox(height: 8),
        Text('Convierte videos a audio MP3 de alta calidad', style: WiStyles.normal.copyWith(color: WiColors.textLight)),
        const SizedBox(height: 32),

        // GRID DE CARACTERÍSTICAS
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
          children: [
            _buildCard(Icons.video_file, 'Formatos\nSoportados', 'MP4, MKV\nAVI, MOV\nWMV, FLV', WiColors.primary),
            _buildCard(Icons.high_quality, 'Calidad\nde Audio', '128k - 192k\n256k - 320k\nbitrate', WiColors.success),
            _buildCard(Icons.batch_prediction, 'Conversión\npor Lotes', 'Múltiples\narchivos\nsimultáneos', WiColors.accent),
            _buildCard(Icons.speed, 'Alto\nRendimiento', 'Optimizado\ncon FFmpeg\nprofesional', WiColors.warning),
            _buildCard(Icons.folder_special, 'Organización\nAvanzada', 'Rutas\npersonalizables\nde salida', WiColors.primary),
          ],
        ),
        const SizedBox(height: 24),

        // INFO ADICIONAL
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: WiColors.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle, color: WiColors.success, size: 24),
                  const SizedBox(width: 12),
                  Text('✨ Características principales', style: WiStyles.subtitulo),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildFeature('🎬', 'Drag & Drop', 'Arrastra videos directamente')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildFeature('📊', 'Progreso Real', 'Visualiza el estado de conversión')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildFeature('💾', 'Auto-guardado', 'Recuerda tus preferencias')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildFeature('⚡', 'Rápido', 'Conversión optimizada')),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildCard(IconData icon, String titulo, String descripcion, Color color) {
    return _HoverCard(
      color: color,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: WiColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              titulo,
              style: WiStyles.normal.copyWith(fontWeight: FontWeight.bold, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              descripcion,
              style: WiStyles.pequeno.copyWith(color: WiColors.textLight, fontSize: 11, height: 1.4),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(String emoji, String titulo, String descripcion) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(titulo, style: WiStyles.normal.copyWith(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 4),
        Text(descripcion, style: WiStyles.pequeno.copyWith(fontSize: 11)),
      ],
    );
  }
}

class _HoverCard extends StatefulWidget {
  final Widget child;
  final Color color;

  const _HoverCard({required this.child, required this.color});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.color.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}