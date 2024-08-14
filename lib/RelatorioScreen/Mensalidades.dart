// ignore_for_file: non_constant_identifier_names, unused_element, prefer_const_literals_to_create_immutables, prefer_const_constructors, file_names

import 'package:app_pilates/Componentes/GlassContainer.dart';
import 'package:app_pilates/Controle/AlunosController.dart';
import 'package:flutter/material.dart';

class MensalidadesScreen extends StatefulWidget {
  const MensalidadesScreen({super.key});

  @override
  MensalidadesScreenState createState() => MensalidadesScreenState();
}

List<String> Filtros = ["VENCIDAS", "ATÉ 4 DIAS", "1 SEMANA", "TODOS"];
String FiltroAtual = "TODOS";

int AjustarQuantidades(MaxW) {
  return MaxW >= 1100
      ? 4
      : MaxW > 930
          ? 3
          : MaxW > 620
              ? 2
              : 1;
}

class MensalidadesScreenState extends State<MensalidadesScreen> {
  @override
  Widget build(BuildContext context) {
    EnviarParaInicio() => {Navigator.pushNamed(context, "/WeekScreen")};
    var WindowWidth = MediaQuery.of(context).size.width;
    var WindowHeight = MediaQuery.of(context).size.height;
    return GlassContainer(
        Cor: const Color.fromRGBO(255, 255, 255, 1),
        Width: WindowWidth > 601
            ? (WindowWidth * .2) >= 200
                ? (WindowWidth * .8) - 30
                : (WindowWidth - 230)
            : WindowWidth - 20,
        Height: WindowHeight - (WindowWidth > 601 ? 0 : 75),
        Child: Column(children: [
          Center(
            child: Text(
              "MENSALIDADES",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          GlassContainer(
            Width: 0,
            Height: (50 * (WindowWidth > 880 ? 1 : 2)) + 2,
            Cor: Colors.transparent,
            Child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 50,
                    crossAxisCount: WindowWidth > 880 ? 4 : 2),
                children: Filtros.map((e) => TextButton(
                      onPressed: () => setState(() {
                        FiltroAtual = e;
                      }),
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          width: double.maxFinite,
                          child: GlassContainer(
                            Width: 0,
                            Height: 35,
                            Child: Center(
                              child: Text(e,
                                  style: TextStyle(
                                    color: FiltroAtual != e
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(173, 99, 173, 1),
                                  )),
                            ),
                            Cor: FiltroAtual != e
                                ? Color.fromRGBO(255, 255, 255, 1)
                                : Color.fromRGBO(173, 99, 173, 1),
                          )),
                    )).toList()),
          ),
          Expanded(
              child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: AjustarQuantidades(WindowWidth),
                mainAxisExtent: 40),
            children:
                AlunosController().ObterMensalidades(FiltroAtual).map((aluno) {
              Color corTexto;
              String texto;
              int diasDiferenca =
                  -DateTime.now().difference(aluno.GetUltimoPagamento()).inDays;
              if (aluno.UltimoPagamento == null) {
                diasDiferenca = -1;
              }
              Transformar(DateTime data) {
                return '${data.day}/${data.month}/${data.year}';
              }

              texto =
                  '${aluno.Nome}: ${Transformar(aluno.GetUltimoPagamento())}';

              if (diasDiferenca == 0) {
                texto = '${aluno.Nome}: Hoje';
                corTexto = Colors.red;
              } else if (diasDiferenca <= 0) {
                texto = '${aluno.Nome}: há ${diasDiferenca.abs()} dias';
                corTexto = Colors.red;
              } else if (diasDiferenca <= 4) {
                corTexto = Colors.orange;
                texto = '${aluno.Nome}: em ${diasDiferenca.abs()} dias';
              } else {
                corTexto = Colors.white;
                texto = '${aluno.Nome}: Daqui ${diasDiferenca.abs()} dias';
              }

              return Text(
                texto,
                style: TextStyle(color: corTexto),
              );
            }).toList(),
          ))
        ]));
  }
}
