import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PRUpcomingCard extends StatelessWidget {
  const PRUpcomingCard({
    Key? key,
    required this.id,
    required this.date,
    required this.name,
    required this.remainingBalance,
    required this.dueStatus,
    required this.status,
  }) : super(key: key);

  final String id;
  final String date;
  final String name;
  final String remainingBalance;
  final String dueStatus;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 15, bottom: 10),
      width: MediaQuery.of(context).size.width - 45,
      height: 80,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: const Offset(4.0, 4.0),
            blurRadius: 4.0,
            spreadRadius: 0.0,
          )
        ],
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ref${DateFormat('yyyyMMdd').format(DateTime.parse(date))}$id",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Text(name),
              Text(
                "\$ $remainingBalance",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.red),
              ),
            ],
          ),

          const SizedBox(height: 8), // Adjust spacing between title and subtitle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dueStatus,
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                status,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
