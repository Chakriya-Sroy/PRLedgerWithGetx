import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/supplier.dart';
import 'package:laravelsingup/home.dart';
import 'package:laravelsingup/model/supplier.dart';
import 'package:laravelsingup/pages/merchant/supplier/supplier_form.dart';
import 'package:laravelsingup/pages/merchant/supplier/supplier_log.dart';
import 'package:laravelsingup/widgets/form/input_button.dart';

class SupplierPage extends StatefulWidget {
  const SupplierPage({Key? key}) : super(key: key);

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  final SupplierController supplierController = Get.put(SupplierController());

  @override
  void initState() {
    // TODO: implement initState
    supplierController.setIsloadingToTrue();
    supplierController.fetchSupplier();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.to(const HomePage());
            },
          ),
          title: const Text(
            'Supplier',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              children: [
                CupertinoSearchTextField(
                  controller: supplierController.search,
                  backgroundColor: Colors.grey.shade100,
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                  onChanged: (value) =>
                      {supplierController.searchTerm.value = value},
                ),
                Obx(() => supplierController.supplierLength.value == 0
                    ? whenSupplierIsEmpthy()
                    : SizedBox(),),
                supplierController.isLoading.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Obx(() => ListView.builder(
                          shrinkWrap: true,
                          itemCount:supplierController.filtersuppliers().length,
                          itemBuilder: (context, index) {
                            SupplierModel filteredSupplier =
                                supplierController.filtersuppliers()[index];
                            return Container(
                              margin: const EdgeInsets.only(top: 20),
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide.none,
                                  left:
                                      BorderSide(width: 5, color: Colors.green),
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
                                    Text(filteredSupplier.name.length > 20
                                        ? filteredSupplier.name
                                                .substring(0, 15) +
                                            '...'
                                        : filteredSupplier.name),
                                    Text(
                                        "\$ ${filteredSupplier.totalRemaining.toString()}")
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.arrow_forward_ios_outlined),
                                  onPressed: () {
                                    Get.to(const SupplierLogTransaction(),
                                        arguments: filteredSupplier.id);
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
        floatingActionButton:
            Obx(() => supplierController.supplierLength.value > 0
                ? FloatingActionButton(
                    onPressed: () {
                      Get.to(const SupplierForm());
                    },
                    backgroundColor: Colors.green,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  )
                : SizedBox()));
  }
}

Container whenSupplierIsEmpthy() {
  return Container(
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.only(top: 50),
    alignment: AlignmentDirectional.center,
    decoration: BoxDecoration(
        color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
    child: Column(children: [
      Text('No Supplier yet, add Supplier ?'),
      const SizedBox(
        height: 20,
      ),
      SizedBox(
          width: 150,
          child: InputButton(
              label: "Add",
              onPress: () {
                Get.to(const SupplierForm());
              },
              backgroundColor: Colors.green,
              color: Colors.white))
    ]),
  );
}
