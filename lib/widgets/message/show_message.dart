import 'package:flutter/material.dart';

Future<void> showAlertMessageBox(BuildContext context,
    {String? Errormessage, String? message}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      contentPadding: const EdgeInsets.all(30),
      actionsPadding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
      content: Errormessage.toString().length==0 || Errormessage.toString()=="null"
          ?  Text(message.toString() ): Text(Errormessage.toString()),
            // ): SizedBox(
            //   height: MediaQuery.of(context).size.height/4, 
            //   child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //        const  Icon(
            //           Icons.warning_rounded,
            //           size: 40,
            //           color: Colors.green,
            //         ),
            //         const SizedBox(
            //           height: 20,
            //         ),
                   
            //       ]),
            //),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
        ),
      ],
    ),
  );
}
