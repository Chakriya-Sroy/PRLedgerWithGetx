import 'package:flutter/material.dart';
class MenuItem extends StatelessWidget {
  final String title;
  final String imageIconPath;
  final Function () onTap;
  const MenuItem({super.key,
      required this.title,
      required this. imageIconPath,
      required this.onTap
    });

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Text(title),
        GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            width: 70,
            height: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.green, width: 2),
                shape: BoxShape.circle),
            child: SizedBox(
                width: 45,
                height: 45,
                child: Image.network(imageIconPath, fit: BoxFit.cover)),
          ),
        ),
      ],
    );
  }
}

