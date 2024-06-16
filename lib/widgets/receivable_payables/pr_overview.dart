import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laravelsingup/widgets/attribute_list.dart';
import 'package:laravelsingup/widgets/attribute_row.dart';
import 'package:laravelsingup/widgets/show_attachment.dart';
class PROverview extends StatelessWidget {
  final String id;
  final String receivableAmount;
  final String receivableRemark;
  final String receivableDueDate;
  final String receivablePaymentTerms;
  final String receivableAttachment;
  final String receivableRemainingBalance;
  const PROverview({super.key,required this.id,required this.receivableAmount,required this.receivableRemainingBalance,required this.receivableDueDate,required this.receivablePaymentTerms,required this.receivableRemark,required this.receivableAttachment});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           AttributeList(
                  attributes: [
                    AttributeRowData(
                        attribute: 'Ref.no:', value:"${DateFormat('yyyyMMdd').format(DateTime.parse(receivableDueDate))}${id}", spaceBetween: 15),
                    AttributeRowData(
                        attribute: 'Remark:',
                        value: receivableRemark,
                        spaceBetween: 15),
                    AttributeRowData(
                        attribute: 'Due Date:',
                        value: DateFormat('yyyy-MM-dd').format(DateTime.parse(receivableDueDate)),
                        spaceBetween: 15),
                    AttributeRowData(
                        attribute: 'Payment Terms:',
                        value: receivablePaymentTerms,
                        spaceBetween: 15),
                    AttributeRowData(
                        attribute: 'Total amounts:',
                        value: '\$' + receivableAmount,
                        spaceBetween: 15),
                    AttributeRowData(
                        attribute: 'Payment Details:',
                        value: "Remaining: \$" + receivableRemainingBalance,
                        spaceBetween: 15),
                  ],
                ),
              
               
        ],
    );
  }
}


