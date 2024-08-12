// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names, unused_import, unused_element, unused_local_variable, prefer_const_literals_to_create_immutables, prefer_function_declarations_over_variables, avoid_print, unrelated_type_equality_checks, unnecessary_null_comparison, empty_catches

import 'package:app_pilates/Controle/Classes.dart';
import 'package:app_pilates/Controle/Controller.dart';
import 'package:flutter/material.dart';
import 'package:app_pilates/Componentes/GlassContainer.dart';
import 'package:flutter/widgets.dart';

class NovoAgendamentoScreen extends StatefulWidget {
  const NovoAgendamentoScreen({super.key});

  @override
  NovoAgendamentoScreenState createState() => NovoAgendamentoScreenState();
}

String VendoDiaSemana = "";

class NovoAgendamentoScreenState extends State<NovoAgendamentoScreen> {
  final TextEditingController _controller = TextEditingController();
  List<DataEnvio_Week_Horario> HorariosSelecionados = [];

  void AdicionarHorario(String DiaDaSemana, String HoraSelecionada) {
    try {
      if (HorariosSelecionados.length < 2) {
        bool diaJaAdicionado = HorariosSelecionados.any(
          (e) => e.DiaDaSemana == DiaDaSemana,
        );
        if (!diaJaAdicionado) {
          HorariosSelecionados.add(
            DataEnvio_Week_Horario(
              DiaDaSemana: DiaDaSemana,
              HorarioSelecionado: HoraSelecionada,
            ),
          );
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void RemoverHorario(String DiaDaSemana, String HoraSelecionada) {
    var horario = HorariosSelecionados.firstWhere(
      (e) =>
          e.DiaDaSemana == DiaDaSemana &&
          e.HorarioSelecionado == HoraSelecionada,
    );
    HorariosSelecionados.removeAt(HorariosSelecionados.indexOf(horario));
  }

  void MsgErro(String mensagem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Aviso'),
          content: Text(mensagem),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void SalvarNovoAgendamento() {
    if (HorariosSelecionados.length < 2) {
      MsgErro("Esqueceu de adicionar dia da semana");
      return;
    }
    if (_controller.text.isEmpty) {
      MsgErro("Esqueceu do nome");
      return;
    }

    for (var element in HorariosSelecionados) {
      Controller()
          .Obter_Dia_porString(element.DiaDaSemana)
          .Horarios
          .firstWhere((e) => e.Hora == element.HorarioSelecionado)
          .Alunos
          .add(Aluno(Nome: _controller.text, Presenca: false));
    }
    _controller.text = "";
    HorariosSelecionados.clear();
    Navigator.pushNamed(context, "/WeekScreen");
  }

  bool CheckSeSelecionado(String DiaDaSemana, String HoraSelecionada) {
    try {
      var horario = HorariosSelecionados.firstWhere(
        (e) =>
            e.DiaDaSemana == DiaDaSemana &&
            e.HorarioSelecionado == HoraSelecionada,
      );
      return horario != null;
    } catch (e) {
      return false;
    }
  }

  double DefinirTamanho(int Quantidade) {
    if (Quantidade <= 4) {
      return 170;
    }
    if (Quantidade <= 8) {
      return 150 * 2;
    }
    if (Quantidade <= 12) {
      return 150 * 3;
    }
    if (Quantidade <= 15) {
      return 150 * 4;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    EnviarParaInicio() => {Navigator.pushNamed(context, "/WeekScreen")};
    var WindowWidth = MediaQuery.of(context).size.width;
    return GlassContainer(
      Cor: Color.fromRGBO(255, 255, 255, 1),
      Width: (WindowWidth * .2) >= 200
          ? (WindowWidth * .8) - 30
          : (WindowWidth - 230),
      Height: 0,
      Child: Column(
        children: [
          Center(
            child: Text(
              "NOVO AGENDAMENTO",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            width: double.maxFinite,
            child: TextField(
              style: TextStyle(color: Colors.white, fontSize: 20),
              controller: _controller,
              decoration: InputDecoration(
                hintText: "NOME DA PESSOA",
                hintStyle: TextStyle(color: Colors.white, fontSize: 20),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
              ),
            ),
          ),
          Center(
            child: Text(
              'HORARIOS LIVRES [${HorariosSelecionados.length}/2]',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Expanded(
            child: ListView(
              children: Controller()
                  .Obter_Dias_Da_Semana()
                  .map(
                    (D) => TextButton(
                      onPressed: () => {
                        setState(() {
                          VendoDiaSemana =
                              VendoDiaSemana == D.Nome ? "" : D.Nome;
                        })
                      },
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: GlassContainer(
                        Cor: Color.fromRGBO(255, 255, 255, 1),
                        Width: 0,
                        MaxHeight: DefinirTamanho(D.Horarios.length), //
                        Height: VendoDiaSemana == D.Nome ? 0 : 40,
                        Child: Column(
                          children: [
                            Text(
                              D.Nome,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                            if (VendoDiaSemana == D.Nome)
                              Expanded(
                                child: GridView(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          mainAxisExtent: 130),
                                  children: D.Horarios.map(
                                    (e) => TextButton(
                                      onPressed: () => {
                                        setState(
                                          () {
                                            if (!CheckSeSelecionado(
                                                D.Nome, e.Hora)) {
                                              AdicionarHorario(D.Nome, e.Hora);
                                            } else {
                                              RemoverHorario(D.Nome, e.Hora);
                                            }
                                          },
                                        )
                                      },
                                      style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(
                                            Colors.transparent),
                                      ),
                                      child: GlassContainer(
                                        Width: 0,
                                        Height: 0,
                                        Cor: !CheckSeSelecionado(D.Nome, e.Hora)
                                            ? Color.fromRGBO(255, 255, 255, 1)
                                            : Color.fromRGBO(173, 99, 173, 1),
                                        Child: Column(
                                          children: [
                                            Center(
                                              child: Text(
                                                e.Hora,
                                                style: TextStyle(
                                                    color: !CheckSeSelecionado(
                                                            D.Nome, e.Hora)
                                                        ? Color.fromRGBO(
                                                            255, 255, 255, 1)
                                                        : Color.fromRGBO(
                                                            173, 99, 173, 1),
                                                    fontSize: 15),
                                              ),
                                            ),
                                            Column(
                                              children: e.Alunos.map(
                                                (e) => Text(
                                                  e.Nome,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15),
                                                ),
                                              ).toList(),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ).toList(),
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          TextButton(
            onPressed: SalvarNovoAgendamento,
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
            ),
            child: GlassContainer(
              Cor: Color.fromRGBO(12, 255, 32, 1),
              Width: 0,
              Rotate: 20,
              Height: 40,
              Child: Center(
                child: Text(
                  "SALVAR",
                  style: TextStyle(
                      color: Color.fromRGBO(12, 255, 32, 1), fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
CheckSeSelecionado(D.Nome, e.Hora)?
  Color.fromRGBO(255, 255, 255, 1):
  Color.fromRGBO(173, 99, 173, 1),
*/