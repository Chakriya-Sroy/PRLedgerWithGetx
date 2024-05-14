import "package:flutter/material.dart";


Future<void> ConfirmMessageBox(BuildContext context,
    {required String message, required Function() onPressed}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Confirmation"),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      contentPadding: const EdgeInsets.all(30),
      actionsPadding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      actions: [
        Flex(
            crossAxisAlignment: CrossAxisAlignment.center,
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("No"),
                  textColor: Colors.white,
                  color: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  elevation: 0,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: MaterialButton(
                  onPressed: onPressed,
                  child: Text("Confirm"),
                  textColor: Colors.white,
                  color: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  elevation: 0,
                ),
              ),
            ]),
        // )
      ],
      // actions: [
      //    SizedBox(
      //           width: 125,
      //           height: 50,
      //           child: InputButton(
      //               label: "Cancel",
      //               onPress: () {
      //                 Navigator.of(context).pop();
      //               },
      //               backgroundColor: Colors.red,
      //               color: Colors.white),
      //         ),
      //         SizedBox(
      //           width: 125,
      //           height: 50,
      //           child: InputButton(
      //               label: "Ok",
      //               onPress: onPressed,
      //               backgroundColor: Colors.green,
      //               color: Colors.white),
      //         ),
      // ],
      // actionsPadding: const EdgeInsets.only(top:20,bottom: 20),
      // actionsAlignment: MainAxisAlignment.center,
    ),
  );
}
