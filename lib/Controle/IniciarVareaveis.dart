// ignore_for_file: non_constant_identifier_names, file_names

import 'package:app_pilates/Controle/Classes.dart';
import 'package:app_pilates/Controle/Controller.dart';

List<String> diasSemana = [
  "SEGUNDA-FEIRA",
  "TERÇA-FEIRA",
  "QUARTA-FEIRA",
  "QUINTA-FEIRA",
  "SEXTA-FEIRA",
];

IniciarPrograma() {
  for (var Data in diasSemana) {
    List<Horario> Horarios = [];
    for (var Hora in Controller().ObterConfiguracoes().HorasTrabalhadas) {
      Horarios.add(
          Horario(Hora: Hora < 9 ? '0$Hora:00' : '$Hora:00', IdAlunos: []));
    }
    Controller().Adicionar_Dia_Da_Semana(Data, Horarios);
  }
}
