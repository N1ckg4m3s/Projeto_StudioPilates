// ignore_for_file: non_constant_identifier_names, file_names, unrelated_type_equality_checks, camel_case_types
import 'AlunosController.dart';

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
  int? Parcelado;
  int? ParcelaPaga;
  int? ValorTotal;
  String? ModeloNegocios;
  List<Hora>? PresencaSemana;

  Aluno({
    required this.Id,
    required this.Nome,
    this.Anotacoes,
    this.UltimoPagamento,
    this.ModeloNegocios,
    this.PresencaSemana,
    this.ParcelaPaga,
    this.Parcelado,
    this.ValorTotal,
  });
  //GETTERS
  String GetNome() {
    return Nome;
  }

  String GetUltimoPagamentoFormatoYMD() {
    int year = UltimoPagamento!.year;
    int mont = UltimoPagamento!.month;
    int day = UltimoPagamento!.day;
    return '${day <= 9 ? '0$day' : day}/${mont <= 9 ? '0$mont' : mont}/$year';
  }

  DateTime GetUltimoPagamento() {
    return UltimoPagamento!; //!
    //.add(Duration(days: 30 * int.parse(ModeloNegocios!)));
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': Nome,
      'anotacoes': Anotacoes,
      'ultimo_pagamento': UltimoPagamento?.toIso8601String(),
      'parcelado': Parcelado,
      'parcela_paga': ParcelaPaga ?? 0,
      'valor_total': ValorTotal,
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
        Parcelado: map['parcelado'],
        ModeloNegocios: map['modelo_negocios'],
        ParcelaPaga: map['parcela_paga'],
        ValorTotal: map['valor_total']);
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
