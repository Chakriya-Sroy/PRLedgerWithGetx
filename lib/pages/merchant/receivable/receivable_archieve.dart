import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/receivable.dart';
import 'package:laravelsingup/pages/merchant/receivable/receivable_detail.dart';
import 'package:laravelsingup/widgets/receivable_payables/pr_tile.dart';

class ArchieveReceivables extends StatefulWidget {
  const ArchieveReceivables({super.key});

  @override
  State<ArchieveReceivables> createState() => _ArchieveReceivablesState();
}

class _ArchieveReceivablesState extends State<ArchieveReceivables> {
  final receivableController = Get.put(ReceivableController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      receivableController.setIsloadingToTrue();
      receivableController.fetchArchieveReceivable();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Archieve Receivable',
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
              itemCount: receivableController.archieveReceivables.length,
              itemBuilder: (context, index) {
                return PRListTile(
                    id: receivableController.archieveReceivables[index].id,
                    name: receivableController
                        .archieveReceivables[index].customerName
                        .toString(),
                    amount: receivableController
                        .archieveReceivables[index].remaining
                        .toString(),
                    status:
                        receivableController.archieveReceivables[index].status,
                    date: receivableController.archieveReceivables[index].date
                        .toString(),
                    onPressed: () {
                      Get.to(const ReceivableDetail(),
                          arguments: receivableController
                              .archieveReceivables[index].id);
                    });
              },
            )),
      )),
    );
  }
}
