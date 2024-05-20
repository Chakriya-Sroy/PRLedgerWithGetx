import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laravelsingup/controller/receivable.dart';


class ReceivableDueDate extends StatefulWidget {
  const ReceivableDueDate({super.key});

  @override
  State<ReceivableDueDate> createState() => _ReceivableDueDateState();
}

class _ReceivableDueDateState extends State<ReceivableDueDate> {
  final receivableController =Get.put(ReceivableController());
  void _openDatePicker(BuildContext context) {
    BottomPicker.date(
      pickerTitle: Text('Select Date',),
      pickerTextStyle: TextStyle(color: Colors.green, fontSize: 18),
      dateOrder: DatePickerDateOrder.ymd,
      minDateTime: DateTime.now(),
      onSubmit: (index) {
         receivableController.selectedDueDate.value=DateFormat('yyyy-MM-dd').format(index);
      },
      onChange: (index) {
         receivableController.selectedDueDate.value=DateFormat('yyyy-MM-dd').format(index);
      },
      
      buttonStyle: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.blue[200]!,
        ),
      ),
      bottomPickerTheme: BottomPickerTheme.blue,
    ).show(context);
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Select Due Date"),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 50,
          padding: const EdgeInsets.only(left: 15,right: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                offset: Offset(4.0, 4.0),
                blurRadius: 10.0,
                spreadRadius: 1.0,
              )
            ],
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() =>  Text(receivableController.selectedDueDate.value),),
                IconButton(onPressed:() => _openDatePicker(context), icon: Icon(Icons.date_range,color: Colors.grey,))
              ],
          ),
        ),
      ],
    );
  }
}

   