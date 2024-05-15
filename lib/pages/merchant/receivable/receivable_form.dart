
import 'dart:ffi';

import 'package:dropdown_search/dropdown_search.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laravelsingup/controller/receivable.dart';
import 'package:laravelsingup/widgets/form/custom_text_field.dart';
import 'package:laravelsingup/widgets/form/input_button.dart';
import 'package:laravelsingup/widgets/form/input_date.dart';
import 'package:laravelsingup/widgets/form/input_text.dart';

import 'receivable_page.dart';


class ReceivableForm extends StatefulWidget {
  const ReceivableForm({Key? key});

  @override
  State<ReceivableForm> createState() => _ReceivableFormState();
}

class _ReceivableFormState extends State<ReceivableForm> {
   final receivableController =Get.put(ReceivableController());
  @override
  void initState() {
    // TODO: implement initState
    receivableController.fetchCustomer();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receivable Record', style: TextStyle(fontSize: 15)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ReceivableForm([
            ReceivableTitleField(),
            CustomerListSelection(receivableController, onChange: (value) {
                  receivableController.selectedCustomer.value=value.toString();
                } ),
            ReceivableAmountandPaymentTerm(),
            ReceivableDateandDueDate(),
            ReceivableRemarkField(),
            //RecievableAttachment(),
            ReceivableSubmitButton(),
          ], 10),
        ),
      ),
    );
  }

  Column ReceivableSubmitButton() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        InputButton(
            label: "Add",
            onPress: (){
              receivableController.createReceivable();
              receivableController.message.value.isNotEmpty ?
              ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Obx(
                        () => Text(receivableController.message.toString(),
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ):const SizedBox();
                 
            },
            backgroundColor: Colors.green,
            color: Colors.white)
      ],
    );
  }

  Row ReceivableDateandDueDate() {
    return buildReceivableFormRowWithSpacing(
        [ReceivableDateSelection(), ReceivableDueDateSelection()], 20);
  }

  Row ReceivableAmountandPaymentTerm() {
    return buildReceivableFormRowWithSpacing(
        [ReceivableAmountField(), ReceivablePaymentTermSelection()], 20);
  }

  // AddAttachment RecievableAttachment() {
  //   return AddAttachment(onFileNameChanged: (fileName) {
  //     _fileName = fileName;
  //   });
  // }

  InputTextField ReceivableRemarkField() {
    return InputTextField(
      label: 'Remark',
      controller: receivableController.remark,
    );
  }

  ReceivableTitleField() {
    return Obx(() =>  CustomTextField(
        label: "Title",
        controller: receivableController.title,
        validation: receivableController.titleValidation.value,
        gapHeight: 5));
  }

  ReceivableDueDateSelection() {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputDate(
          label: "Due Date",
          value: receivableController.dueDate,
          onDateChanged: (selectedDate) {
           receivableController.selectedDueDate.value=DateFormat('yyyy-MM-dd').format(selectedDate);
          },
        ),
        const SizedBox(
          height: 5,
        ),
        Obx(() => Text(
          receivableController.dueDateValidation.value,
          style: TextStyle(
            color: Colors.red,
            fontSize: 10,
          ),
        )),
      ],
    ));
  }

  Expanded ReceivableDateSelection() {
    return Expanded(
        child: Column(
      children: [
        InputDate(
          label: "Date",
          value: receivableController.date,
          onDateChanged: (selectedDate) {
             receivableController.selectedDate.value=DateFormat('yyyy-MM-dd').format(selectedDate);
          },
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          '',
          style: TextStyle(
            fontSize: 10,
          ),
        ),
      ],
    ));
  }

  ReceivablePaymentTermSelection() {
    return  Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectOptionDropDown(
              height: 150,
              label: "Payment Term",
              selectedValue: receivableController.selectedPaymentTerm.value,
              showOptions: receivableController.paymentOptions,
              options: receivableController.payments,
              showTextField: false,
              onChanged: (value) => {
                    receivableController.selectedPaymentTerm.value=value.toString()
                  }),
          const SizedBox(
            height: 5,
          ),
          Obx(() =>   Text(
            receivableController.selectedPaymentTermValidation.toString(),
            style: TextStyle(
              color: Colors.red,
              fontSize: 10,
            ),
          ))
        ],
      ),
    );
  }

  Expanded ReceivableAmountField() {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputTextField(
            label: "Amount",
            controller: receivableController.amount,
            textInputFormator: true),
        const SizedBox(
          height: 5,
        ),
       Obx(() =>  Text(
          receivableController.amountValidation.toString(),
          style: TextStyle(
            color: Colors.red,
            fontSize: 10,
          ),
        ))
      ],
    ));
  }

  Row buildReceivableFormRowWithSpacing(List<Widget> widgets, double spacing) {
    List<Widget> spacedWidgets = [];
    for (int i = 0; i < widgets.length; i++) {
      spacedWidgets.add(widgets[i]);
      if (i != widgets.length - 1) {
        spacedWidgets.add(SizedBox(width: spacing));
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: spacedWidgets,
    );
  }

  Column ReceivableForm(List<Widget> widgets, double spacing) {
    List<Widget> spacedWidgets = [];
    for (int i = 0; i < widgets.length; i++) {
      spacedWidgets.add(widgets[i]);
      if (i != widgets.length - 1) {
        spacedWidgets.add(SizedBox(height: spacing));
      }
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: spacedWidgets,
    );
  }

  Widget CustomerListSelection(ReceivableController receivableController,{ required Function(String) onChange}) {
    return  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectOptionDropDown(
                  label: "Select Customer",
                  selectedValue: receivableController.selectedCustomer.value,
                  options: receivableController.ListCustomerId,
                  showOptions: receivableController.ListCustomerName,
                  onChanged: (value){
                    receivableController.selectedCustomer.value=value.toString();
                  },
                  showTextField: true,
                  height: 250,
                ),
                const SizedBox(
                  height: 5,
                ),
               Obx(() =>   Text(
                  receivableController.selectedCustomerValidation.value,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                  ),
                ),)
              ],
            );
          } 
}

class SelectOptionDropDown extends StatefulWidget {
  final String label;
  final List<String> options;
  final List<String> showOptions;
  final bool showTextField;
  String selectedValue;
  final double height;
  final Function(String) onChanged;
  SelectOptionDropDown({
    super.key,
    required this.label,
    required this.selectedValue,
    required this.showOptions,
    required this.options,
    required this.showTextField,
    required this.onChanged,
    required this.height,
  });

  @override
  State<SelectOptionDropDown> createState() => _SelectOptionDropDownState();
}

class _SelectOptionDropDownState extends State<SelectOptionDropDown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label),
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          margin: const EdgeInsets.only(top: 10),
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
          child: DropdownSearch<String>(
            dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration:
                    InputDecoration(border: InputBorder.none)),
            items: widget.options,
            itemAsString: (String? selectedOption) {
              // Display the corresponding show option for the selected option
              if (selectedOption != null) {
                int index = widget.options.indexOf(selectedOption);
                if (index >= 0 && index < widget.showOptions.length) {
                  return widget.showOptions[index];
                }
              }
              return '';
            },
            popupProps: PopupProps.menu(
                showSearchBox: widget.showTextField,
                constraints: BoxConstraints(maxHeight: widget.height)),
            onChanged: (value) {
              setState(() {
                widget.selectedValue = value.toString();
              });
              widget.onChanged(value!);
            },
          ),
        ),
      ],
    );
  }
}
