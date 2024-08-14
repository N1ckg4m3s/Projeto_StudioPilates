// ignore_for_file: file_names, non_constant_identifier_names, avoid_print, prefer_const_constructors, unnecessary_null_comparison

import 'package:app_pilates/Controle/Classes.dart';
import 'package:app_pilates/Controle/Controller.dart';

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
    try {
      return ListaAlunos.firstWhere((element) => element.Id == Id);
    } catch (e) {
      return VisualizadorDeErro;
    }
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

  void RemoverAluno(Aluno Data) {
    Controller().RemoverDosHorarios(Data);
    ListaAlunos.removeWhere((element) => element.Id == Data.Id);
  }

  // CONTROLE PAGAMENTO e REMARCAÇÃO
  List<Aluno> ObterMensalidades(String Filtro) {
    DateTime agora = DateTime.now();
    return ListaAlunos.where((Aluno A) {
      int Diference = -agora.difference(A.GetUltimoPagamento()).inDays;

      if (Filtro == "VENCIDAS") {
        return Diference < 0;
      } else if (Filtro == "ATÉ 4 DIAS") {
        return Diference > 0 && Diference <= 4;
      } else if (Filtro == "1 SEMANA") {
        return Diference > 4 && Diference <= 7;
      }
      return true;
    }).toList();
  }

  // DB FUNCTIONS
  SalvarData() {}
  TransformarData() {}
}
