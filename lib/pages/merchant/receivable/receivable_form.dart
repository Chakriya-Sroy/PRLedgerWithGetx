
// import 'package:dropdown_search/dropdown_search.dart';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import 'receivable_page.dart';


// class ReceivableForm extends StatefulWidget {
//   const ReceivableForm({Key? key});

//   @override
//   State<ReceivableForm> createState() => _ReceivableFormState();
// }

// class _ReceivableFormState extends State<ReceivableForm> {
//   // Controller For TextField
//   final _titleController = TextEditingController();
//   final _amountController = TextEditingController();
//   final _remarkController = TextEditingController();

//   DateTime _date = DateTime.now();
//   DateTime _dueDate = DateTime.now();

//   String _selectedCustomer = "";
//   final List<String> _paymentOptions = ["equal to due date", '7', '15', '30'];
//   final List<String> _payments = ["0", "7", "15", "30"];
//   String? _selectedPaymentTerm = "";
//   String _titleValidation = "";
//   String _amountValidation = "";
//   String _dueDateValidation = "";
//   String _selectedCustomerValidation = "";
//   String _selectedPaymentTermValidation = "";
//   String _fileName = "";
//   bool _isNumber(String amount) {
//     final phoneRegex = RegExp(r'^[0-9]+$');
//     return phoneRegex.hasMatch(amount);
//   }

//   bool isValidDecimalNumber(String value) {
//     RegExp regex = RegExp(r'^\d+(\.\d{1,2})?$');
//     return regex.hasMatch(value);
//   }

//   void onSubmitReceivable() {
//     if (_titleController.text.isEmpty) {
//       setState(() {
//         _titleValidation = "Title field is required";
//       });
//     } else if (_titleController.text.length > 50) {
//       {
//         setState(() {
//           _titleValidation = "Title field can't be more than 50 characher";
//         });
//       }
//     } else {
//       setState(() {
//         _titleValidation = "";
//       });
//     }
//     if (_amountController.text.isEmpty) {
//       setState(() {
//         _amountValidation = "Amount field is required";
//       });
//     } else {
//       setState(() {
//         _amountValidation = "";
//       });
//     }
//     if (_dueDate.compareTo(_date) < 0) {
//       setState(() {
//         _dueDateValidation = "Due Date can't be before Date";
//       });
//     } else if (_dueDate.compareTo(_date) == 0) {
//       setState(() {
//         _dueDateValidation = "Due Date can't be equal to  Date";
//       });
//     } else if (!_dueDate.isAtSameMomentAs(_date
//             .add(Duration(days: int.parse(_selectedPaymentTerm.toString())))) &&
//         !_dueDate.isAfter(_date
//             .add(Duration(days: int.parse(_selectedPaymentTerm.toString()))))) {
//       setState(() {
//         _dueDateValidation =
//             "Due Date must be equal to payment term or after payment term";
//       });
//     } else {
//       setState(() {
//         _dueDateValidation = "";
//       });
//     }
//     if (_selectedCustomer.toString().isEmpty) {
//       setState(() {
//         _selectedCustomerValidation = "Please Select Customer";
//       });
//     } else {
//       setState(() {
//         _selectedCustomerValidation = "";
//       });
//     }
//     if (_selectedPaymentTerm.toString().isEmpty) {
//       setState(() {
//         _selectedPaymentTermValidation = "Please Select Payment Terms";
//       });
//     } else {
//       setState(() {
//         _selectedPaymentTermValidation = "";
//       });
//     }
//     if (_titleController.text.isNotEmpty &&
//             _amountController.text.isNotEmpty &&
//             _dueDate.compareTo(_date) > 0 &&
//             _dueDate.isAtSameMomentAs(_date.add(
//                 Duration(days: int.parse(_selectedPaymentTerm.toString())))) ||
//         _dueDate.isAfter(_date.add(
//                 Duration(days: int.parse(_selectedPaymentTerm.toString())))) &&
//             _selectedCustomer.toString().isNotEmpty &&
//             _selectedPaymentTerm.toString().isNotEmpty) {
//       firestore.addReceivable(Receivable(
//           title: _titleController.text,
//           customerId: _selectedCustomer.toString(),
//           amount: _amountController.text,
//           remaining: _amountController.text,
//           paymentTerm: _selectedPaymentTerm.toString(),
//           date: DateFormat('yy/MM/dd').format(_date),
//           dueDate: DateFormat('yy/MM/dd').format(_dueDate),
//           remark: _remarkController.text,
//           status: "outstanding",
//           attachment: _fileName ?? '' // Representing null attachment
//           ));
//       showAlertMessageBox(context, message: "Receivable successfully created")
//           .then((value) =>
//               Navigator.push(context, MaterialPageRoute(builder: (context) {
//                 return ReceivablePage();
//               })));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Receivable Record', style: TextStyle(fontSize: 15)),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: ReceivableForm([
//             ReceivableTitleField(),
//             CustomerListSelection(
//                 selectedValue: _selectedCustomer,
//                 onChange: (value) {
//                   setState(() {
//                     _selectedCustomer = value;
//                   });
//                 }),
//             ReceivableAmountandPaymentTerm(),
//             ReceivableDateandDueDate(),
//             ReceivableRemarkField(),
//             RecievableAttachment(),
//             ReceivableSubmitButton(),
//           ], 10),
//         ),
//       ),
//     );
//   }

//   Column ReceivableSubmitButton() {
//     return Column(
//       children: [
//         const SizedBox(
//           height: 20,
//         ),
//         InputButton(
//             label: "Add",
//             onPress: onSubmitReceivable,
//             backgroundColor: Colors.green,
//             color: Colors.white)
//       ],
//     );
//   }

//   Row ReceivableDateandDueDate() {
//     return buildReceivableFormRowWithSpacing(
//         [ReceivableDateSelection(), ReceivableDueDateSelection()], 20);
//   }

//   Row ReceivableAmountandPaymentTerm() {
//     return buildReceivableFormRowWithSpacing(
//         [ReceivableAmountField(), ReceivablePaymentTermSelection()], 20);
//   }

//   AddAttachment RecievableAttachment() {
//     return AddAttachment(onFileNameChanged: (fileName) {
//       _fileName = fileName;
//     });
//   }

//   InputTextField ReceivableRemarkField() {
//     return InputTextField(
//       label: 'Remark',
//       controller: _remarkController,
//     );
//   }

//   CustomTextField ReceivableTitleField() {
//     return CustomTextField(
//         label: "Title",
//         controller: _titleController,
//         validation: _titleValidation,
//         gapHeight: 5);
//   }

//   Expanded ReceivableDueDateSelection() {
//     return Expanded(
//         child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         InputDate(
//           label: "Due Date",
//           value: _dueDate,
//           onDateChanged: (selectedDate) {
//             setState(() {
//               _dueDate = selectedDate;
//             });
//           },
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//         Text(
//           _dueDateValidation,
//           style: TextStyle(
//             color: Colors.red,
//             fontSize: 10,
//           ),
//         ),
//       ],
//     ));
//   }

//   Expanded ReceivableDateSelection() {
//     return Expanded(
//         child: Column(
//       children: [
//         InputDate(
//           label: "Date",
//           value: _date,
//           onDateChanged: (selectedDate) {
//             setState(() {
//               _date = selectedDate;
//             });
//           },
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//         Text(
//           "",
//           style: TextStyle(
//             fontSize: 10,
//           ),
//         ),
//       ],
//     ));
//   }

//   Expanded ReceivablePaymentTermSelection() {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SelectOptionDropDown(
//               height: 150,
//               label: "Payment Term",
//               selectedValue: _selectedPaymentTerm.toString(),
//               showOptions: _paymentOptions,
//               options: _payments,
//               showTextField: false,
//               onChanged: (value) => {
//                     setState(() {
//                       _selectedPaymentTerm = value;
//                     })
//                   }),
//           const SizedBox(
//             height: 5,
//           ),
//           Text(
//             _selectedPaymentTermValidation,
//             style: TextStyle(
//               color: Colors.red,
//               fontSize: 10,
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Expanded ReceivableAmountField() {
//     return Expanded(
//         child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         InputTextField(
//             label: "Amount",
//             controller: _amountController,
//             textInputFormator: true),
//         const SizedBox(
//           height: 5,
//         ),
//         Text(
//           _amountValidation,
//           style: TextStyle(
//             color: Colors.red,
//             fontSize: 10,
//           ),
//         )
//       ],
//     ));
//   }

//   Row buildReceivableFormRowWithSpacing(List<Widget> widgets, double spacing) {
//     List<Widget> spacedWidgets = [];
//     for (int i = 0; i < widgets.length; i++) {
//       spacedWidgets.add(widgets[i]);
//       if (i != widgets.length - 1) {
//         spacedWidgets.add(SizedBox(width: spacing));
//       }
//     }

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: spacedWidgets,
//     );
//   }

//   Column ReceivableForm(List<Widget> widgets, double spacing) {
//     List<Widget> spacedWidgets = [];
//     for (int i = 0; i < widgets.length; i++) {
//       spacedWidgets.add(widgets[i]);
//       if (i != widgets.length - 1) {
//         spacedWidgets.add(SizedBox(height: spacing));
//       }
//     }
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: spacedWidgets,
//     );
//   }

//   StreamBuilder CustomerListSelection(
//       {required selectedValue, required Function(String) onChange}) {
//     FireStoreServices firebase = FireStoreServices();
//     return StreamBuilder<QuerySnapshot>(
//         stream: firebase.getCustomersList(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             List customerList = snapshot.data!.docs;
//             List<String> customers = [];
//             List<String> customerId = [];
//             for (var document in customerList) {
//               customers.add(document["fullname"]);
//               customerId.add(document.id);
//             }
//              return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SelectOptionDropDown(
//                   label: "Select Customer",
//                   selectedValue: selectedValue,
//                   options: customerId,
//                   showOptions: customers,
//                   onChanged: onChange,
//                   showTextField: true,
//                   height: 250,
//                 ),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 Text(
//                   _selectedCustomerValidation,
//                   style: TextStyle(
//                     color: Colors.red,
//                     fontSize: 10,
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             return SizedBox();
//           }
//         });
//   }
// }

// class SelectOptionDropDown extends StatefulWidget {
//   final String label;
//   final List<String> options;
//   final List<String> showOptions;
//   final bool showTextField;
//   String selectedValue;
//   final double height;
//   final Function(String) onChanged;
//   SelectOptionDropDown({
//     super.key,
//     required this.label,
//     required this.selectedValue,
//     required this.showOptions,
//     required this.options,
//     required this.showTextField,
//     required this.onChanged,
//     required this.height,
//   });

//   @override
//   State<SelectOptionDropDown> createState() => _SelectOptionDropDownState();
// }

// class _SelectOptionDropDownState extends State<SelectOptionDropDown> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(widget.label),
//         Container(
//           padding: const EdgeInsets.only(left: 20, right: 20),
//           margin: const EdgeInsets.only(top: 10),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(5),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.shade300,
//                 offset: Offset(4.0, 4.0),
//                 blurRadius: 10.0,
//                 spreadRadius: 1.0,
//               )
//             ],
//           ),
//           child: DropdownSearch<String>(
//             dropdownDecoratorProps: const DropDownDecoratorProps(
//                 dropdownSearchDecoration:
//                     InputDecoration(border: InputBorder.none)),
//             items: widget.options,
//             itemAsString: (String? selectedOption) {
//               // Display the corresponding show option for the selected option
//               if (selectedOption != null) {
//                 int index = widget.options.indexOf(selectedOption);
//                 if (index >= 0 && index < widget.showOptions.length) {
//                   return widget.showOptions[index];
//                 }
//               }
//               return '';
//             },
//             popupProps: PopupProps.menu(
//                 showSearchBox: widget.showTextField,
//                 constraints: BoxConstraints(maxHeight: widget.height)),
//             onChanged: (value) {
//               setState(() {
//                 widget.selectedValue = value!;
//               });
//               widget.onChanged(value!);
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
