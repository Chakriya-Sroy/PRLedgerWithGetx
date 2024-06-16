import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../attribute_row.dart';
class PRVisualizeCardProgress extends StatelessWidget {
  final String title;
  final double totalRemainingBalance;
  final double totalOustanding;
  final void Function()? onPressed;
  late bool ? isCustomer=false;
  late bool ? isSupplier=false;
  PRVisualizeCardProgress(
      {super.key,
      this.isCustomer,
      this.isSupplier,
      required this.title,
      required this.totalOustanding,
      required this.totalRemainingBalance,
      this.onPressed}
    );

  @override
  Widget build(BuildContext context) {

    String buttonText;
    if (isCustomer == true) {
      buttonText = "View Customer's Receivable";
    } else if (isSupplier == true) {
      buttonText = "View Supplier's Payable";
    } else {
      buttonText = "See More";
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin:const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(4.0, 4.0),
            blurRadius: 4.0,
            spreadRadius: 0.0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AttributeRow(
              attribute: title,
              value: "\$" +
                  "${(totalOustanding - totalRemainingBalance).toStringAsFixed(2)}/$totalOustanding"),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Total Paid \$ ${(totalOustanding - totalRemainingBalance).toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            lineHeight: 8.0,
            percent: (totalOustanding-totalRemainingBalance)/totalOustanding,
            backgroundColor: Colors.grey.shade300,
            progressColor: Colors.green,
            barRadius: const Radius.circular(5),
            animation: true,
            animationDuration: 500,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: onPressed,
                  child: Text(
                    buttonText,
                    style: const TextStyle(color: Colors.green),
                  )))
        ],
      ),
    );
  }
}
