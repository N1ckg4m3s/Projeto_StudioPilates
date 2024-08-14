// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names, prefer_const_literals_to_create_immutables, unused_import

import 'package:app_pilates/ConfigScreen/NovoAluno.dart';
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
String ShowPage = "MENSALIDADES";
bool DroweAberto = false;

class RelatorioScreenState extends State<RelatorioScreen> {
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
                SizedBox(
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
  return ShowPage == "FALTAS GERAIS"
      ? FaltasGeraisScreen()
      : ShowPage == "MENSALIDADES"
          ? MensalidadesScreen()
          : Text("Deu B.O aqui");
}
