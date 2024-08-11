// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, avoid_print, constant_identifier_names

import 'package:flutter/material.dart';
import 'Componentes/GlassContainer.dart';

final List<Map<String, String>> InfoNavBar = [
  {"day": "SEGUNDA-FEIRA", "Redirecionamento": "Texto"},
  {"day": "TERÇA-FEIRA", "Redirecionamento": "Texto"},
  {"day": "QUARTA-FEIRA", "Redirecionamento": "Texto"},
  {"day": "QUINTA-FEIRA", "Redirecionamento": "Texto"},
  {"day": "SEXTA-FEIRA", "Redirecionamento": "Texto"},
  {"day": "SÁBADO", "Redirecionamento": "Texto"},
  {"day": "DOMINGO", "Redirecionamento": "Texto"},
];

class WeekScreen extends StatelessWidget {
  const WeekScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var WindowWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color.fromRGBO(55, 46, 46, 1),
        body: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            GlassContainer(
              Cor: Color.fromRGBO(255, 255, 255, 0),
              Width: (WindowWidth * .2),
              MinWidth: 200,
              Height: 0,
              Child: ListView(
                children: InfoNavBar.map((e) {
                  return GlassContainer(
                    Cor: Color.fromRGBO(255, 255, 255, 0),
                    Width: 180,
                    MinWidth: 100,
                    Height: 35,
                    Child: Center(
                      child: Text(
                        e,
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            GlassContainer(
              Cor: Color.fromRGBO(255, 255, 255, 0),
              Width: (WindowWidth * .2) >= 200
                  ? (WindowWidth * .8) - 30
                  : (WindowWidth - 230),
              Height: 0,
              Child: Text("opaa"),
            ),
          ],
        ));
  }
}
