import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../attribute_row.dart';
class PRVisualizeCardProgress extends StatelessWidget {
  final String title;
  final double totalRemainingBalance;
  final double totalOustanding;
  final void Function()? onPressed;
  const PRVisualizeCardProgress(
      {super.key,
      required this.title,
      required this.totalOustanding,
      required this.totalRemainingBalance,
      this.onPressed}
    );

  @override
  Widget build(BuildContext context) {
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
            offset: Offset(4.0, 4.0),
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
                  "${(totalOustanding - totalRemainingBalance).toStringAsFixed(2)}/${totalOustanding}"),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Total Paid \$" +
                (totalOustanding - totalRemainingBalance).toStringAsFixed(2),
            style: TextStyle(
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
            barRadius: Radius.circular(5),
            animation: true,
            animationDuration: 500,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: onPressed,
                  child: Text(
                    'see more',
                    style: TextStyle(color: Colors.green),
                  )))
        ],
      ),
    );
  }
}
