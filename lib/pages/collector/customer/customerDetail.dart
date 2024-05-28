import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/customer.dart';
import 'package:laravelsingup/pages/collector/customer/customer_log.dart';
import 'package:laravelsingup/widgets/profile/profile_card.dart';

class CustomerDetail extends StatefulWidget {
  const CustomerDetail({super.key});

  @override
  State<CustomerDetail> createState() => _CustomerDetailState();
}

class _CustomerDetailState extends State<CustomerDetail> {
  final CustomerController customerController = Get.put(CustomerController());
  final String id = Get.arguments;

  @override
  void initState() {
    // Make sure that is Failed , isSuccess, erorrMessage and message haven't initalize
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      customerController.initializeStatusFlags();
      customerController.fetchIndividualCustomer(id);
    });
  }

  List<String> amount = [];

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.green,
            ),
          ),
        ),
        body: Obx(() => customerController.customer.value == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProfileCard(
                          supplier: false,
                          fullname: customerController.customer.value!.name,
                          gender: customerController.customer.value!.gender,
                          email: customerController.customer.value!.email ?? '',
                          address:customerController.customer.value!.address ?? '',
                          phone: customerController.customer.value!.phone),
                    ],
                  ),
                ),
              )));
  }
}
