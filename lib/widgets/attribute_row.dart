import 'package:flutter/material.dart';

class AttributeRow extends StatelessWidget {
  final String attribute;
  final String value;
  final TextStyle? AttributeTextStyle; 
  final TextStyle ? ValueTextStyle;
  late bool ? applyToAttribute =false;// New property for dynamic TextStyle
  late bool ? applyToValue=false;

  AttributeRow({
    Key? key,
    required this.attribute,
    required this.value,
    this.AttributeTextStyle, 
    this.ValueTextStyle,
    this.applyToAttribute,
    this.applyToValue
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          attribute,
         style: applyToAttribute==true ? AttributeTextStyle : null, // Apply textStyle to the attribute text
        ),
        if(value.length >20)
        Flexible(child: Text(
          value,
          style: applyToValue==true ? ValueTextStyle : null,
        ),)
        else 
        Text(
          value,
         style: applyToValue==true ? ValueTextStyle : null,
        ),
      ],
    );
  }
}
