// ignore_for_file: file_names, non_constant_identifier_names

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
