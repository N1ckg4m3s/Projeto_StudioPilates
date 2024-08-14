// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names, unused_import, unused_element, unused_local_variable, prefer_const_literals_to_create_immutables, must_be_immutable, prefer_typing_uninitialized_variables, no_logic_in_create_state

import 'package:app_pilates/Controle/AlunosController.dart';
import 'package:app_pilates/Controle/Classes.dart';
import 'package:app_pilates/Controle/Controller.dart';
import 'package:flutter/material.dart';
import 'package:app_pilates/Componentes/GlassContainer.dart';

class AgendamentoScreen extends StatefulWidget {
  var EnviarParaNovoAgendamento;
  var EnviarParaSobre;

  AgendamentoScreen({
    super.key,
    required this.EnviarParaNovoAgendamento,
    required this.EnviarParaSobre,
  });

  @override
  AgendamentoScreenState createState() => AgendamentoScreenState(
        EnviarParaNovoAgendamento: EnviarParaNovoAgendamento,
        EnviarParaSobre: EnviarParaSobre,
      );
}

String VendoDiaSemana = "SEGUNDA-FEIRA";

class AgendamentoScreenState extends State<AgendamentoScreen> {
  var EnviarParaNovoAgendamento;
  var EnviarParaSobre;
  AgendamentoScreenState({
    required this.EnviarParaNovoAgendamento,
    required this.EnviarParaSobre,
  });

  double ArrumarHeight() {
    var HorasWork = Controller().ObterConfiguracoes().HorasTrabalhadas.length;
    if (HorasWork <= 4) {
      return 150;
    }
    if (HorasWork <= 8) {
      return 150 * 2;
    }
    if (HorasWork <= 12) {
      return 150 * 3;
    }
    if (HorasWork <= 15) {
      return 150 * 4;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    EnviarParaInicio() => {Navigator.pushNamed(context, "/WeekScreen")};

    var WindowWidth = MediaQuery.of(context).size.width;
    var WindowHeight = MediaQuery.of(context).size.height;
    return GlassContainer(
      Cor: Color.fromRGBO(255, 255, 255, 1),
      Width: WindowWidth > 601
          ? (WindowWidth * .2) >= 200
              ? (WindowWidth * .8) - 30
              : (WindowWidth - 230)
          : WindowWidth - 20,
      Height: WindowHeight - (WindowWidth > 601 ? 0 : 55),
      Child: Column(
        children: [
          Center(
            child: Text(
              "ALUNOS",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          TextButton(
            onPressed: () => {EnviarParaNovoAgendamento()},
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
            ),
            child: GlassContainer(
              Cor: Color.fromRGBO(255, 255, 255, 1),
              Width: 0,
              Height: 40,
              Child: Center(
                child: Text(
                  "NOVO ALUNO",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ),
          Expanded(
              child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 85, crossAxisCount: 3),
            padding: EdgeInsets.only(right: 10),
            children: AlunosController()
                .ObterAlunos()
                .map((e) => Card(WindowWidth, e, EnviarParaSobre))
                .toList(),
          ))
        ],
      ),
    );
  }
}

Widget Card(WindowWidth, Aluno Data, EnviarParaSobre) {
  return TextButton(
      style: ButtonStyle(
          overlayColor: MaterialStatePropertyAll(Colors.transparent)),
      onPressed: () => {EnviarParaSobre(Data)},
      child: GlassContainer(
          Width: 300,
          Height: 64,
          Padding: EdgeInsets.all(10),
          Cor: Colors.white,
          Child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Data.GetUltimoPagamentoFormatoYMD(),
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  Text(
                    Controller().Gerar_Siglas_Do_Aluno(Data.Id),
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  )
                ],
              ),
              Text(
                Data.GetNome().toUpperCase(),
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            ],
          )));
}
