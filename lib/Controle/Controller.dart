// ignore_for_file: file_names, non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, unnecessary_null_comparison, unrelated_type_equality_checks
import 'package:app_pilates/Controle/DataBase.dart';
import 'package:app_pilates/Controle/Classes.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

final List<DiaSemana> Data = [];
Configuracoes? ConfiguracoesBasicas;

Horario HorarioAntErro = Horario(Hora: "", IdAlunos: []);

Map<String, String> Tranfomacao = {
  "SEGUNDA-FEIRA": "SEG",
  "TERÇA-FEIRA": "TER",
  "QUARTA-FEIRA": "QUA",
  "QUINTA-FEIRA": "QUI",
  "SEXTA-FEIRA": "SEX",
  "SABADO-FEIRA": "SAB",
  "DOMINGO-FEIRA": "DOM",
};

class Controller {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> adicionarDiaDaSemana(String nome, List<Horario> horarios) async {
    final db = await _dbHelper.database;

    // Adicionar o dia da semana
    int diaSemanaId = await db.insert('dia_semana', {'nome': nome});

    // Adicionar horários
    for (var horario in horarios) {
      int horarioId = await db.insert('horario', {'hora': horario.Hora});
      await db.insert('hora', {
        'horario_id': horarioId,
        'dia_semana_id': diaSemanaId,
        'presenca': 0, // Presença default como não marcada
      });
    }
  }

  Future<void> removerDosHorarios(Aluno aluno) async {
    final db = await _dbHelper.database;

    var presencas = await db.query(
      'presenca',
      where: 'aluno_id = ?',
      whereArgs: [aluno.Id],
    );

    for (var presenca in presencas) {
      await db.delete(
        'presenca',
        where: 'id = ?',
        whereArgs: [presenca['id']],
      );
    }
  }

  Future<List<DiaSemana>> obterData() async {
    final db = await _dbHelper.database;

    final diaSemanas = await db.query('dia_semana');
    List<DiaSemana> data = [];

    for (var diaSemana in diaSemanas) {
      final horarios = await db.query(
        'hora',
        where: 'dia_semana_id = ?',
        whereArgs: [diaSemana['id']],
      );

      List<Horario> horariosList = [];
      for (var horario in horarios) {
        var horarioDetails = await db.query(
          'horario',
          where: 'id = ?',
          whereArgs: [horario['horario_id']],
        );
        horariosList.add(Horario(
          Hora: "${horarioDetails[0]['hora']}",
          IdAlunos: [], // Popular quando necessário
        ));
      }

      data.add(DiaSemana(
        Nome: "${diaSemana['nome']}",
        Horarios: horariosList,
      ));
    }
    return data;
  }

  Future<List<DiaSemana>> obterDiasDaSemana(int manter) async {
    final db = await _dbHelper.database;
    final diaSemanas = await db.query('dia_semana');
    List<DiaSemana> horariosLivres = [];

    for (var diaSemana in diaSemanas) {
      final horarios = await db.query(
        'hora',
        where: 'dia_semana_id = ?',
        whereArgs: [diaSemana['id']],
      );

      List<Horario> horariosList = [];
      for (var horario in horarios) {
        var horarioDetails = await db.query(
          'horario',
          where: 'id = ?',
          whereArgs: [horario['horario_id']],
        );
        horariosList.add(Horario(
          Hora: "${horarioDetails[0]['hora']}",
          IdAlunos: [], // Popular quando necessário
        ));
      }

      if (horariosList.isNotEmpty) {
        horariosLivres.add(DiaSemana(
          Nome: "${diaSemana['nome']}",
          Horarios: horariosList,
        ));
      }
    }
    return horariosLivres;
  }

  Future<List<Horario>> obterHorariosDia(int diaSemanaId) async {
    final db = await _dbHelper.database;
    final horarios = await db.query(
      'hora',
      where: 'dia_semana_id = ?',
      whereArgs: [diaSemanaId],
    );

    List<Horario> horariosList = [];
    for (var horario in horarios) {
      var horarioDetails = await db.query(
        'horario',
        where: 'id = ?',
        whereArgs: [horario['horario_id']],
      );
      horariosList.add(Horario(
        Hora: "${horarioDetails[0]['hora']}",
        IdAlunos: [], // Popular quando necessário
      ));
    }
    return horariosList;
  }

  // Obtem os alunos que estão no horariro de um determinado dia
  Future<Horario> obterAlunosHorariosEDia(
      String nomeDiaSemana, String hora) async {
    try {
      final db = await _dbHelper.database;

      // Obter o ID do dia da semana
      final diaSemana = await db.query(
        'dia_semana',
        where: 'nome = ?',
        whereArgs: [nomeDiaSemana],
      );

      if (diaSemana.isEmpty) {
        return Horario(Hora: "", IdAlunos: []);
      }

      final diaSemanaId = diaSemana[0]['id'];

      final horarios = await db.query(
        'hora',
        where: 'dia_semana_id = ? AND horario = ?',
        whereArgs: [diaSemanaId, hora],
      );

      if (horarios.isEmpty) {
        return Horario(Hora: hora, IdAlunos: []);
      }

      final horaId = horarios[0]['id'];

      // Obter os alunos associados ao horário
      final alunosIds = await db.rawQuery(
        '''
        SELECT a.id
        FROM aluno AS a
        INNER JOIN presenca AS p ON a.id = p.aluno_id
        WHERE p.hora_id = ? AND p.dia_id = ?
        ''',
        [horaId, diaSemanaId],
      );

      final idsAlunos = alunosIds.map((row) => row['id'] as int).toList();
      return Horario(
        Hora: hora,
        IdAlunos: idsAlunos,
      );
    } catch (e) {
      debugPrint('CATCH AO "obterAlunosHorariosEDia" $e');
      return Horario(Hora: "", IdAlunos: []);
    }
  }

  // Obtem o dia da semana apenas pelo nome
  Future<DiaSemana> obterDiaPorString(String nomeDiaSemana) async {
    try {
      final db = await _dbHelper.database;

      // 1. Obter o ID do dia da semana
      final diaSemanaResult = await db.query(
        'dia_semana',
        where: 'nome = ?',
        whereArgs: [nomeDiaSemana],
      );

      if (diaSemanaResult.isEmpty) {
        return DiaSemana(Nome: nomeDiaSemana, Horarios: []);
      }

      int diaSemanaId = diaSemanaResult.first['id'] as int;

      // 2. Obter horários associados a esse dia da semana
      final horariosResult = await db.query(
        'hora',
        where: 'dia_semana_id = ?',
        whereArgs: [diaSemanaId],
      );

      List<Horario> horariosList = [];

      for (var horario in horariosResult) {
        int horarioId = horario['id'] as int;

        // 3. Obter os alunos associados a cada horário
        final presencaResult = await db.query(
          'presenca',
          where: 'hora_id = ? AND dia_id = ?',
          whereArgs: [horarioId, diaSemanaId],
        );

        List<int> alunoIds =
            presencaResult.map<int>((e) => e['aluno_id'] as int).toList();

        List<int> alunosList = [];
        for (var alunoId in alunoIds) {
          final alunoResult = await db.query(
            'aluno',
            where: 'id = ?',
            whereArgs: [alunoId],
          );

          if (alunoResult.isNotEmpty) {
            alunosList.add(Aluno.fromMap(alunoResult.first).Id);
          }
        }

        horariosList.add(Horario(
          Hora: horario['horario'] as String,
          IdAlunos: alunosList,
        ));
      }
      return DiaSemana(
        Nome: nomeDiaSemana,
        Horarios: horariosList,
      );
    } catch (e) {
      debugPrint("Erro ao obter o dia da semana: $e");
      return DiaSemana(
        Nome: "ERROR",
        Horarios: [],
      );
    }
  }

  // Define as configurações padrões
  Future<void> definirConfiguracoes(Configuracoes config) async {
    final db = await _dbHelper.database;
    await db.insert(
        'configuracoes',
        {
          'horas_trabalhadas': config.HorasTrabalhadas.join(','),
          'limite_aulas_por_horario': config.LimiteAulasPorHorario,
          'dia_de_hoje': config.DiaDeHoje.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Obtem as configurações padrões
  Future<Configuracoes> obterConfiguracoes() async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> config = await db.query('configuracoes');

      if (config.isEmpty) {
        return Configuracoes(
          HorasTrabalhadas: [],
          LimiteAulasPorHorario: 0,
          DiaDeHoje: DateTime.now(),
        );
      }

      return Configuracoes(
        HorasTrabalhadas: (config[0]['horas_trabalhadas'] as String)
            .split(',')
            .map(int.parse)
            .toList(),
        LimiteAulasPorHorario:
            int.parse("${config[0]['limite_aulas_por_horario']}"),
        DiaDeHoje: DateTime.parse("${config[0]['dia_de_hoje']}"),
      );
    } catch (e) {
      debugPrint("Deu catch $e");
      return Configuracoes(
        HorasTrabalhadas: [],
        LimiteAulasPorHorario: 0,
        DiaDeHoje: DateTime.now(),
      );
    }
  }

  Future<String> gerarSiglasDoAluno(int id) async {
    final db = await _dbHelper.database;

    // Consultar todas as presenças do aluno
    final presencas = await db.rawQuery('''
      SELECT h.id AS hora_id, h.dia_semana_id, ds.nome AS dia_semana
      FROM presenca p
      INNER JOIN hora h ON p.hora_id = h.id
      INNER JOIN dia_semana ds ON h.dia_semana_id = ds.id
      WHERE p.aluno_id = ?
    ''', [id]);

    List<String> siglas = [];

    for (var presenca in presencas) {
      String nomeDiaSemana = '${presenca['dia_semana']}';
      if (Tranfomacao.containsKey(nomeDiaSemana)) {
        siglas.add(Tranfomacao[nomeDiaSemana]!);
      }
    }

    return siglas.join(' | ');
  }

  Future<int> obterIdDiaPorString(String nome) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(
        'dia_semana',
        where: 'nome = ?',
        whereArgs: [nome],
      );

      if (result.isEmpty) {
        return -1; // Indica que o dia da semana não foi encontrado
      }

      return result.first['id'] as int; // Obter o valor do ID do mapa
    } catch (e) {
      debugPrint("Erro ao obter ID do dia da semana: $e");
      return -1; // Indica que ocorreu um erro
    }
  }

  Future<int> obterIdHoraPorString(String nome) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(
        'hora',
        where: 'horario = ?',
        whereArgs: [nome],
      );

      if (result.isEmpty) {
        return -1; // Indica que o dia da semana não foi encontrado
      }

      return result.first['id'] as int; // Obter o valor do ID do mapa
    } catch (e) {
      debugPrint("Erro ao obter ID da hora: $e");
      return -1; // Indica que ocorreu um erro
    }
  }

  Future<List<int>> obterAlunosDaHora(int idHora, int idDia) async {
    try {
      final db = await _dbHelper.database;

      // Consulta a tabela 'presenca' para encontrar todos os alunos associados ao idHora fornecido
      final result = await db.query(
        'presenca',
        where: 'hora_id = ? AND dia_id = ?',
        whereArgs: [idHora, idDia],
      );

      // Extraí os IDs dos alunos da consulta
      final List<int> alunoIds =
          result.map((map) => map['aluno_id'] as int).toList();

      return alunoIds;
    } catch (e) {
      debugPrint("Erro ao obter alunos da hora: $e");
      return []; // Retorna uma lista vazia em caso de erro
    }
  }
}
