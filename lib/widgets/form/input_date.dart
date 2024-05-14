import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InputDate extends StatefulWidget {
  String label;
  DateTime value;
  final ValueChanged<DateTime> onDateChanged;
  InputDate({super.key, required this.label, required this.value,required this.onDateChanged});
  @override
  State<InputDate> createState() => _InputDatePickerState();
}

class _InputDatePickerState extends State<InputDate> {
  void _openDatePicker(BuildContext context) {
    BottomPicker.date(
      pickerTitle: Text('Select Date',),
      pickerTextStyle: TextStyle(color: Colors.green, fontSize: 18),
      // pickerTextStyle: TextStyle(
      //   color: Colors.green,
      // ),
      dateOrder: DatePickerDateOrder.ymd,
      minDateTime: DateTime.now(),
      onSubmit: (index) {
        setState(() {
           //For ValueChange call back function
          widget.onDateChanged(index);
           //For Update Ui
          widget.value = index;
        });
      },
      onChange: (index) {
        setState(() {
          //For ValueChange call back function
          widget.onDateChanged(index);
          //For Update Ui
          widget.value = index;
        });
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
        Text(widget.label),
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
                Text(DateFormat('yyyy-MM-dd').format(widget.value)),
                IconButton(onPressed:() => _openDatePicker(context), icon: Icon(Icons.date_range,color: Colors.grey,))
              ],
          ),
        ),
      ],
    );
  }
}
