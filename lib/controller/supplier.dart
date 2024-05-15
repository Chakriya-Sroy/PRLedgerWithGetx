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

  // Obsearvable Supplier List instance fromSupplier model
  RxList<SupplierModel> suppliers = RxList();

  // Obseravable Supplier instance formSupplier model
  Rx<SupplierModel?>supplier = Rx<SupplierModel?>(null);

  // Observerable Supplier Payables
  // Payable
  RxList<PayableModel>supplierPayables=RxList();

  // Obseravable Supplier transaction from transaction model
  RxList<TransactionModel> transactions = RxList();

  // Obsearvabel errormessage
  RxString errorMessage = ''.obs;

  // Obsearvable length ofSupplier's List
  RxInt supplierLength = 0.obs;

  // Obseravable Length of Transaction's List
  RxInt transactionLength=0.obs;

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
          transactionLength.value=transactions.length;
        }
      } catch (e) {
        errorMessage.value = e.toString();
      } finally {
        setIsLoadingTofalse();
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
          Map<String, dynamic>SupplierAttributes = jsonResponse["data"];
         supplier.value = SupplierModel.fromJson(SupplierAttributes);
        }
      } catch (e) {
        errorMessage.value = e.toString();
      } finally {
        setIsLoadingTofalse();
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
  // future function to add newSupplier
  Future<void> addSupplier() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      if (validation()) {
        try {
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
            clearTextEditor();
            Map<String, dynamic> json = jsonDecode(response.body);
            message.value = "";
            message.value = json["message"];
            suppliers.add(SupplierModel.fromJson(json));

          //  Get.off(constSupplierPage());
          } else {
            final responseData = jsonDecode(response.body);
            final errorMessage = responseData['message'];
            errorMessage.value = errorMessage;
          }
        } catch (e) {
          errorMessage.value = e.toString();
        }finally{
          setIsLoadingTofalse();
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
          message.value = "";
          message.value = jsonDecode(response.body)["message"];
        }
      } catch (e) {
        errorMessage.value = e.toString();
      }finally{
        setIsLoadingTofalse();
      }
    }
  }
  // future function to updateSupplier base on Id
  Future<void> updateCustomer(String id) async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      if (validation()) {
        try {
          var headers = ApiEndPoints().setHeaderToken(token);
          var url = ApiEndPoints.baseUrl + ApiEndPoints.supplierEndPoints.updateSupplierViewEndPoint(id);
          Map body = createSupplierBody();
          final response = await http.patch(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: headers,
          );
          if (response.statusCode == 200) {
            Map<String, dynamic> json = jsonDecode(response.body);
            clearTextEditor();
            message.value = json["message"];
          } else {
            final responseData = jsonDecode(response.body);
            errorMessage.value = responseData['message'];
          }
        } catch (e) {
          errorMessage.value = e.toString();
        } finally {
          setIsLoadingTofalse();
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
    if (email.text.isEmpty) {
      emailValidation.value = "The email filed is required";
    } else if (!email.text.isEmail) {
      emailValidation.value = "The email format is incorrect";
    } else {
      emailValidation.value = "";
    }
    if (address.text.isEmpty) {
      addressValidation.value = "The address filed is required";
    } else {
      addressValidation.value = "";
    }
    if (phone.text.isEmpty) {
      phoneValidation.value = "The phone field is required";
    } else if (!phone.text.isPhoneNumber) {
      phoneValidation.value = "The phone number format is incorrect";
    } else {
      phoneValidation.value = "";
    }
    return phoneValidation.isEmpty &&
        addressValidation.isEmpty &&
        emailValidation.isEmpty &&
        nameValidation.isEmpty;
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
    email.text =supplier.value!.email;
    name.text =supplier.value!.name;
    phone.text =supplier.value!.phone;
    address.text =supplier.value!.address;
    remark.text =supplier.value!.remark ?? '';
  }

  // Method to set the state of Obsearvable isLoading to true
  bool setIsloadingToTrue(){
    return isLoading.value;
  }
  // Method to set the state of Obsearvable isLoading to false
  bool setIsLoadingTofalse(){
    return !isLoading.value;
  }
}
