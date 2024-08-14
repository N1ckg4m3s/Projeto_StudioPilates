// ignore_for_file: file_names, non_constant_identifier_names, use_function_type_syntax_for_parameters, avoid_function_literals_in_foreach_calls, avoid_print, unused_local_variable
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

gerarDadosTeste() {
  int NumeroDeAlunos = 50;
  Random random = Random();

  for (var nrmAluno = 0; nrmAluno < NumeroDeAlunos; nrmAluno++) {
    String NomeAluno =
        '${Nomes[random.nextInt(Nomes.length)]} ${Sobrenomes[random.nextInt(Sobrenomes.length)]}';

    Aluno NovoAluno =
        AlunosController().AdicionarAluno(Aluno(Id: -1, Nome: NomeAluno));

    String DiaDaSemanaRandom;
    List<Hora> HorariosSelecionados = [];
    List<DiaSemana> DiasDaSemana = Controller().Obter_Dias_Da_Semana();

    while (HorariosSelecionados.length < 2) {
      DiaDaSemanaRandom = diasSemana[random.nextInt(diasSemana.length)];

      List<Horario> Horarios =
          DiasDaSemana[random.nextInt(DiasDaSemana.length)].Horarios;

      var Escolha = Horarios[random.nextInt(Horarios.length)];

      if (Escolha.IdAlunos.length <
              ConfiguracoesBasicas!.LimiteAulasPorHorario &&
          !Escolha.IdAlunos.contains(NovoAluno.Id)) {
        HorariosSelecionados.add(
          Hora(
              Horario: Escolha.Hora,
              Presenca: random.nextInt(100) < 50,
              DiaSemana: DiaDaSemanaRandom),
        );

        Controller()
            .Obter_Dia_porString(DiaDaSemanaRandom)
            .Horarios
            .firstWhere((e) => e.Hora == Escolha.Hora)
            .AdicionarPessoa(NovoAluno.Id);
      }
      NovoAluno.SetPresencaSemana(HorariosSelecionados);
      NovoAluno.SetAnotacoes("Sem anotações");
      int year = DateTime.now().year;
      int month = DateTime.now().month;
      NovoAluno.SetUltimoPagamento(
          DateTime(year, month, random.nextInt(29) + 1));
      NovoAluno.SetModeloNegocios('1');
    }
  }
}
