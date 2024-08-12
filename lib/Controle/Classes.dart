// ignore_for_file: file_names, non_constant_identifier_names, camel_case_types

class DiaSemana {
  String Nome;
  List<Horario> Horarios;

  DiaSemana({
    required this.Nome,
    required this.Horarios,
  });

  String GetNome() {
    return Nome;
  }
}

class Horario {
  String Hora;
  List<Aluno> Alunos;

  Horario({
    required this.Hora,
    required this.Alunos,
  });

  String ObterPessoas() {
    List<String> nomesList = Alunos.map((aluno) => aluno.Nome).toList();

    String nomes = nomesList.join(" | ");

    return nomes;
  }

  AdicionarPessoa() {}
}

class Aluno {
  String Nome;
  bool Presenca;

  Aluno({
    required this.Nome,
    required this.Presenca,
  });

  SetPresenca(bool Valor) {
    Presenca = Valor;
  }
}

class DataEnvio_Week_Horario {
  String DiaDaSemana;
  String HorarioSelecionado;

  DataEnvio_Week_Horario({
    required this.DiaDaSemana,
    required this.HorarioSelecionado,
  });
}

class Configuracoes {
  List<int> HorasTrabalhadas = [6, 7, 8, 9, 10, 11, 15, 16, 17, 18, 19, 20];
  int LimiteAulasPorHorario = 4;
}
