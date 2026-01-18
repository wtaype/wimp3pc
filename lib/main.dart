import 'package:flutter/material.dart';
import 'pantallas/inicio.dart';
import 'wicss.dart';
import 'wii.dart';

void main() => runApp(const WiMP3App());

class WiMP3App extends StatelessWidget {
  const WiMP3App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: wii.apptitulo,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: WiColors.primary,
        scaffoldBackgroundColor: WiColors.background,
        useMaterial3: true,
      ),
      home: const PantallaInicio(),
    );
  }
}