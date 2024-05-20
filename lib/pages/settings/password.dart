import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/settings.dart';
import 'package:laravelsingup/widgets/form/input_button.dart';
import 'package:laravelsingup/widgets/form/input_text.dart';
import 'package:laravelsingup/widgets/message/show_message.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _currentPassword=TextEditingController();
  final TextEditingController _newPassword=TextEditingController();
  final TextEditingController _confirmPassword=TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar:AppBar(
        backgroundColor: Colors.grey.shade100,
        iconTheme: IconThemeData(color: Colors.green),
         leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: (){Get.to(const SettingPage());},
        ), 
      ) ,
      body: SingleChildScrollView(
        child:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ 
              InputTextField(label: "Current password", controller: _currentPassword,obscureText: true,hintText: "Current Password",boxShadow: false,hidePasswordIcon: false,),
              const SizedBox(height: 10,),
              InputTextField(label: "New password", controller: _newPassword,obscureText: true,hintText: "New Password",boxShadow: false,hidePasswordIcon: false,),
              const SizedBox(height: 10,),
              InputTextField(label: "Confirm password", controller: _confirmPassword,obscureText: true,hintText: "Confirm Password",boxShadow: false,hidePasswordIcon: false,),
              const SizedBox(height: 30,),
              InputButton(label: "Save", onPress: (){
                 if(_newPassword.text.isEmpty || _confirmPassword.text.isEmpty){
                  showAlertMessageBox(context,Errormessage: "Password Field is required");
                 }
                 else if(_newPassword.text !=_confirmPassword.text){
                  showAlertMessageBox(context,Errormessage: "New Password and Confirm Password not match");
                 }
              }, backgroundColor: Colors.green, color: Colors.white)
            ]
          )
        ) 
      ),
    );
  }
}