import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PRListTile extends StatelessWidget {
  final String name;
  final String amount;
  final String status;
  final String date;
  final String id;
  final void Function()? onPressed;
  const PRListTile(
      {super.key,
      required this.id,
      required this.name,
      required this.amount,
      required this.status,
      required this.date,
      required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade300,
                offset: const Offset(4.0, 4.0),
                blurRadius: 10.0,
                spreadRadius: 1.0)
          ]),
      child: Column(
        children: [
          receivableTileHeader(name: name),
          receivableTileBody(id:id,amount: amount, date: date, status: status),
        ],
      ),
    );
  }

  SizedBox receivableTileBody(
      {String? title,
      required String id,
      required String amount,
      required String date,
      required String status}) {
    return SizedBox(
      height: 80,
      child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ref${DateFormat('yyyyMMdd').format(DateTime.parse(date))}${id}",
                style: const TextStyle(fontSize: 15),
              ),
              Text(
                '\$' + amount,
                style: const TextStyle(fontSize: 12),
              )
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('yyyy-MM-dd').format(DateTime.parse(date)),
                style: const TextStyle(fontSize: 10),
              ),
              Text(
                status,
                style: const  TextStyle(fontSize: 10),
              )
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios_outlined),
            onPressed: onPressed,
          )),
    );
  }

  Container receivableTileHeader({required String name}) {
    return Container(
        width: double.infinity,
        height: 40,
        decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5))),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 10),
          child: Text(
            name,
            style: const TextStyle(color: Colors.white),
          ),
        ));
  }
}
