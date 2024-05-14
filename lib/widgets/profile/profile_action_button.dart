import 'package:flutter/material.dart';
import '../form/input_button.dart';
class ProfileActionButton extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  
  const ProfileActionButton({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        InputButton(
          onPress: onEdit,
          label: "Edit",
          backgroundColor: Colors.green,
          color: Colors.white,
        ),
        SizedBox(height: 10),
        InputButton(
          onPress: onDelete,
          label: "Delete",
          backgroundColor: Colors.red,
          color: Colors.white,
        ),
      ],
    );
  }
}

