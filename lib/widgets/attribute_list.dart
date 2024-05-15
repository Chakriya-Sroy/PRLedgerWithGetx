import 'package:flutter/material.dart';

import 'attribute_row.dart';

class AttributeList extends StatelessWidget {
  //This line declear list of attributeRowData
  final List<AttributeRowData> attributes;
  const AttributeList({super.key,required this.attributes});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: _buildAttributeRows(),
    );
  }
  //_buildAttributeRows() function that will return List 
  List<Widget> _buildAttributeRows() {
    // list to store widget
    List<Widget> rows = [];

    for (var attributeData in attributes) {
      // rows list will add new widget call attributeRow and SizedBox with the high if there are 4 atribute row there will be 4 sizedBox
      rows.add(AttributeRow(attribute: attributeData.attribute, value: attributeData.value));
      rows.add(SizedBox(height: attributeData.spaceBetween));
    }

    return rows;
  }
}
// make class or model call attributeRowData that required attribute,value and space between each
class AttributeRowData {
  final String attribute;
  final String value;
  final double spaceBetween;

  const AttributeRowData({
    required this.attribute,
    required this.value,
    required this.spaceBetween 
  });
}