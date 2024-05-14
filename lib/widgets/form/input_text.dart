import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputTextField extends StatefulWidget {
  String label;
  TextEditingController controller;
  bool? textInputFormator = false;
  bool? obscureText = false;
  String? hintText = "null";
  bool? boxShadow = true;
  bool? hidePasswordIcon = false;
  InputTextField({
    super.key,
    required this.label,
    required this.controller,
    this.textInputFormator,
    this.obscureText,
    this.hintText,
    this.boxShadow,
    this.hidePasswordIcon,
  });

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
 late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: widget.boxShadow ?? true
                  ? [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        offset: Offset(4.0, 4.0),
                        blurRadius: 10.0,
                        spreadRadius: 1.0,
                      )
                    ]
                  : []),
          child: TextField(
            controller: widget.controller,
            obscureText: _obscureText,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hintText == "null" ? "" : widget.hintText,
                suffixIcon: widget.hidePasswordIcon ?? true
                    ? null
                    : IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )),
            inputFormatters: widget.textInputFormator == true
                ? <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}')),
                    // This formatter allows digits and up to 2 decimal places
                  ]
                : [],
          ),
        ),
      ],
    );
  }
}
