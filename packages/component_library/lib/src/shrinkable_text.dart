import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ShrinkableText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;

  const ShrinkableText(
    this.data, {
    this.style,
    this.textAlign = TextAlign.center,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('rendering ShrinkableText');
    return AutoSizeText(data, style: style, textAlign: textAlign);
  }
}
