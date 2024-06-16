import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/customer.dart';
import 'package:laravelsingup/model/customer.dart';
import 'package:laravelsingup/pages/collector/customer/customer_log.dart';

class CollectorCustomerPage extends StatefulWidget {
  const CollectorCustomerPage({Key? key}) : super(key: key);

  @override
  State<CollectorCustomerPage> createState() => _CollectorCustomerPageState();
}

class _CollectorCustomerPageState extends State<CollectorCustomerPage> {
  final CustomerController customerController = Get.put(CustomerController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      customerController.setIsloadingToTrue();
      customerController.fetchAssignCustomer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text(
            'customer',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                children: [
                  CupertinoSearchTextField(
                    controller: customerController.search,
                    backgroundColor: Colors.grey.shade100,
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 15, right: 15),
                    onChanged: (value) =>
                        {customerController.searchTerm.value = value},
                  ),
                  Obx(
                    () => customerController.assignCustomerLength.value == 0
                        ? whenCustomerisEmpty()
                        : const SizedBox(),
                  ),
                  customerController.isLoading.value
                      ? const  Center(
                          child: CircularProgressIndicator(),
                        )
                      : Obx(() => ListView.builder(
                            shrinkWrap: true,
                            itemCount: customerController
                                .filterAssignCustomers()
                                .length,
                            itemBuilder: (context, index) {
                              CustomerModel filteredCustomer =
                                  customerController
                                      .filterAssignCustomers()[index];
                              return Container(
                                margin: const EdgeInsets.only(top: 20),
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                decoration: BoxDecoration(
                                  border:const  Border(
                                    top: BorderSide.none,
                                    left: BorderSide(
                                        width: 5, color: Colors.green),
                                    bottom: BorderSide.none,
                                    right: BorderSide.none,
                                  ),
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(filteredCustomer.name.length > 20
                                          ? filteredCustomer.name
                                                  .substring(0, 15) +
                                              '...'
                                          : filteredCustomer.name),
                                      Text(
                                          "\$ ${filteredCustomer.totalRemaining.toString()}")
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon:
                                        const Icon(Icons.arrow_forward_ios_outlined),
                                    onPressed: () {
                                      Get.to(const CustomerLogTransaction(),
                                          arguments: filteredCustomer.id);
                                    },
                                  ),
                                ),
                              );
                            },
                          )),
                ],
              ),
            ),
          ),
        ));
  }
}

Container whenCustomerisEmpty() {
  return Container(
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.only(top: 50),
    alignment: AlignmentDirectional.center,
    decoration: BoxDecoration(
        color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
    child: const Column(children: [
      Text("Merchance haven't assign any customer yet"),
      SizedBox(
        height: 20,
      ),
    ]),
  );
}
