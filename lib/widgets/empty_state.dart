import 'package:flutter/material.dart';
import 'package:laravelsingup/widgets/form/input_button.dart';
class WhenListIsEmpty extends StatelessWidget {
  final String title;
  final Function () onPressed;
  const WhenListIsEmpty({super.key,required this.title,required this.onPressed});

  @override
  Widget build(BuildContext context) {
      return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 50),
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
          color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        Text(title),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
            width: 150,
            child: InputButton(
                label: "Add",
                onPress: onPressed,
                backgroundColor: Colors.green,
                color: Colors.white))
      ]),
    );
  }
}
