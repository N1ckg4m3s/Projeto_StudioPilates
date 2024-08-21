// ignore_for_file: file_names, non_constant_identifier_names, camel_case_types, prefer_interpolation_to_compose_strings, avoid_print, unrelated_type_equality_checks

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

  Future<String> ObterPessoas() async {
    List<Future<String>> nomeFutures = IdAlunos.map((id) async {
      Aluno aluno = await AlunosController().obterAlunoPorId(id);
      return aluno.GetNome();
    }).toList();
    List<String> nomesList = await Future.wait(nomeFutures);
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
  int DiaSemana;
  bool Presenca;

  Hora({
    required this.Horario,
    required this.DiaSemana,
    required this.Presenca,
  });

  Map<String, dynamic> toMap() {
    return {
      'horario': Horario,
      'dia_semana_id': DiaSemana,
    };
  }
}

class Aluno {
  int Id;
  String Nome;
  String? Anotacoes;
  DateTime? UltimoPagamento;
  bool? Parcelado;
  String? ModeloNegocios;
  List<Hora>? PresencaSemana;

  Aluno({
    required this.Id,
    required this.Nome,
    this.Anotacoes,
    this.UltimoPagamento,
    this.ModeloNegocios,
    this.PresencaSemana,
    this.Parcelado,
  });

  //SETTERS
  SetNome(String NovoNome) {
    Nome = NovoNome;
  }

  SetAnotacoes(String NovaAnotacao) {
    Anotacoes = NovaAnotacao;
  }

  SetUltimoPagamento(DateTime DataPagamento, int Modelo, bool Parcelado) {
    UltimoPagamento = DataPagamento;
    ModeloNegocios = '$Modelo';
    Parcelado = Parcelado;
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
    return UltimoPagamento!
        .add(Duration(days: 30 * int.parse(ModeloNegocios!)));
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

  Map<String, dynamic> toMap() {
    return {
      'nome': Nome,
      'anotacoes': Anotacoes,
      'ultimo_pagamento': UltimoPagamento?.toIso8601String(),
      'parcelado': Parcelado == true ? 1 : 0,
      'modelo_negocios': ModeloNegocios,
    };
  }

  // Criar um objeto Aluno a partir de um mapa (para leitura do banco de dados)
  factory Aluno.fromMap(Map<String, dynamic> map) {
    return Aluno(
      Id: map['id'],
      Nome: map['nome'],
      Anotacoes: map['anotacoes'],
      UltimoPagamento: DateTime.parse(map['ultimo_pagamento']),
      Parcelado: map['parcelado'] == 1,
      ModeloNegocios: map['modelo_negocios'],
      // PresencaSemana pode ser populada separadamente, se necessário
    );
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
