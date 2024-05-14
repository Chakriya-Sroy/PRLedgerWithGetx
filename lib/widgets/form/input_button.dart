import 'package:flutter/material.dart';

class InputButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color color;
  final void Function() onPress;
  const InputButton(
      {super.key,
      required this.label,
      required this.onPress,
      required this.backgroundColor,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: onPress,
        child: Container(
          width: double.infinity,
          height: 50,
          alignment: const AlignmentDirectional(0, 0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            label,
            style: TextStyle(color: color),
          ),
        ));
  }
}
