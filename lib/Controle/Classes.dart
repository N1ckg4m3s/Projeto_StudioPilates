// ignore_for_file: file_names, non_constant_identifier_names, camel_case_types

import 'package:app_pilates/Controle/AlunosController.dart';

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
  List<int> IdAlunos;

  Horario({
    required this.Hora,
    required this.IdAlunos,
  });

  String ObterPessoas() {
    List<String> nomesList =
        IdAlunos.map((id) => AlunosController().ObterAlunoPorId(id).GetNome())
            .toList();

    String nomes = nomesList.join(" | ");

    return nomes;
  }

  AdicionarPessoa(int Id) {
    IdAlunos.add(Id);
  }
}

class FormatoDeData {
  String Ano;
  String Mes;
  String Dia;
  FormatoDeData({
    required this.Ano,
    required this.Mes,
    required this.Dia,
  });

  String ParaTexto(bool Humano) {
    if (Humano) {
      return '$Dia / $Mes / $Ano';
    }
    return '$Ano / $Mes / $Dia';
  }
}

class Hora {
  String Horario;
  bool Presenca;

  Hora({
    required this.Horario,
    required this.Presenca,
  });
}

class Aluno {
  int Id;
  String Nome;
  String? Anotacoes;
  DateTime? UltimoPagamento;
  String? ModeloNegocios;
  List<Hora>? PresencaSemana;

  Aluno({
    required this.Id,
    required this.Nome,
    this.Anotacoes,
    this.UltimoPagamento,
    this.ModeloNegocios,
    this.PresencaSemana,
  });

  //SETTERS
  SetNome(String NovoNome) {
    Nome = NovoNome;
  }

  SetAnotacoes(String NovaAnotacao) {
    Anotacoes = NovaAnotacao;
  }

  SetUltimoPagamento(DateTime DataPagamento) {
    UltimoPagamento = DataPagamento;
  }

  SetModeloNegocios(String NovoModeloNegocios) {
    ModeloNegocios = NovoModeloNegocios;
  }

  SetPresenca(String Horario) {
    PresencaSemana!
            .firstWhere((element) => element.Horario == Horario)
            .Presenca =
        !PresencaSemana!
            .firstWhere((element) => element.Horario == Horario)
            .Presenca;
  }

  //GETTERS
  String GetNome() {
    return Nome;
  }

  String GetAnotacoes() {
    return Anotacoes!;
  }

  DateTime GetUltimoPagamento() {
    return UltimoPagamento!;
  }

  String GetModeloNegocios() {
    return ModeloNegocios!;
  }

  bool GetPresenca(String Horario) {
    return PresencaSemana!
        .firstWhere((element) => element.Horario == Horario)
        .Presenca;
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
