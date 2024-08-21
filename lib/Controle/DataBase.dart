// ignore_for_file: file_names, depend_on_referenced_packages, avoid_print, unnecessary_brace_in_string_interps

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'app_pilates.db');
      // deleteDatabase(path);
      return await openDatabase(path,
          onCreate: (db, version) async {
            // Criação das tabelas
            await db.execute('''
              CREATE TABLE dia_semana (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                nome TEXT NOT NULL
              );
            ''');

            await db.execute('''
              CREATE TABLE hora (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                horario TEXT NOT NULL,
                dia_semana_id INTEGER,
                FOREIGN KEY (dia_semana_id) REFERENCES dia_semana(id)
              );
            ''');

            await db.execute('''
              CREATE TABLE aluno (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                nome TEXT NOT NULL,
                anotacoes TEXT,
                ultimo_pagamento TEXT,
                parcelado INTEGER, -- Usar 0 para falso e 1 para verdadeiro
                modelo_negocios TEXT
              );
            ''');

            await db.execute('''
              CREATE TABLE presenca (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                aluno_id INTEGER,
                hora_id INTEGER,
                dia_id INTEGER,
                presenca INTEGER, -- Adicionado para armazenar se o aluno está presente ou não
                FOREIGN KEY (aluno_id) REFERENCES aluno(id),
                FOREIGN KEY (hora_id) REFERENCES hora(id)
              );
            ''');

            await db.execute('''
              CREATE TABLE configuracoes (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                horas_trabalhadas TEXT,
                limite_aulas_por_horario INTEGER,
                dia_de_hoje TEXT
              );
            ''');

            List<String> diasSemana = [
              "SEGUNDA-FEIRA",
              "TERÇA-FEIRA",
              "QUARTA-FEIRA",
              "QUINTA-FEIRA",
              "SEXTA-FEIRA",
              "SÁBADO",
              "DOMINGO"
            ];

            for (var dia in diasSemana) {
              await db.insert(
                'dia_semana',
                {'nome': dia},
              );
            }
          },
          version: 9,
          onUpgrade: (Database db, int oldVersion, int newVersion) async {
            if (oldVersion < 9) {
              await db.execute('''
              ALTER TABLE hora ADD COLUMN presenca BOOLEAN;
            ''');
            }
          });
    } catch (e) {
      debugPrint('Erro ao inicializar o banco de dados: $e');
      rethrow;
    }
  }
}
