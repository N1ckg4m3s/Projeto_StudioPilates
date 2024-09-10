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
  Configuracoes configuracoes = await Controller().obterConfiguracoes();
  Controller().definirConfiguracoes(configuracoes);
}
