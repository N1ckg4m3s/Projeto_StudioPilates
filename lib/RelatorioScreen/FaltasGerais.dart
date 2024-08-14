// ignore_for_file: non_constant_identifier_names, unused_element, prefer_const_literals_to_create_immutables, prefer_const_constructors, file_names

import 'package:app_pilates/Componentes/GlassContainer.dart';
import 'package:app_pilates/Controle/AlunosController.dart';
import 'package:flutter/material.dart';

class FaltasGeraisScreen extends StatefulWidget {
  const FaltasGeraisScreen({super.key});

  @override
  FaltasGeraisScreenState createState() => FaltasGeraisScreenState();
}

class FaltasGeraisScreenState extends State<FaltasGeraisScreen> {
  @override
  Widget build(BuildContext context) {
    EnviarParaInicio() => {Navigator.pushNamed(context, "/WeekScreen")};
    var WindowWidth = MediaQuery.of(context).size.width;
    var WindowHeight = MediaQuery.of(context).size.height;
    return GlassContainer(
        Cor: const Color.fromRGBO(255, 255, 255, 1),
        Width: WindowWidth > 601
            ? (WindowWidth * .2) >= 200
                ? (WindowWidth * .8) - 30
                : (WindowWidth - 230)
            : WindowWidth - 20,
        Padding: EdgeInsets.all(10),
        Height: WindowHeight - (WindowWidth > 601 ? 0 : 55),
        Child: Column(children: [
          Center(
            child: Text(
              "FALTAS",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          Expanded(
              child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, mainAxisExtent: 40),
            children: AlunosController()
                .ObterFaltas()
                .map((e) => Text(
                      '${e.Nome}: [ ${AlunosController().DominutivoDiaSemanaByFaltas(e)} ]'
                          .toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ))
                .toList(),
          ))
        ]));
  }
}
