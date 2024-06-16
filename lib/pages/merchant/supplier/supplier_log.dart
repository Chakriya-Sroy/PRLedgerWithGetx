import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laravelsingup/controller/supplier.dart';
import 'package:laravelsingup/pages/merchant/supplier/supplier.dart';
import 'package:laravelsingup/pages/merchant/supplier/supplier_detail.dart';
import 'package:laravelsingup/pages/merchant/supplier/supplier_payable.dart';
import 'package:laravelsingup/widgets/attribute_row.dart';
import 'package:laravelsingup/widgets/receivable_payables/pr_transaction_log.dart';
import 'package:laravelsingup/widgets/receivable_payables/visualize.dart';

class SupplierLogTransaction extends StatefulWidget {
  const SupplierLogTransaction({super.key});

  @override
  State<SupplierLogTransaction> createState() => _SupplierLogTransactionState();
}

class _SupplierLogTransactionState extends State<SupplierLogTransaction> {
  final supplierController = Get.put(SupplierController());
  final String id = Get.arguments;
  @override
  void initState() {
    super.initState();
    supplierController.setIsloadingToTrue();
    supplierController.fetchIndividualSupplier(id);
    supplierController.fetchTransactionLog(id);
  }

  @override

  Widget build(BuildContext context) {
    return Obx(() => supplierController.supplier.value==null
        ? const Center(
           child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(supplierController.supplier.value!.name,style: const TextStyle(color: Colors.white),),
              centerTitle: true,
              backgroundColor: Colors.green,
              leading: GestureDetector(
                onTap: () {
                  Get.off(const SupplierPage());
                },
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Get.to(const SupplierDetail(), arguments: id);
                    },
                    child: const Text(
                      'Detail',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      PRVisualizeCardProgress(
                          title: "Payables",
                          totalOustanding:supplierController.supplier.value!.totalPayableAmount,
                          totalRemainingBalance: supplierController
                              .supplier.value!.totalRemaining,
                          onPressed: (){
                            Get.to(const SupplierPayableList(),arguments: supplierController.supplier.value!.id);
                          },    
                        ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Transaction's Log"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(() =>supplierController.transactionLength.value == 0 ? const SizedBox() : const PRTransactionLog(isReceivable: false) )
                    ],
                  )),
            )));
  }
}

// ListView transactionLog(SupplierController supplierController) {
//   return ListView.builder(
//       scrollDirection: Axis.vertical,
//       shrinkWrap: true,
//       itemCount: supplierController.transactions.length,
//       itemBuilder: (context, index) {
//         return Column(
//           children: [
//             transactionLogCard(
//               payableId: supplierController.transactions[index].payableId.toString(),
//               payableCreatedDate: supplierController.transactions[index].payableCreated.toString(),
//               amount: supplierController.transactions[index].amount,
//               transactionType:
//                   supplierController.transactions[index].transactionType,
//               transactionDate: supplierController
//                   .transactions[index].transactionDate
//                   .toString(),
//             )
//           ],
//         );
//       });
// }

// Container transactionLogCard(
//     {required double amount,
//     required String payableId,
//     required String payableCreatedDate,
//     required String transactionDate,
//     required String transactionType}) {
//   return Container(
//     width: double.infinity,
//     margin: const EdgeInsets.only(bottom: 20),
//     padding: const EdgeInsets.all(20),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(5),
//       color: Colors.grey.shade100,
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.shade300,
//           offset: const Offset(4.0, 4.0),
//           blurRadius: 10.0,
//           spreadRadius: 1.0,
//         )
//       ],
//     ),
//     child: Column(
//       children: [
//         AttributeRow(
//             applyToAttribute: true,
//             AttributeTextStyle: const TextStyle(color: Colors.green),
//             attribute: transactionType == 'payable' ?"Ref#${DateFormat('yyyyMMdd').format(DateTime.parse(payableCreatedDate))}$payableId" :"Payment#${DateFormat('yyyyMMdd').format(DateTime.parse(payableCreatedDate))}$payableId",
//             value: "\$ $amount",
//             applyToValue: true,
//             ValueTextStyle: transactionType == 'payable' ?const  TextStyle(color: Colors.red,fontWeight: FontWeight.bold): const  TextStyle(color: Colors.green,fontWeight: FontWeight.bold),
//             ),
//         // const SizedBox(height: 5,),
//         // AttributeRow(attribute: transactionType == 'payable' ? '' :'Payment' , value: transactionDate)
//         Align(
//           alignment: Alignment.centerRight,
//           child: Text(
//             transactionDate,
//             style: TextStyle(fontSize: 10),
//           ),
//         )
//       ],
//     ),
//   );
// }
