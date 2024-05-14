// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:payable_receivable_ui/pages/merchance/receivable/receivable_detail.dart';
// import 'package:payable_receivable_ui/services/firestore.dart';

// // import '../../../services/firestore.dart';
// // import '../receivable/receivable_detail.dart';


// class CustomerReceivableList extends StatefulWidget {
//   final String customerId;
//   const CustomerReceivableList({super.key, required this.customerId});

//   @override
//   State<CustomerReceivableList> createState() => _CustomerReceivableListState();
// }

// class _CustomerReceivableListState extends State<CustomerReceivableList> {
//   void viewReceivableDetail(String recievableId, String receivableTitle) {
//     Navigator.push(context, MaterialPageRoute(builder: (context) {
//       return ReceivableDetail(
//           receivableId: recievableId, receivableTitle: receivableTitle);
//     }));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Customer's Receivables",
//           style: TextStyle(color: Colors.white,fontSize: 15),
//         ),
//         iconTheme: IconThemeData(color: Colors.white),
//         backgroundColor: Colors.green,
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//           child: Column(
//             children: [getCustomerReceivable(customerId: widget.customerId)],
//           ),
//         ),
//       ),
//     );
//   }

//   StreamBuilder getCustomerReceivable({required String customerId}) {
//     FireStoreServices firebase = FireStoreServices();
//     return StreamBuilder<QuerySnapshot>(
//         stream: firebase.getCustomerReceivable(customerId),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             List receivable = snapshot.data!.docs;
//             if (receivable.length == 0) {
//               return Container(
//                 padding: const EdgeInsets.all(20),
//                 margin: const EdgeInsets.only(top: 50),
//                 alignment: AlignmentDirectional.center,
//                 decoration: BoxDecoration(
//                     color: Colors.grey.shade100,
//                     borderRadius: BorderRadius.circular(10)),
//                 child: Text("There no receivable added yet"),
//               );
//             }
//             return ListView.builder(
//               shrinkWrap: true,
//               itemCount: receivable.length,
//               itemBuilder: (context, index) {
//                 DocumentSnapshot document = receivable[index];
//                 String receivableId = document.id;
//                 String receivableTitile = document["title"];
//                 return Container(
//                     margin: EdgeInsets.only(bottom: 20),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         border: Border(left:BorderSide(color: Colors.green,width: 5) ),
//                         color: Colors.grey.shade100,
//                         boxShadow: [
//                           BoxShadow(
//                               color: Colors.grey.shade300,
//                               offset: Offset(4.0, 4.0),
//                               blurRadius: 10.0,
//                               spreadRadius: 1.0)
//                         ]),
//                     child: SizedBox(
//                       height: 80,
//                       child: ListTile(
//                           leading: Text(
//                             '1001',
//                             style: TextStyle(fontSize: 15),
//                           ),
//                           title: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(document["title"],
//                                   style: TextStyle(fontSize: 12)),
//                               Text(
//                                 '\$' + document["remainingBalance"],
//                                 style: TextStyle(fontSize: 12),
//                               )
//                             ],
//                           ),
//                           subtitle: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 document["date"],
//                                 style: TextStyle(fontSize: 10),
//                               ),
//                               Text(
//                                 document["status"],
//                                 style: TextStyle(fontSize: 10),
//                               )
//                             ],
//                           ),
//                           trailing: IconButton(
//                             icon: Icon(Icons.arrow_forward_ios_outlined),
//                             onPressed: () {
//                               viewReceivableDetail(
//                                   receivableId, receivableTitile);
//                             },
//                           )),
//                     ));
//               },
//             );
//           } else {
//             return SizedBox();
//           }
//         });
//   }
// }
