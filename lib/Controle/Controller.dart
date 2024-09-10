// ignore_for_file: non_constant_identifier_names, file_names

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

  void removerDosHorarios(Aluno aluno) async {
    try {
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
    } catch (e) {
      debugPrint("Catch on 'removerDosHorarios' Error: $e");
    }
  }

  Future<List<DiaSemana>> obterData() async {
    try {
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
    } catch (e) {
      return throw ("Catch on 'obterData' Error: $e");
    }
  }

  Future<List<Horario>> obterHorariosDia(int diaSemanaId) async {
    try {
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
    } catch (e) {
      return throw ("Catch on 'obterHorariosDia' Error: $e");
    }
  }

  Future<String> ObterDiaDaSemanaPorId(int Id) async {
    final db = await _dbHelper.database;
    try {
      final diaSemanaResult = await db.query(
        'dia_semana',
        where: 'id = ?',
        whereArgs: [Id],
      );
      return '${diaSemanaResult.first['nome']}';
    } catch (e) {
      return throw ("Catch on 'ObterDiaDaSemanaPorId' Error: $e");
    }
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
      return throw ("Catch on 'obterAlunosHorariosEDia' Error: $e");
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
      return throw ("Catch on 'obterDiaPorString' Error: $e");
    }
  }

  // Define as configurações padrões
  void definirConfiguracoes(Configuracoes config) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
          'configuracoes',
          {
            'horas_trabalhadas': config.HorasTrabalhadas.join(','),
            'limite_aulas_por_horario': config.LimiteAulasPorHorario,
            'dia_de_hoje': config.DiaDeHoje.toIso8601String(),
          },
          where: "id = ?",
          whereArgs: [1],
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      debugPrint("Catch on 'definirConfiguracoes' Error: $e");
    }
  }

  // Obtem as configurações padrões
  Future<Configuracoes> obterConfiguracoes() async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> config =
          await db.query('configuracoes', where: "id = ?", whereArgs: [1]);
      if (config.isEmpty) {
        return Configuracoes(
          HorasTrabalhadas: [],
          LimiteAulasPorHorario: 4,
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
      return throw ("Catch on 'obterConfiguracoes' Error: $e");
    }
  }

  Future<String> gerarSiglasDoAluno(int id) async {
    try {
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
    } catch (e) {
      return throw ("Catch on 'gerarSiglasDoAluno' Error: $e");
    }
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
      return throw ("Catch on 'obterIdDiaPorString' Error: $e");
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
      return throw ("Catch on 'obterIdHoraPorString' Error: $e");
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
      return throw ("Catch on 'obterAlunosDaHora' Error: $e");
    }
  }

  void TODOS_OS_QUERY() async {
    final db = await _dbHelper.database;
    try {
      final QueryPresenca = await db.query('presenca');
      final QueryDia_semana = await db.query('dia_semana');
      final QueryHora = await db.query('hora');
      // final QueryHorario = await db.query('horario');
      final QueryAluno = await db.query('aluno');

      debugPrint(
          "Resultado QueryPresenca= ${QueryPresenca.toString()}"); // Verificar pois tem data -1 || null
      debugPrint("=============================");
      debugPrint(
          "Resultado QueryDia_semana= ${QueryDia_semana.toString()}"); // Tudo certo
      debugPrint("=============================");
      debugPrint(
          "Resultado QueryHora= ${QueryHora.toString()}"); // Verificar Dados repetidos com ID diferente.
      debugPrint("=============================");
      // debugPrint("Resultado QueryHorario= ${QueryHorario.toString()}");
      // debugPrint("=============================");
      debugPrint("Resultado QueryAluno= ${QueryAluno.toString()}"); // OK
      debugPrint("=============================");
    } catch (e) {
      debugPrint("Deu CATCH TODOS_OS_QUERY $e");
    }
  }
}
