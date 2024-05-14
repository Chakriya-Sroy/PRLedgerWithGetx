import 'package:flutter/material.dart';

class DrawerBodyItem extends StatelessWidget {
  final String title;
  final Function onTap;
  const DrawerBodyItem({super.key,required this.title,required this.onTap});

  @override
  Widget build(BuildContext context) {
   return GestureDetector(
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
        child: Text(
          title,
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ));
  }
}


