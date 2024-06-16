import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/model/payable.dart';
import 'package:laravelsingup/model/supplier.dart';
import 'package:laravelsingup/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SupplierController extends GetxController {
  //TextEditingController For Create Supplier
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController remark = TextEditingController();
  // TextEditingController For search
  TextEditingController search = TextEditingController();

  // Text Validation For each TextEditingController
  var nameValidation = RxString("");
  var emailValidation = RxString("");
  var addressValidation = RxString("");
  var phoneValidation = RxString("");
  var message = RxString("");

  // Is Loading to listent to progress of fetching data from API
  RxBool isLoading = false.obs;
  // Obsearvable String to listent to Search Editing Controller For fitlterSupplier List
  RxString searchTerm = ''.obs;

  RxBool isSuccess = false.obs;
  RxBool isFailed = false.obs;
  // Obsearvable Supplier List instance fromSupplier model
  RxList<SupplierModel> suppliers = RxList();

  // Obseravable Supplier instance formSupplier model
  Rx<SupplierModel?> supplier = Rx<SupplierModel?>(null);

  // Observerable Supplier Payables
  // Payable
  RxList<PayableModel> supplierPayables = RxList();

  // Obseravable Supplier transaction from transaction model
  RxList<TransactionModel> transactions = RxList();

  // Obsearvabel errormessage
  RxString errorMessage = ''.obs;

  // Obsearvable length ofSupplier's List
  RxInt supplierLength = 0.obs;

  // Obseravable Length of Transaction's List
  RxInt transactionLength = 0.obs;

  // Future function to fetch transaction
  Future<void> fetchTransactionLog(String id) async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      try {
        var headers = ApiEndPoints().setHeaderToken(token);
        var url = ApiEndPoints.baseUrl +
            ApiEndPoints.supplierEndPoints.getSupplierTransacctionEndPoint(id);
        final response = await http.get(Uri.parse(url), headers: headers);

        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          List<dynamic> data = jsonResponse["data"];
          transactions.clear();
          for (var item in data) {
            transactions.add(TransactionModel.fromJson(item));
          }
          transactionLength.value = transactions.length;
        }
      
      } catch (e) {
        errorMessage.value = e.toString();
        
      } finally {
       isLoading.value=false;
      }
    }
  }

  // future function to fetch indiviudalSupplier base on Id
  Future<void> fetchIndividualSupplier(String id) async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      try {
        var headers = ApiEndPoints().setHeaderToken(token);
        var url = ApiEndPoints.baseUrl +
            ApiEndPoints.supplierEndPoints.getSupplierViewEndpoint(id);
        final response = await http.get(Uri.parse(url), headers: headers);

        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          Map<String, dynamic> supplierAttributes = jsonResponse["data"];
          supplier.value = SupplierModel.fromJson(supplierAttributes);
          List payables = supplierAttributes["payables"];
          supplierPayables.clear();
          for (var payable in  payables) {
            supplierPayables.add(PayableModel(
                id:payable["id"].toString(),
                supplierId:payable["supplier_id"].toString(),
                amount: payable["amount"],
                remaining: payable["remaining"],
                date: payable["date"],
                dueDate: payable["dueDate"],
                paymentTerm: payable["payment_term"],
                status: payable["status"]));
          }
        }
      } catch (e) {
        errorMessage.value = e.toString();
      } finally {
       isLoading.value=false;
      }
    }
  }

  // future function to fetch allSupplier belong to authentication user
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
          List<SupplierModel> suppliersData = supplierList
              .map((supplierData) => SupplierModel.fromJson(supplierData))
              .toList();
          suppliers.clear();
          suppliers.addAll(suppliersData);
          supplierLength.value = suppliers.length;
          isSuccess.value=true;
        } else {
          final responseData = jsonDecode(response.body);
          isFailed.value=true;
          errorMessage.value=responseData['message'];
        }
      } catch (e) {
        errorMessage.value = e.toString();
      } finally {
       isLoading.value=false;
      }
    }
  }

  // future function to add newSupplier
  Future<void> addSupplier() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      if (validation()) {
        try {
          isLoading.value=true;
          var headers = ApiEndPoints().setHeaderToken(token);
          var url = ApiEndPoints.baseUrl +
              ApiEndPoints.supplierEndPoints.supplierCreate;
          Map body = createSupplierBody();
          final response = await http.post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: headers,
          );
          if (response.statusCode == 200) {
            Map<String, dynamic> json = jsonDecode(response.body);
            message.value = json["message"];
           // suppliers.add(SupplierModel.fromJson(json["data"]));
            isSuccess.value = true;
            clearTextEditor();
          } else {
            final responseData = jsonDecode(response.body);
            errorMessage.value = responseData['message'];
            isFailed.value = true;
            print(errorMessage);
          }
        } catch (e) {
          print(e.toString());
        } finally {
         isLoading.value=false;
        }
      }
    }
  }

  // future function to deleteSupplier
  Future<void> deleteSupplier(String id) async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      try {
        var headers = ApiEndPoints().setHeaderToken(token);
        var url = ApiEndPoints.baseUrl +
            ApiEndPoints.supplierEndPoints.deleteCustomerEndPoint(id);

        final response = await http.delete(
          Uri.parse(url),
          headers: headers,
        );

        if (response.statusCode == 200) {
          message.value = jsonDecode(response.body)["message"];
          isSuccess.value=true;
        }else{
          errorMessage.value=jsonDecode(response.body)["message"];
          isFailed.value=true;
        }
      } catch (e) {
        errorMessage.value = e.toString();
      } finally {
       isLoading.value=false;
      }
    }
  }

  // future function to updateSupplier base on Id
  Future<void> updateSupplier(String id) async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      if (validation()) {
        try {
          var headers = ApiEndPoints().setHeaderToken(token);
          var url = ApiEndPoints.baseUrl +
              ApiEndPoints.supplierEndPoints.updateSupplierViewEndPoint(id);
          Map body = createSupplierBody();
          final response = await http.patch(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: headers,
          );
          if (response.statusCode == 200) {
            Map<String, dynamic> json = jsonDecode(response.body);
            message.value = json["message"];
            clearTextEditor();
            isSuccess.value=true;
          } else {
            final responseData = jsonDecode(response.body);
            errorMessage.value = responseData['message'];
            isFailed.value=true;
          }
        } catch (e) {
          errorMessage.value = e.toString();
        } finally {
         isLoading.value=false;
        }
      }
    }
  }

  // Method To Clear Text from TextEditingController After Form is submit
  void clearTextEditor() {
    name.clear();
    email.clear();
    address.clear();
    phone.clear();
    remark.clear();
  }

  // Method to validate the input form TextEditingController
  bool validation() {
    if (name.text.isEmpty) {
      nameValidation.value = "The fullname field is required";
    } else {
      nameValidation.value = "";
    }
    if (phone.text.isEmpty) {
      phoneValidation.value = "The phone field is required";
    } else if (!phone.text.isPhoneNumber) {
      phoneValidation.value = "The phone number format is incorrect";
    } else {
      phoneValidation.value = "";
    }
    return phoneValidation.isEmpty && nameValidation.isEmpty;
  }

  // Method to create body form to send to API
  Map<String, String> createSupplierBody() {
    return {
      'fullname': name.text,
      'email': email.text,
      'address': address.text,
      'phone': phone.text,
      'remark': remark.text,
    };
  }

  // Method to filterSupplier base  on Obsearvable search term
  List<SupplierModel> filtersuppliers() {
    searchTerm.value = search.text;
    if (searchTerm.isEmpty) {
      return suppliers; // Return all suppliers if search text is empty
    } else {
      return suppliers
          .where((supplier) => supplier.name.toLowerCase().contains(searchTerm))
          .toList();
    }
  }

  // Method to assigng initial text value to TextEditingController
  void AssignSupplierValueToTextEditor() {
    email.text = supplier.value!.email ?? '';
    name.text = supplier.value!.name;
    phone.text = supplier.value!.phone;
    address.text = supplier.value!.address ?? '';
    remark.text = supplier.value!.remark ?? '';
  }

  // Method to set the state of Obsearvable isLoading to true
  bool setIsloadingToTrue() {
    return isLoading.value;
  }

  // Method to set the state of Obsearvable isLoading to false
  bool setIsLoadingTofalse() {
    return !isLoading.value;
  }

  bool setIsSuccessToFalse() {
    return !isSuccess.value;
  }

  bool setIsSuccessToTrue() {
    return isSuccess.value;
  }

  String clearInitialMessage() {
    return message.value = '';
  }

  void initializeStatusFlags() {
    isSuccess.value = false;
    isFailed.value = false;
    errorMessage.value = '';
    message.value = '';
  }
}
