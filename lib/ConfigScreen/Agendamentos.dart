// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names, unused_import, unused_element, unused_local_variable, prefer_const_literals_to_create_immutables, must_be_immutable, prefer_typing_uninitialized_variables, no_logic_in_create_state

import 'package:app_pilates/Controle/Controller.dart';
import 'package:flutter/material.dart';
import 'package:app_pilates/Componentes/GlassContainer.dart';

class AgendamentoScreen extends StatefulWidget {
  var EnviarParaNovoAgendamento;

  AgendamentoScreen({super.key, required this.EnviarParaNovoAgendamento});

  @override
  AgendamentoScreenState createState() => AgendamentoScreenState(
      EnviarParaNovoAgendamento: EnviarParaNovoAgendamento);
}

String VendoDiaSemana = "";

class AgendamentoScreenState extends State<AgendamentoScreen> {
  var EnviarParaNovoAgendamento;
  AgendamentoScreenState({required this.EnviarParaNovoAgendamento});

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
              "AGENDAMENTOS",
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
                      "NOVO AGENDAMENTO",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ))),
          Expanded(
            child: ListView(
              children: Controller()
                  .Obter_Dias_Da_Semana()
                  .map(
                    (d) => TextButton(
                      onPressed: () => {
                        setState(() {
                          VendoDiaSemana =
                              VendoDiaSemana == d.Nome ? "" : d.Nome;
                        })
                      },
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: GlassContainer(
                        Cor: Color.fromRGBO(255, 255, 255, 1),
                        Width: 0,
                        MaxHeight: ArrumarHeight(),
                        Height: VendoDiaSemana == d.Nome ? 0 : 40,
                        Child: Column(
                          children: [
                            Text(
                              d.Nome,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                            if (VendoDiaSemana == d.Nome)
                              Expanded(
                                child: GridView(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          mainAxisExtent: 130),
                                  children: Controller()
                                      .ObterConfiguracoes()
                                      .HorasTrabalhadas
                                      .map(
                                        (e) => TextButton(
                                          onPressed: () => {},
                                          style: ButtonStyle(
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    Colors.transparent),
                                          ),
                                          child: GlassContainer(
                                            Width: 0,
                                            Height: 0,
                                            Cor: Colors.white,
                                            Child: Column(
                                              children: [
                                                Center(
                                                  child: Text(
                                                    '${e <= 9 ? ('0$e') : e}:00',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                                Column(
                                                  children: Controller()
                                                      .Obter_Alunos_Horarios_e_Dia(
                                                          VendoDiaSemana,
                                                          '${e <= 9 ? ('0$e') : e}:00')
                                                      .Alunos
                                                      .map(
                                                        (e) => Text(
                                                          e.Nome,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15),
                                                        ),
                                                      )
                                                      .toList(),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}

/*


*/