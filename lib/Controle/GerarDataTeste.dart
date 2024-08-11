// ignore_for_file: file_names, non_constant_identifier_names, use_function_type_syntax_for_parameters, avoid_function_literals_in_foreach_calls, avoid_print
import 'dart:math';
import 'package:app_pilates/Controle/Controller.dart';

import 'Classes.dart';

List<DiaSemana> gerarDadosTeste() {
  final List<String> diasSemana = [
    "SEGUNDA-FEIRA",
    "TERÇA-FEIRA",
    "QUARTA-FEIRA",
    "QUINTA-FEIRA",
    "SEXTA-FEIRA",
  ];

  final List<String> horariosFixos = [
    "06:00",
    "07:00",
    "08:00",
    "09:00",
    "10:00",
    "11:00",
    "12:00",
    "13:00"
  ];

  final List<String> nomesAlunos = [
    "Ana",
    "Carlos",
    "João",
    "Maria",
    "Pedro",
    "Lucas",
    "Fernanda",
    "Laura"
  ];

  Random random = Random();

  List<DiaSemana> dias = [];

  for (var dia in diasSemana) {
    List<Horario> horarios = [];
    for (var hora in horariosFixos) {
      List<Aluno> alunos = [];
      for (int j = 0; j < 4; j++) {
        String nome = nomesAlunos[random.nextInt(nomesAlunos.length)];
        alunos.add(Aluno(Nome: nome, Presenca: false));
      }
      horarios.add(Horario(Hora: hora, Alunos: alunos));
    }
    Controller().Adicionar_Dia_Da_Semana(dia, horarios);
    dias.add(DiaSemana(Nome: dia, Horarios: horarios));
  }

  return dias;
}
