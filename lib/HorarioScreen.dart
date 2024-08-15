// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, avoid_print, constant_identifier_names, unnecessary_brace_in_string_interps, prefer_function_declarations_over_variables, unused_local_variable, curly_braces_in_flow_control_structures, dead_code

import 'package:app_pilates/Controle/AlunosController.dart';
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

class HorarioScreen extends StatefulWidget {
  const HorarioScreen({super.key});

  @override
  StateHorarioScreen createState() => StateHorarioScreen();
}

String DiaSemanaSelecionado = "SEGUNDA-FEIRA";
String TopicoSelecionado = "06:00";
DiaSemana? Dia;
bool DroweAberto = false;

class StateHorarioScreen extends State<HorarioScreen> {
  @override
  void initState() {
    super.initState();
    // Inicialização padrão
    Dia = Controller().Obter_Dia_porString('SEGUNDA-FEIRA');
    TopicoSelecionado = "07:00";
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Tentando obter os argumentos da navegação
    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is DataEnvio_Week_Horario) {
      DiaSemanaSelecionado = arguments.DiaDaSemana;
      Dia = Controller().Obter_Dia_porString(arguments.DiaDaSemana);
      TopicoSelecionado = arguments.HorarioSelecionado;
    } else {
      Dia = Controller().Obter_Dia_porString('SEGUNDA-FEIRA');
      TopicoSelecionado = Dia!.Horarios.first.Hora;
    }
  }

  @override
  Widget build(BuildContext context) {
    EnviarParaInicio() => {Navigator.pushNamed(context, "/WeekScreen")};

    var WindowWidth = MediaQuery.of(context).size.width;
    double WindowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromRGBO(55, 46, 46, 1),
      body: LayoutBuilder(
        builder: (context, constraints) {
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
                    ConteudoTela(
                        WindowWidth, WindowHeight - 75, setState, true),
                    if (DroweAberto)
                      Container(
                        width: WindowWidth,
                        height: WindowHeight - 55,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.black,
                            Colors.black.withOpacity(.8),
                            Colors.transparent,
                          ], stops: [
                            0,
                            .7,
                            .8
                          ]),
                        ),
                        child: Row(
                          children: [
                            NavBar(WindowWidth, WindowHeight, setState,
                                EnviarParaInicio),
                            TextButton(
                                style: ButtonStyle(
                                  overlayColor: MaterialStatePropertyAll(
                                      Colors.transparent),
                                ),
                                onPressed: () => setState(() {
                                      DroweAberto = false;
                                    }),
                                child: SizedBox(
                                  width: WindowWidth - 240,
                                  height: WindowHeight - 55,
                                ))
                          ],
                        ),
                      )
                  ],
                )
              ],
            );
          else
            return Row(
              children: [
                NavBar(WindowWidth, WindowHeight, setState, EnviarParaInicio),
                ConteudoTela(WindowWidth, WindowHeight, setState, false)
              ],
            );
        },
      ),
    );
  }
}

Widget NavBar(WindowWidth, WindowHeight, setState, EnviarParaInicio) {
  return GlassContainer(
    Cor: Color.fromRGBO(255, 255, 255, 1),
    Width: (WindowWidth * .2),
    MinWidth: 200,
    Height: WindowHeight,
    Child: Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(right: 10),
            children: Dia!.Horarios.map(
              (e) {
                return TextButton(
                  onPressed: () => {
                    setState(
                      () {
                        TopicoSelecionado = e.Hora;
                      },
                    )
                  },
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: GlassContainer(
                    Cor: (TopicoSelecionado != (e.Hora)
                        ? Color.fromRGBO(255, 255, 255, 1)
                        : Color.fromRGBO(173, 99, 173, 1)),
                    Width: 0,
                    Rotate: 7,
                    MinWidth: 0,
                    Height: 35,
                    Child: Center(
                      child: Text(
                        e.Hora,
                        style: TextStyle(
                          color: (TopicoSelecionado != (e.Hora)
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(173, 99, 173, 1)),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
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
    ),
  );
}

Widget ConteudoTela(WindowWidth, WindowHeight, setState, bool Tamanho) {
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
          '${DiaSemanaSelecionado} ${TopicoSelecionado}',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.normal),
        ),
        Expanded(
          child: ListView(
            children: Dia!.Horarios
                .firstWhere((element) => element.Hora == TopicoSelecionado)
                .IdAlunos
                .map(
              (e) {
                return TextButton(
                  onPressed: () => {
                    setState(() {
                      AlunosController()
                          .ObterAlunoPorId(e)
                          .SetPresenca(TopicoSelecionado, DiaSemanaSelecionado);
                    })
                  },
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: GlassContainer(
                    Cor: AlunosController().ObterAlunoPorId(e).GetPresenca(
                            TopicoSelecionado, DiaSemanaSelecionado) // PRESENÇA
                        ? Color.fromRGBO(12, 255, 32, 1)
                        : Color.fromRGBO(255, 255, 255, 1),
                    Rotate: 20,
                    Width: 0,
                    Height: 55,
                    Child: Center(
                      child: Text(
                        AlunosController().ObterAlunoPorId(e).GetNome(),
                        style: TextStyle(
                          color: AlunosController()
                                  .ObterAlunoPorId(e)
                                  .GetPresenca(
                                      TopicoSelecionado, DiaSemanaSelecionado)
                              ? Color.fromRGBO(12, 255, 32, 1)
                              : Color.fromRGBO(255, 255, 255, 1),
                          fontSize: 20,
                        ),
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
