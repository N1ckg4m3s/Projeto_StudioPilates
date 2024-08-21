// ignore_for_file: non_constant_identifier_names, file_names

import 'package:app_pilates/Componentes/CaregandoData.dart';
import 'package:app_pilates/Componentes/GlassContainer.dart';
import 'package:app_pilates/Controle/AlunosController.dart';
import 'package:flutter/material.dart';

class FaltasGeraisScreen extends StatefulWidget {
  const FaltasGeraisScreen({super.key});

  @override
  FaltasGeraisScreenState createState() => FaltasGeraisScreenState();
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

class FaltasGeraisScreenState extends State<FaltasGeraisScreen> {
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
      Padding: const EdgeInsets.all(10),
      Height: WindowHeight - (WindowWidth > 601 ? 0 : 75),
      Child: Column(
        children: [
          const Center(
            child: Text(
              "FALTAS",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
            future: AlunosController().obterFaltas(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CarregandoDataBar();
              } else if (snapshot.hasError) {
                return const Center(child: Text("Erro ao carregar dados"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Nenhum aluno com falta"));
              } else {
                List<Map<String, dynamic>> faltas = snapshot.data!;
                return GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: AjustarQuantidades(WindowWidth),
                    mainAxisExtent: 40,
                  ),
                  children: faltas.map((falta) {
                    return Text(
                      '${falta['nome']}: [ ${falta['dia']} - ${falta['horario']} ]'
                          .toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    );
                  }).toList(),
                );
              }
            },
          )),
        ],
      ),
    );
  }
}
