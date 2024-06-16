import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laravelsingup/controller/customer.dart';
import 'package:laravelsingup/pages/merchant/customer/customer.dart';
import 'package:laravelsingup/pages/merchant/customer/customer_detail.dart';
import 'package:laravelsingup/pages/merchant/customer/customer_receivable.dart';
import 'package:laravelsingup/widgets/attribute_row.dart';
import 'package:laravelsingup/widgets/receivable_payables/pr_transaction_log.dart';
import 'package:laravelsingup/widgets/receivable_payables/visualize.dart';

class CustomerLogTransaction extends StatefulWidget {
  const CustomerLogTransaction({super.key});

  @override
  State<CustomerLogTransaction> createState() => _CustomerLogTransactionState();
}

class _CustomerLogTransactionState extends State<CustomerLogTransaction> {
  final customerController = Get.put(CustomerController());
  final String id = Get.arguments;
  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
      customerController.setIsloadingToTrue();
    customerController.fetchIndividualCustomer(id);
    customerController.fetchTransactionLog(id);
    });
   
  }

  @override

  Widget build(BuildContext context) {
    return Obx(() => customerController.customer.value==null
        ? const Center(
           child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(customerController.customer.value!.name,style: const TextStyle(color: Colors.white),),
              centerTitle: true,
              backgroundColor: Colors.green,
              leading: GestureDetector(
                onTap: () {
                  Get.to(const CustomerPage());
                },
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Get.to(const CustomerDetail(), arguments: id);
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
                      Obx(() =>   PRVisualizeCardProgress(
                         
                          title: "Receivables",
                          totalOustanding:
                              customerController.customer.value!.totalReceivableAmount,
                          totalRemainingBalance: customerController
                              .customer.value!.totalRemaining,
                          
                            onPressed: (){
                              Get.to(const CustomerReceivableList(),arguments: customerController.customer.value!.id);
                            },
                          ),
                          
                            ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Transaction's Log"),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(() =>customerController.transactions.isEmpty ? const SizedBox() :const  PRTransactionLog(isReceivable: true))
                    ],
                  )),
            )));
  }
}

// ListView transactionLog(CustomerController customerController) {
//   return ListView.builder(
//       scrollDirection: Axis.vertical,
//       shrinkWrap: true,
//       itemCount: customerController.transactions.length,
//       itemBuilder: (context, index) {
//         return Column(
//           children: [
//             transactionLogCard(
//               receivableId: customerController.transactions[index].receivableId.toString(),
//               receivableCreatedDate: customerController.transactions[index].receivableCreated,
//               amount: customerController.transactions[index].amount,
//               transactionType:
//                   customerController.transactions[index].transactionType,
//               transactionDate: customerController
//                   .transactions[index].transactionDate
//                   .toString(),
//             )
//           ],
//         );
//       });
// }

// Container transactionLogCard(
//     {
//     required String receivableId,
//     required String receivableCreatedDate,
//     required double amount,
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
//             attribute: transactionType == 'receivable' ?"Ref#${DateFormat('yyyyMMdd').format(DateTime.parse(receivableCreatedDate.toString()))}${receivableId}" : "Payment#${DateFormat('yyyyMMdd').format(DateTime.parse(receivableCreatedDate.toString()))}${receivableId}",
//             value: "\$ $amount",
//              applyToValue: true,
//             ValueTextStyle: transactionType == 'receivable' ?const  TextStyle(color: Colors.red,fontWeight: FontWeight.bold): const  TextStyle(color: Colors.green,fontWeight: FontWeight.bold),
//           ),
//         Align(
//           alignment: Alignment.centerRight,
//           child: Text(
//             transactionDate,
//             style: const TextStyle(fontSize: 10),
//           ),
//         )
//       ],
//     ),
//   );
// }
