import 'package:get/get.dart';

class CollectorModel{
  final String id;
  final String name;
  final String email;
  late RxBool hasCollectorRequest;
  CollectorModel({required this.id,required this.name,required this.email,required this.hasCollectorRequest});
  factory CollectorModel.fromJson(Map<String, dynamic> json) {
    return CollectorModel(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      hasCollectorRequest: json["has_collector_request"] ==true ? RxBool(true):RxBool(false)
    );
  }
}

class SenderModel{
  final String id;
  final String name;
  final String email;
  SenderModel({required this.id,required this.name,required this.email});
  factory SenderModel.fromJson(Map<String, dynamic> json) {
    return SenderModel(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
    );
  }
}
class ReceiverModel{
  final String id;
  final String name;
  final String email;
  ReceiverModel({required this.id,required this.name,required this.email});
  factory ReceiverModel.fromJson(Map<String, dynamic> json) {
    return ReceiverModel(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
    );
  }
}