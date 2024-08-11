// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, avoid_print, constant_identifier_names

import 'package:app_pilates/Controle/Controller.dart';

import 'Controle/Classes.dart';
import 'package:flutter/material.dart';
import 'Componentes/GlassContainer.dart';

final List<String> InfoNavBar = [
  "SEGUNDA-FEIRA",
  "TERÇA-FEIRA",
  "QUARTA-FEIRA",
  "QUINTA-FEIRA",
  "SEXTA-FEIRA",
];

class WeekScreen extends StatefulWidget {
  const WeekScreen({super.key});

  @override
  StateWeekScreen createState() => StateWeekScreen();
}

String TopicoSelecionado = "SEGUNDA-FEIRA";
DiaSemana? Dia;

class StateWeekScreen extends State<WeekScreen> {
  @override
  Widget build(BuildContext context) {
    Dia = Controller().Obter_Dia_porString(TopicoSelecionado);
    var WindowWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(55, 46, 46, 1),
      body: Row(
        children: [
          GlassContainer(
              Cor: Color.fromRGBO(255, 255, 255, 0),
              Width: (WindowWidth * .2),
              MinWidth: 200,
              Height: 0,
              Child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(right: 10),
                      children: InfoNavBar.map((e) {
                        return TextButton(
                            onPressed: () => {
                                  setState(
                                    () {
                                      TopicoSelecionado = e;
                                    },
                                  )
                                },
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            child: GlassContainer(
                              Cor: (TopicoSelecionado != (e)
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(173, 99, 173, 1)),
                              Width: 0,
                              Rotate: 7,
                              MinWidth: 0,
                              Height: 35,
                              Child: Center(
                                child: Text(
                                  e,
                                  style: TextStyle(
                                    color: (TopicoSelecionado != (e)
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(173, 99, 173, 1)),
                                  ),
                                ),
                              ),
                            ));
                      }).toList(),
                    ),
                  ),
                  TextButton(
                    onPressed: () => {},
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: GlassContainer(
                      Cor: Color.fromRGBO(255, 255, 255, 1),
                      Width: (WindowWidth * .2),
                      MinWidth: 200,
                      Rotate: 7,
                      Height: 35,
                      Child: Center(
                        child: Text(
                          "CONFIGURAÇÕES",
                          style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1)),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => {},
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: GlassContainer(
                      Cor: Color.fromRGBO(255, 255, 255, 1),
                      Width: (WindowWidth * .2),
                      MinWidth: 200,
                      Rotate: 7,
                      Height: 35,
                      Child: Center(
                        child: Text(
                          "RELATORIO SEMANAL",
                          style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1)),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          GlassContainer(
            Cor: Color.fromRGBO(255, 255, 255, 0),
            Width: (WindowWidth * .2) >= 200
                ? (WindowWidth * .8) - 30
                : (WindowWidth - 230),
            Height: 0,
            Child: Column(
              children: [
                Text(
                  TopicoSelecionado,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.normal),
                ),
                Expanded(
                  child: ListView(
                    children: Dia!.Horarios.map(
                      (e) {
                        return TextButton(
                          onPressed: () => {},
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          child: GlassContainer(
                            Cor: Color.fromRGBO(255, 255, 255, 1),
                            Rotate: 20,
                            Width: 0,
                            Height: 55,
                            Child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    e.Hora,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    e.ObterPessoas(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

/*
GlassContainer(
        Width: 0,
        Height: 40,
        Child: Text(e.Hora),
        Cor: Color.fromRGBO(255, 255, 255, 1),
      );
*/