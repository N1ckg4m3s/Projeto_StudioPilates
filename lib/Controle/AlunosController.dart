// ignore_for_file: file_names, non_constant_identifier_names, avoid_print

import 'package:app_pilates/Controle/Classes.dart';

Map<String, String> Tranfomacao = {
  "SEGUNDA-FEIRA": "SEG",
  "TERÇA-FEIRA": "TER",
  "QUARTA-FEIRA": "QUA",
  "QUINTA-FEIRA": "QUI",
  "SEXTA-FEIRA": "SEX",
  "SABADO-FEIRA": "SAB",
  "DOMINGO-FEIRA": "DOM",
};
final List<Aluno> ListaAlunos = [];
Aluno VisualizadorDeErro = Aluno(Id: -1, Nome: "-- ==ERRO AQUI ==--");

class AlunosController {
  // SETTERS
  Aluno AdicionarAluno(Aluno NovoValor) {
    if (NovoValor.Id <= 0) {
      NovoValor.Id = ListaAlunos.length + 1;
    }
    ListaAlunos.add(NovoValor);
    return NovoValor;
  }

  // GETTERS
  List<Aluno> ObterAlunos() {
    return ListaAlunos;
  }

  Aluno ObterAlunoPorId(int Id) {
    if (Id == -1) {
      return VisualizadorDeErro;
    }
    return ListaAlunos.firstWhere((element) => element.Id == Id);
  }

  List<Aluno> ObterFaltas() {
    List<Aluno> alunosComFaltas = [];

    for (var aluno in ListaAlunos) {
      bool temFalta = aluno.PresencaSemana!.any((hora) => !hora.Presenca);
      if (temFalta) {
        alunosComFaltas.add(aluno);
      }
    }

    return alunosComFaltas;
  }

  String DominutivoDiaSemanaByFaltas(Aluno ObterSilgas) {
    List<String> siglas = [];

    for (var Presenca in ObterSilgas.PresencaSemana!) {
      if (!Presenca.Presenca) {
        siglas.add(Tranfomacao[Presenca.DiaSemana]!);
      }
    }

    return siglas.join(' | ');
  }

  // CONTROLE PAGAMENTO e REMARCAÇÃO

  // DB FUNCTIONS
  SalvarData() {}
  TransformarData() {}
}
