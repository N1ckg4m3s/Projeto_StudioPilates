// ignore_for_file: non_constant_identifier_names, file_names

import 'package:app_pilates/RelatorioScreen/FaltasGerais.dart';
import 'package:app_pilates/RelatorioScreen/Mensalidades.dart';
import 'package:flutter/material.dart';
import 'package:app_pilates/Componentes/GlassContainer.dart';

class RelatorioScreen extends StatefulWidget {
  const RelatorioScreen({super.key});

  @override
  RelatorioScreenState createState() => RelatorioScreenState();
}

final List<String> Paginas = ["FALTAS GERAIS", "MENSALIDADES"];
String ShowPage = "FALTAS GERAIS";
bool DroweAberto = false;

class RelatorioScreenState extends State<RelatorioScreen> {
  @override
  void initState() {
    super.initState();
    DroweAberto = false;
  }

  @override
  Widget build(BuildContext context) {
    EnviarParaInicio() => {Navigator.pushNamed(context, "/WeekScreen")};

    var WindowWidth = MediaQuery.of(context).size.width;
    var WindowHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: const Color.fromRGBO(55, 46, 46, 1),
        body: LayoutBuilder(builder: (context, constraints) {
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
                              setState(() {
                                DroweAberto = !DroweAberto;
                              })
                            },
                        icon: const Icon(Icons.menu))),
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
                            NavBar(WindowWidth, WindowHeight, setState,
                                EnviarParaInicio),
                            TextButton(
                                style: const ButtonStyle(
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
      Cor: const Color.fromRGBO(255, 255, 255, 1),
      Width: (WindowWidth * .2),
      MinWidth: 200,
      Height: 0,
      Child: Column(
        children: [
          Expanded(
            child: ListView(
                padding: const EdgeInsets.only(right: 10),
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
                    ))).toList()),
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
      ));
}

Widget ConteudoTela(setState) {
  return ShowPage == "FALTAS GERAIS"
      ? const FaltasGeraisScreen()
      : ShowPage == "MENSALIDADES"
          ? const MensalidadesScreen()
          : const Text("Deu B.O aqui");
}
