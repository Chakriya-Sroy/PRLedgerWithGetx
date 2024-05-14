import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/receivable.dart';
import 'package:laravelsingup/home.dart';
import 'package:laravelsingup/widgets/empty_state.dart';
import 'package:laravelsingup/widgets/form/input_button.dart';
import 'package:laravelsingup/widgets/receivable_payables/pr_tile.dart';
import 'receivable_form.dart';

class ReceivablePage extends StatefulWidget {
  const ReceivablePage({super.key});

  @override
  State<ReceivablePage> createState() => _ReceivablePageState();
}

class _ReceivablePageState extends State<ReceivablePage> {
  final receivableController = Get.put(ReceivableController());
  @override
  void initState() {
    // TODO: implement initState
    receivableController.setIsloadingToTrue();
    receivableController.fetchReceivable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Receivable',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.to(const HomePage());
            },
          ),
          //  iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child:
                Obx(() => receivableController.lengthofReceivableList.value == 0
                    ? WhenListIsEmpty(title: 'No Receivable yet, add Receivable ?', onPressed: (){})
                    : Obx(() => ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    receivableController.receivables.length,
                                itemBuilder: (context, index) {
                                  return PRListTile(
                                      name: receivableController
                                          .receivables[index].customerName
                                          .toString(),
                                      title: receivableController
                                                  .receivables[index]
                                                  .title
                                                  .length >
                                              20
                                          ? receivableController
                                                  .receivables[index].title
                                                  .substring(0, 15) +
                                              '...'
                                          : receivableController
                                              .receivables[index].title,
                                      amount: receivableController
                                          .receivables[index].amount
                                          .toString(),
                                      status: receivableController
                                          .receivables[index].status,
                                      date: receivableController.receivables[index].date
                                          .toString(),
                                      onPressed: () {});
                                },
                              )),
                    )
                            ),
          ),
        floatingActionButton:
            Obx(() => receivableController.lengthofReceivableList.value > 0
                ? FloatingActionButton(
                    onPressed: () {
                      //  Get.to(const ReceivableForm());
                    },
                    backgroundColor: Colors.green,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  )
                : const SizedBox()));
  }

  
}
