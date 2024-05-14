import 'package:flutter/material.dart';
import 'input_text.dart';
class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String validation;
  final double gapHeight;
  bool ? obscureText=false;
  CustomTextField({super.key,required this.label,required this.controller,required this.validation,required this.gapHeight,this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          InputTextField(
                    label:label,
                    controller: controller,
                    obscureText: obscureText ?? false,
                  ),
          SizedBox(height: gapHeight,),
          Text(
            validation,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                          )
          ),
    ]);
  }
}