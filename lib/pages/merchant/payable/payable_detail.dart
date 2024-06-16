import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/payable.dart';
import 'package:laravelsingup/pages/merchant/payable/payable.dart';
import 'package:laravelsingup/widgets/form/input_button.dart';
import 'package:laravelsingup/widgets/receivable_payables/display_payment_sheet.dart';
import 'package:laravelsingup/widgets/receivable_payables/pr_overview.dart';
import 'package:laravelsingup/widgets/receivable_payables/pr_payment.dart';

class PayableDetail extends StatefulWidget {
  const PayableDetail({super.key});

  @override
  State<PayableDetail> createState() => _PayableDetailState();
}

class _PayableDetailState extends State<PayableDetail> {
  final payableController = Get.put(PayableController());
  String id = Get.arguments;
  late ValueNotifier<File?> attachmentFileNotifier = ValueNotifier<File?>(null);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      payableController.setIsloadingToTrue();
      payableController.fetchIndividualPayable(id);
      payableController.payableId.value = id;
    });
  }
   void showSnackBar(bool isSuccess,bool isFailed,String message,
      String errorMessage) {
    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(message, style: const TextStyle(color: Colors.white)),
        ),
      );
      Get.off(const PayablePage());
    } 
    if(isFailed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(errorMessage, style: const TextStyle(color: Colors.white)),
        ),
      );
      Get.off(const PayablePage());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Obx(() => payableController.payable.value == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              // title: Text(
              //   payableController.payable.value!.title,
              //   style: TextStyle(fontSize: 15),
              // ),
              leading: GestureDetector(
                onTap: () {
                  Get.to(const PayablePage());
                },
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Stack(
                children: [
                Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PayableOverview(),
                        PayableAddPaymentButton(context),
                        PayablePaymentDetailList(),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    )),
                PayableAddToArchieveButton(),
                Obx(() => payableController.isLoading.value
                    ? Container(
                        color: Colors.black.withOpacity(
                            0.2), // Semi-transparent black color for the backdrop
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : const SizedBox())
              ]),
            ),
          ));
  }

  Obx PayableAddToArchieveButton() {
    return Obx(() => payableController.payable.value!.remaining == 0
        ? Positioned(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: InputButton(
                  label: "Add To Archieve",
                  onPress: () async {
                    await payableController.archievePayable(payableController.payable.value!.id);
                    showSnackBar(
                      payableController.isSuccess.value, 
                      payableController.isFailed.value, 
                      payableController.message.value, 
                      payableController.errorMessage.value
                    );
                  },
                  backgroundColor: Colors.green,
                  color: Colors.white),
            ),
          )
        : const SizedBox());
  }

  Obx PayableOverview() {
    return Obx(
      () => PROverview(
          id: payableController.payable.value!.id,
          receivableAmount: payableController.payable.value!.amount.toString(),
          receivableRemainingBalance:
              payableController.payable.value!.remaining.toString(),
          receivableDueDate: payableController.payable.value!.dueDate,
          receivablePaymentTerms: payableController.payable.value!.paymentTerm,
          receivableRemark: payableController.payable.value!.remark.toString(),
          receivableAttachment:
              payableController.payable.value!.attachment.toString()),
    );
  }

  Obx PayablePaymentDetailList() {
    return Obx(() => Expanded(
      child: Container(
            margin: const EdgeInsets.only(top: 15, bottom: 15),
            child: ListView.builder(
              shrinkWrap: true,
              //physics: NeverScrollableScrollPhysics(),
              physics: BouncingScrollPhysics(),
              itemCount: payableController.payablePayments.length,
              itemBuilder: (context, index) {
                return PaymentDetailExpansionTile(
                  paymentAmount: payableController.payablePayments[index].amount,
                  paymentDate: payableController.payablePayments[index].date,
                  paymentRemark:
                      payableController.payablePayments[index].remark.toString(),
                  paymentAttachment: payableController
                      .payablePayments[index].attachment
                      .toString(),
                );
              },
            ),
          ),
    ));
  }

  Obx PayableAddPaymentButton(BuildContext context) {
    return Obx(
      () => payableController.payable.value!.remaining > 0
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Add Payment'),
                IconButton(
                  onPressed: () {
                    displayPaymentBottomSheet(context,
                        //  attachmentNotifier: attachmentFileNotifier,
                        receivableId: payableController.payable.value!.id,
                        remainingBalance: payableController
                            .payable.value!.remaining
                            .toString(),
                        paymentController: payableController.amount,
                        remarkController: payableController.remark,
                        onSubmit: () async {
                      payableController.setIsloadingToTrue();
                      await payableController.createPayablePayment();
                      Navigator.pop(context);
                      payableController.fetchIndividualPayable(id);
                      if (payableController.isSuccess.value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Obx(
                              () => Text(payableController.message.toString(),
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        );
                      }
                    });
                  },
                  icon: Icon(Icons.add_box, color: Colors.green),
                ),
              ],
            )
          : const Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Text('Payment has been fully paid'),
            ),
    );
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
// FetchPaymentDetail(payableController payableController) {
//   return Container(
//     margin: const EdgeInsets.only(top: 15, bottom: 15),
//     child: ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: payableController.payablePayments.length,
//       itemBuilder: (context, index) {
//         return PaymentDetailExpansionTile(
//           paymentAmount:
//               payableController.payablePayments[index].amount.toString(),
//           paymentDate: payableController.payablePayments[index].date,
//           paymentRemark:
//               payableController.payablePayments[index].remark.toString(),
//           paymentAttachment: payableController
//               .payablePayments[index].attachment
//               .toString(),
//         );
//       },
//     ),
//   );
// }

// FetchPayableDetail(payableController payableController) {
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Obx(
//         () => PROverview(
//             receivableAmount:
//                 payableController.payable.value!.amount.toString(),
//             receivableRemainingBalance:
//                 payableController.payable.value!.remaining.toString(),
//             receivableDueDate: payableController.payable.value!.dueDate,
//             receivablePaymentTerms:
//                 payableController.payable.value!.paymentTerm,
//             receivableRemark:
//                 payableController.payable.value!.remark.toString(),
//             receivableAttachment:
//                 payableController.payable.value!.attachment.toString()),
//       ),
//       if (double.parse(
//               payableController.payable.value!.remaining.toString()) >
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

//       FetchPaymentDetail(payableController)
//     ],
//   );
// }
