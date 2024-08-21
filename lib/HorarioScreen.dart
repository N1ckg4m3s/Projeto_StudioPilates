// ignore_for_file: non_constant_identifier_names, file_names

import 'package:app_pilates/Componentes/CaregandoData.dart';
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
final ValueNotifier<String> topicoSelecionadoNotifier =
    ValueNotifier("SEGUNDA-FEIRA");
final ValueNotifier<bool> droweAbertoNotifier = ValueNotifier(false);
DiaSemana? Dia;
bool DroweAberto = false;

class StateHorarioScreen extends State<HorarioScreen> {
  @override
  void initState() {
    super.initState();
    CarregarDadosIniciais() async {
      Dia = await Controller().obterDiaPorString('SEGUNDA-FEIRA');
      topicoSelecionadoNotifier.value = "07:00";
    }

    CarregarDadosIniciais();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    CarregarDados() async {
      final arguments = ModalRoute.of(context)?.settings.arguments;

      if (arguments is DataEnvio_Week_Horario) {
        DiaSemanaSelecionado = arguments.DiaDaSemana;
        Dia = await Controller().obterDiaPorString(arguments.DiaDaSemana);
        topicoSelecionadoNotifier.value = arguments.HorarioSelecionado;
      } else {
        Dia = await Controller().obterDiaPorString('SEGUNDA-FEIRA');
        topicoSelecionadoNotifier.value = Dia!.Horarios.first.Hora;
      }
    }

    CarregarDados();
  }

  @override
  Widget build(BuildContext context) {
    EnviarParaInicio() => {Navigator.pushNamed(context, "/WeekScreen")};

    var WindowWidth = MediaQuery.of(context).size.width;
    double WindowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(55, 46, 46, 1),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: 50,
                    height: 35,
                    child: IconButton(
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        onPressed: () => {
                              droweAbertoNotifier.value =
                                  !droweAbertoNotifier.value,
                            },
                        icon: const Icon(Icons.menu))),
                Stack(
                  children: [
                    ValueListenableBuilder<String>(
                      valueListenable: topicoSelecionadoNotifier,
                      builder: (context, topicoSelecionado, child) {
                        return ConteudoTela(
                            WindowWidth,
                            WindowHeight - 75,
                            setState,
                            true,
                            topicoSelecionado,
                            Dia,
                            DiaSemanaSelecionado);
                      },
                    ),
                    ValueListenableBuilder<bool>(
                        valueListenable: droweAbertoNotifier,
                        builder: (context, DroweAbertoNot, child) {
                          if (DroweAbertoNot) {
                            return Container(
                              width: WindowWidth,
                              height: WindowHeight - 55,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Colors.black,
                                  Colors.black.withOpacity(.8),
                                  Colors.transparent,
                                ], stops: const [
                                  0,
                                  .7,
                                  .8
                                ]),
                              ),
                              child: Row(
                                children: [
                                  NavBar(WindowWidth, WindowHeight,
                                      (newTopico) {
                                    topicoSelecionadoNotifier.value = newTopico;
                                    droweAbertoNotifier.value = false;
                                  }, setState, EnviarParaInicio,
                                      topicoSelecionadoNotifier.value),
                                  TextButton(
                                      style: const ButtonStyle(
                                        overlayColor: MaterialStatePropertyAll(
                                            Colors.transparent),
                                      ),
                                      onPressed: () =>
                                          droweAbertoNotifier.value = false,
                                      child: SizedBox(
                                        width: WindowWidth - 240,
                                        height: WindowHeight - 55,
                                      ))
                                ],
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                  ],
                )
              ],
            );
          } else {
            return Row(
              children: [
                NavBar(WindowWidth, WindowHeight, (newTopico) {
                  topicoSelecionadoNotifier.value = newTopico;
                  droweAbertoNotifier.value = false;
                }, setState, EnviarParaInicio, topicoSelecionadoNotifier.value),
                ValueListenableBuilder<String>(
                  valueListenable: topicoSelecionadoNotifier,
                  builder: (context, topicoSelecionado, child) {
                    return ConteudoTela(WindowWidth, WindowHeight, setState,
                        true, topicoSelecionado, Dia, DiaSemanaSelecionado);
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

Widget NavBar(WindowWidth, WindowHeight, SelecionarTopico, setState,
    EnviarParaInicio, TopicoSelecionado) {
  return GlassContainer(
    Cor: const Color.fromRGBO(255, 255, 255, 1),
    Width: (WindowWidth * .2),
    MinWidth: 200,
    Height: WindowHeight,
    Child: Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(right: 10),
            children: Dia!.Horarios.map(
              (e) {
                return ValueListenableBuilder<String>(
                  valueListenable: topicoSelecionadoNotifier,
                  builder: (context, topicoSelecionado, child) {
                    return TextButton(
                      onPressed: () => {
                        setState(
                          () {
                            SelecionarTopico(e.Hora);
                          },
                        )
                      },
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: GlassContainer(
                        Cor: (TopicoSelecionado != (e.Hora)
                            ? const Color.fromRGBO(255, 255, 255, 1)
                            : const Color.fromRGBO(173, 99, 173, 1)),
                        Width: 0,
                        Rotate: 7,
                        MinWidth: 0,
                        Height: 35,
                        Child: Center(
                          child: Text(
                            e.Hora,
                            style: TextStyle(
                              color: (TopicoSelecionado != (e.Hora)
                                  ? const Color.fromRGBO(255, 255, 255, 1)
                                  : const Color.fromRGBO(173, 99, 173, 1)),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
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
            Cor: const Color.fromRGBO(255, 255, 255, 1),
            Width: (WindowWidth * .2),
            MinWidth: 200,
            Rotate: 7,
            Height: 35,
            Child: const Center(
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

Widget ConteudoTela(
  double WindowWidth,
  double WindowHeight,
  void Function(void Function()) setState,
  bool Tamanho,
  String TopicoSelecionado,
  DiaSemana? Dia,
  String DiaSemanaSelecionado,
) {
  return GlassContainer(
    Cor: const Color.fromRGBO(255, 255, 255, 1),
    Width: Tamanho
        ? WindowWidth - 20
        : (WindowWidth * .2) >= 200
            ? (WindowWidth * .8) - 30
            : (WindowWidth - 230),
    Height: WindowHeight,
    Child: Column(
      children: [
        Text(
          '$DiaSemanaSelecionado $TopicoSelecionado',
          style: const TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.normal),
        ),
        Expanded(
          child: ListView(
            children: Dia?.Horarios.isEmpty ?? true
                ? [const Text("")]
                : Dia!.Horarios
                    .firstWhere((element) => element.Hora == TopicoSelecionado)
                    .IdAlunos
                    .map(
                    (IdAluno) {
                      return FutureBuilder<Aluno>(
                        future: AlunosController().obterAlunoPorId(IdAluno),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CarregandoDataBar();
                          } else if (snapshot.hasError) {
                            return const Text("ERROR");
                          } else if (!snapshot.hasData) {
                            return const Text("No data");
                          }
                          final aluno = snapshot.data!;

                          return FutureBuilder<bool>(
                            future: AlunosController().ObterPresencaAluno(
                                IdAluno,
                                TopicoSelecionado,
                                DiaSemanaSelecionado),
                            builder: (context, presencaSnapshot) {
                              if (presencaSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CarregandoDataBar();
                              } else if (presencaSnapshot.hasError) {
                                return const Text("ERROR");
                              } else if (!presencaSnapshot.hasData) {
                                return const Text("No data");
                              }

                              bool presenca = presencaSnapshot.data!;

                              return TextButton(
                                onPressed: () async {
                                  try {
                                    int idDaHora = await Controller()
                                        .obterIdHoraPorString(
                                            TopicoSelecionado);

                                    AlunosController().DefinirPresencaAluno(
                                        aluno.Id, Dia.Nome, idDaHora);

                                    // Atualiza a UI
                                    setState(() {});
                                  } catch (e) {
                                    debugPrint(
                                        "Erro ao definir a presença do aluno: $e");
                                  }
                                },
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                ),
                                child: GlassContainer(
                                  Cor: presenca
                                      ? const Color.fromRGBO(12, 255, 32, 1)
                                      : const Color.fromRGBO(255, 255, 255, 1),
                                  Rotate: 20,
                                  Width: 0,
                                  Height: 55,
                                  Child: Center(
                                    child: Text(
                                      aluno.Nome,
                                      style: TextStyle(
                                        color: presenca
                                            ? const Color.fromRGBO(
                                                12, 255, 32, 1)
                                            : const Color.fromRGBO(
                                                255, 255, 255, 1),
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ).toList(),
          ),
        ),
      ],
    ),
  );
}
