import 'package:flutter/material.dart';
import '../form/input_button.dart';
class ProfileCard extends StatelessWidget {
  ProfileCard({
    super.key,
    required this.supplier,
    required this.address,
    required this.fullname,
    required this.email,
    required this.phone,
    this.gender,
    this.remark,
  });

  final bool supplier;
  final String fullname;
  String ?gender;
  final String email;
  final String address;
  final String phone;
  String ? remark;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 300,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(4.0, 4.0),
                blurRadius: 10.0,
                spreadRadius: 1.0,
              )
            ],
          ),
        ),
        Positioned(
          top: -30,
          left: 0,
          right: 0,
          child: Column(
            children: [
              ProfileAvata(fullname: fullname),
              if(!supplier)
                ProfileDetail(gender: gender,email: email,phone: phone,address: address,remark: remark ?? '',)
              else
                ProfileDetail(email: email,phone: phone,address: address,remark: remark ?? '',)
            ],
          ),
        ),
      ],
    );
  }
}

class ProfileAvata extends StatelessWidget {
  final String fullname;
  const ProfileAvata({super.key, required this.fullname});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green.shade300,
          ),
          child: SizedBox(
            child: Image.asset(
              "lib/images/profileIcon.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(
          fullname,
          style: TextStyle(color: Colors.green),
        ),
      ],
    );
  }
}

class ProfileDetail extends StatelessWidget {
  final String ?gender;
  final String phone;
  final String email;
  final String address;
  final String remark;
  const ProfileDetail({super.key,this.gender, required this.phone,required this.email,required this.address,required this.remark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (gender != null) // Conditionally display Gender row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Gender',
                  style: TextStyle(color: Colors.green),
                ),
                Text(gender!), // Access gender using null-aware operator
              ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Phone Number',
                style: TextStyle(color: Colors.green),
              ),
              Text(phone)
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Email',
                style: TextStyle(color: Colors.green),
              ),
              Text(email)
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Address',
                style: TextStyle(color: Colors.green),
              ),
              Flexible(child: Text(address))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Remark',
                style: TextStyle(color: Colors.green),
              ),
              Flexible(child: Text(remark))
            ],
          ),
        ],
      ),
    );
  }
}
