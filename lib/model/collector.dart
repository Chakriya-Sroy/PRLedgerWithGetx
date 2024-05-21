import 'package:get/get.dart';

class CollectorModel{
  final String id;
  final String name;
  final String email;
  var hasCollectorRequest =false.obs;
  CollectorModel({required this.id,required this.name,required this.email});
  factory CollectorModel.fromJson(Map<String, dynamic> json) {
    return CollectorModel(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
    );
  }
}
