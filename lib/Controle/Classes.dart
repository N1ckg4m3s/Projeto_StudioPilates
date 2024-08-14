// ignore_for_file: file_names, non_constant_identifier_names, camel_case_types, prefer_interpolation_to_compose_strings, avoid_print

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
  String DiaSemana;
  bool Presenca;

  Hora({
    required this.Horario,
    required this.DiaSemana,
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

  SetPresenca(String Horario, String DiaSemana) {
    PresencaSemana!
            .firstWhere((element) =>
                element.DiaSemana == DiaSemana && element.Horario == Horario)
            .Presenca =
        !PresencaSemana!
            .firstWhere((element) =>
                element.DiaSemana == DiaSemana && element.Horario == Horario)
            .Presenca;
  }

  SetPresencaSemana(List<Hora> Esquema) {
    PresencaSemana = Esquema;
  }

  //GETTERS
  String GetNome() {
    return Nome;
  }

  String GetAnotacoes() {
    return Anotacoes!;
  }

  String GetUltimoPagamentoFormatoYMD() {
    int year = UltimoPagamento!.year;
    int mont = UltimoPagamento!.month;
    int day = UltimoPagamento!.day;
    return '${day <= 9 ? '0$day' : day}/${mont <= 9 ? '0$mont' : mont}/$year';
  }

  DateTime GetUltimoPagamento() {
    return UltimoPagamento!;
  }

  String GetModeloNegocios() {
    return ModeloNegocios!;
  }

  bool GetPresenca(String horario, String diaSemana) {
    try {
      Hora horaEncontrada = PresencaSemana!.firstWhere(
        (element) =>
            element.DiaSemana == diaSemana && element.Horario == horario,
      );
      return horaEncontrada.Presenca;
    } catch (e) {
      return false;
    }
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
  List<int> HorasTrabalhadas;
  int LimiteAulasPorHorario;
  DateTime DiaDeHoje;

  Configuracoes({
    required this.HorasTrabalhadas,
    required this.LimiteAulasPorHorario,
    required this.DiaDeHoje,
  });
}
