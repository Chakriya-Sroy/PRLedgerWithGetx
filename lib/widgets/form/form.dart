import 'package:flutter/material.dart';

class FormList extends StatelessWidget {
  final List<Widget> inputWidgets;
  final double ? gapHeight; 
  const FormList({Key? key, required this.inputWidgets,this.gapHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _buildInputWidgets(),
    );
  }
  List<Widget> _buildInputWidgets() {
    List<Widget> widgets = [];
    
    for (var inputWidget in inputWidgets) {
      widgets.add(inputWidget);
      widgets.add(SizedBox(height: gapHeight)); // Adjust spacing as needed
    }
    return widgets;
  }
}
