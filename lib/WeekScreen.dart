// ignore_for_file: non_constant_identifier_names, file_names

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

final ValueNotifier<bool> droweAbertoNotifier = ValueNotifier(false);
final ValueNotifier<String> topicoSelecionadoNotifier =
    ValueNotifier("SEGUNDA-FEIRA");

DiaSemana? Dia;
final TextEditingController Teste = TextEditingController();

class StateWeekScreen extends State<WeekScreen> {
  @override
  Widget build(BuildContext context) {
    double windowWidth = MediaQuery.of(context).size.width;
    double windowHeight = MediaQuery.of(context).size.height;

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
                    onPressed: () {
                      droweAbertoNotifier.value = !droweAbertoNotifier.value;
                    },
                    icon: const Icon(Icons.menu),
                  ),
                ),
                Stack(
                  children: [
                    ValueListenableBuilder<String>(
                      valueListenable: topicoSelecionadoNotifier,
                      builder: (context, topicoSelecionado, child) {
                        return ConteudoTela(
                          windowWidth,
                          windowHeight - 75,
                          () => Navigator.pushNamed(context, "/ConfigScreen"),
                          (horaSelec) => Navigator.pushNamed(
                              context, "/HorarioScreen",
                              arguments: DataEnvio_Week_Horario(
                                  DiaDaSemana: topicoSelecionado,
                                  HorarioSelecionado: horaSelec)),
                          true,
                          topicoSelecionado: topicoSelecionado,
                        );
                      },
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: droweAbertoNotifier,
                      builder: (context, droweAberto, child) {
                        if (droweAberto) {
                          return Container(
                            width: windowWidth,
                            height: windowHeight - 55,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black,
                                  Colors.black.withOpacity(.8),
                                  Colors.transparent
                                ],
                                stops: const [0, .7, .8],
                              ),
                            ),
                            child: Row(
                              children: [
                                NavBar(
                                  windowWidth,
                                  windowHeight,
                                  (newTopico) {
                                    topicoSelecionadoNotifier.value = newTopico;
                                    droweAbertoNotifier.value = false;
                                  },
                                  () => Navigator.pushNamed(
                                      context, "/ConfigScreen"),
                                  () => Navigator.pushNamed(
                                      context, "/RelatScreen"),
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                  ),
                                  onPressed: () =>
                                      droweAbertoNotifier.value = false,
                                  child: SizedBox(
                                    width: windowWidth - 240,
                                    height: windowHeight - 55,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
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
                  windowWidth,
                  windowHeight,
                  (newTopico) {
                    topicoSelecionadoNotifier.value = newTopico;
                  },
                  () => Navigator.pushNamed(context, "/ConfigScreen"),
                  () => Navigator.pushNamed(context, "/RelatScreen"),
                ),
                ValueListenableBuilder<String>(
                  valueListenable: topicoSelecionadoNotifier,
                  builder: (context, topicoSelecionado, child) {
                    return ConteudoTela(
                      windowWidth,
                      windowHeight,
                      () => Navigator.pushNamed(context, "/ConfigScreen"),
                      (horaSelec) => Navigator.pushNamed(
                          context, "/HorarioScreen",
                          arguments: DataEnvio_Week_Horario(
                              DiaDaSemana: topicoSelecionado,
                              HorarioSelecionado: horaSelec)),
                      false,
                      topicoSelecionado: topicoSelecionado,
                    );
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

Widget NavBar(
  double windowWidth,
  double windowHeight,
  Function(String) onSelectTopico,
  VoidCallback enviarParaConfigs,
  VoidCallback enviarParaRelatorios,
) {
  return GlassContainer(
    Cor: const Color.fromRGBO(255, 255, 255, 1),
    Width: (windowWidth * .2),
    MinWidth: 200,
    Height: windowHeight,
    Child: Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(right: 10),
            children: InfoNavBar.map((e) {
              return ValueListenableBuilder<String>(
                valueListenable: topicoSelecionadoNotifier,
                builder: (context, topicoSelecionado, child) {
                  return TextButton(
                    onPressed: () => onSelectTopico(e),
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: GlassContainer(
                      Cor: (topicoSelecionado != e
                          ? const Color.fromRGBO(255, 255, 255, 1)
                          : const Color.fromRGBO(173, 99, 173, 1)),
                      Width: 0,
                      Rotate: 7,
                      MinWidth: 0,
                      Height: 35,
                      Child: Center(
                        child: Text(
                          e,
                          style: TextStyle(
                            color: (topicoSelecionado != e
                                ? const Color.fromRGBO(255, 255, 255, 1)
                                : const Color.fromRGBO(173, 99, 173, 1)),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
        TextButton(
          onPressed: enviarParaConfigs,
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
          child: GlassContainer(
            Cor: const Color.fromRGBO(255, 255, 255, 1),
            Width: (windowWidth * .2),
            MinWidth: 200,
            Rotate: 7,
            Height: 35,
            Child: const Center(
              child: Text(
                "CONFIGURAÇÕES",
                style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: enviarParaRelatorios,
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
          child: GlassContainer(
            Cor: const Color.fromRGBO(255, 255, 255, 1),
            Width: (windowWidth * .2),
            MinWidth: 200,
            Rotate: 7,
            Height: 35,
            Child: const Center(
              child: Text(
                "RELATORIO SEMANAL",
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
  double windowWidth,
  double windowHeight,
  VoidCallback enviarParaConfigs,
  void Function(String) enviarParaHorarios,
  bool tamanho, {
  required String topicoSelecionado,
}) {
  return FutureBuilder(
    future: Controller().obterConfiguracoes(),
    builder: (context, AsyncSnapshot<Configuracoes> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(
            child:
                Text('Erro ao carregar dados (WEEKSCREEN) ${snapshot.error}'));
      } else if (snapshot.hasData) {
        var configs = snapshot.data!;
        return GlassContainer(
          Cor: const Color.fromRGBO(255, 255, 255, 1),
          Width: tamanho
              ? windowWidth - 20
              : (windowWidth * .2) >= 200
                  ? (windowWidth * .8) - 30
                  : (windowWidth - 230),
          Height: windowHeight,
          Child: Column(
            children: [
              Text(
                topicoSelecionado,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.normal),
              ),
              Expanded(
                child: ListView(
                  children: configs.HorasTrabalhadas.map((HoraQueTrabalha) {
                    return FutureBuilder(
                      future: Controller().obterAlunosHorariosEDia(
                          topicoSelecionado,
                          '${HoraQueTrabalha <= 9 ? '0$HoraQueTrabalha' : HoraQueTrabalha}:00'),
                      builder:
                          (context, AsyncSnapshot<Horario> horarioSnapshot) {
                        if (horarioSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (horarioSnapshot.hasError) {
                          return const Center(
                              child: Text('Erro ao carregar horários'));
                        } else if (horarioSnapshot.hasData) {
                          var horario = horarioSnapshot.data!;
                          return FutureBuilder<String>(
                            future: horario.ObterPessoas(),
                            builder: (context, AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Erro: ${snapshot.error}');
                              } else if (!snapshot.hasData) {
                                return const Text('Nenhum dado disponível');
                              }
                              return TextButton(
                                onPressed: () => enviarParaHorarios(
                                    '${HoraQueTrabalha <= 9 ? '0$HoraQueTrabalha' : HoraQueTrabalha}:00'),
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                ),
                                child: GlassContainer(
                                  Cor: const Color.fromRGBO(255, 255, 255, 1),
                                  Rotate: 20,
                                  Width: 0,
                                  Height: 57,
                                  Child: Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          '${HoraQueTrabalha <= 9 ? '0$HoraQueTrabalha' : HoraQueTrabalha}:00',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          snapshot.data!,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child: Text('Nenhum horário disponível'));
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      } else {
        return const Center(child: Text('Nenhum dado disponível'));
      }
    },
  );
}
