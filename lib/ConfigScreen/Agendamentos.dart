// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names, unused_import, unused_element, unused_local_variable

import 'package:flutter/material.dart';
import 'package:app_pilates/Componentes/GlassContainer.dart';

class AgendamentoScreen extends StatefulWidget {
  const AgendamentoScreen({super.key});

  @override
  AgendamentoScreenState createState() => AgendamentoScreenState();
}

class AgendamentoScreenState extends State<AgendamentoScreen> {
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
        Child: Text("AGENDAMENTOS"));
  }
}
