// ignore_for_file: non_constant_identifier_names, file_names

import 'package:app_pilates/Componentes/CaregandoData.dart';
import 'package:app_pilates/Componentes/GlassContainer.dart';
import 'package:app_pilates/Controle/AlunosController.dart';
import 'package:app_pilates/Controle/Classes.dart';
import 'package:flutter/material.dart';

class MensalidadesScreen extends StatefulWidget {
  const MensalidadesScreen({super.key});

  @override
  MensalidadesScreenState createState() => MensalidadesScreenState();
}

List<String> Filtros = ["VENCIDAS", "ATÉ 4 DIAS", "1 SEMANA", "TODOS"];
String FiltroAtual = "TODOS";

int AjustarQuantidades(MaxW) {
  return MaxW >= 1100
      ? 4
      : MaxW > 930
          ? 3
          : MaxW > 620
              ? 2
              : 1;
}

class MensalidadesScreenState extends State<MensalidadesScreen> {
  @override
  Widget build(BuildContext context) {
    var WindowWidth = MediaQuery.of(context).size.width;
    var WindowHeight = MediaQuery.of(context).size.height;
    return GlassContainer(
        Cor: const Color.fromRGBO(255, 255, 255, 1),
        Width: WindowWidth > 601
            ? (WindowWidth * .2) >= 200
                ? (WindowWidth * .8) - 30
                : (WindowWidth - 230)
            : WindowWidth - 20,
        Height: WindowHeight - (WindowWidth > 601 ? 0 : 75),
        Child: Column(children: [
          const Center(
            child: Text(
              "MENSALIDADES",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          Container(
            width: double.maxFinite,
            height: (50 *
                    (WindowWidth > 880
                        ? 1
                        : WindowWidth > 500
                            ? 2
                            : 3)) +
                2,
            color: Colors.transparent,
            child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: WindowWidth > 500 ? 50 : 60,
                    crossAxisCount: WindowWidth > 880 ? 4 : 2),
                children: Filtros.map((e) => TextButton(
                      onPressed: () => setState(() {
                        FiltroAtual = e;
                      }),
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                      ),
                      child: Container(
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          width: double.maxFinite,
                          child: GlassContainer(
                            Width: 0,
                            Height: 35,
                            Child: Center(
                              child: Text(e,
                                  style: TextStyle(
                                    color: FiltroAtual != e
                                        ? const Color.fromRGBO(255, 255, 255, 1)
                                        : const Color.fromRGBO(173, 99, 173, 1),
                                  )),
                            ),
                            Cor: FiltroAtual != e
                                ? const Color.fromRGBO(255, 255, 255, 1)
                                : const Color.fromRGBO(173, 99, 173, 1),
                          )),
                    )).toList()),
          ),
          Expanded(
            child: FutureBuilder<List<Aluno>>(
              future: AlunosController().obterMensalidades(FiltroAtual),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CarregandoDataBar(); // ou qualquer widget de carregamento
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Erro ao carregar dados"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Nenhum aluno encontrado"));
                }

                // Agora temos os dados
                List<Aluno> alunos = snapshot.data!;

                return GridView(
                  padding: const EdgeInsets.all(5),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: AjustarQuantidades(WindowWidth),
                    mainAxisExtent: 40,
                  ),
                  children: alunos.map((aluno) {
                    Color corTexto;
                    String texto;

                    String Nome = aluno.Nome;

                    String Tipo =
                        ["M", "B", "T"][int.parse(aluno.ModeloNegocios!) - 1];

                    String Parcela = aluno.Parcelado! <= 0
                        ? "Av"
                        : "${aluno.ParcelaPaga ?? 0}/${aluno.Parcelado!}";

                    String ProximoPag = "";

                    DateTime? ultimoPagamento = aluno.GetUltimoPagamento();

                    DateTime hoje = DateTime.now();
                    int diasDiferenca;

                    String TranformarDiferenca(int Dias) {
                      if (Dias < 0) {
                        return 'Vencido há ${-Dias}d';
                      } else if (Dias == 0) {
                        return 'Hj';
                      } else if (Dias <= 7) {
                        return '${Dias}dias';
                      } else if (Dias > 7 && Dias <= 30) {
                        int EmSemana = (Dias / 7).floor();
                        return "${EmSemana}sem.";
                      } else {
                        int EmMes = (Dias / 30).floor();
                        return "${EmMes}mes";
                      }
                    }

                    if (aluno.Parcelado! > 0 &&
                        aluno.Parcelado! <= (aluno.ParcelaPaga ?? 0)) {
                      // debugPrint("Tem parcela, mas já foi tudo pago");
                      diasDiferenca = -hoje
                          .difference(ultimoPagamento.add(Duration(
                              days: 30 *
                                  (int.parse('${aluno.ModeloNegocios}') - 1))))
                          .inDays;
                      ProximoPag = TranformarDiferenca(diasDiferenca);
                    } else if (aluno.Parcelado! > 0) {
                      diasDiferenca = -hoje
                          .difference(
                              ultimoPagamento.add(const Duration(days: 30)))
                          .inDays;
                      ProximoPag = TranformarDiferenca(diasDiferenca);
                    } else {
                      diasDiferenca = -hoje
                          .difference(ultimoPagamento.add(Duration(
                              days:
                                  (30 * int.parse('${aluno.ModeloNegocios}')))))
                          .inDays;
                      ProximoPag = TranformarDiferenca(diasDiferenca);
                    }

                    if (diasDiferenca <= 1) {
                      corTexto = Colors.red;
                    } else if (diasDiferenca <= 7) {
                      corTexto = Colors.orange;
                    } else {
                      corTexto = Colors.white;
                    }

                    texto = "$Nome: [$Tipo] [$Parcela] [$ProximoPag]";
                    return Text(
                      texto,
                      style: TextStyle(color: corTexto),
                    );
                  }).toList(),
                );
              },
            ),
          )
        ]));
  }
}
