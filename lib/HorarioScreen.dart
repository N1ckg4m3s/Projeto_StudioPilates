// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, avoid_print, constant_identifier_names, unnecessary_brace_in_string_interps, prefer_function_declarations_over_variables, unused_local_variable

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
      Dia = Controller().Obter_Dia_porString(arguments.DiaDaSemana);
      TopicoSelecionado = arguments.HorarioSelecionado;
    } else {
      // Fallback para valores padrão
      Dia = Controller().Obter_Dia_porString('SEGUNDA-FEIRA');
      TopicoSelecionado = Dia!.Horarios.first.Hora;
    }
  }

  @override
  Widget build(BuildContext context) {
    EnviarParaInicio() => {Navigator.pushNamed(context, "/WeekScreen")};

    var WindowWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(55, 46, 46, 1),
      body: Row(
        children: [
          GlassContainer(
              Cor: Color.fromRGBO(255, 255, 255, 1),
              Width: (WindowWidth * .2),
              MinWidth: 200,
              Height: 0,
              Child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.only(right: 10),
                      children: Dia!.Horarios.map((e) {
                        return TextButton(
                            onPressed: () => {
                                  setState(
                                    () {
                                      TopicoSelecionado = e.Hora;
                                    },
                                  )
                                },
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
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
                            ));
                      }).toList(),
                    ),
                  ),
                  TextButton(
                    onPressed: EnviarParaInicio,
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
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
                          style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1)),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          GlassContainer(
            Cor: Color.fromRGBO(255, 255, 255, 1),
            Width: (WindowWidth * .2) >= 200
                ? (WindowWidth * .8) - 30
                : (WindowWidth - 230),
            Height: 0,
            Child: Column(
              children: [
                Text(
                  '${DiaSemanaSelecionado} ${TopicoSelecionado}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.normal),
                ),
                Expanded(
                  child: ListView(
                    children: Dia!.Horarios
                        .firstWhere(
                            (element) => element.Hora == TopicoSelecionado)
                        .Alunos
                        .map(
                      (e) {
                        return TextButton(
                          onPressed: () => {
                            setState(() {
                              e.SetPresenca(!e.Presenca);
                            })
                          },
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                          ),
                          child: GlassContainer(
                            Cor: e.Presenca
                                ? Color.fromRGBO(12, 255, 32, 1)
                                : Color.fromRGBO(255, 255, 255, 1),
                            Rotate: 20,
                            Width: 0,
                            Height: 55,
                            Child: Center(
                              child: Text(
                                e.Nome,
                                style: TextStyle(
                                  color: e.Presenca
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
          )
        ],
      ),
    );
  }
}
