// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names, unused_import, unused_element, unused_local_variable, prefer_const_literals_to_create_immutables, avoid_print, prefer_typing_uninitialized_variables, must_be_immutable, no_logic_in_create_state

import 'package:app_pilates/Controle/Controller.dart';
import 'package:flutter/material.dart';
import 'package:app_pilates/Componentes/GlassContainer.dart';

class HorarioScreen extends StatefulWidget {
  const HorarioScreen({super.key});

  @override
  HorarioScreenState createState() => HorarioScreenState();
}

class HorarioScreenState extends State<HorarioScreen> {
  @override
  Widget build(BuildContext context) {
    EnviarParaInicio() => {Navigator.pushNamed(context, "/WeekScreen")};

    var WindowWidth = MediaQuery.of(context).size.width;
    var WindowHeight = MediaQuery.of(context).size.height;

    var QuantidadeItens = WindowWidth > 850
        ? 5
        : WindowWidth > 700
            ? 3
            : WindowWidth > 600
                ? 5
                : 4; //

    return GlassContainer(
      Cor: Color.fromRGBO(255, 255, 255, 1),
      Width: WindowWidth > 601
          ? (WindowWidth * .2) >= 200
              ? (WindowWidth * .8) - 30
              : (WindowWidth - 230)
          : WindowWidth - 20,
      Height: WindowHeight - (WindowWidth > 601 ? 0 : 75),
      Child: Column(
        children: [
          Center(
            child: Text(
              "HORARIOS FUNCIONAMENTO",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          Expanded(
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: QuantidadeItens, mainAxisExtent: 75),
              children: List.generate(
                  17,
                  (index) => TextButton(
                        onPressed: () => {
                          setState(() {
                            if (Controller()
                                .ObterConfiguracoes()
                                .HorasTrabalhadas
                                .contains(index + 6)) {
                              Controller()
                                  .ObterConfiguracoes()
                                  .HorasTrabalhadas
                                  .removeAt(Controller()
                                      .ObterConfiguracoes()
                                      .HorasTrabalhadas
                                      .indexOf(index + 6));
                            } else {
                              Controller()
                                  .ObterConfiguracoes()
                                  .HorasTrabalhadas
                                  .add(index + 6);
                            }
                          })
                        },
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: GlassContainer(
                          Width: 0,
                          Height: 0,
                          Cor: !Controller()
                                  .ObterConfiguracoes()
                                  .HorasTrabalhadas
                                  .contains(index + 6)
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(173, 99, 173, 1),
                          Rotate: !Controller()
                                  .ObterConfiguracoes()
                                  .HorasTrabalhadas
                                  .contains(index)
                              ? 50
                              : 20,
                          Child: Center(
                            child: Text(
                              '${(index + 6) <= 9 ? '0${index + 6}' : (index + 6)}:00',
                              style: TextStyle(
                                  color: !Controller()
                                          .ObterConfiguracoes()
                                          .HorasTrabalhadas
                                          .contains(index + 6)
                                      ? Color.fromRGBO(255, 255, 255, 1)
                                      : Color.fromRGBO(173, 99, 173, 1),
                                  fontSize: 25),
                            ),
                          ),
                        ),
                      )),
            ),
          )
        ],
      ),
    );
  }
}
