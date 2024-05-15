import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laravelsingup/model/payable.dart';
import 'package:laravelsingup/pages/merchant/payable/payable.dart';
import 'package:laravelsingup/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class PayableController extends GetxController{

// TextEditingController
TextEditingController title =TextEditingController();
TextEditingController remark=TextEditingController();
TextEditingController amount =TextEditingController();  

//Validation
RxString titleValidation = "".obs;
RxString amountValidation = "".obs;
RxString dueDateValidation = "".obs;

RxList<PayableModel>payables=RxList();
late Rx<PayableModel ?>payable=Rx<PayableModel?>(null);
RxString message =RxString('');
RxString errorMessage=RxString('');
RxInt lengthofPayableList =0.obs;
RxBool isLoading =false.obs;

// For Supplier Select Options
RxList<String>ListofSupplierName=RxList();
RxList<String>ListofSupplierId=RxList();
RxString selectedSupplier =RxString('');
RxString payableId=RxString('');


RxString attachment=RxString('');
// DateTime
DateTime date =DateTime.now();
late DateTime dueDate=DateTime.now();
RxString selectedDate=RxString('');
RxString selectedDueDate=RxString('');
RxString selectedSupplierValidation =RxString('');
 
  // For PaymentTerm Options Selection
final List<String> paymentOptions = ["equal to due date", '7', '15'];
final List<String> payments = ["0", "7", "15"];
RxString selectedPaymentTermValidation = "".obs;
RxString selectedPaymentTerm=RxString('');
// List of Payable Payment
RxList <PayablePaymentModel>payablePayments=RxList();

 Map<String,dynamic> createPayableBody(){
  return {
    'title':title.text,
    'supplier_id':selectedSupplier.value,
    'amount':amount.text,
    'payment_term':selectedPaymentTerm.value == "0" ? 'equaltodueDate' : selectedPaymentTerm.value,
    'remark':remark.text,
    'status':'outstanding',
    'attachment':attachment.value,
    'date':selectedDate.value =='' ? DateFormat('yyyy-MM-dd').format(date) : selectedDate,
    'dueDate':selectedDueDate.value,
  };
 }
 Map<String,dynamic> createPaymentBody(){
  return {
    'payable_id':payableId.value,
    'amount':amount.text,
    'remark':remark.text,
    'attachment':attachment.value
  };
 }


// Create Payable
// Note haven't Dont yet
Future<void>createPayablePayment () async{
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      try {
        var headers = ApiEndPoints().setHeaderToken(token);
        var url = ApiEndPoints.baseUrl + ApiEndPoints.payableEndPoints.payablePayments;
        Map body = createPaymentBody();
          final response = await http.post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: headers,
          );
          if(response.statusCode==200){
              clearTextEditor();
              Map<String, dynamic> jsonResponse = jsonDecode(response.body);
              Map<String,dynamic>data=jsonResponse["data"][0]["attributes"];
              payablePayments.add(PayablePaymentModel.fromJson(data));
              message.value=jsonResponse["message"];  
          }else{
            print(jsonDecode(response.body)["message"]);
          }

        }catch(e){
          errorMessage.value=e.toString();
          print(errorMessage);
        }finally{
          setIsLoadingTofalse();
        }
    }
   
 }


// Create Payable
Future<void>createPayable() async{
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      if (validation()) {
        try {
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
            message.value = "";
            message.value = json["message"];
            payables.add(PayableModel.fromJson(json));
            Get.off(const PayablePage());
            print(message);

          //  Get.off(constSupplierPage());
          } else {
            final responseData = jsonDecode(response.body);
            final errorMessage = responseData['message'];
            errorMessage.value = errorMessage;
            print(errorMessage);
          }
        } catch (e) {
          errorMessage.value = e.toString();
          print(errorMessage);
        }finally{
          setIsLoadingTofalse();
        }
      }
    }
  }
// Fetch Individual Payable
Future<void>fetchIndividualPayable(String id) async{
    final pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token");
    if (token != null) {
      try {
        var headers = ApiEndPoints().setHeaderToken(token);
        var url =
            ApiEndPoints.baseUrl + ApiEndPoints.payableEndPoints.getPayableViewEndPoint(id);
        final response = await http.get(Uri.parse(url), headers: headers);
        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          Map<String,dynamic> payableData = jsonResponse["data"];
          // Get a receivable value
           payable.value=PayableModel.fromJson(payableData); 
          // // Get payment of receivable
         List paymentData = jsonResponse["data"]["relationships"]["payment"];
          payablePayments.clear();
          for ( var payment in paymentData){
            payablePayments.add(
              PayablePaymentModel(
              id: payment["id"].toString(),
              payableId: payment["payable_id"].toString(),
              amount: payment["amount"],
              date: payment["date"]
              )
            );
          }
        } else {
          final responseData = jsonDecode(response.body);
           errorMessage.value  = responseData['message'];
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
          List<dynamic> PayableList = jsonResponse["data"];
          List<PayableModel> receivableData = PayableList
              .map((payable) => PayableModel.fromJson(payable))
              .toList();
          payables.clear();
          payables.addAll(receivableData);
          lengthofPayableList.value=payables.length;  
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
          for(var info in supplierList){
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

  void clearTextEditor(){
    remark.clear();
    title.clear();
    amount.clear();
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
      if(selectedDueDate.isEmpty){
        dueDateValidation.value="Please select Due Date";
      }else{
            dueDateValidation.value="";
      }
    
      return titleValidation.isEmpty &&  selectedSupplierValidation.isEmpty && dueDateValidation.isEmpty && amountValidation.isEmpty &&selectedPaymentTermValidation.isEmpty;
  }

  bool setIsloadingToTrue(){
    return isLoading.value;
  }
  bool setIsLoadingTofalse(){
    return !isLoading.value;
  }
}