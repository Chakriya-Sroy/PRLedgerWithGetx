


// import 'package:flutter/material.dart';



// class ReceivableDetail extends StatefulWidget {
//   final String receivableTitle;
//   final String receivableId;

//   const ReceivableDetail({
//     Key? key,
//     required this.receivableId,
//     required this.receivableTitle,
//   }) : super(key: key);

//   @override
//   State<ReceivableDetail> createState() => _ReceivableDetailState();
// }

// class _ReceivableDetailState extends State<ReceivableDetail> {
//   TextEditingController _paymentController = TextEditingController();
//   TextEditingController _remarkController = TextEditingController();
//   final FireStoreServices firebase = FireStoreServices();
//   String _fileName = '';

//   bool isValidDecimalNumber(String value) {
//   RegExp regex = RegExp(r'^\d+(\.\d{1,2})?$');
//   return regex.hasMatch(value);
// }

//   Future _displayPaymentBottomSheet(
//       BuildContext context,
//       String receivableId,
//       String remainingBalance,
//       TextEditingController paymentController,
//       TextEditingController remarkController,
//       String fileName) {
//     return showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Container(
//           height: 400,
//           width: double.infinity,
//           child: Padding(
//             padding: const EdgeInsets.only(left: 20, right: 20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 InputTextField(
//                   label: 'Payment Amount',
//                   controller: paymentController,
//                   textInputFormator: true,
//                 ),
//                 InputTextField(
//                   label: 'Payment Remark',
//                   controller: remarkController,
//                 ),
//                 AddAttachment(
//                   onFileNameChanged: (newfileName) {
//                     fileName = newfileName;
//                   },
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 InputButton(
//                     label: "Save",
//                     onPress: () {
//                       if(paymentController.text.isEmpty){
//                         Navigator.pop(context);
//                       }
//                       else if(double.parse(paymentController.text)<=0){
//                         showAlertMessageBox(context, Errormessage: "The amount must be greater than 0");
//                       }
//                       else if (double.parse(remainingBalance) >=
//                           double.parse(paymentController.text)) {
//                         //update receivable amount
//                         String newAmount = (double.parse(remainingBalance) -
//                                 double.parse(paymentController.text))
//                             .toString();
//                         firebase.updateReceivableRemaining(
//                             receivableId, newAmount);
//                         //add receivable paid
//                         firebase.addRecievablePayment(
//                           receivableId,
//                           Payment(
//                             amount: paymentController.text,
//                             remark: remarkController.text,
//                             attachment: fileName ?? '',
//                           ),
//                         );
//                         Navigator.pop(context);
                         
//                         showAlertMessageBox(context,
//                                 message: "Payment Successfully Added");
                           
//                       } else if (double.parse(remainingBalance) <
//                           double.parse(paymentController.text)) {
//                         showAlertMessageBox(context,
//                             Errormessage:
//                                 "The amount that enter exceed the remaining balance");
//                         // Navigator.pop(context);
//                       }
//                     },
//                     backgroundColor: Colors.green,
//                     color: Colors.white)
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // void RefreshPage() {
//   //   setState(() {
//   //      FetchReceivableDetail(widget.receivableId);
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.receivableTitle,
//           style: TextStyle(fontSize: 15),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(30),
//         child:FetchReceivableDetail(widget.receivableId)
//       ),
//     );
//   }
  
//   StreamBuilder<QuerySnapshot> FetchPaymentDetail({required String receivableId}) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: firebase.getsReceivablePaymentDetail(receivableId),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//               return Text("Something went wrong");
//         }
//         if (snapshot.hasData) {
//           List paymentDetail = snapshot.data!.docs;
//           return Container(
//                 margin: const EdgeInsets.only(top: 15,bottom: 15),
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context, index) {
//                     DocumentSnapshot document = paymentDetail[index];
//                     return PaymentDetailExpansionTile(paymentAmount: document["paymentAmount"],paymentDate: document["created_at"],paymentRemark: document["paymentRemark"], paymentAttachment: document["paymentAttachment"],);
//                   },
//                 ),
//               );
          
//         } 
//         return Text("loading");
//       },
//     );
//   }

//   StreamBuilder FetchReceivableDetail(String id) {
//     FireStoreServices firebase = FireStoreServices();
//     return StreamBuilder<DocumentSnapshot>(
//         stream: firebase.getReceivableDetail(id),
//         builder: (context, snapshot) {

//           if (snapshot.hasError) {
//               return Text("Something went wrong");
//           }
//           if (snapshot.hasData) {
//             DocumentSnapshot document = snapshot.data!;
//              String paymentTerm=document["paymentTerm"].toString() =="0" ? "Equal to due Date" :document["paymentTerm"].toString ();
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
               
//                 ReceivableOverview(receivableAmount: document["amount"], receivableRemainingBalance: document["remainingBalance"] , receivableDueDate: document["dueDate"], receivablePaymentTerms: paymentTerm, receivableRemark: document["remark"], receivableAttachment: document["attachment"]),
//                 if (double.parse(document["remainingBalance"]) > 0)
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text('Add Payment'),
//                       IconButton(
//                         onPressed: () => _displayPaymentBottomSheet(context, document.id ,document["remainingBalance"], _paymentController, _remarkController, _fileName),
//                         icon: Icon(Icons.add_box, color: Colors.green),
//                       ),
//                     ],
//                   )
//                 else  Padding(
//                   padding: const EdgeInsets.only(top:15,bottom: 15),
//                   child: Text('Payment has been fully paid'),
//                 ),
//                   /*
//                     * Future Task, where we allow user to archieve any receivable that receive fully paid
//                         // TextButton(onPressed: (){
//                         //     setState(() {
//                         //        widget.receivable.addToAchieve=true;
//                         //     });
//                         // },
//                         // child: Text('Add to achieve',style: TextStyle(color: Colors.red),))
//                     */

                 
//                 FetchPaymentDetail(receivableId:document.id),
//               ],
            
//             );
//           } else {
//             return Text('Loading ...') ;
//           }
//         });
//   }
// }

// // class PaymentDetailExpansionTile extends StatelessWidget {
// //   const PaymentDetailExpansionTile({
// //     super.key,
// //     required this.paymentDate,
// //     required this.paymentAmount,
// //     required this.paymentRemark,
// //     required this.paymentAttachment
// //   });
// //   final Timestamp paymentDate;
// //   final String paymentAmount;
// //   final String paymentRemark;
// //   final String paymentAttachment;
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 10),
// //       child: ExpansionTile(
// //         shape: Border.all(color: Colors.transparent),
// //         title: AttributeRow(
// //           attribute: DateFormat('yyyy/MM/dd')
// //               .format(paymentDate.toDate()),
// //           value: "\$" + paymentAmount,
// //           textStyle: TextStyle(fontSize: 15),
// //         ),
// //         backgroundColor: Colors.grey.shade100,
// //         collapsedBackgroundColor: Colors.grey.shade100,
// //         children: <Widget>[
// //           Padding(
// //             padding: const EdgeInsets.only(
// //                 left: 20, right: 25, bottom: 10),
// //             child: Column(
// //               children: [
// //                 AttributeRow(
// //                   attribute: 'Payment Remark :',
// //                   value: paymentRemark,
// //                   textStyle: TextStyle(fontSize: 12),
// //                 ),
// //                 Row(
// //                   mainAxisAlignment:
// //                       MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Text(
// //                       'Payment Attachment :',
// //                       style: TextStyle(fontSize: 12),
// //                     ),
// //                     showAttachment(
// //                         imagePath:
// //                             paymentAttachment),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           )
// //           // Use document data here if needed
// //         ],
// //       ),
// //     );
// //   }
// // }

// class ReceivableOverview extends StatelessWidget {
//   final String receivableAmount;
//   final String receivableRemark;
//   final String receivableDueDate;
//   final String receivablePaymentTerms;
//   final String receivableAttachment;
//   final String receivableRemainingBalance;
//   const ReceivableOverview({super.key,required this.receivableAmount,required this.receivableRemainingBalance,required this.receivableDueDate,required this.receivablePaymentTerms,required this.receivableRemark,required this.receivableAttachment});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//            AttributeList(
//                   attributes: [
//                     AttributeRowData(
//                         attribute: 'Ref.no:', value: '1001', spaceBetween: 15),
//                     AttributeRowData(
//                         attribute: 'Remark:',
//                         value: receivableRemark,
//                         spaceBetween: 15),
//                     AttributeRowData(
//                         attribute: 'Due Date:',
//                         value: receivableDueDate,
//                         spaceBetween: 15),
//                     AttributeRowData(
//                         attribute: 'Payment Terms:',
//                         value: receivablePaymentTerms,
//                         spaceBetween: 15),
//                     AttributeRowData(
//                         attribute: 'Total amounts:',
//                         value: '\$' + receivableAmount,
//                         spaceBetween: 15),
//                   ],
//                 ),
//                 Text('Attachment'),
//                 const SizedBox(height: 15),
//                 showAttachment(imagePath: receivableAttachment),
//                 const SizedBox(height: 15),
//                 AttributeRow(
//                 attribute: "Payment Details",
//                 value: "Remaining: \$" + receivableRemainingBalance,
//                 ),
               
//         ],
//     );
//   }
// }

