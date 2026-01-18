import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../wicss.dart';

class PantallaMensajes extends StatefulWidget {
  const PantallaMensajes({super.key});

  @override
  State<PantallaMensajes> createState() => _PantallaMensajesState();
}

class _PantallaMensajesState extends State<PantallaMensajes> {
  int _indice = 0;
  Timer? _timer;

  final List<MensajeMotivacional> _mensajes = const [
    MensajeMotivacional(icono: Icons.favorite, texto: 'Dios te ama ❤️', color: Color(0xFFE91E63)),
    MensajeMotivacional(icono: Icons.auto_awesome, texto: 'Eres una bendición 🙏', color: Color(0xFF9C27B0)),
    MensajeMotivacional(icono: Icons.lightbulb, texto: 'Todo es posible con fe ✨', color: Color(0xFFFF9800)),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => setState(() => _indice = (_indice + 1) % _mensajes.length));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mensaje = _mensajes[_indice];
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [mensaje.color.withOpacity(0.1), WiColors.background],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(mensaje.icono, size: 120, color: mensaje.color, key: ValueKey('icon_$_indice'))
              .animate()
              .scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 32),
            Text(
              mensaje.texto,
              style: WiStyles.titulo.copyWith(fontSize: 42, color: mensaje.color),
              textAlign: TextAlign.center,
              key: ValueKey('text_$_indice'),
            ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.3, end: 0),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_mensajes.length, (i) => AnimatedContainer(
                key: ValueKey('dot_$i'),
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: _indice == i ? 32 : 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _indice == i ? mensaje.color : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class MensajeMotivacional {
  final IconData icono;
  final String texto;
  final Color color;

  const MensajeMotivacional({required this.icono, required this.texto, required this.color});
}