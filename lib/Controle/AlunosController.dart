// ignore_for_file: file_names, non_constant_identifier_names, avoid_print

import 'package:app_pilates/Controle/Classes.dart';

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

  // CONTROLE PAGAMENTO e REMARCAÇÃO

  // DB FUNCTIONS
  SalvarData() {}
  TransformarData() {}
}
