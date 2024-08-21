// ignore_for_file: file_names, depend_on_referenced_packages, non_constant_identifier_names, collection_methods_unrelated_type

import 'package:app_pilates/Controle/Classes.dart';
import 'package:app_pilates/Controle/Controller.dart';
import 'package:app_pilates/Controle/DataBase.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

class AlunosController {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Adicionar um novo aluno
  Future<Aluno> adicionarAluno(Aluno novoAluno) async {
    try {
      final db = await _dbHelper.database;

      // 1. Adicionar o aluno
      novoAluno.Id = await db.insert(
        'aluno',
        novoAluno.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      if (novoAluno.PresencaSemana != null) {
        for (var hora in novoAluno.PresencaSemana!) {
          var result = await db.query(
            'hora',
            where: 'horario = ? AND dia_semana_id = ?',
            whereArgs: [hora.Horario, hora.DiaSemana],
          );

          int horarioId;

          if (result.isEmpty) {
            // Adicionar o horário se não existir
            horarioId = await db.insert(
              'hora',
              hora.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          } else {
            horarioId = result.first['id'] as int;
          }
          await db.insert(
            'presenca',
            {
              'aluno_id': novoAluno.Id,
              'hora_id': horarioId,
              'dia_id': hora.DiaSemana,
              'presenca': 0,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      }
    } catch (e) {
      debugPrint('Erro ao adicionar aluno: $e');
    }
    return novoAluno;
  }

  // Atualiza os dados do aluno no DB
  Future<void> atualizaAluno(Aluno alunoAtualizado) async {
    final db = await _dbHelper.database;

    try {
      await db.update(
        'aluno',
        alunoAtualizado.toMap(),
        where: 'id = ?',
        whereArgs: [alunoAtualizado.Id],
      );

      await db.delete(
        'presenca',
        where: 'aluno_id = ?',
        whereArgs: [alunoAtualizado.Id],
      );

      for (var hora in alunoAtualizado.PresencaSemana!) {
        final horaId = await db.insert('hora', {
          'horario': hora.Horario,
          'dia_semana_id': hora.DiaSemana,
        });

        await db.insert('presenca', {
          'aluno_id': alunoAtualizado.Id,
          'hora_id': horaId,
        });
      }
    } catch (e) {
      debugPrint("Erro ao atualizar aluno: $e");
    }
  }

  // Obter todos os alunos
  Future<List<Aluno>> obterAlunos() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('aluno');

    return List.generate(maps.length, (i) {
      return Aluno.fromMap(maps[i]);
    });
  }

  // Obter aluno por ID
  Future<Aluno> obterAlunoPorId(int id) async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'aluno',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return Aluno.fromMap(maps.first);
      } else {
        return Aluno(Id: -1, Nome: "-- ==ERRO AQUI ==--"); // Aluno de erro
      }
    } catch (e) {
      return Aluno(Id: -1, Nome: "-- ==ERRO AQUI ==--");
    }
  }

  // Obter faltas
  Future<List<Map<String, dynamic>>> obterFaltas() async {
    try {
      final db = await _dbHelper.database;

      // Consulta para obter as faltas dos alunos
      final result = await db.rawQuery('''
      SELECT aluno.nome, hora.horario, dia_semana.nome AS dia
      FROM presenca
      INNER JOIN aluno ON presenca.aluno_id = aluno.id
      INNER JOIN hora ON presenca.hora_id = hora.id
      INNER JOIN dia_semana ON presenca.dia_id = dia_semana.id
      WHERE presenca.presenca = 0; -- Considerando 0 como ausência
    ''');

      return result;
    } catch (e) {
      debugPrint("Erro ao obterFaltas: $e");
      return [];
    }
  }

  // Remover um aluno
  Future<void> removerAluno(Aluno aluno) async {
    final db = await _dbHelper.database;

    // Remover aluno dos horários
    await Controller().removerDosHorarios(aluno);

    // Remover aluno
    await db.delete(
      'aluno',
      where: 'id = ?',
      whereArgs: [aluno.Id],
    );
  }

  // Obter mensalidades
  Future<List<Aluno>> obterMensalidades(String filtro) async {
    final alunos = await obterAlunos();
    DateTime agora = DateTime.now();
    return alunos.where((Aluno a) {
      int diferencia = -agora.difference(a.GetUltimoPagamento()).inDays;

      if (filtro == "VENCIDAS") {
        return diferencia < 0;
      } else if (filtro == "ATÉ 4 DIAS") {
        return diferencia > 0 && diferencia <= 4;
      } else if (filtro == "1 SEMANA") {
        return diferencia > 4 && diferencia <= 7;
      }
      return true;
    }).toList();
  }

  String DominutivoDiaSemanaByFaltas(Aluno aluno) {
    List<String> siglas = [];

    if (aluno.PresencaSemana != null) {
      for (var presenca in aluno.PresencaSemana!) {
        if (!presenca.Presenca) {
          siglas.add(Tranfomacao[presenca.DiaSemana]!);
        }
      }
    }

    return siglas.join(' | ');
  }

  void DefinirPresencaAluno(int idAluno, String dia, int idHora) async {
    try {
      if (idAluno == -1) throw ("idAluno esta negativo");
      if (idHora == -1) throw ("idHora esta negativo");
      // 1. Obter o ID do dia a partir do nome do dia
      int idDia = await Controller().obterIdDiaPorString(dia);

      // 2. Verificar a presença atual do aluno para o dia e horário especificados
      final db = await _dbHelper.database;
      final presencaResult = await db.query(
        'presenca',
        where: 'aluno_id = ? AND hora_id = ? AND dia_id = ?',
        whereArgs: [idAluno, idHora, idDia],
      );

      bool novaPresenca;

      if (presencaResult.isEmpty) {
        await db.insert(
          'presenca',
          {
            'aluno_id': idAluno,
            'hora_id': idHora,
            'presenca': 1,
            'dia_id': idDia
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } else {
        // Se houver registro, alternar o valor de presença
        int presencaAtual = presencaResult.first['presenca'] as int;
        novaPresenca = presencaAtual == 0; // Alterna entre true (1) e false (0)

        await db.update(
          'presenca',
          {'presenca': novaPresenca ? 1 : 0},
          where: 'aluno_id = ? AND hora_id = ? AND dia_id = ?',
          whereArgs: [idAluno, idHora, idDia],
        );
      }
    } catch (e) {
      debugPrint("Erro ao definir a presença do aluno: $e");
    }
  }

  Future<bool> ObterPresencaAluno(
      int idAluno, String HoraSelec, String diaSemanaSelecionado) async {
    try {
      final db = await _dbHelper.database;
      int idHora = await Controller().obterIdHoraPorString(HoraSelec);
      int idDia = await Controller().obterIdDiaPorString(diaSemanaSelecionado);

      final result = await db.query(
        'presenca',
        where: 'aluno_id = ? AND hora_id = ? AND dia_id = ?',
        whereArgs: [idAluno, idHora, idDia],
      );

      if (result.isEmpty) {
        return false; // Presença não definida, assume-se ausência
      }

      return result.first['presenca'] == 1;
    } catch (e) {
      debugPrint("Erro ao obter a presença: $e");
      return false; // Em caso de erro, assume-se ausência
    }
  }

  Future<List<Hora>> ObterHorariosAluno(int alunoId) async {
    try {
      final db = await _dbHelper.database;

      // Primeiro, obtenha todos os registros de presença do aluno
      final presencas = await db.query(
        'presenca',
        where: 'aluno_id = ?',
        whereArgs: [alunoId],
      );

      // Extraia os IDs dos horários das presenças
      final horarioIds =
          presencas.map((presenca) => presenca['hora_id'] as int).toSet();

      // Obtenha os detalhes dos horários usando os IDs
      final horarios = await Future.wait(horarioIds.map((id) async {
        final horarioList = await db.query(
          'hora',
          where: 'id = ?',
          whereArgs: [id],
        );

        return horarioList.isNotEmpty
            ? Hora(
                Horario: '${horarioList.first['horario']}',
                DiaSemana: int.parse('${horarioList.first['dia_semana_id']}'),
                Presenca: horarioList.first['presenca'] == 1,
              )
            : null;
      }));

      // Filtre nulos e retorne a lista de horários
      return horarios.whereType<Hora>().toList();
    } catch (e) {
      debugPrint("Erro ao obter horários do aluno: $e");
      return [];
    }
  }
}
