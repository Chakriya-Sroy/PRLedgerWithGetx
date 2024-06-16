import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/model/customer.dart';
import 'package:laravelsingup/model/receivable.dart';
import 'package:laravelsingup/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CustomerController extends GetxController {
  //TextEditingController For Create Customer
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
  var gender = RxString("Male");
  var message = RxString("");

  // is Success
  RxBool isSuccess = false.obs;
  // Is Loading to listent to progress of fetching data from API
  RxBool isLoading = false.obs;
  // is Failed
  RxBool isFailed = false.obs;
  // Obsearvable String to listent to Search Editing Controller For fitlter Customer List
  RxString searchTerm = ''.obs;

  // Obsearvable Customer List instance from customer model
  RxList<CustomerModel> customers = RxList();
  RxList<CustomerModel> assignCustomers = RxList();
  // Obseravable Customer instance form customer model and customer that user has been assign
  Rx<CustomerModel?> customer = Rx<CustomerModel?>(null);
  Rx<CustomerModel?> assignCustomer = Rx<CustomerModel?>(null);
  // Observable Customer Receivables
  RxList<ReceivableModel> customerReceivables = RxList();
  // Obseravable Customer transaction from transaction model
  RxList<TransactionModel> transactions = RxList();
  // Obsearvabel errormessage
  RxString errorMessage = ''.obs;

  // Obsearvable length of Customer's List
  RxInt customerLenght = 0.obs;
  RxInt assignCustomerLength = 0.obs;
  // Obseravable Length of Transaction's List
  RxInt transactionLength = 0.obs;

  // Collector and its customer that already assign or haven't
  RxList<AssignCustomerModel> ListofAssignCustomerToCollector = RxList();

  // Future function to fetch transaction
  Future<void> fetchTransactionLog(String id) async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      try {
        isLoading.value = true;
        var headers = ApiEndPoints().setHeaderToken(token);
        var url = ApiEndPoints.baseUrl +
            ApiEndPoints.customerEndPoints.getCustomerTransacctionEndPoint(id);
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
        isLoading.value = false;
      }
    }
  }

  // future function to fetch indiviudal customer base on Id
  Future<void> fetchIndividualCustomer(String id) async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      try {
        isLoading.value = true;
        var headers = ApiEndPoints().setHeaderToken(token);
        var url = ApiEndPoints.baseUrl +
            ApiEndPoints.customerEndPoints.getCustomerViewEndpoint(id);
        final response = await http.get(Uri.parse(url), headers: headers);

        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          Map<String, dynamic> customerAttributes = jsonResponse["data"];
          customer.value = CustomerModel.fromJson(customerAttributes);
          List receivables = customerAttributes["receivables"];
          customerReceivables.clear();
          for (var receivable in receivables) {
            customerReceivables.add(ReceivableModel(
                isArchive: receivable['isArchive'],
                id: receivable["id"].toString(),
                customerId: receivable["customer_id"].toString(),
                amount: receivable["amount"],
                remaining: receivable["remaining"],
                date: receivable["date"],
                dueDate: receivable["dueDate"],
                paymentTerm: receivable["payment_term"],
                status: receivable["status"]));
          }
        }
      } catch (e) {
        errorMessage.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> fetchAssignCustomer() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      try {
        isLoading.value = true;
        var headers = ApiEndPoints().setHeaderToken(token);
        var url =
            ApiEndPoints.baseUrl + ApiEndPoints.customerEndPoints.customerAssignList;
        final response = await http.get(Uri.parse(url), headers: headers);
        if (response.statusCode == 200) {
         
          List<dynamic> customerList = jsonDecode(response.body);
          List<CustomerModel> customersData = customerList
              .map((customerData) => CustomerModel.fromJson(customerData))
              .toList();
          assignCustomers.clear();
          assignCustomers.addAll(customersData);
          assignCustomerLength.value=assignCustomers.length;
        } else {
          final responseData = jsonDecode(response.body);
          final errorMessage = responseData['message'];
          message.value = errorMessage;
        }
      } catch (e) {
        print (e);
      } finally {
        isLoading.value = false;
      }
    }
  }

 
  // future function to fetch all customer belong to authentication user
  Future<void> fetchCustomer() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      try {
        isLoading.value = true;
        var headers = ApiEndPoints().setHeaderToken(token);
        var url =
            ApiEndPoints.baseUrl + ApiEndPoints.customerEndPoints.customerList;
        final response = await http.get(Uri.parse(url), headers: headers);
        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          // List of customer that belong to user
          List<dynamic> customerList = jsonResponse["data"];
          List<CustomerModel> customersData = customerList
              .map((customerData) => CustomerModel.fromJson(customerData))
              .toList();
          customers.clear();
          customers.addAll(customersData);
          customerLenght.value = customers.length;
        } else {
          final responseData = jsonDecode(response.body);
          final errorMessage = responseData['message'];
          message.value = errorMessage;
        }
      } catch (e) {
        errorMessage.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    }
  }

  // future function to add new customer
  Future<void> addCustomer() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      if (validation()) {
        clearInitialMessage();
        isLoading.value = true;
        try {
          var headers = ApiEndPoints().setHeaderToken(token);
          var url = ApiEndPoints.baseUrl +
              ApiEndPoints.customerEndPoints.customerCreate;
          Map body = createCustomerBody();
          final response = await http.post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: headers,
          );
          if (response.statusCode == 200) {
            Map<String, dynamic> json = jsonDecode(response.body);
            message.value = json["message"];
            //customers.add(CustomerModel.fromJson(json));
            isSuccess.value = true;
            clearTextEditor();
          } else {
            final responseData = jsonDecode(response.body);
            errorMessage.value = responseData['message'];
            isFailed.value = true;
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

  // future function to delete customer
  Future<void> deleteCustomer(String id) async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");

    if (token != null) {
      isSuccess.value = false;
      clearInitialMessage();
      try {
        isLoading.value = true;
        var headers = ApiEndPoints().setHeaderToken(token);
        var url = ApiEndPoints.baseUrl +
            ApiEndPoints.customerEndPoints.deleteCustomerEndPoint(id);

        final response = await http.delete(
          Uri.parse(url),
          headers: headers,
        );
        if (response.statusCode == 200) {
          message.value = jsonDecode(response.body)["message"];
          isSuccess.value = true;
        } else {
          errorMessage.value = jsonDecode(response.body)["message"];
          isFailed.value = true;
        }
      } catch (e) {
        errorMessage.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    }
  }

  // future function to update customer base on Id
  Future<void> updateCustomer(String id) async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    isSuccess.value = false;
    isLoading.value = true;
    if (token != null) {
      if (validation()) {
        try {
          clearInitialMessage();
          var headers = ApiEndPoints().setHeaderToken(token);
          var url = ApiEndPoints.baseUrl +
              ApiEndPoints.customerEndPoints.updateCustomerViewEndPoint(id);
          Map body = createCustomerBody();
          final response = await http.patch(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: headers,
          );
          if (response.statusCode == 200) {
            Map<String, dynamic> json = jsonDecode(response.body);
            message.value = json["message"];
            isSuccess.value = true;
          } else {
            final responseData = jsonDecode(response.body);
            errorMessage.value = responseData['message'];
          }
        } catch (e) {
          errorMessage.value = e.toString();
        } finally {
          isLoading.value = false;
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

  // Assign customer to collector
  Future<void> assignCustomerToCollector(
      String collectorId, String customerId) async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    isSuccess.value = false;
    isLoading.value = true;
    if (token != null) {
      try {
        clearInitialMessage();
        var headers = ApiEndPoints().setHeaderToken(token);
        var url = ApiEndPoints.baseUrl +
            ApiEndPoints.customerEndPoints.customerAssignToCollector;
        Map body =
            createAssignOrUnassignCustomerRequestBody(collectorId, customerId);
        final response = await http.post(
          Uri.parse(url),
          body: jsonEncode(body),
          headers: headers,
        );
        if (response.statusCode == 200) {
          Map<String, dynamic> json = jsonDecode(response.body);
          message.value = json["message"];
          isSuccess.value = true;
        } else {
          final responseData = jsonDecode(response.body);
          errorMessage.value = responseData['message'];
          print(errorMessage);
        }
      } catch (e) {
        print(e.toString());
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Unassign customer from collector
  Future<void> unassignCustomerFromCollector(
      String collectorId, String customerId) async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    isSuccess.value = false;
    isLoading.value = true;
    if (token != null) {
      try {
        clearInitialMessage();
        var headers = ApiEndPoints().setHeaderToken(token);
        var url = ApiEndPoints.baseUrl +
            ApiEndPoints.customerEndPoints.customerUnassignToCollector;
        Map body =
            createAssignOrUnassignCustomerRequestBody(collectorId, customerId);
        final response = await http.post(
          Uri.parse(url),
          body: jsonEncode(body),
          headers: headers,
        );
        if (response.statusCode == 200) {
          Map<String, dynamic> json = jsonDecode(response.body);
          message.value = json["message"];
          isSuccess.value = true;
        } else {
          final responseData = jsonDecode(response.body);
          errorMessage.value = responseData['message'];
          print(errorMessage);
        }
      } catch (e) {
        print(e.toString());
      } finally {
        isLoading.value = false;
      }
    }
  }


  Future<void> fetchAssignCustomerToCollector() async {
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      isLoading.value = true;
      try {
        var headers = ApiEndPoints().setHeaderToken(token);
        var url = ApiEndPoints.baseUrl +
            ApiEndPoints.customerEndPoints.customerThatAlreadyAssignToCollector;
        final response = await http.get(Uri.parse(url), headers: headers);
        if (response.statusCode == 200) {
          List<dynamic> jsonResponse = jsonDecode(response.body)["data"];
          ListofAssignCustomerToCollector.clear();
          for (var item in jsonResponse) {
            ListofAssignCustomerToCollector.add(
                AssignCustomerModel.fromJson(item));
          }
        } else {
          errorMessage.value = jsonDecode(response.body)["message"];
        }
      } catch (e) {
        print(e.toString());
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Method to create body form to send to API
  Map<String, String> createCustomerBody() {
    return {
      'fullname': name.text,
      'email': email.text,
      'address': address.text,
      'phone': phone.text,
      'gender': gender.value,
      'remark': remark.text,
    };
  }

  Map<String, dynamic> createAssignOrUnassignCustomerRequestBody(
      String collectorId, String customerId) {
    return {'collector_id': collectorId, 'customer_id': customerId};
  }

  // Method to filter Customer base  on Obsearvable search term
  List<CustomerModel> filterCustomers() {
    searchTerm.value = search.text;
    if (searchTerm.isEmpty) {
      return customers; // Return all customers if search text is empty
    } else {
      return customers
          .where((customer) => customer.name.toLowerCase().contains(searchTerm))
          .toList();
    }
  }
  List<CustomerModel> filterAssignCustomers() {
    searchTerm.value = search.text;
    if (searchTerm.isEmpty) {
      return assignCustomers; // Return all customers if search text is empty
    } else {
      return assignCustomers
          .where((customer) => customer.name.toLowerCase().contains(searchTerm))
          .toList();
    }
  }

  List<CustomerModel> filterUnassignCustomers() {
    // Map IDs from ListofAssignCustomerToCollector
    List<String> assignedCustomerIds = ListofAssignCustomerToCollector.map(
        (assignCustomer) => assignCustomer.id).toList();

    // Filter customers to exclude those with IDs in the assignedCustomerIds list
    return customers
        .where((customer) => !assignedCustomerIds.contains(customer.id))
        .toList();
  }

  // Method to assigng initial text value to TextEditingController
  void AssignCustomerValueToTextEditor() {
    email.text = customer.value!.email ?? '';
    name.text = customer.value!.name;
    phone.text = customer.value!.phone;
    address.text = customer.value!.address ?? '';
    remark.text = customer.value!.remark ?? '';
  }

  // Method to set the state of Obsearvable isLoading to true
  bool setIsloadingToTrue() {
    return isLoading.value;
  }

  // Method to set the state of Obsearvable isLoading to false
  bool setIsLoadingTofalse() {
    return !isLoading.value;
  }

  bool setIsSuccessToTrue() {
    return isSuccess.value;
  }

  bool setIsSuccessToFalse() {
    return !isSuccess.value;
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
