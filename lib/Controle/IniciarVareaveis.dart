// ignore_for_file: non_constant_identifier_names, file_names

import 'package:app_pilates/Controle/Classes.dart';
import 'package:app_pilates/Controle/Controller.dart';

List<String> diasSemana = [
  "SEGUNDA-FEIRA",
  "TERÇA-FEIRA",
  "QUARTA-FEIRA",
  "QUINTA-FEIRA",
  "SEXTA-FEIRA",
  "SÁBADO-FEIRA",
  "DOMINGO-FEIRA"
];

Future<void> IniciarPrograma() async {
  Configuracoes configuracoes = Configuracoes(
    DiaDeHoje: DateTime.now(),
    HorasTrabalhadas: [6, 7, 8, 9, 10, 11, 15, 16, 17, 18, 19, 20],
    LimiteAulasPorHorario: 4,
  );
  Controller().definirConfiguracoes(configuracoes);
}
