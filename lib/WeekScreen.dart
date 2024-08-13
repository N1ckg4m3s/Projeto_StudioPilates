// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, avoid_print, constant_identifier_names, unused_element, curly_braces_in_flow_control_structures

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
bool DroweAberto = true;

class StateWeekScreen extends State<WeekScreen> {
  @override
  Widget build(BuildContext context) {
    EnviarParaHorarios(String HoraSelec) => {
          Navigator.pushNamed(context, "/HorarioScreen",
              arguments: DataEnvio_Week_Horario(
                  DiaDaSemana: TopicoSelecionado,
                  HorarioSelecionado: HoraSelec))
        };
    EnviarParaConfigs() => {Navigator.pushNamed(context, "/ConfigScreen")};
    Dia = Controller().Obter_Dia_porString(TopicoSelecionado);
    double WindowWidth = MediaQuery.of(context).size.width;
    double WindowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Color.fromRGBO(55, 46, 46, 1),
        body: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < 600)
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
                    ConteudoTela(WindowWidth, WindowHeight - 75,
                        EnviarParaConfigs, EnviarParaHorarios, true),
                    if (DroweAberto)
                      Container(
                        width: WindowWidth,
                        height: WindowHeight - 35,
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
                        child: NavBar(WindowWidth, WindowHeight, setState,
                            EnviarParaConfigs),
                      )
                  ],
                )
              ],
            );
          else
            return Row(children: [
              NavBar(WindowWidth, WindowHeight, setState, EnviarParaConfigs),
              ConteudoTela(WindowWidth, WindowHeight, EnviarParaConfigs,
                  EnviarParaHorarios, false),
            ]);
        }));
  }
}

Widget NavBar(WindowWidth, WindowHeight, setState, EnviarParaConfigs) {
  return GlassContainer(
      key: Key("NavBar"),
      Cor: Color.fromRGBO(255, 255, 255, 1),
      Width: (WindowWidth * .2),
      MinWidth: 200,
      Height: WindowHeight,
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
            onPressed: EnviarParaConfigs,
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
                  "CONFIGURAÇÕES",
                  style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () => {},
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
                  "RELATORIO SEMANAL",
                  style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                ),
              ),
            ),
          ),
        ],
      ));
}

Widget ConteudoTela(WindowWidth, WindowHeight, EnviarParaConfigs,
    EnviarParaHorarios, bool Tamanho) {
  return GlassContainer(
    Cor: Color.fromRGBO(255, 255, 255, 1),
    Width: Tamanho
        ? WindowWidth - 20
        : (WindowWidth * .2) >= 200
            ? (WindowWidth * .8) - 30
            : (WindowWidth - 230),
    Height: WindowHeight,
    Child: Column(
      children: [
        Text(
          TopicoSelecionado,
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.normal),
        ),
        Expanded(
          child: ListView(
            children: Controller().ObterConfiguracoes().HorasTrabalhadas.map(
              (e) {
                return TextButton(
                  onPressed: () =>
                      {EnviarParaHorarios('${e <= 9 ? ('0$e') : e}:00')},
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: GlassContainer(
                    Cor: Color.fromRGBO(255, 255, 255, 1),
                    Rotate: 20,
                    Width: 0,
                    Height: 57,
                    Child: Center(
                      child: Column(
                        children: [
                          Text(
                            '${e <= 9 ? ('0$e') : e}:00',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            Controller()
                                .Obter_Alunos_Horarios_e_Dia(TopicoSelecionado,
                                    '${e <= 9 ? ('0$e') : e}:00')
                                .ObterPessoas(),
                            overflow: TextOverflow.ellipsis,
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
  );
}
