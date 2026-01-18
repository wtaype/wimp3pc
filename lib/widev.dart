import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'wicss.dart';

// ═══════════════════════════════════════════════════════════════════
// 🎯 WIDGETS REUTILIZABLES - Sistema de componentes
// ═══════════════════════════════════════════════════════════════════

// 📦 TARJETA PRINCIPAL
class WiCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const WiCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(24),
      decoration: WiStyles.tarjeta,
      child: child,
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }
}

// 🎯 SELECTOR DE CALIDAD
class QualitySelector extends StatelessWidget {
  final String selectedQuality;
  final Function(String) onChanged;

  const QualitySelector({
    super.key,
    required this.selectedQuality,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Calidad de Audio', style: WiStyles.subtitulo),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          children: ['128k', '192k', '256k', '320k'].map((quality) {
            final isSelected = quality == selectedQuality;
            return ChoiceChip(
              label: Text(quality),
              selected: isSelected,
              onSelected: (_) => onChanged(quality),
              backgroundColor: Colors.grey[200],
              selectedColor: WiColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : WiColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// 📊 WIDGET DE PROGRESO
class ProgressWidget extends StatelessWidget {
  final String status;
  final double? progress;

  const ProgressWidget({super.key, required this.status, this.progress});

  @override
  Widget build(BuildContext context) {
    return WiCard(
      child: Column(
        children: [
          if (progress != null) ...[
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: WiColors.primary,
              minHeight: 8,
            ),
            const SizedBox(height: 12),
            Text('${(progress! * 100).toInt()}%', style: WiStyles.normal),
          ] else ...[
            const CircularProgressIndicator(),
          ],
          const SizedBox(height: 16),
          Text(status, style: WiStyles.normal, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// 📄 INFO DE ARCHIVO
class FileInfoCard extends StatelessWidget {
  final String filename;
  final String size;
  final VoidCallback? onRemove;

  const FileInfoCard({
    super.key,
    required this.filename,
    required this.size,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return WiCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.video_file, size: 48, color: WiColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(filename, style: WiStyles.normal, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(size, style: WiStyles.pequeno),
              ],
            ),
          ),
          if (onRemove != null)
            IconButton(
              icon: const Icon(Icons.close, color: WiColors.accent),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }
}