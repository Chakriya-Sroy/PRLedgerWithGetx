import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/payable.dart';


class PayableForm extends StatefulWidget {
  const PayableForm({super.key});

  @override
  State<PayableForm> createState() => _PayableFormState();
}

class _PayableFormState extends State<PayableForm> {
  final payableController =Get.put(PayableController());
 @override
  void initState() {
    // TODO: implement initState
    payableController.fetchSupplier();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}