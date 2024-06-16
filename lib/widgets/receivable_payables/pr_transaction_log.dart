import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laravelsingup/controller/customer.dart';
import 'package:laravelsingup/controller/supplier.dart';
import 'package:laravelsingup/widgets/attribute_row.dart';

class PRTransactionLog extends StatelessWidget {
  final bool isReceivable;
  const PRTransactionLog({super.key, required this.isReceivable});

  @override
  Widget build(BuildContext context) {
    final customerController = Get.put(CustomerController());
    final supplierController = Get.put(SupplierController());
    return isReceivable == true
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: customerController.transactions.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  transactionLogCard(
                    id: customerController
                        .transactions[index].receivableId
                        .toString(),
                    date: customerController
                        .transactions[index].receivableCreated,
                    amount: customerController.transactions[index].amount,
                    transactionType:
                        customerController.transactions[index].transactionType,
                    transactionDate: customerController
                        .transactions[index].transactionDate
                        .toString(),
                  )
                ],
              );
            })
        : ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: supplierController.transactions.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  transactionLogCard(
                    id: supplierController
                        .transactions[index].payableId
                        .toString(),
                    date:
                        supplierController.transactions[index].payableCreated,
                    amount: supplierController.transactions[index].amount,
                    transactionType:
                        supplierController.transactions[index].transactionType,
                    transactionDate: supplierController
                        .transactions[index].transactionDate
                        .toString(),
                  )
                ],
              );
            });
  }

  Container transactionLogCard(
      {required String id,
      required String date,
      required double amount,
      required String transactionDate,
      required String transactionType}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey.shade100,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(4.0, 4.0),
            blurRadius: 10.0,
            spreadRadius: 1.0,
          )
        ],
      ),
      child: Column(
        children: [
          AttributeRow(
              applyToAttribute: true,
              AttributeTextStyle: const TextStyle(color: Colors.green),
              attribute: transactionType == 'payment'
                  ? "Payment#${DateFormat('yyyyMMdd').format(DateTime.parse(date.toString()))}$id"
                  : "Ref#${DateFormat('yyyyMMdd').format(DateTime.parse(date.toString()))}$id",
              value: "\$ $amount"),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              transactionDate,
              style: const TextStyle(fontSize: 10),
            ),
          )
        ],
      ),
    );
  }
}
