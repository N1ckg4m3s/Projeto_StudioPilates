// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:app_pilates/Componentes/CaregandoData.dart';
import 'package:app_pilates/Componentes/GlassContainer.dart';
import 'package:app_pilates/Controle/AlunosController.dart';
import 'package:app_pilates/Controle/Classes.dart';

class PagamentosScreen extends StatefulWidget {
  const PagamentosScreen({super.key});

  @override
  PagamentosScreenState createState() => PagamentosScreenState();
}

int AjustarQuantidades(MaxW) {
  return MaxW >= 1100
      ? 4
      : MaxW > 930
          ? 3
          : MaxW > 620
              ? 2
              : 1;
}

class PagamentosScreenState extends State<PagamentosScreen> {
  @override
  Widget build(BuildContext context) {
    var WindowWidth = MediaQuery.of(context).size.width;
    var WindowHeight = MediaQuery.of(context).size.height;

    double WidthGlassContainer = WindowWidth > 601
        ? (WindowWidth * .2) >= 200
            ? (WindowWidth * .8) - 30
            : (WindowWidth - 230)
        : WindowWidth - 20;

    return GlassContainer(
      Cor: const Color.fromRGBO(255, 255, 255, 1),
      Width: WidthGlassContainer,
      Height: WindowHeight - (WindowWidth > 601 ? 0 : 75),
      Child: Column(
        children: [
          const Center(
            child: Text(
              "RELATORIO RECEBIMENTO",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Aluno>>(
              future: AlunosController().obterAlunos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CarregandoDataBar(); // ou qualquer widget de carregamento
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Erro ao carregar dados"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Nenhum aluno encontrado"));
                }

                // Agora temos os dados
                DateTime Hoje = DateTime.now().add(const Duration(days: 50));
                List<Aluno> alunos = snapshot.data!;

                // Cálculos
                double totalReceber = alunos.fold(0.0, (sum, a) {
                  return sum + (a.ValorTotal ?? 0.0);
                });

                double valorNesseMes = alunos.fold(0.0, (sum, a) {
                  if (a.Parcelado == 0 &&
                      Hoje.month > a.UltimoPagamento!.month) {
                    return sum;
                  }
                  int parcelasRestantes =
                      (a.Parcelado ?? 0) - (a.ParcelaPaga ?? 0);
                  return sum +
                      (parcelasRestantes > 0
                          ? (a.ValorTotal ?? 0.0) / (a.Parcelado ?? 1)
                          : 0);
                });

                double valorMesesFuturos = alunos.fold(0.0, (sum, a) {
                  int parcelasRestantes =
                      (a.Parcelado ?? 0) - (a.ParcelaPaga ?? 0);
                  if (parcelasRestantes > 0) {
                    return sum +
                        ((a.ValorTotal ?? 0.0) / (a.Parcelado ?? 1)) *
                            parcelasRestantes;
                  }
                  return sum;
                });

                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TOTAL A RECEBER: R\$ ${totalReceber.toStringAsFixed(2)}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            "VALOR NESSE MÊS: R\$ ${valorNesseMes.toStringAsFixed(2)}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            "VALOR PARA MESES FUTUROS: R\$ ${(valorMesesFuturos - valorNesseMes).toStringAsFixed(2)}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          const Divider(thickness: 2, color: Colors.black),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView(
                        padding: const EdgeInsets.all(5),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: AjustarQuantidades(WindowWidth),
                          mainAxisExtent: 40,
                        ),
                        children: alunos.map((aluno) {
                          Color corTexto;
                          String texto;
                          String modeloNegocios = aluno.ModeloNegocios ?? '';
                          num valorParcela = (aluno.Parcelado ?? 1) > 0
                              ? (aluno.ValorTotal ?? 1.0) /
                                  (aluno.Parcelado ?? 1)
                              : (aluno.ValorTotal ?? 1.0);

                          String valorFormatado =
                              valorParcela.toStringAsFixed(2);

                          if (modeloNegocios == '1') {
                            corTexto = const Color(0xFF09FF00); // Verde
                            modeloNegocios = "M";
                          } else if (modeloNegocios == '2') {
                            corTexto = const Color(0xFFFF7F01); // Laranja
                            modeloNegocios = "B";
                          } else {
                            corTexto = const Color(0xFFFF0000); // Vermelho
                            modeloNegocios = "T";
                          }

                          texto =
                              '${aluno.Nome}: R\$ $valorFormatado [${modeloNegocios.substring(0, 1).toUpperCase()}]';

                          return Text(
                            texto,
                            style: TextStyle(color: corTexto),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
