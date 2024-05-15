import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laravelsingup/widgets/attribute_row.dart';
class PaymentDetailExpansionTile extends StatelessWidget {
  const PaymentDetailExpansionTile({
    super.key,
    required this.paymentDate,
    required this.paymentAmount,
    required this.paymentRemark,
    required this.paymentAttachment
  });
  final String paymentDate;
  final double paymentAmount;
  final String paymentRemark;
  final String paymentAttachment;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        shape: Border.all(color: Colors.transparent),
        title: AttributeRow(
          attribute: DateFormat('yyyy-MM-dd').format(DateTime.parse(paymentDate)),
          value: "\$" + paymentAmount.toString(),
          applyToValue: true,
          ValueTextStyle: TextStyle(fontSize: 15),
        ),
        backgroundColor: Colors.grey.shade100,
        collapsedBackgroundColor: Colors.grey.shade100,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                left: 20, right: 25, bottom: 10),
            child: Column(
              children: [
                AttributeRow(
                  attribute: 'Payment Remark :',
                  value: paymentRemark,
                  applyToValue: true,
                  ValueTextStyle: TextStyle(fontSize: 12),
                ),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payment Attachment :',
                      style: TextStyle(fontSize: 12),
                    ),
                    // showAttachment(
                    //     imagePath:
                    //         paymentAttachment),
                  ],
                ),
              ],
            ),
          )
          // Use document data here if needed
        ],
      ),
    );
  }
}
