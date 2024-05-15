import 'package:intl/intl.dart';

class ReceivableModel {
  final String id;
  final String customerId;
  String ? customerName;
  final String title;
  final double amount;
  final double remaining;
  final String date;
  final String dueDate;
  final String status;
  final String paymentTerm;
  String? remark;
  String? attachment;
  ReceivableModel(
      {required this.id,
      required this.title,
      required this.customerId,
      required this.amount,
      required this.remaining,
      required this.date,
      required this.dueDate,
      required this.paymentTerm,
      required this.status,
      this.customerName,
      this.attachment,
      this.remark
      }
    );
   factory ReceivableModel.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'];
    return ReceivableModel(
      id: attributes['id'].toString(),
      title: attributes['title'],
      customerId: attributes['customerId'].toString(),
      amount: attributes['amount'],
      remaining: attributes['remaining'],
      customerName: attributes["customerName"],
      attachment: attributes['attachment'] ==null ? '' : attributes['attachment'],
      remark: attributes['remark']==null ?'':attributes['remark'],
      paymentTerm: attributes['payment_term'],
      date: attributes['date'],
      dueDate: attributes['dueDate'],
      status: attributes['status']
    );
  }
}

class ReceivablePaymentModel {
  final String id;
  final String receivableId;
  final String userId;
  final double amount;
  final String date;
  String ? remark;
  String  ? attachment;
  ReceivablePaymentModel({required this.id,required this.receivableId,required this.userId,required this.amount,this.attachment,this.remark,required this.date});
  factory ReceivablePaymentModel.fromJson(Map<String,dynamic>json){
    return ReceivablePaymentModel(
      id:json["id"].toString(),
      userId:json["user_id"].toString(),
      receivableId:json["receivable_id"].toString(),
      amount:double.parse(json["amount"]),
      date:json["date"],
      remark:json["remark"],
      attachment:json["attachment"]
    );
  }
}
