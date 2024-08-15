// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names, unused_import, unused_element, unused_local_variable, prefer_const_literals_to_create_immutables, prefer_function_declarations_over_variables, avoid_print, unrelated_type_equality_checks, unnecessary_null_comparison, empty_catches, prefer_typing_uninitialized_variables, no_logic_in_create_state, must_be_immutable
import 'package:app_pilates/Controle/AlunosController.dart';
import 'package:app_pilates/Controle/Classes.dart';
import 'package:app_pilates/Controle/Controller.dart';
import 'package:flutter/material.dart';
import 'package:app_pilates/Componentes/GlassContainer.dart';

class NovoAgendamentoScreen extends StatefulWidget {
  var Data;
  NovoAgendamentoScreen({super.key, required this.Data});

  @override
  NovoAgendamentoScreenState createState() =>
      NovoAgendamentoScreenState(Data: Data);
}

List<String> ListaRegimes = ["Mensal", "Bimestral", "TriMestral"];

String VendoDiaSemana = "";
final TextEditingController _controller = TextEditingController();
final TextEditingController _controllerAnotacao = TextEditingController();
final TextEditingController _controllerData = TextEditingController();
final TextEditingController _controllerRegime =
    TextEditingController(text: 'Mensal');

int EtapaAtual = 0; //

class NovoAgendamentoScreenState extends State<NovoAgendamentoScreen> {
  var Data;
  NovoAgendamentoScreenState({required this.Data});

  List<DataEnvio_Week_Horario> HorariosSelecionados = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Data != null) {
      _controller.text = Data.GetNome();
      _controllerData.text = '${Data.GetUltimoPagamento()}';
      _controllerAnotacao.text = Data.GetAnotacoes() ?? "";
      _controllerRegime.text =
          ListaRegimes[int.parse(Data.GetModeloNegocios()) - 1];
      for (var H in Data.PresencaSemana!) {
        HorariosSelecionados.add(DataEnvio_Week_Horario(
            DiaDaSemana: H.DiaSemana, HorarioSelecionado: H.Horario));
      }
    }
  }

  void AdicionarHorario(String DiaDaSemana, String HoraSelecionada) {
    try {
      if (HorariosSelecionados.length < 2) {
        bool diaJaAdicionado = HorariosSelecionados.any(
          (e) => e.DiaDaSemana == DiaDaSemana,
        );
        if (!diaJaAdicionado) {
          HorariosSelecionados.add(
            DataEnvio_Week_Horario(
              DiaDaSemana: DiaDaSemana,
              HorarioSelecionado: HoraSelecionada,
            ),
          );
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void RemoverHorario(String DiaDaSemana, String HoraSelecionada) {
    var horario = HorariosSelecionados.firstWhere(
      (e) =>
          e.DiaDaSemana == DiaDaSemana &&
          e.HorarioSelecionado == HoraSelecionada,
    );
    HorariosSelecionados.removeAt(HorariosSelecionados.indexOf(horario));
  }

  void MsgErro(String mensagem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Aviso'),
          content: Text(mensagem),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void ProximaEtapa() {
    if (EtapaAtual == 0) {
      if (_controller.text.isEmpty) {
        MsgErro("Esqueceu do nome");
        return;
      }
      if (HorariosSelecionados.length < 2) {
        MsgErro("Esqueceu de adicionar dia da semana");
        return;
      }
      setState(() {
        EtapaAtual += 1;
      });
    } else if (EtapaAtual == 1) {
      if (_controllerData.text.isEmpty) {
        MsgErro("Esqueceu da data de registro");
        return;
      }
      _controllerRegime.text =
          '${ListaRegimes.indexOf(_controllerRegime.text) + 1}';
      SalvarNovoAgendamento();
    }
  }

  void SalvarNovoAgendamento() {
    List<Hora> HorasPraPresenca = [];
    for (var element in HorariosSelecionados) {
      HorasPraPresenca.add(Hora(
          Horario: element.HorarioSelecionado,
          Presenca: false,
          DiaSemana: element.DiaDaSemana));
    }

    _controllerRegime.text =
        '${ListaRegimes.indexOf(_controllerRegime.text) + 1}';
    if (Data != null) {
      Data.SetNome(_controller.text);
      Data.SetAnotacoes(_controllerAnotacao.text);
      Data.SetUltimoPagamento(DateTime.parse(_controllerData.text),
          int.parse(_controllerRegime.text), false);
      Data.SetPresencaSemana(HorasPraPresenca);
    } else {
      Aluno NovoAluno = AlunosController().AdicionarAluno(Aluno(
          Id: -1,
          Nome: _controller.text,
          PresencaSemana: HorasPraPresenca,
          Anotacoes: _controllerAnotacao.text,
          UltimoPagamento: DateTime.parse(_controllerData.text),
          ModeloNegocios: _controllerRegime.text));

      for (var element in HorariosSelecionados) {
        Controller()
            .Obter_Dia_porString(element.DiaDaSemana)
            .Horarios
            .firstWhere((e) => e.Hora == element.HorarioSelecionado)
            .AdicionarPessoa(NovoAluno.Id);
      }
    }
    _controller.text = "";
    EtapaAtual = 0;
    HorariosSelecionados.clear();
    Navigator.pushNamed(context, "/WeekScreen");
  }

  void RemoverAluno() {
    AlunosController().RemoverAluno(Data);
  }

  bool CheckSeSelecionado(String DiaDaSemana, String HoraSelecionada) {
    try {
      var horario = HorariosSelecionados.firstWhere(
        (e) =>
            e.DiaDaSemana == DiaDaSemana &&
            e.HorarioSelecionado == HoraSelecionada,
      );
      return horario != null;
    } catch (e) {
      return false;
    }
  }

  double DefinirTamanho(int Quantidade) {
    if (Quantidade <= 4) {
      return 170;
    }
    if (Quantidade <= 8) {
      return 150 * 2;
    }
    if (Quantidade <= 12) {
      return 150 * 3;
    }
    if (Quantidade <= 15) {
      return 150 * 4;
    }
    return 0;
  }

  Future<void> selectDate(
      BuildContext context, TextEditingController Contr) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(2100));
    if (picked != null && picked != DateTime.now()) {
      setState(
        () {
          Contr.text = '$picked';
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    EnviarParaInicio() => {Navigator.pushNamed(context, "/WeekScreen")};
    var WindowWidth = MediaQuery.of(context).size.width;
    var WindowHeight = MediaQuery.of(context).size.height;
    return GlassContainer(
      Cor: Color.fromRGBO(255, 255, 255, 1),
      Width: WindowWidth > 601
          ? (WindowWidth * .2) >= 200
              ? (WindowWidth * .8) - 30
              : (WindowWidth - 230)
          : WindowWidth - 20,
      Height: WindowHeight - (WindowWidth > 601 ? 0 : 75),
      Child: Column(
        children: [
          Center(
            child: Text(
              "NOVO ALUNO",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          if (EtapaAtual == 0)
            PrimeiraEtapa(
                HorariosSelecionados,
                setState,
                DefinirTamanho,
                WindowWidth,
                CheckSeSelecionado,
                AdicionarHorario,
                RemoverHorario,
                Data),
          if (EtapaAtual == 1) SegundaEtapa(selectDate, context, setState),
          BotoesFimPagina(Data, ProximaEtapa, SalvarNovoAgendamento,
              RemoverAluno, EnviarParaInicio, WindowWidth)
        ],
      ),
    );
  }
}

Widget PrimeiraEtapa(HorariosSelecionados, setState, DefinirTamanho,
    WindowWidth, CheckSeSelecionado, AdicionarHorario, RemoverHorario, Data) {
  return Expanded(
      child: Column(
    children: [
      Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        width: double.maxFinite,
        child: TextField(
          style: TextStyle(color: Colors.white, fontSize: 20),
          controller: _controller,
          decoration: InputDecoration(
            hintText: "NOME DA PESSOA",
            hintStyle: TextStyle(color: Colors.white, fontSize: 20),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
          ),
        ),
      ),
      Center(
        child: Text(
          'HORARIOS LIVRES [${HorariosSelecionados.length}/2]',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      Expanded(
        child: ListView(
          children: Controller()
              .Obter_Dias_Da_Semana(Data?.Id ?? -1)
              .map(
                (D) => TextButton(
                  onPressed: () => {
                    setState(() {
                      VendoDiaSemana = VendoDiaSemana == D.Nome ? "" : D.Nome;
                    })
                  },
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: GlassContainer(
                    Cor: Color.fromRGBO(255, 255, 255, 1),
                    Width: 0,
                    MaxHeight: DefinirTamanho(D.Horarios.length), //
                    Height: VendoDiaSemana == D.Nome ? 0 : 40,
                    Child: Column(
                      children: [
                        Text(
                          D.Nome,
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        if (VendoDiaSemana == D.Nome)
                          Expanded(
                            child: GridView(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: WindowWidth > 950
                                          ? 4
                                          : WindowWidth > 780
                                              ? 3
                                              : 2,
                                      mainAxisExtent:
                                          WindowWidth > 500 ? 130 : 140),
                              children: D.Horarios.map(
                                (e) => TextButton(
                                  onPressed: () => {
                                    setState(
                                      () {
                                        if (!CheckSeSelecionado(
                                            D.Nome, e.Hora)) {
                                          AdicionarHorario(D.Nome, e.Hora);
                                        } else {
                                          RemoverHorario(D.Nome, e.Hora);
                                        }
                                      },
                                    )
                                  },
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.transparent),
                                  ),
                                  child: GlassContainer(
                                    Width: 0,
                                    Height: 0,
                                    Cor: !CheckSeSelecionado(D.Nome, e.Hora)
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(173, 99, 173, 1),
                                    Child: Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            e.Hora,
                                            style: TextStyle(
                                                color: !CheckSeSelecionado(
                                                        D.Nome, e.Hora)
                                                    ? Color.fromRGBO(
                                                        255, 255, 255, 1)
                                                    : Color.fromRGBO(
                                                        173, 99, 173, 1),
                                                fontSize: 15),
                                          ),
                                        ),
                                        Column(
                                          children: e.IdAlunos.map(
                                            (e) => Text(
                                              AlunosController()
                                                  .ObterAlunoPorId(e)
                                                  .GetNome(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                          ).toList(),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ).toList(),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    ],
  ));
}

Widget SegundaEtapa(selectDate, context, setState) {
  return Expanded(
    child: Column(
      children: [
        TextButton(
          onPressed: () => selectDate(context, _controllerData),
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
          child: Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              width: double.maxFinite,
              child: GlassContainer(
                  Width: 0,
                  Height: 35,
                  Child: Center(
                    child: Text(
                        'DATA REGISTRO${_controllerData.text.isEmpty ? '' : ' [${DateTime.parse(_controllerData.text).day}/ ${DateTime.parse(_controllerData.text).month}/ ${DateTime.parse(_controllerData.text).year}]'}',
                        style: TextStyle(color: Colors.white)),
                  ),
                  Cor: Colors.white)),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          width: double.maxFinite,
          child: TextField(
            style: TextStyle(color: Colors.white, fontSize: 20),
            controller: _controllerAnotacao,
            decoration: InputDecoration(
              hintText: "ANOTAÇÕES",
              hintStyle: TextStyle(color: Colors.white, fontSize: 20),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
            ),
          ),
        ),
        GlassContainer(
          Width: 0,
          Height: 100,
          Cor: Colors.transparent,
          Child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 75, crossAxisCount: 3),
              children: ListaRegimes.map((e) => TextButton(
                    onPressed: () => setState(() {
                      _controllerRegime.text = e;
                    }),
                    style: ButtonStyle(
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: Container(
                        margin: EdgeInsets.only(left: 0, right: 0),
                        width: double.maxFinite,
                        child: GlassContainer(
                          Width: 0,
                          Height: 35,
                          Child: Center(
                            child: Text(e,
                                style: TextStyle(
                                  color: _controllerRegime.text != e
                                      ? Color.fromRGBO(255, 255, 255, 1)
                                      : Color.fromRGBO(173, 99, 173, 1),
                                )),
                          ),
                          Cor: _controllerRegime.text != e
                              ? Color.fromRGBO(255, 255, 255, 1)
                              : Color.fromRGBO(173, 99, 173, 1),
                        )),
                  )).toList()),
        )
      ],
    ),
  );
}

Widget BotoesFimPagina(Data, ProximaEtapa, SalvarNovoAgendamento, RemoverAluno,
    EnviarParaInicio, WindowWidth) {
  if (Data != null) {
    return GlassContainer(
        Width: 0,
        Height: WindowWidth > 500 ? 52 : 100,
        Cor: Colors.transparent,
        Child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: WindowWidth > 500 ? 50 : 60, crossAxisCount: 2),
          children: [
            TextButton(
              onPressed: EtapaAtual < 1 ? ProximaEtapa : SalvarNovoAgendamento,
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: GlassContainer(
                Cor: Color.fromRGBO(12, 255, 32, 1),
                Width: 0,
                Rotate: 20,
                Height: 40,
                Child: Center(
                  child: Text(
                    EtapaAtual < 1 ? "PROXIMA ETAPA" : "SALVAR",
                    style: TextStyle(
                        color: Color.fromRGBO(12, 255, 32, 1), fontSize: 15),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () => {RemoverAluno(), EnviarParaInicio()},
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: GlassContainer(
                Cor: Colors.red,
                Width: 0,
                Rotate: 20,
                Height: 40,
                Child: Center(
                  child: Text(
                    "REMOVER",
                    style: TextStyle(color: Colors.red, fontSize: 15),
                  ),
                ),
              ),
            )
          ],
        ));
  }
  return TextButton(
    onPressed: EtapaAtual < 1 ? ProximaEtapa : SalvarNovoAgendamento,
    style: ButtonStyle(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
    ),
    child: GlassContainer(
      Cor: Color.fromRGBO(12, 255, 32, 1),
      Width: 0,
      Rotate: 20,
      Height: 40,
      Child: Center(
        child: Text(
          EtapaAtual < 1 ? "PROXIMA ETAPA" : "SALVAR",
          style: TextStyle(color: Color.fromRGBO(12, 255, 32, 1), fontSize: 15),
        ),
      ),
    ),
  );
}
