import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PRListTile extends StatelessWidget {
  final String name;
  final String title;
  final String amount;
  final String status;
  final String date;
  final void Function()? onPressed;
  const PRListTile(
      {super.key,
      required this.name,
      required this.title,
      required this.amount,
      required this.status,
      required this.date,
      required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade300,
                offset: Offset(4.0, 4.0),
                blurRadius: 10.0,
                spreadRadius: 1.0)
          ]),
      child: Column(
        children: [
          ReceivableTileHeader(name: name ),
          ReceivableTileBody(title:title,amount:amount,date:date,status:status),
        ],
      ),
    );
  }

  SizedBox ReceivableTileBody({required String title,required String amount, required String date,required String status}) {
    return SizedBox(
          height: 80,
          child: ListTile(
            leading: Text('1001',style: TextStyle(fontSize: 15),),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text(title,style: TextStyle(fontSize: 12)),
              Text('\$'+amount,style: TextStyle(fontSize: 12),)
            ],),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text( DateFormat('yyyy-MM-dd').format(DateTime.parse(date)),style:TextStyle(fontSize: 10),),
                Text(status,style:TextStyle(fontSize: 10),)
              ],
            ),
            trailing:  IconButton(
                icon: Icon(Icons.arrow_forward_ios_outlined),
                onPressed: onPressed,
              )
          ),
        );
  }

  Container ReceivableTileHeader({required String name}) {
    return Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5))),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 10),
          child: Text(name,style: TextStyle(color: Colors.white),),
        ));
  }
}
