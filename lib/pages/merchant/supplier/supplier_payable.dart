import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laravelsingup/controller/supplier.dart';
import 'package:laravelsingup/pages/merchant/payable/payable_detail.dart';
import 'package:laravelsingup/pages/merchant/receivable/receivable_detail.dart';
class SupplierPayableList extends StatefulWidget {
  
  const SupplierPayableList({super.key});

  @override
  State<SupplierPayableList> createState() => _SupplierPayableListState();
}

class _SupplierPayableListState extends State<SupplierPayableList> {
  final supplierController =Get.put(SupplierController());
  String id =Get.arguments;
  @override
  void initState() {
    // TODO: implement initState  
   super.initState();
   
    WidgetsBinding.instance.addPostFrameCallback((_) {
   supplierController.fetchIndividualSupplier(id);
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => supplierController.supplier.value ==null 
      ? Center(
          child: CircularProgressIndicator(),
      )
      :
      Scaffold(
      appBar: AppBar(
        title: Text(
          "${supplierController.supplier.value!.name}'s payables",
          style: TextStyle(color: Colors.white,fontSize: 15),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [getSupplierPayable(supplierController)],
          ),
        ),
      ),
    )
     
    );
  }

 getSupplierPayable(SupplierController supplierController) {
  
    return Obx(() => supplierController.supplierPayables.length ==0 ?Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(top: 50),
                alignment: AlignmentDirectional.center,
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10)),
                child: Text("There no payable added yet"),
              ):ListView.builder(
              shrinkWrap: true,
              itemCount: supplierController.supplierPayables.length,
              itemBuilder: (context, index) {
                return SupplierPayableCard(
                  // title: supplierController.SupplierPayables[index].title,
                  remaining: supplierController.supplierPayables[index].remaining.toString(),
                  date: supplierController.supplierPayables[index].date,
                  status: supplierController.supplierPayables[index].status,
                  onPressed: (){
                    Get.to(const PayableDetail(),arguments: supplierController.supplierPayables[index].id);
                  }
                );
              },
            )
            );
 }

 Container SupplierPayableCard({String ?title,required String remaining,required String date,required String status,required Function() onPressed}) {
   return Container(
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border(left:BorderSide(color: Colors.green,width: 5) ),
                      color: Colors.grey.shade100,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            offset: Offset(4.0, 4.0),
                            blurRadius: 10.0,
                            spreadRadius: 1.0)
                      ]),
                  child: SizedBox(
                    height: 80,
                    child: ListTile(
                        leading: Text(
                          '1001',
                          style: TextStyle(fontSize: 15),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(title ?? '',
                                style: TextStyle(fontSize: 12)),
                            Text(
                              '\$' + remaining,
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('yyyy-MM-dd').format(DateTime.parse(date)),
                              style: TextStyle(fontSize: 10),
                            ),
                            Text(
                              status,
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_forward_ios_outlined),
                          onPressed: onPressed,
                        )),
                  ));
}}