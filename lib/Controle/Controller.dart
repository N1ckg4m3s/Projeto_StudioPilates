// ignore_for_file: file_names, non_constant_identifier_names, avoid_print, prefer_interpolation_to_compose_strings
import 'Classes.dart';

final List<DiaSemana> Data = [];

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
    DiaSemana.Horarios.add(Horario(Hora: Hora, Alunos: []));
  }

  //Essa função é para obter todas os horarios e as pessoas do dia da semana determinado
  Obter_Horarios_Livres() {}

  //Essa função é para obter todas os horarios e as pessoas do dia da semana determinado
  List<Horario> Obter_Horarios_Dia(DiaSemana? DiaSemana) {
    return DiaSemana!.Horarios;
  }

  //Essa função é para obtem o dia baseado no nome
  DiaSemana Obter_Dia_porString(String nomeDiaSemana) {
    DiaSemana diaSemana = Data.firstWhere(
      (dia) => dia.Nome == nomeDiaSemana,
      orElse: () => throw Exception('Dia da semana não encontrado'),
    );
    return diaSemana;
  }
}
