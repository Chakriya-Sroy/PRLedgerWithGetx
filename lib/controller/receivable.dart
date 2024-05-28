import 'dart:convert';
import 'dart:js';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laravelsingup/model/receivable.dart';
import 'package:laravelsingup/pages/merchant/receivable/receivable_page.dart';
import 'package:laravelsingup/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ReceivableController extends GetxController {
  // TextEditingController For create receivable and their validation text
  TextEditingController remark = TextEditingController();
  TextEditingController amount = TextEditingController();
  RxString attachment = ''.obs;
  RxString titleValidation = "".obs;
  RxString amountValidation = "".obs;
  RxString dueDateValidation = "".obs;

  // For message
  RxString message = RxString('');
  RxString errorMessage = RxString('');

  // For Date and Due Date Selection Option with the their selected value
  DateTime date = DateTime.now();
  DateTime dueDate = DateTime.now();
  RxString selectedDueDate = ''.obs;
  RxBool isLoading = false.obs;
  RxBool isSuccess = false.obs;
  RxBool isFailed =false.obs;
  // For PaymentTerm Options Selection
  final List<String> paymentOptions = ["equal to due date", '7', '15'];
  final List<String> payments = ["0", "7", "15"];
  RxString selectedPaymentTermValidation = "".obs;
  RxString selectedPaymentTerm = ''.obs;

  // For fetching customer name and Id with its selected value
  RxList<String> ListCustomerName = RxList();
  RxList<String> ListCustomerId = RxList();
  RxString selectedCustomer = ''.obs;
  RxString selectedCustomerValidation = "".obs;
  RxString customerId = ''.obs;

  //For Storing Receivable List,Receivable ,Payments and lengthh of receivable;
  RxList<ReceivableModel> receivables = RxList();
  late Rx<ReceivableModel?> receivable = Rx<ReceivableModel?>(null);
  RxList<ReceivablePaymentModel> receivablePayments = RxList();
  RxInt lengthofReceivableList = 0.obs;

  // Use For Make Payment
  RxString receivableID = ''.obs;

  // Map object
  Map<String, dynamic> createReceivableBody() {
    return {
      'customer_id': selectedCustomer.value,
      'amount': amount.text,
      'payment_term': selectedPaymentTerm.value == "0"
          ? 'equaltodueDate'
          : selectedPaymentTerm.value,
      'remark': remark.text,
      'status': 'outstanding',
      'attachment': attachment.value,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'dueDate': selectedDueDate.value,
    };
  }

  Map<String, dynamic> createPaymentBody() {
    return {
      'receivable_id': receivableID.value,
      'amount': amount.text,
      'remark': remark.text,
      'attachment': attachment.value
    };
  }

  Future<void> createReceivablePayment() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    isSuccess.value=false;
    if (token != null) {
      try {
        var headers = ApiEndPoints().setHeaderToken(token);
        var url = ApiEndPoints.baseUrl +
            ApiEndPoints.receivableEndPoints.receivablePayment;
        Map body = createPaymentBody();
        final response = await http.post(
          Uri.parse(url),
          body: jsonEncode(body),
          headers: headers,
        );
        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          //Map<String, dynamic> data = jsonResponse["data"][0]["attributes"];
          //receivablePayments.add(ReceivablePaymentModel.fromJson(data));
          message.value = jsonResponse["message"];
          isSuccess.value=true;
        } else {
          print(jsonDecode(response.body)["message"]);
        }
      } catch (e) {
        errorMessage.value = e.toString();
        print(errorMessage);
      } finally {
        isLoading.value=false;
      }
    }
  }

  Future<void> fetchIndividualReceivable(String id) async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      try {
        var headers = ApiEndPoints().setHeaderToken(token);
        var url = ApiEndPoints.baseUrl +
            ApiEndPoints.receivableEndPoints.getReceivableViewEndPoint(id);
        final response = await http.get(Uri.parse(url), headers: headers);
        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          Map<String, dynamic> receivableData = jsonResponse["data"];
          // Get a receivable value
          receivable.value = ReceivableModel.fromJson(receivableData);
          // // Get payment of receivable
          List paymentData = jsonResponse["data"]["relationships"]["payment"];
          receivablePayments.clear();
          for (var payment in paymentData) {
            receivablePayments.add(ReceivablePaymentModel(
                id: payment["id"].toString(),
                receivableId: payment["receivable_id"].toString(),
                userId: payment["user_id"].toString(),
                amount: payment["amount"],
                date: payment["date"]));
          }
        } else {
          final responseData = jsonDecode(response.body);
          errorMessage.value = responseData['message'];
          print(errorMessage);
        }
      } catch (e) {
        errorMessage.value = e.toString();
        print(errorMessage);
      } finally {
        isLoading.value=false;
      }
    }
  }

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
          List<dynamic> customerList = jsonResponse["data"];
          ListCustomerId.clear();
          ListCustomerName.clear();
          for (var customer in customerList) {
            ListCustomerName.add(customer["attributes"]["name"]);
            ListCustomerId.add(customer["attributes"]["id"]);
          }
        } else {
          final responseData = jsonDecode(response.body);
          errorMessage.value = responseData['message'];
        }
      } catch (e) {
        errorMessage.value = e.toString();
        print(errorMessage);
      } finally {
        isLoading.value=false;
      }
    }
  }

  Future<void> fetchReceivable() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      try {
        var headers = ApiEndPoints().setHeaderToken(token);
        var url = ApiEndPoints.baseUrl +
            ApiEndPoints.receivableEndPoints.receivableList;
        final response = await http.get(Uri.parse(url), headers: headers);
        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          List<dynamic> receivableList = jsonResponse["data"]["receivables"];
          List<ReceivableModel> receivableData = receivableList
              .map((receivable) => ReceivableModel.fromJson(receivable))
              .toList();
          receivables.clear();
          receivables.addAll(receivableData);
          lengthofReceivableList.value = receivables.length;
        } else {
          final responseData = jsonDecode(response.body);
          message.value = responseData["message"];
        }
      } catch (e) {
        errorMessage.value = e.toString();
      } finally {
        isLoading.value=false;
      }
    }
  }

  Future<void> createReceivable() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      if (validation()) {
        try {
          isLoading.value=true;
          var headers = ApiEndPoints().setHeaderToken(token);
          var url = ApiEndPoints.baseUrl +
              ApiEndPoints.receivableEndPoints.receivableCreate;
          Map body = createReceivableBody();
          final response = await http.post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: headers,
          );

          if (response.statusCode == 200) {
           
            Map<String, dynamic> json = jsonDecode(response.body);
            message.value = json["message"];
            isSuccess.value=true;
             
          }else{
            isFailed.value=true;
            errorMessage.value=jsonDecode(response.body)["message"];
          }
        } catch (e) {
          errorMessage.value = e.toString();
        } finally {
          isLoading.value=false;
        }
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
    if (amount.text.isEmpty) {
      amountValidation.value = "Amount field is required";
    } 
    else if(double.parse(amount.text)<=0 || amount.text.startsWith('00')){
      amountValidation.value = "The amount must be greather than 0";
    } 
    else {
      amountValidation.value = "";
    }

    if (selectedCustomer.value.isEmpty) {
      selectedCustomerValidation.value = "Please Select Customer";
    } else {
      selectedCustomerValidation.value = "";
    }
    if (selectedPaymentTerm.value.isEmpty) {
      selectedPaymentTermValidation.value = "Please Select Payment Terms";
    } else {
      selectedPaymentTermValidation.value = "";
    }
    if (selectedDueDate.value.isEmpty) {
      dueDateValidation.value = "Please select Due Date";
    } else if (selectedDueDate.value == DateFormat('yyyy-MM-dd').format(date)) {
      dueDateValidation.value = "Due Date can't be equal to today";
    } else if (selectedPaymentTerm.value != "0" &&
        DateTime.parse(selectedDueDate.value).isBefore(date
            .add(Duration(days: int.parse(selectedPaymentTerm.toString()))))) {
      dueDateValidation.value = "Due Date must be after payment term";
    } else {
      dueDateValidation.value = '';
    }

    return selectedCustomerValidation.isEmpty &&
        dueDateValidation.isEmpty &&
        amountValidation.isEmpty &&
        selectedPaymentTermValidation.isEmpty;
  }



  void clearTextEditor() {
    remark.clear();
    amount.clear();
  }

  void clearReceivableForm() {
    selectedCustomer.value = '';
    selectedDueDate.value = '';
    amount.clear();
    remark.clear();
    selectedPaymentTerm.value = '';
  }

  bool setIsLoadingTofalse() {
    return !isLoading.value;
  }

  bool setIsloadingToTrue() {
    return isLoading.value;
  }
  void initializeStatusFlags() {
    isSuccess.value = false;
    isFailed.value = false;
    errorMessage.value = '';
    message.value='';}
}
