// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names, prefer_const_literals_to_create_immutables

import 'package:app_pilates/ConfigScreen/NovoAluno.dart';
import 'package:app_pilates/Controle/Classes.dart';
import 'package:flutter/material.dart';
import 'package:app_pilates/Componentes/GlassContainer.dart';
import 'package:flutter/widgets.dart';

import 'Aluno.dart';
import 'Horarios.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  ConfigScreenState createState() => ConfigScreenState();
}

final List<String> Paginas = ["HORARIOS", "ALUNO"];
String ShowPage = "NOVOAGENDAMENTO";
bool DroweAberto = false;
Aluno? DataParaSobre; // = Aluno(Id: -1, Nome: "TESTE SEM DATA");

class ConfigScreenState extends State<ConfigScreen> {
  @override
  Widget build(BuildContext context) {
    EnviarParaInicio() => {Navigator.pushNamed(context, "/WeekScreen")};

    var WindowWidth = MediaQuery.of(context).size.width;
    var WindowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color.fromRGBO(55, 46, 46, 1),
        body: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 50,
                    height: 35,
                    child: IconButton(
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        onPressed: () => {
                              setState(() {
                                DroweAberto = !DroweAberto;
                              })
                            },
                        icon: Icon(Icons.menu))),
                Stack(
                  children: [
                    ConteudoTela(setState),
                    if (DroweAberto)
                      Container(
                        width: WindowWidth,
                        height: WindowHeight - 55,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.black,
                            Colors.black,
                            Colors.transparent,
                          ], stops: [
                            0,
                            .5,
                            1
                          ]),
                        ),
                        padding: EdgeInsets.only(right: WindowWidth * .5),
                        child: NavBar(WindowWidth, WindowHeight - 55, setState,
                            EnviarParaInicio),
                      )
                  ],
                )
              ],
            );
          } else {
            return Row(children: [
              NavBar(WindowWidth, WindowHeight, setState, EnviarParaInicio),
              ConteudoTela(setState),
            ]);
          }
        }));
  }
}

Widget NavBar(WindowWidth, WindowHeight, setState, EnviarParaInicio) {
  return GlassContainer(
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
              overlayColor: MaterialStateProperty.all(Colors.transparent),
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
                  style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                ),
              ),
            ),
          ),
        ],
      ));
}

Widget ConteudoTela(setState) {
  return ShowPage == "HORARIOS"
      ? HorarioScreen()
      : ShowPage == "ALUNO"
          ? AgendamentoScreen(
              EnviarParaNovoAgendamento: () => {
                setState(() {
                  ShowPage = "NOVOAGENDAMENTO";
                })
              },
              EnviarParaSobre: (Aluno Data) => {
                setState(() {
                  ShowPage = "NOVOAGENDAMENTO";
                  DataParaSobre = Data;
                })
              },
            )
          : ShowPage == "NOVOAGENDAMENTO"
              ? NovoAgendamentoScreen(Data: DataParaSobre)
              : Text("DEU BO AQ");
}
