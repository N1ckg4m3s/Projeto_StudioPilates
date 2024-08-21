// ignore_for_file: non_constant_identifier_names, file_names, avoid_init_to_null

import 'package:flutter/material.dart';
import 'package:app_pilates/Componentes/GlassContainer.dart';
import 'Aluno.dart';
import 'Horarios.dart';
import 'NovoAluno.dart';
import 'package:app_pilates/Controle/Classes.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  ConfigScreenState createState() => ConfigScreenState();
}

final List<String> Paginas = ["HORARIOS", "ALUNO"];
final ValueNotifier<String> showPageNotifier = ValueNotifier("ALUNO");
final ValueNotifier<bool> droweAbertoNotifier = ValueNotifier(false);
Aluno? DataParaSobre = null;

class ConfigScreenState extends State<ConfigScreen> {
  @override
  void initState() {
    super.initState();
    DataParaSobre = null;
    showPageNotifier.value = "ALUNO";
    droweAbertoNotifier.value = false;
  }

  @override
  Widget build(BuildContext context) {
    EnviarParaInicio() => Navigator.pushNamed(context, "/WeekScreen");

    var WindowWidth = MediaQuery.of(context).size.width;
    var WindowHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromRGBO(55, 46, 46, 1),
      body: SingleChildScrollView(
        child: LayoutBuilder(
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
                      onPressed: () {
                        droweAbertoNotifier.value = !droweAbertoNotifier.value;
                      },
                      icon: const Icon(Icons.menu),
                    ),
                  ),
                  Stack(
                    children: [
                      ValueListenableBuilder<String>(
                        valueListenable: showPageNotifier,
                        builder: (context, showPage, child) {
                          return ConteudoTela(
                            showPage,
                            (NovaPagina) {
                              showPageNotifier.value = NovaPagina;
                            },
                          );
                        },
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: droweAbertoNotifier,
                        builder: (context, droweAberto, child) {
                          if (droweAberto) {
                            return Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height - 55,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black,
                                    Colors.black.withOpacity(.8),
                                    Colors.transparent,
                                  ],
                                  stops: const [0, .7, .8],
                                ),
                              ),
                              child: Row(
                                children: [
                                  NavBar(
                                    WindowWidth,
                                    WindowHeight,
                                    EnviarParaInicio,
                                    (Topico) {
                                      showPageNotifier.value = Topico;
                                      droweAbertoNotifier.value = false;
                                    },
                                    showPageNotifier.value,
                                  ),
                                  TextButton(
                                    style: ButtonStyle(
                                      overlayColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                    ),
                                    onPressed: () {
                                      droweAbertoNotifier.value = false;
                                    },
                                    child: SizedBox(
                                      width: WindowWidth - 240,
                                      height: WindowHeight - 55,
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Row(
                children: [
                  NavBar(
                    WindowWidth,
                    WindowHeight,
                    EnviarParaInicio,
                    (Topico) {
                      showPageNotifier.value = Topico;
                      droweAbertoNotifier.value = false;
                    },
                    showPageNotifier.value,
                  ),
                  ValueListenableBuilder<String>(
                    valueListenable: showPageNotifier,
                    builder: (context, showPage, child) {
                      return ConteudoTela(
                        showPage,
                        (NovaPagina) {
                          showPageNotifier.value = NovaPagina;
                        },
                      );
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

Widget NavBar(
  double WindowWidth,
  double WindowHeight,
  VoidCallback EnviarParaInicio,
  Function(String) SetTopico,
  String ShowPage,
) {
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
            children: Paginas.map((e) {
              return TextButton(
                onPressed: () => SetTopico(e),
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                child: GlassContainer(
                  Cor: e != ShowPage
                      ? const Color.fromRGBO(255, 255, 255, 1)
                      : const Color.fromRGBO(173, 99, 173, 1),
                  Width: 0,
                  Rotate: 7,
                  MinWidth: 0,
                  Height: 35,
                  Child: Center(
                    child: Text(
                      e,
                      style: const TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
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

Widget ConteudoTela(String ShowPage, void Function(String) SetShowPage) {
  switch (ShowPage) {
    case "HORARIOS":
      return const HorarioScreen();
    case "ALUNO":
      return AgendamentoScreen(
        EnviarParaNovoAgendamento: () => SetShowPage("NOVOAGENDAMENTO"),
        EnviarParaSobre: (Aluno Data) {
          DataParaSobre = Data;
          SetShowPage("NOVOAGENDAMENTO");
        },
      );
    case "NOVOAGENDAMENTO":
      return NovoAgendamentoScreen(Data: DataParaSobre);
    default:
      return const Text("Página não encontrada");
  }
}
