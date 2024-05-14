import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/model/receivable.dart';
import 'package:laravelsingup/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReceivableController extends GetxController {
  // TextEditingController For create receivable
  TextEditingController title = TextEditingController();
  TextEditingController remark = TextEditingController();
  TextEditingController amount = TextEditingController();
  RxString selectedPaymentTerm = ''.obs;
  RxString attachment = ''.obs;
  RxString customerId = ''.obs;
  final List<String> paymentOptions = ["equal to due date", '7', '15', '30'];
  final List<String> payments = ["0", "7", "15", "30"];
  RxString titleValidation = "".obs;
  RxString amountValidation = "".obs;
  RxString dueDateValidation = "".obs;
  RxString selectedCustomerValidation = "".obs;
  RxString selectedPaymentTermValidation = "".obs;
  RxString selectedCustomer = ''.obs;
  final DateTime date = DateTime.now();
  RxString message=RxString('');
  RxString errorMessage=RxString('');
  late DateTime dueDate;
  RxBool isLoading=false.obs;
  RxList<ReceivableModel>receivables=RxList();
  RxInt lengthofReceivableList=0.obs;

  // For fetching customer name and Id
  RxList<String>ListCustomerName=RxList();
  RxList<String>ListCustomerId=RxList();

 Future<void> fetchCustomer() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      try {
        var headers = ApiEndPoints().setHeaderToken(token);
        var url =
            ApiEndPoints.baseUrl + ApiEndPoints.customerEndPoints.customerList;
        final response = await http.get(Uri.parse(url), headers: headers);
        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          List<dynamic> customerList = jsonResponse["data"]["Customer"];
          ListCustomerId.clear();
          ListCustomerName.clear();
          for(var customer in customerList){
             ListCustomerName.add(customer["name"]);
             ListCustomerId.add(customer["id"]);
          }
          print(ListCustomerId);
          print(ListCustomerName);
        
        } else {
          final responseData = jsonDecode(response.body);
          final errorMessage = responseData['message'];
          message.value = errorMessage;
          print(message);
        }
      } catch (e) {
        errorMessage.value = e.toString();
        print(errorMessage);
      } finally {
        setIsLoadingTofalse();
      }
    }
  }
  Future<void> fetchReceivable() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      try {
        var headers = ApiEndPoints().setHeaderToken(token);
        var url =
            ApiEndPoints.baseUrl + ApiEndPoints.receivableEndPoints.receivableList;
        final response = await http.get(Uri.parse(url), headers: headers);
        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          List<dynamic> receivableList = jsonResponse["data"]["receivables"];
          List<ReceivableModel> receivableData = receivableList
              .map((receivable) => ReceivableModel.fromJson(receivable))
              .toList();
          receivables.clear();
          receivables.addAll(receivableData);
          lengthofReceivableList.value=receivables.length;  
        } else {
          final responseData = jsonDecode(response.body);
          message.value = responseData["message"];
        }
      } catch (e) {
        errorMessage.value = e.toString();
      } finally {
        setIsLoadingTofalse();
      }
    }
  }


  bool isNumber(String amount) {
    final numberRegex = RegExp(r'^[0-9]+$');
    return numberRegex.hasMatch(amount);
  }

  bool isValidDecimalNumber(String value) {
    RegExp regex = RegExp(r'^\d+(\.\d{1,2})?$');
    return regex.hasMatch(value);
  }

  bool validation() {
      if (title.text.isEmpty) {
        titleValidation.value = "Title field is required";
      } else if (title.text.length > 50) {
        {
          titleValidation.value = "Title field can't be more than 50 characher";
        }
      } else {
        titleValidation.value = "";
      }
      if (amount.text.isEmpty) {
        amountValidation.value = "Amount field is required";
      } else {
        amountValidation.value = "";
      }
      if (dueDate.compareTo(date) < 0) {
        dueDateValidation.value = "Due Date can't be before Date";
      } else if (dueDate.compareTo(date) == 0) {
        dueDateValidation.value = "Due Date can't be equal to  Date";
      } else if (!dueDate.isAtSameMomentAs(date.add(
              Duration(days: int.parse(selectedPaymentTerm.toString())))) &&
          !dueDate.isAfter(date.add(
              Duration(days: int.parse(selectedPaymentTerm.toString()))))) {
        dueDateValidation.value =
            "Due Date must be equal to payment term or after payment term";
      } else {
        dueDateValidation.value = "";
      }
      if (selectedCustomer.toString().isEmpty) {
        selectedCustomerValidation.value = "Please Select Customer";
      } else {
        selectedCustomerValidation.value = "";
      }
      if (selectedPaymentTerm.value.isEmpty) {
        selectedPaymentTermValidation.value = "Please Select Payment Terms";
      } else {
        selectedPaymentTermValidation.value = "";
      }
    
      return titleValidation.isEmpty &&  selectedCustomerValidation.isEmpty && dueDateValidation.isEmpty && amountValidation.isEmpty &&selectedPaymentTermValidation.isEmpty;
  }
  bool setIsLoadingTofalse(){
    return !isLoading.value;
  }
  bool setIsloadingToTrue(){
    return isLoading.value;
  }
}
