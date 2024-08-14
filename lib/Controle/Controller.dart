// ignore_for_file: file_names, non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings, unnecessary_null_comparison
import 'Classes.dart';

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
  //Essa função é para adicionar um horario a um dia da semana
  Adicionar_Pessoa_No_Horario(Horario Hora, Aluno Pessoa) {}

  //Essa função é para adicionar um horario a um dia da semana
  Adicionar_Dia_Da_Semana(String Nome, List<Horario> Hora) {
    DiaSemana NewData = DiaSemana(Nome: Nome, Horarios: Hora);
    Data.add(NewData);
    return NewData;
  }

  //Essa função é para adicionar um horario a um dia da semana
  Adicionar_Horario_No_Dia(DiaSemana DiaSemana, String Hora) {
    DiaSemana.Horarios.add(Horario(Hora: Hora, IdAlunos: []));
  }

  //Essa função é para obter todas os horarios e as pessoas do dia da semana determinado
  List<DiaSemana> Obter_Horarios_Livres() {
    return Data;
  }

  //Essa função é para obter todas os dias da semana determinado
  List<DiaSemana> Obter_Dias_Da_Semana() {
    List<DiaSemana> horariosLivres = [];

    for (var diaSemana in Data) {
      var diaSemanaLivre = DiaSemana(
        Nome: diaSemana.Nome,
        Horarios: [],
      );

      for (var horario in diaSemana.Horarios) {
        if (horario.IdAlunos.length <
            ConfiguracoesBasicas!.LimiteAulasPorHorario) {
          diaSemanaLivre.Horarios.add(horario);
        }
      }

      if (diaSemanaLivre.Horarios.isNotEmpty) {
        horariosLivres.add(diaSemanaLivre);
      }
    }

    return horariosLivres;
  }

  //Essa função é para obter todas os horarios e as pessoas do dia da semana determinado
  List<Horario> Obter_Horarios_Dia(DiaSemana? DiaSemana) {
    return DiaSemana!.Horarios;
  }

  Horario Obter_Alunos_Horarios_e_Dia(String DiaSemana, String Horario) {
    var Dia = Obter_Dia_porString(DiaSemana);
    try {
      return Dia.Horarios.firstWhere((element) => element.Hora == Horario);
    } catch (e) {
      return HorarioAntErro;
    }
  }

  //Essa função é para obtem o dia baseado no nome
  DiaSemana Obter_Dia_porString(String nomeDiaSemana) {
    DiaSemana diaSemana = Data.firstWhere(
      (dia) => dia.Nome == nomeDiaSemana,
      orElse: () => DiaSemana(Horarios: [], Nome: nomeDiaSemana),
    );
    return diaSemana;
  }

  DefinirConfiguracoes(Configuracoes Config) {
    ConfiguracoesBasicas = Config;
  }

  Configuracoes ObterConfiguracoes() {
    return ConfiguracoesBasicas!;
  }

  String Gerar_Siglas_Do_Aluno(int Id) {
    List<String> siglas = [];
    for (var dia in Data) {
      for (var hora in dia.Horarios) {
        if (hora.IdAlunos.contains(Id)) {
          siglas.add(Tranfomacao[dia.Nome]!);
          break;
        }
      }
    }
    return siglas.join(' | ');
  }
}
