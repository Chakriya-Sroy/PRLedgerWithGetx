import 'package:get/get.dart';

class CustomerModel{
  final String id;
  final String name;
  final String phone;
  final String ? email;
  final String ? address;
  final String ? remark;
  final double totalRemaining;
  final double totalReceivable;
  final double totalReceivableAmount;
  final String gender;
  CustomerModel({
    required this.id,
    required this.name,
    this.email,
    required this.phone,
    this.address,
    required this.totalRemaining,
    required this.totalReceivable,
    required this.totalReceivableAmount,
    this.remark,
    required this.gender});
  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'];
    return CustomerModel(
      id: attributes['id'],
      name: attributes['name'],
      gender: attributes['gender'],
      phone: attributes['phone'],
      email: attributes['email'],
      address: attributes['address'],
      remark: attributes['remark'],
      totalReceivable: attributes['total_receivables'],
      totalReceivableAmount: attributes['total_receivable_amount'],
      totalRemaining: attributes['total_remaning'],
    );
  }
  
}
class AssignCustomerModel{
  final String id;
  final String name;
  AssignCustomerModel({required this.id,required this.name});
   factory AssignCustomerModel.fromJson(Map<String, dynamic> json) {
    return AssignCustomerModel(id: json["id"].toString(), name:json["fullname"]);
   }
}
class TransactionModel {
  final int id;
  final int customerId;
  final String transactionType;
  final int? receivableId;
  final int? paymentId;
  final double amount;
  final String transactionDate;

  TransactionModel({
    required this.id,
    required this.customerId,
    required this.transactionType,
    this.receivableId,
    this.paymentId,
    required this.amount,
    required this.transactionDate,
   
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedTransactionDate = DateTime.parse(json['transaction_date']);
    DateTime transactionDay = DateTime(parsedTransactionDate.year, parsedTransactionDate.month, parsedTransactionDate.day);
    Duration difference = DateTime.now().difference(transactionDay);
    int daysDifference = difference.inDays;

    return TransactionModel(
      id: json['id'],
      customerId: json['customer_id'],
      transactionType: json['transaction_type'],
      receivableId: json['receivable_id'],
      paymentId: json['payment_id'],
      amount: double.parse(json['amount']),
      transactionDate: daysDifference==1 ? "Added yesterday" : daysDifference==0 ? "Added today" : "Added $daysDifference days ago"
    );
  }
}
