import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(
      {super.key,
      this.text = "",
      this.color = Colors.white,
      this.fontSize = 12,
      this.fontWeight = FontWeight.normal,
      this.textOverflow,
      this.maxLine = 1,
      this.fontFamily = "Montserrat",
      this.textAlign,
      this.decoration});
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextOverflow? textOverflow;
  final int? maxLine;
  final String? fontFamily;
  final TextAlign? textAlign;
  final TextDecoration? decoration;
  @override
  Widget build(BuildContext context) {
    return Text(
      softWrap: true,
      overflow: TextOverflow.visible,
      textAlign: textAlign,
      text,
      maxLines: maxLine,
      style: TextStyle(
        
        decorationStyle: TextDecorationStyle.solid,
        decorationColor: Colors.black,
        decoration: decoration,
        fontFamily: fontFamily,
        color: color,
        overflow: textOverflow,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: FontStyle.normal,
        
      ),
    );
  }
}
