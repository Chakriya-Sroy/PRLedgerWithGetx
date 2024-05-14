import 'dart:convert';

import 'package:get/get.dart';
import 'package:laravelsingup/model/payable.dart';
import 'package:laravelsingup/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class PayableController extends GetxController{
  

RxList<PayableModel>payables=RxList();
RxString message =RxString('');
RxString errorMessage=RxString('');
RxInt lengthofPayableList =0.obs;
RxBool isLoading =false.obs;
RxList<String>ListofSupplierName=RxList();
RxList<String>ListofSupplierId=RxList();

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
            ListofSupplierName.add(info["attributes"]["fullname"]);
          }
          print(ListofSupplierId);
          print(ListofSupplierName);
        
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
  bool setIsloadingToTrue(){
    return isLoading.value;
  }
  bool setIsLoadingTofalse(){
    return !isLoading.value;
  }
}