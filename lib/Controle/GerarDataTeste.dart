// ignore_for_file: file_names, non_constant_identifier_names, use_function_type_syntax_for_parameters, avoid_function_literals_in_foreach_calls, avoid_print
import 'dart:math';
import 'package:app_pilates/Controle/AlunosController.dart';
import 'package:app_pilates/Controle/Controller.dart';

import 'Classes.dart';

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
  "13:00",
  "14:00",
  "15:00",
  "16:00",
  "17:00",
  "18:00",
  "19:00",
  "20:00",
  "21:00",
  "22:00"
];
final List<String> Nomes = [
  'Lucas',
  'Ana',
  'Gabriel',
  'Mariana',
  'João',
  'Isabela',
  'Miguel',
  'Sofia',
  'Pedro',
  'Lara'
];
List<String> Sobrenomes = [
  'Silva',
  'Oliveira',
  'Santos',
  'Pereira',
  'Costa',
  'Almeida',
  'Ferreira',
  'Rodrigues',
  'Lima',
  'Gomes'
];

List<DiaSemana> gerarDadosTeste() {
  Random random = Random();

  List<DiaSemana> dias = [];

  for (var dia in diasSemana) {
    List<Horario> horarios = [];
    for (var hora in horariosFixos) {
      List<int> alunos = [];
      int Rand = random.nextInt(10);
      for (int j = 0; j < (Rand >= 4 ? 4 : Rand); j++) {
        String nome =
            '${Nomes[random.nextInt(Nomes.length)]} ${Sobrenomes[random.nextInt(Sobrenomes.length)]}';

        var AlunoRetorno = AlunosController().AdicionarAluno(Aluno(
            Id: -1,
            Nome: nome,
            PresencaSemana: [Hora(Horario: hora, Presenca: false)]));
        alunos.add(AlunoRetorno.Id);
      }
      horarios.add(Horario(Hora: hora, IdAlunos: alunos));
    }
    Controller().Adicionar_Dia_Da_Semana(dia, horarios);
    dias.add(DiaSemana(Nome: dia, Horarios: horarios));
  }

  return dias;
}
