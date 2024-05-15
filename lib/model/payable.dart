class PayableModel {
  final String id;
  final String supplierId;
  String ? supplierrName;
  final String title;
  final double amount;
  final double remaining;
  final String date;
  final String dueDate;
  final String status;
  final String paymentTerm;
  String? remark;
  String? attachment;
  PayableModel(
      {required this.id,
      required this.title,
      required this.supplierId,
      required this.amount,
      required this.remaining,
      required this.date,
      required this.dueDate,
      required this.paymentTerm,
      required this.status,
      this.supplierrName,
      this.attachment,
      this.remark
      }
    );
   factory PayableModel.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'];
    return PayableModel(
      id: attributes['id'].toString(),
      title: attributes['title'],
      supplierId: attributes['supplierId'].toString(),
      amount: attributes['amount'],
      remaining: attributes['remaining'],
      supplierrName: attributes["supplierName"],
      attachment: attributes['attachment'] ==null ? '' : attributes['attachment'],
      remark: attributes['remark']==null ?'':attributes['remark'],
      paymentTerm: attributes['payment_term'],
      date: attributes['date'],
      dueDate: attributes['dueDate'],
      status: attributes['status']
    );
  }
}

class PayablePaymentModel {
  final String id;
  final String payableId;
  final double amount;
  final String date;
  String ? remark;
  String  ? attachment;
  PayablePaymentModel({required this.id,required this.payableId,required this.amount,this.attachment,this.remark,required this.date});
  factory PayablePaymentModel.fromJson(Map<String,dynamic>json){
    final attributes=json["attributes"];
    return PayablePaymentModel(
      id:attributes[ "id"],
      payableId:attributes["payable_id"],
      amount:attributes["amount"],
      date:attributes["date"],
      remark:attributes["remark"],
      attachment:attributes["attachment"]
    );
  }
}
