class SupplierModel{
  final String id;
  final String name;
  final String phone;
  String ?email;
  String ?address;
  String ? remark;
  final double totalRemaining;
  final double totalPayable;
  final double totalPayableAmount;
  SupplierModel({
    required this.id,
    required this.name,
    this.email,
    required this.phone,
    this.address,
    required this.totalPayable,
    required this.totalRemaining,
    required this.totalPayableAmount,
    this.remark,
    });
  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'];
    return SupplierModel(
      id: attributes['id'],
      name: attributes['name'],
      phone: attributes['phone'],
      email: attributes['email'],
      address: attributes['address'],
      remark: attributes['remark'],
      totalPayable: attributes['total_payables'],
      totalPayableAmount: attributes['total_payable_amount'],
      totalRemaining: attributes['total_remaning'],
    );
  }
  
}
class TransactionModel {
  final int id;
  final int supplierId;
  final String transactionType;
  final int? payableId;
  final int? paymentId;
  final double amount;
  final String transactionDate;

  TransactionModel({
    required this.id,
    required this.supplierId,
    required this.transactionType,
    this.payableId,
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
      supplierId: json['supplier_id'],
      transactionType: json['transaction_type'],
      payableId: json['payable_id'],
      paymentId: json['payment_id'],
      amount: double.parse(json['amount']),
      transactionDate: daysDifference==1 ? "Added yesterday" : daysDifference==0 ? "Added today" : "Added $daysDifference days ago"
    );
  }
}
