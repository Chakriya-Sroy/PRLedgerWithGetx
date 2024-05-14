

class UserModel {
  final String name;
  final String email;
  final String id;
  final bool hasCollectorRole;
  UserModel({
    required this.name,
    required this.email,
    required this.id,
    required this.hasCollectorRole
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      hasCollectorRole: json['has_collector_role'],
    );
  }
}

class Subscription{
  final String type;
  DateTime ? start;
  DateTime  ? end;
  bool ? active;
  Subscription({required this.type,this.start,this.end,this.active});
  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      type: json['type'],
      start: json['start'] != null ? DateTime.parse(json['start']) :null,
      end: json['end'] != null ? DateTime.parse(json['end']) : null,
      active: json['status'] == 'active' ? true :false,
    );
  }
}

class Receivable{
  final double total;
  final double outstanding;
  final double remaining;
  Receivable({required this.total,required this.outstanding,required this.remaining});
  factory Receivable.fromJson(Map<String,dynamic>json){
    return Receivable(total: json['total_receivables'], outstanding: json['total_outstanding'], remaining: json['total_remaining']);
  }
}

class UpcomingReceivable{
  final String id;
  final String customer;
  final String status;
  final double remaining;
  final String upcoming;
  UpcomingReceivable({required this.id,required this.customer,required this.remaining,required this.status,required this.upcoming});
  factory UpcomingReceivable.fromJson(Map<String,dynamic>json){
    return UpcomingReceivable(id: json['id'], remaining: json['remaining'], customer: json['customer'],status: json["status"],upcoming: json["upcoming"]);
  }

}

class Payable{
  final double total;
  final double outstanding;
  final double remaining;
  Payable({required this.total,required this.outstanding,required this.remaining});
  factory Payable.fromJson(Map<String,dynamic>json){
    return Payable(total: json['total_payables'], outstanding: json['total_outstanding'], remaining: json['total_remaining']);
  }
}
