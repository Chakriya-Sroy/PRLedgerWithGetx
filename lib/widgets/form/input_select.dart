import 'package:flutter/material.dart';

class InputSelectOption extends StatefulWidget {
  String label;
  List<String>options;
  String selectedOptionsValue;
  final ValueChanged<String>onChanged;
  InputSelectOption({super.key,required this.label,required this.options,required this.selectedOptionsValue,required this.onChanged});
  @override
  State<InputSelectOption> createState() => _InputSelectOptionState();
}

class _InputSelectOptionState extends State<InputSelectOption> {
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                offset: Offset(4.0, 4.0),
                blurRadius: 10.0,
                spreadRadius: 1.0,
              )
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              isExpanded: true,
              elevation: 5,
              items: widget.options.map((option) {
                return DropdownMenuItem(
                  child: Text(option),
                  value:option,
                );
              }).toList(),
              onChanged: (newvalue) {
                setState(() {
                  widget.onChanged(newvalue.toString());
                });
              },
              value: widget.selectedOptionsValue,
            ),
          ),
        ),
      ],
    );
  }
}

