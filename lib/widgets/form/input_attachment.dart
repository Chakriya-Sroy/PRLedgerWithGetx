

import 'dart:io';

import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';


class AddAttachment extends StatefulWidget {
  final void Function(File?) onFilePicked;
  const AddAttachment({super.key,required this.onFilePicked});
  @override
  State<AddAttachment> createState() => _AddAttachmentState();
}

class _AddAttachmentState extends State<AddAttachment> {
  FilePickerResult? result;
  String? _fileName;
  PlatformFile? pickedfile;
  bool isLoading = false;
  File? fileToDisplay;
  void _pickFile() async {
  try {
    setState(() {
      isLoading = true;
    });
  // if (Platform.isIOS || Platform.isAndroid) {
  //     // Use native file picker for mobile platforms
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
  //       withData: true,
  //       allowMultiple: false,
  //     );

  //     if (result != null && result.files.isNotEmpty) {
  //       final filePath = result.files.first.path;
  //       final fileBytes = result.files.first.bytes;
  //       final fileName = result.files.first.name;
  //       setState(() {
  //         _fileName = fileName;
  //         fileToDisplay = File(filePath!);
  //       });
  //       widget.onFilePicked(fileToDisplay);
  //       print(fileBytes);
  //     }
  //   } else {
  //     // Use web file picker for web platform
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
  //       withData: true,
  //       allowMultiple: false,
  //     );

  //     if (result != null && result.files.isNotEmpty) {
  //       final fileBytes = result.files.first.bytes;
  //       final fileName = result.files.first.name;
  //       setState(() {
  //         _fileName = fileName;
  //          fileToDisplay = File.fromRawPath(fileBytes!);
  //       });
  //       widget.onFilePicked(fileToDisplay);
  //       print(fileBytes);
  //     }
  //   }

    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
      withData: true,
      allowMultiple: false,
    );

    if (result != null && result!.files.isNotEmpty) {
      //final filePath = result!.files.first.path;
      final fileBytes=result!.files.first.bytes;
      final fileName = result!.files.first.name;
       setState(() {
          _fileName = fileName;
          fileToDisplay =  File.fromRawPath(fileBytes!);
        });
      widget.onFilePicked(fileToDisplay);
      //await firebase.uploadFile(fileBytes!, fileName);
      print(fileName);
    }

    setState(() {
      isLoading = false;
    });
  } catch (e) {
    print(e);
    setState(() {
      isLoading = false;
    });
  }
}
  String? get fileName => _fileName;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      height: 50,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 20),
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
      child: Row(
        children: [
          IconButton(
            color: Colors.grey,
            icon: Icon(Icons.file_present),
            onPressed: () =>_pickFile(),
          ),
          Text('Add Attachment'),
        ],
      ),
    );
  }
}
