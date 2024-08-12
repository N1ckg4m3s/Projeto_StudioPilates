// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names

import 'package:app_pilates/ConfigScreen/NovoAgendamento.dart';
import 'package:flutter/material.dart';
import 'package:app_pilates/Componentes/GlassContainer.dart';

import 'Agendamentos.dart';
import 'Horarios.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  ConfigScreenState createState() => ConfigScreenState();
}

final List<String> Paginas = ["HORARIOS", "AGENDAMENTOS"];
String ShowPage = "NOVOAGENDAMENTO";

class ConfigScreenState extends State<ConfigScreen> {
  @override
  Widget build(BuildContext context) {
    EnviarParaInicio() => {Navigator.pushNamed(context, "/WeekScreen")};

    var WindowWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(55, 46, 46, 1),
      body: Row(
        children: [
          GlassContainer(
              Cor: Color.fromRGBO(255, 255, 255, 1),
              Width: (WindowWidth * .2),
              MinWidth: 200,
              Height: 0,
              Child: Column(
                children: [
                  Expanded(
                    child: ListView(
                        padding: EdgeInsets.only(right: 10),
                        children: Paginas.map((e) => TextButton(
                            onPressed: () => {
                                  setState(() {
                                    ShowPage = e;
                                  })
                                },
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            child: GlassContainer(
                              Cor: e != ShowPage
                                  ? Color.fromRGBO(255, 255, 255, 1)
                                  : Color.fromRGBO(173, 99, 173, 1),
                              Width: 0,
                              Rotate: 7,
                              MinWidth: 0,
                              Height: 35,
                              Child: Center(
                                child: Text(
                                  e,
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                ),
                              ),
                            ))).toList()),
                  ),
                  TextButton(
                    onPressed: EnviarParaInicio,
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
                          "VOLTAR",
                          style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1)),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          if (ShowPage == "HORARIOS")
            HorarioScreen()
          else if (ShowPage == "AGENDAMENTOS")
            AgendamentoScreen(
                EnviarParaNovoAgendamento: () => {
                      setState(() {
                        ShowPage = "NOVOAGENDAMENTO";
                      })
                    })
          else if (ShowPage == "NOVOAGENDAMENTO")
            NovoAgendamentoScreen()
          else
            Text("DEU BO AQ")
        ],
      ),
    );
  }
}
