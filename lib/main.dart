import 'package:flutter/material.dart';
import 'package:app_pilates/WeekScreen.dart';
import 'Controle/GerarDataTeste.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    gerarDadosTeste();
    return MaterialApp(
      initialRoute: "/WeekScreen",
      routes: {
        "/WeekScreen": (context) => const WeekScreen(),
      },
    );
  }
}
