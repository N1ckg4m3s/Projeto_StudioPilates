// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final double Width;
  final double Height; // Valor pra delimitar e 0 pra tamanho maximo
  final Widget Child;

  final Color? Cor;

  final EdgeInsets? Padding;

  final double? MinWidth;
  final double? MinHeight;
  final double? MaxWidth;
  final double? MaxHeight;

  final double? BorderRadios;
  final double? Rotate;

  const GlassContainer({
    super.key,
    required this.Width,
    required this.Height,
    required this.Child,
    required this.Cor,
    this.MinWidth,
    this.MinHeight,
    this.MaxWidth,
    this.MaxHeight,
    this.BorderRadios,
    this.Rotate,
    this.Padding,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Width == 0 ? double.infinity : Width,
      height: Height == 0 ? double.maxFinite : Height,
      constraints: BoxConstraints(
        maxHeight: MaxHeight ?? double.maxFinite,
        minHeight: MinHeight ?? double.minPositive,
        maxWidth: MaxWidth ?? double.maxFinite,
        minWidth: MinWidth ?? double.minPositive,
      ),
      margin: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
      padding: Padding ?? const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(BorderRadios ?? 10),
        gradient: RadialGradient(
          center: const Alignment(-0.5, -0.5),
          radius: Rotate ?? 2,
          colors: [
            Color.fromRGBO(Cor!.red, Cor!.green, Cor!.blue, .1),
            Color.fromRGBO(Cor!.red, Cor!.green, Cor!.blue, .04),
            Color.fromRGBO(Cor!.red, Cor!.green, Cor!.blue, 0),
          ],
          stops: const [0.0, 0.61, 1.0],
        ),
        border: Border(
          top: BorderSide(
            color: Cor ?? const Color.fromRGBO(0, 255, 255, 1),
            width: 1,
          ),
          left: BorderSide(
            color: Cor ?? const Color.fromRGBO(0, 255, 255, 1),
            width: 1,
          ),
        ),
      ),
      child: Child,
    );
  }
}
