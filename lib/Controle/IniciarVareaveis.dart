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
  Controller().DefinirConfiguracoes(Configuracoes(
      DiaDeHoje: DateTime.now(),
      HorasTrabalhadas: [6, 7, 8, 9, 10, 11, 15, 16, 17, 18, 19, 20],
      LimiteAulasPorHorario: 4));
  for (var Data in diasSemana) {
    List<Horario> Horarios = [];
    for (var Hora in Controller().ObterConfiguracoes().HorasTrabalhadas) {
      Horarios.add(
          Horario(Hora: Hora < 9 ? '0$Hora:00' : '$Hora:00', IdAlunos: []));
    }
    Controller().Adicionar_Dia_Da_Semana(Data, Horarios);
  }
}
