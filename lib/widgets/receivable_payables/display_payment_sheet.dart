import 'dart:io';

import 'package:flutter/material.dart';
import 'package:laravelsingup/widgets/form/input_attachment.dart';
import 'package:laravelsingup/widgets/form/input_button.dart';
import 'package:laravelsingup/widgets/message/show_message.dart';

import '../form/input_text.dart';

Future displayPaymentBottomSheet(
      BuildContext context, {
      required  String receivableId,
      required String remainingBalance,
      required TextEditingController paymentController,
      required TextEditingController remarkController,
      required Function () onSubmit,
   //   required ValueNotifier<File?> attachmentNotifier,
      }
      ) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InputTextField(
                  label: 'Payment Amount',
                  controller: paymentController,
                  textInputFormator: true,
                ),
                InputTextField(
                  label: 'Payment Remark',
                  controller: remarkController,
                ),
                const SizedBox(
                  height: 20,
                ),
                InputButton(
                    label: "Save",
                    onPress: () {
                      if(paymentController.text.isEmpty){
                        Navigator.pop(context);
                      }
                      else if(double.parse(paymentController.text)<=0){
                        showAlertMessageBox(context, Errormessage: "The amount must be greater than 0");
                      }
                      else if (double.parse(remainingBalance) >=
                          double.parse(paymentController.text)) {
                        //update receivable amount
                        String newAmount = (double.parse(remainingBalance) -
                                double.parse(paymentController.text))
                            .toString();
                        onSubmit();       
                      } else if (double.parse(remainingBalance) <
                          double.parse(paymentController.text)) {
                        showAlertMessageBox(context,
                            Errormessage:"The amount that enter exceed the remaining balance");
                        // Navigator.pop(context);
                      }
                    },
                    backgroundColor: Colors.green,
                    color: Colors.white)
              ],
            ),
          ),
        );
      },
    );
  }
