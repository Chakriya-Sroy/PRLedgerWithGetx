import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/receivable.dart';
import 'package:laravelsingup/pages/merchant/receivable/receivable_detail.dart';
import 'package:laravelsingup/widgets/receivable_payables/pr_tile.dart';

class AssignReceivables extends StatefulWidget {
  const AssignReceivables({super.key});

  @override
  State<AssignReceivables> createState() => _AssignReceivablesState();
}

class _AssignReceivablesState extends State<AssignReceivables> {
  final receivableController = Get.put(ReceivableController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      receivableController.setIsloadingToTrue();
      receivableController.fetchAssignReceivable();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Receivables',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(() => ListView.builder(
              shrinkWrap: true,
              itemCount: receivableController.assignReceivables.length,
              itemBuilder: (context, index) {
                return PRListTile(
                    id: receivableController.assignReceivables[index].id,
                    name: receivableController
                        .assignReceivables[index].customerName
                        .toString(),
                    amount: receivableController
                        .assignReceivables[index].remaining
                        .toString(),
                    status:
                        receivableController.assignReceivables[index].status,
                    date: receivableController.assignReceivables[index].date
                        .toString(),
                    onPressed: () {
                      Get.to(const ReceivableDetail(),
                          arguments: receivableController
                              .assignReceivables[index].id);
                    });
              },
            )),
      )),
    );
  }
}
