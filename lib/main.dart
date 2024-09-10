import 'package:app_pilates/ConfigScreen/ConfScreenMain.dart';
import 'package:app_pilates/Controle/IniciarVareaveis.dart';
import 'package:app_pilates/HorarioScreen.dart';
import 'package:app_pilates/RelatorioScreen/RelatorioScreenMain.dart';
import 'package:flutter/material.dart';
import 'package:app_pilates/WeekScreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    IniciarPrograma();

    return MaterialApp(
      initialRoute: "/WeekScreen",
      routes: {
        "/WeekScreen": (context) => const WeekScreen(),
        "/HorarioScreen": (context) => const HorarioScreen(),
        "/ConfigScreen": (context) => const ConfigScreen(),
        "/RelatScreen": (context) => const RelatorioScreen(),
      },
    );
  }
}
