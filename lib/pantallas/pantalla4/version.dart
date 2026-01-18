import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../wicss.dart';
import '../../wii.dart';

class PantallaVersion extends StatelessWidget {
  const PantallaVersion({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        // HERO SECTION
        Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [WiColors.primary, WiColors.primary.withOpacity(0.6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: WiColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
                ),
                child: Icon(Icons.audio_file, size: 60, color: WiColors.primary),
              ).animate().scale(duration: 600.ms).shake(),
              const SizedBox(height: 20),
              Text(wii.app, style: WiStyles.titulo.copyWith(fontSize: 32, color: Colors.white)).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${wii.version}', style: WiStyles.subtitulo.copyWith(color: Colors.white, fontSize: 18)),
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 12),
              Text('Conversor Profesional de Video a MP3', style: WiStyles.normal.copyWith(color: Colors.white70)).animate().fadeIn(delay: 700.ms),
            ],
          ),
        ).animate().slideY(begin: -0.2, duration: 600.ms),
        const SizedBox(height: 32),

        // STATS CARDS
        Row(
          children: [
            Expanded(child: _buildStatCard(Icons.rocket_launch, 'Lanzamiento', wii.lanzamiento.toString(), WiColors.success)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard(Icons.person, 'Desarrollador', wii.autor, WiColors.accent)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard(Icons.flutter_dash, 'Framework', 'Flutter 3.24', WiColors.primary)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard(Icons.desktop_windows, 'Plataforma', 'Windows', WiColors.warning)),
          ],
        ).animate().fadeIn(delay: 900.ms),
        const SizedBox(height: 32),

        // FEATURES GRID
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.8,
          children: [
            _buildFeatureCard('🎬', 'Múltiples Formatos', 'MP4, MKV, AVI, MOV, WMV', WiColors.primary),
            _buildFeatureCard('🎵', '4 Calidades', '128k, 192k, 256k, 320k', WiColors.success),
            _buildFeatureCard('⚡', 'Conversión Rápida', 'Optimizado con FFmpeg', WiColors.accent),
            _buildFeatureCard('📁', 'Drag & Drop', 'Arrastra y convierte', WiColors.warning),
            _buildFeatureCard('📊', 'Progreso Real', 'Visualización en tiempo real', WiColors.primary),
            _buildFeatureCard('💾', 'Por Lotes', 'Múltiples archivos simultáneos', WiColors.success),
          ],
        ).animate().fadeIn(delay: 1100.ms),
        const SizedBox(height: 32),

        // TIMELINE
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: WiColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.history, color: WiColors.primary, size: 28),
                  const SizedBox(width: 12),
                  Text('📜 Historial de Versiones', style: WiStyles.subtitulo),
                ],
              ),
              const SizedBox(height: 24),
              _buildTimelineItem('1.0.0', '18 Enero 2025', 'Lanzamiento inicial', [
                'Conversión de video a MP3',
                'Soporte para 7 formatos',
                'Calidad personalizable (128k-320k)',
                'Conversión por lotes',
                'Interfaz moderna y compacta',
                'Sistema de arrastrar y soltar',
              ], true),
            ],
          ),
        ).animate().fadeIn(delay: 1300.ms),
        const SizedBox(height: 32),

        // TECH STACK
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey.shade50, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.code, color: WiColors.primary, size: 28),
                  const SizedBox(width: 12),
                  Text('🔧 Stack Tecnológico', style: WiStyles.subtitulo),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildTechItem(Icons.flutter_dash, 'Flutter', '3.24.0', WiColors.primary)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTechItem(Icons.code, 'Dart', '3.9.2', WiColors.accent)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTechItem(Icons.movie, 'FFmpeg', '7.1', WiColors.success)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTechItem(Icons.desktop_windows, 'Windows', '10/11', WiColors.warning)),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: 1500.ms),
        const SizedBox(height: 32),

        // LICENSE
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: WiColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.shield, color: WiColors.success, size: 28),
                  const SizedBox(width: 12),
                  Text('⚖️ Licencia & Derechos', style: WiStyles.subtitulo),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: WiColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: WiColors.success.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Copyright © ${wii.lanzamiento} ${wii.autor}', style: WiStyles.normal.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Todos los derechos reservados.', style: WiStyles.pequeno),
                    const Divider(height: 24),
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: WiColors.textLight),
                        const SizedBox(width: 8),
                        Expanded(child: Text('Esta aplicación utiliza FFmpeg bajo licencia LGPL v2.1+', style: WiStyles.pequeno.copyWith(fontStyle: FontStyle.italic))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 1700.ms),
      ],
    ),
  );

  Widget _buildStatCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WiColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(label, style: WiStyles.pequeno.copyWith(color: WiColors.textLight, fontSize: 11)),
          const SizedBox(height: 4),
          Text(value, style: WiStyles.normal.copyWith(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String emoji, String titulo, String descripcion, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WiColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(titulo, style: WiStyles.normal.copyWith(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(descripcion, style: WiStyles.pequeno.copyWith(fontSize: 11, color: WiColors.textLight), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String version, String fecha, String titulo, List<String> items, bool isLatest) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isLatest ? WiColors.success : WiColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(isLatest ? Icons.star : Icons.check, color: Colors.white, size: 20),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isLatest ? WiColors.success : WiColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(version, style: WiStyles.pequeno.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  Text(fecha, style: WiStyles.pequeno.copyWith(color: WiColors.textLight)),
                  if (isLatest) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: WiColors.success.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('ACTUAL', style: WiStyles.pequeno.copyWith(color: WiColors.success, fontWeight: FontWeight.bold, fontSize: 10)),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Text(titulo, style: WiStyles.normal.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle, size: 16, color: WiColors.success),
                    const SizedBox(width: 8),
                    Expanded(child: Text(item, style: WiStyles.pequeno)),
                  ],
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTechItem(IconData icon, String nombre, String version, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(nombre, style: WiStyles.normal.copyWith(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 4),
          Text(version, style: WiStyles.pequeno.copyWith(color: WiColors.textLight, fontSize: 11)),
        ],
      ),
    );
  }
}