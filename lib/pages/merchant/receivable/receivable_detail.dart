import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/receivable.dart';
import 'package:laravelsingup/pages/merchant/receivable/receivable_page.dart';
import 'package:laravelsingup/widgets/receivable_payables/display_payment_sheet.dart';
import 'package:laravelsingup/widgets/receivable_payables/pr_overview.dart';
import 'package:laravelsingup/widgets/receivable_payables/pr_payment.dart';

class ReceivableDetail extends StatefulWidget {
  const ReceivableDetail({super.key});

  @override
  State<ReceivableDetail> createState() => _ReceivableDetailState();
}

class _ReceivableDetailState extends State<ReceivableDetail> {
  final receivableController = Get.put(ReceivableController());
  String id = Get.arguments;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      receivableController.setIsloadingToTrue();
      receivableController.fetchIndividualReceivable(id);
      receivableController.receivableID.value = id;
      receivableController.amount.clear();
      receivableController.remark.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => receivableController.receivable.value == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              // title: Text(
              //   receivableController.receivable.value!.title,
              //   style: TextStyle(fontSize: 15),
              // ),
              leading: GestureDetector(
                onTap: () {
                  Get.to(const ReceivablePage());
                },
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => PROverview(
                            receivableAmount: receivableController
                                .receivable.value!.amount
                                .toString(),
                            receivableRemainingBalance: receivableController
                                .receivable.value!.remaining
                                .toString(),
                            receivableDueDate:
                                receivableController.receivable.value!.dueDate,
                            receivablePaymentTerms: receivableController
                                .receivable.value!.paymentTerm,
                            receivableRemark: receivableController
                                .receivable.value!.remark
                                .toString(),
                            receivableAttachment: receivableController
                                .receivable.value!.attachment
                                .toString()),
                      ),
                      Obx(
                        () => receivableController.receivable.value!.remaining >
                                0
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Add Payment'),
                                  IconButton(
                                    onPressed: () {
                                      displayPaymentBottomSheet(context,
                                          receivableId: receivableController
                                              .receivable.value!.id,
                                          remainingBalance: receivableController
                                              .receivable.value!.remaining
                                              .toString(),
                                          paymentController:
                                              receivableController.amount,
                                          remarkController: receivableController
                                              .remark, onSubmit: () async {
                                        receivableController
                                            .setIsloadingToTrue();
                                        await receivableController
                                            .createReceivablePayment();
                                        Navigator.pop(context);
                                        receivableController
                                            .fetchIndividualReceivable(id);
                                        if (receivableController
                                            .isSuccess.value) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Obx(
                                                () => Text(
                                                    receivableController.message
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ),
                                            ),
                                          );
                                        }
                                      });
                                    },
                                    icon: Icon(Icons.add_box,
                                        color: Colors.green),
                                  ),
                                ],
                              )
                            : const Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 15),
                                child: Text('Payment has been fully paid'),
                              ),
                      ),
                      Obx(() => Container(
                            margin: const EdgeInsets.only(top: 15, bottom: 15),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: receivableController
                                  .receivablePayments.length,
                              itemBuilder: (context, index) {
                                return PaymentDetailExpansionTile(
                                  paymentAmount: receivableController
                                      .receivablePayments[index].amount,
                                  paymentDate: receivableController
                                      .receivablePayments[index].date,
                                  paymentRemark: receivableController
                                      .receivablePayments[index].remark
                                      .toString(),
                                  paymentAttachment: receivableController
                                      .receivablePayments[index].attachment
                                      .toString(),
                                );
                              },
                            ),
                          ))
                    ],
                  )),
            ),
          ));
  }
}



/*
 * Future Task, where we allow user to archieve any receivable that receive fully paid
      // TextButton(onPressed: (){
       //     setState(() {
   //        widget.receivable.addToAchieve=true;
                        //     });
                        // },
                        // child: Text('Add to achieve',style: TextStyle(color: Colors.red),))                                                                     
*/
// FetchPaymentDetail(ReceivableController receivableController) {
//   return Container(
//     margin: const EdgeInsets.only(top: 15, bottom: 15),
//     child: ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: receivableController.receivablePayments.length,
//       itemBuilder: (context, index) {
//         return PaymentDetailExpansionTile(
//           paymentAmount:
//               receivableController.receivablePayments[index].amount.toString(),
//           paymentDate: receivableController.receivablePayments[index].date,
//           paymentRemark:
//               receivableController.receivablePayments[index].remark.toString(),
//           paymentAttachment: receivableController
//               .receivablePayments[index].attachment
//               .toString(),
//         );
//       },
//     ),
//   );
// }

// FetchReceivableDetail(ReceivableController receivableController) {
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Obx(
//         () => PROverview(
//             receivableAmount:
//                 receivableController.receivable.value!.amount.toString(),
//             receivableRemainingBalance:
//                 receivableController.receivable.value!.remaining.toString(),
//             receivableDueDate: receivableController.receivable.value!.dueDate,
//             receivablePaymentTerms:
//                 receivableController.receivable.value!.paymentTerm,
//             receivableRemark:
//                 receivableController.receivable.value!.remark.toString(),
//             receivableAttachment:
//                 receivableController.receivable.value!.attachment.toString()),
//       ),
//       if (double.parse(
//               receivableController.receivable.value!.remaining.toString()) >
//           0)
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('Add Payment'),
//             IconButton(
//               onPressed: () {
//                 // _displayPaymentBottomSheet(
//                 // context, document.id,
//                 // document["remainingBalance"],
//                 // _paymentController,
//                 // _remarkController,
//                 //  _fileName),
//               },
//               icon: Icon(Icons.add_box, color: Colors.green),
//             ),
//           ],
//         )
//       else
//         Padding(
//           padding: const EdgeInsets.only(top: 15, bottom: 15),
//           child: Text('Payment has been fully paid'),
//         ),
//       /*
//                     * Future Task, where we allow user to archieve any receivable that receive fully paid
//                         // TextButton(onPressed: (){
//                         //     setState(() {
//                         //        widget.receivable.addToAchieve=true;
//                         //     });
//                         // },
//                         // child: Text('Add to achieve',style: TextStyle(color: Colors.red),))
//                     */

//       FetchPaymentDetail(receivableController)
//     ],
//   );
// }
