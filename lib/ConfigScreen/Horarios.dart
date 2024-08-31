// ignore_for_file: non_constant_identifier_names, file_names, avoid_print

import 'package:app_pilates/Controle/Classes.dart';
import 'package:app_pilates/Controle/Controller.dart';
import 'package:flutter/material.dart';
import 'package:app_pilates/Componentes/GlassContainer.dart';

class HorarioScreen extends StatefulWidget {
  const HorarioScreen({super.key});

  @override
  HorarioScreenState createState() => HorarioScreenState();
}

class HorarioScreenState extends State<HorarioScreen> {
  List<int> _horasTrabalhadas = [];
  int _limiteAulasPorHorario = 0;

  @override
  void initState() {
    super.initState();
    _loadConfiguracoes();
  }

  Future<void> _loadConfiguracoes() async {
    try {
      Configuracoes configs = await Controller().obterConfiguracoes();
      setState(() {
        _horasTrabalhadas = configs.HorasTrabalhadas;
        _limiteAulasPorHorario = configs.LimiteAulasPorHorario;
        // _isLoading = false;
      });
    } catch (e) {
      // Gerenciar erro, se necessário
      print('Erro ao carregar configurações: $e');
    }
  }

  Future<void> _updateHorasTrabalhadas(int index) async {
    setState(() {
      if (_horasTrabalhadas.contains(index)) {
        _horasTrabalhadas.remove(index);
      } else {
        _horasTrabalhadas.add(index);
      }
    });

    // Atualizar as configurações
    Configuracoes updatedConfigs = Configuracoes(
        HorasTrabalhadas: _horasTrabalhadas,
        LimiteAulasPorHorario: _limiteAulasPorHorario,
        DiaDeHoje: DateTime.now());
    await Controller().definirConfiguracoes(updatedConfigs);
  }

  @override
  Widget build(BuildContext context) {
    var WindowWidth = MediaQuery.of(context).size.width;
    var WindowHeight = MediaQuery.of(context).size.height;

    var QuantidadeItens = WindowWidth > 850
        ? 5
        : WindowWidth > 700
            ? 3
            : WindowWidth > 600
                ? 5
                : 4; //
    double TamanhoTexto = WindowWidth > 400 ? 25 : 20;

    return GlassContainer(
      Cor: const Color.fromRGBO(255, 255, 255, 1),
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
              "HORARIOS FUNCIONAMENTO",
              style: TextStyle(color: Colors.white, fontSize: TamanhoTexto),
            ),
          ),
          Expanded(
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: QuantidadeItens, mainAxisExtent: 75),
              children: List.generate(
                  17,
                  (index) => TextButton(
                        onPressed: () async {
                          await _updateHorasTrabalhadas(index + 6);
                        },
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                        ),
                        child: GlassContainer(
                          Width: 0,
                          Height: 0,
                          Cor: !_horasTrabalhadas.contains(index + 6)
                              ? const Color.fromRGBO(255, 255, 255, 1)
                              : const Color.fromRGBO(173, 99, 173, 1),
                          Rotate: !_horasTrabalhadas.contains(index) ? 50 : 20,
                          Child: Center(
                            child: Text(
                              '${(index + 6) <= 9 ? '0${index + 6}' : (index + 6)}:00',
                              style: TextStyle(
                                  color: !_horasTrabalhadas.contains(index + 6)
                                      ? const Color.fromRGBO(255, 255, 255, 1)
                                      : const Color.fromRGBO(173, 99, 173, 1),
                                  fontSize: TamanhoTexto),
                            ),
                          ),
                        ),
                      )),
            ),
          )
        ],
      ),
    );
  }
}
