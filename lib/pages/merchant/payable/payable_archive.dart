import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/payable.dart';
import 'package:laravelsingup/home.dart';
import 'package:laravelsingup/pages/merchant/payable/payable_detail.dart';
import 'package:laravelsingup/pages/merchant/payable/payable_form.dart';
import 'package:laravelsingup/widgets/empty_state.dart';
import 'package:laravelsingup/widgets/receivable_payables/pr_tile.dart';

class ArchivePayablePagee extends StatefulWidget {
  const ArchivePayablePagee({super.key});

  @override
  State<ArchivePayablePagee> createState() => _ArchivePayablePageeState();
}

class _ArchivePayablePageeState extends State<ArchivePayablePagee> {
  final payableController = Get.put(PayableController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      payableController.setIsloadingToTrue();
      payableController.fetchArchievePayables();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Archieve Payable ",
            style: TextStyle(color: Colors.white),
          ),
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child:
                  Obx(() => ListView.builder(
                                shrinkWrap: true,
                                itemCount: payableController.archivePayables.length,
                                itemBuilder: (context, index) {
                                  return PRListTile(
                                      id: payableController.archivePayables[index].id,
                                      name: payableController
                                          .archivePayables[index].supplierrName
                                          .toString(),
                                      amount: payableController
                                          .archivePayables[index].remaining
                                          .toString(),
                                      status: payableController
                                          .archivePayables[index].status,
                                      date: payableController
                                          .archivePayables[index].date
                                          .toString(),
                                      onPressed: () {
                                        Get.to(const PayableDetail(),
                                            arguments: payableController
                                                .archivePayables[index].id);
                                      });
                                },
                              )),
                    ))
        
       );
  }
}
