// ignore_for_file: avoid_print

import 'package:app_pilates/ConfigScreen/ConfScreenMain.dart';
import 'package:app_pilates/Controle/IniciarVareaveis.dart';
import 'package:app_pilates/HorarioScreen.dart';
import 'package:flutter/material.dart';
import 'package:app_pilates/WeekScreen.dart';
import 'Controle/GerarDataTeste.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    IniciarPrograma();
    gerarDadosTeste();
    return MaterialApp(
      initialRoute: "/WeekScreen",
      routes: {
        "/WeekScreen": (context) => const WeekScreen(), // 500
        "/HorarioScreen": (context) => const HorarioScreen(), // 500
        "/ConfigScreen": (context) => const ConfigScreen(), //
      },
    );
  }
}
