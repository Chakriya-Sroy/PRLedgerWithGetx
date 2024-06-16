import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laravelsingup/model/payable.dart';
import 'package:laravelsingup/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PayableController extends GetxController {
// TextEditingController
// TextEditingController title =TextEditingController();
  TextEditingController remark = TextEditingController();
  TextEditingController amount = TextEditingController();

//Validation
  RxString titleValidation = "".obs;
  RxString amountValidation = "".obs;
  RxString dueDateValidation = "".obs;

  RxList<PayableModel> payables = RxList();
  RxList<PayableModel> archivePayables=RxList();
  late Rx<PayableModel?> payable = Rx<PayableModel?>(null);
  RxString message = RxString('');
  RxString errorMessage = RxString('');
  RxInt lengthofPayableList = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isSuccess = false.obs;
  RxBool isFailed = false.obs;
// For Supplier Select Options
  RxList<String> ListofSupplierName = RxList();
  RxList<String> ListofSupplierId = RxList();
  RxString selectedSupplier = RxString('');
  RxString payableId = RxString('');

  RxString attachment = RxString('');
// DateTime
  DateTime date = DateTime.now();
  RxString selectedDueDate = RxString('');
  RxString selectedSupplierValidation = RxString('');

  // For PaymentTerm Options Selection
  final List<String> paymentOptions = ["equal to due date", '7', '15'];
  final List<String> payments = ["0", "7", "15"];
  RxString selectedPaymentTermValidation = "".obs;
  RxString selectedPaymentTerm = RxString('');
// List of Payable Payment
  RxList<PayablePaymentModel> payablePayments = RxList();

  Map<String, dynamic> createPayableBody() {
    return {
      'supplier_id': selectedSupplier.value,
      'amount': amount.text,
      'payment_term': selectedPaymentTerm.value == "0"
          ? 'equaltodueDate'
          : selectedPaymentTerm.value,
      'remark': remark.text,
      'status': 'outstanding',
     // 'attachment': attachment.value,
      'date': DateFormat('yyyy-MM-dd').format(date.toLocal()),
      'dueDate': selectedDueDate.value,
    };
  }

  Map<String, dynamic> createPaymentBody() {
    return {
      'payable_id': payableId.value,
      'amount': amount.text,
      'remark': remark.text,
      'attachment': attachment.value
    };
  }

// Create Payable
// Note haven't Dont yet
  Future<void> createPayablePayment() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    isSuccess.value = false;
    isFailed.value = false;
    if (token != null) {
      try {
        var headers = ApiEndPoints().setHeaderToken(token);
        var url = ApiEndPoints.baseUrl +
            ApiEndPoints.payableEndPoints.payablePayments;
        Map body = createPaymentBody();
        final response = await http.post(
          Uri.parse(url),
          body: jsonEncode(body),
          headers: headers,
        );
        if (response.statusCode == 200) {
          clearTextEditor();
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          message.value = jsonResponse["message"];
          isSuccess.value = true;
        } else {
          isFailed.value = true;
          print(jsonDecode(response.body)["message"]);
        }
      } catch (e) {
        errorMessage.value = e.toString();
        print(errorMessage);
      } finally {
        setIsLoadingTofalse();
      }
    }
  }

// Create Payable
  Future<void> createPayable() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      if (validation()) {
        try {
          isLoading.value = true;
          var headers = ApiEndPoints().setHeaderToken(token);
           var url = ApiEndPoints.baseUrl +
            ApiEndPoints.payableEndPoints.paybleCreate;
            Map body = createPayableBody();
            final response = await http.post(
              Uri.parse(url),
              body: jsonEncode(body),
              headers: headers,
            );
          
          if (response.statusCode == 200) {
            clearTextEditor();
            Map<String, dynamic> json = jsonDecode(response.body);
            message.value = json["message"];
            isSuccess.value=true;
            // payables.add(PayableModel.fromJson(json));
            // Get.off(const PayablePage());
            //  Get.off(constSupplierPage());
          } else {
            final responseData = jsonDecode(response.body);
            errorMessage.value = responseData['message'];
          }
        } catch (e) {
          errorMessage.value = e.toString();
          print(errorMessage);
        } finally {
          isLoading.value = false;
        }
      }
    }
  }

// Fetch Individual Payable
  Future<void> fetchIndividualPayable(String id) async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      try {
        var headers = ApiEndPoints().setHeaderToken(token);
        var url = ApiEndPoints.baseUrl +
            ApiEndPoints.payableEndPoints.getPayableViewEndPoint(id);
        final response = await http.get(Uri.parse(url), headers: headers);
        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          Map<String, dynamic> payableData = jsonResponse["data"];
          // Get a receivable value
          payable.value = PayableModel.fromJson(payableData);
          // // Get payment of receivable
          List paymentData = jsonResponse["data"]["relationships"]["payment"];
          payablePayments.clear();
          for (var payment in paymentData) {
            payablePayments.add(PayablePaymentModel(
                id: payment["id"].toString(),
                payableId: payment["payable_id"].toString(),
                amount: payment["amount"],
                remark: payment["remark"],
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
        setIsLoadingTofalse();
      }
    }
  }
 Future<void> archievePayable(String id) async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      isLoading.value=true;
      isFailed.value=false;
      isSuccess.value = false;
      message.value = '';
      errorMessage.value = '';
      try {
        var headers = ApiEndPoints().setHeaderToken(token);
        var url = ApiEndPoints.baseUrl +
            ApiEndPoints.payableEndPoints.archievePayable(id);
        final response = await http.patch(Uri.parse(url), headers: headers);
        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          isSuccess.value = true;
          message.value = jsonResponse['message'];
        } else {
          isFailed.value = true;
          errorMessage.value = jsonDecode(response.body)['message'];
        }
      } catch (e) {
        print(e.toString());
      }finally{
        isLoading.value=false;
      }
    }
  }

// Fetch Payable form api
  Future<void> fetchPayables() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      try {
        var headers = ApiEndPoints().setHeaderToken(token);
        var url =
            ApiEndPoints.baseUrl + ApiEndPoints.payableEndPoints.payableList;
        final response = await http.get(Uri.parse(url), headers: headers);
        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          List<dynamic> payableList = jsonResponse["data"];
          List<PayableModel> receivableData = payableList
              .map((payable) => PayableModel.fromJson(payable))
              .toList();
          payables.clear();
          payables.addAll(receivableData);
          lengthofPayableList.value = payables.length;
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

  Future<void> fetchArchievePayables() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      try {
        var headers = ApiEndPoints().setHeaderToken(token);
        var url =
            ApiEndPoints.baseUrl + ApiEndPoints.payableEndPoints.payableArchieveList;
        final response = await http.get(Uri.parse(url), headers: headers);
        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          List<dynamic> payableList = jsonResponse["data"];
          List<PayableModel> data = payableList
              .map((payable) => PayableModel.fromJson(payable))
              .toList();
          archivePayables.clear();
          archivePayables.addAll(data);
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


  // Fetch Supplier from API
  Future<void> fetchSupplier() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      try {
        var headers = ApiEndPoints().setHeaderToken(token);
        var url =
            ApiEndPoints.baseUrl + ApiEndPoints.supplierEndPoints.supplierList;
        final response = await http.get(Uri.parse(url), headers: headers);
        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          List<dynamic> supplierList = jsonResponse["data"];
          ListofSupplierId.clear();
          ListofSupplierName.clear();
          for (var info in supplierList) {
            ListofSupplierId.add(info["attributes"]["id"]);
            ListofSupplierName.add(info["attributes"]["name"]);
          }
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

  void clearTextEditor() {
    remark.clear();
    amount.clear();
  }

  bool validation() {
    if (amount.text.isEmpty) {
      amountValidation.value = "Amount field is required";
    } else if (double.parse(amount.text) <= 0 || amount.text.startsWith('00')) {
      amountValidation.value = "The amount must be greather than 0";
    } else {
      amountValidation.value = "";
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
    if (selectedSupplier.toString().isEmpty) {
      selectedSupplierValidation.value = "Please Select Customer";
    } else {
      selectedSupplierValidation.value = "";
    }
    if (selectedPaymentTerm.value.isEmpty) {
      selectedPaymentTermValidation.value = "Please Select Payment Terms";
    } else {
      selectedPaymentTermValidation.value = "";
    }

    return selectedSupplierValidation.isEmpty &&
        dueDateValidation.isEmpty &&
        amountValidation.isEmpty &&
        selectedPaymentTermValidation.isEmpty;
  }

  bool setIsloadingToTrue() {
    return isLoading.value;
  }

  bool setIsLoadingTofalse() {
    return !isLoading.value;
  }
}

/**
 * 
 * Incase there error tmr on add part pyabalepayment.add()
 */
