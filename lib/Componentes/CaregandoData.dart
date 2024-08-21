// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CarregandoDataBar extends StatelessWidget {
  final String mensagem;

  const CarregandoDataBar({super.key, this.mensagem = 'Carregando dados...'});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
