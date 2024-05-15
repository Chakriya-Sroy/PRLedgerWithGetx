import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laravelsingup/controller/payable.dart';
import 'package:laravelsingup/pages/merchant/payable/payable.dart';
import 'package:laravelsingup/widgets/form/custom_text_field.dart';
import 'package:laravelsingup/widgets/form/input_button.dart';
import 'package:laravelsingup/widgets/form/input_date.dart';
import 'package:laravelsingup/widgets/form/input_text.dart';


class PayableForm extends StatefulWidget {
  const PayableForm({super.key});

  @override
  State<PayableForm> createState() => _PayableFormState();
}

class _PayableFormState extends State<PayableForm> {
  final payableController =Get.put(PayableController());
 @override
  void initState() {
    // TODO: implement initState
    payableController.fetchSupplier();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payable Record', style: TextStyle(fontSize: 15)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ReceivableForm([
            PayableTitleField(),
            SupplierListSelection(payableController, onChange: (value) {
                  payableController.selectedSupplier.value=value.toString();
                } ),
            PayableAmountandPaymentTerm(),
            PayableDateandDueDate(),
            PayableRemarkField(),
            //RecievableAttachment(),
            PayableSubmitButton(),
          ], 10),
        ),
      ),
    );
  }

  Column PayableSubmitButton() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        InputButton(
            label: "Add",
            onPress: (){
              payableController.createPayable();
             
              payableController.message.value.isNotEmpty ? ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Obx(
                        () => Text(payableController.message.toString(),
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ) : const SizedBox();
              payableController.errorMessage.isNotEmpty ? ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Obx(
                        () => Text(payableController.errorMessage.toString(),
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

  Row PayableDateandDueDate() {
    return buildReceivableFormRowWithSpacing(
        [PayableDateSelectio(), PayableDueDateSelection()], 20);
  }

  Row PayableAmountandPaymentTerm() {
    return buildReceivableFormRowWithSpacing(
        [ReceivableAmountField(), ReceivablePaymentTermSelection()], 20);
  }

  // AddAttachment RecievableAttachment() {
  //   return AddAttachment(onFileNameChanged: (fileName) {
  //     _fileName = fileName;
  //   });
  // }

  InputTextField PayableRemarkField() {
    return InputTextField(
      label: 'Remark',
      controller: payableController.remark,
    );
  }

  PayableTitleField() {
    return Obx(() =>  CustomTextField(
        label: "Title",
        controller: payableController.title,
        validation: payableController.titleValidation.value,
        gapHeight: 5));
  }

  PayableDueDateSelection() {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputDate(
          label: "Due Date",
          value: payableController.dueDate,
          onDateChanged: (selectedDate) {
           payableController.selectedDueDate.value=DateFormat('yyyy-MM-dd').format(selectedDate);
          },
        ),
        const SizedBox(
          height: 5,
        ),
        Obx(() => Text(
          payableController.dueDateValidation.value,
          style: TextStyle(
            color: Colors.red,
            fontSize: 10,
          ),
        )),
      ],
    ));
  }

  Expanded PayableDateSelectio() {
    return Expanded(
        child: Column(
      children: [
        InputDate(
          label: "Date",
          value: payableController.date,
          onDateChanged: (selectedDate) {
             payableController.selectedDate.value=DateFormat('yyyy-MM-dd').format(selectedDate);
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
              selectedValue: payableController.selectedPaymentTerm.value,
              showOptions: payableController.paymentOptions,
              options: payableController.payments,
              showTextField: false,
              onChanged: (value) => {
                    payableController.selectedPaymentTerm.value=value.toString()
                  }),
          const SizedBox(
            height: 5,
          ),
          Obx(() =>   Text(
            payableController.selectedPaymentTermValidation.toString(),
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
            controller: payableController.amount,
            textInputFormator: true),
        const SizedBox(
          height: 5,
        ),
       Obx(() =>  Text(
          payableController.amountValidation.toString(),
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

  Widget SupplierListSelection(PayableController payableController,{ required Function(String) onChange}) {
    return  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectOptionDropDown(
                  label: "Select Supplier",
                  selectedValue: payableController.selectedSupplier.toString(),
                  options: payableController.ListofSupplierId,
                  showOptions: payableController.ListofSupplierName,
                  onChanged: onChange,
                  showTextField: true,
                  height: 250,
                ),
                const SizedBox(
                  height: 5,
                ),
               Obx(() =>   Text(
                  payableController.selectedSupplierValidation.value,
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