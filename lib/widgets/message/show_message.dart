import 'package:flutter/material.dart';

Future<void> showAlertMessageBox(BuildContext context,
    {String? Errormessage, String? message}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      
      content: Errormessage.toString().length==0 || Errormessage.toString()=="null"
          ? Container(
              height:70,
              alignment: Alignment.center,
              child: Text(message.toString()),
            ): SizedBox(
              height: 100, 
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                   const  Icon(
                      Icons.warning_rounded,
                      size: 40,
                      color: Colors.green,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(Errormessage.toString())
                  ]),
            ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    ),
  );
}
