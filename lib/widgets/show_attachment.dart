import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:image_network/image_network.dart';

class showAttachment extends StatelessWidget {
  final String imagePath;
  const showAttachment({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return imagePath == ''
        ? const Text(
            'No attachment added',
            style: TextStyle(fontSize: 12),
          )
        : SizedBox(
          width: 50,
          height: 50,
          child:InstaImageViewer(
            imageUrl:imagePath,
            child: ImageNetwork(image: imagePath,width: 50,height: 50,)
          )
        );
  }
}
