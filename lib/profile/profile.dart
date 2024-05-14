
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/user.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../settings.dart';


class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController=Get.put(UserController());
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 40),
          child: Column(
            children: [
              Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                          return SettingPage();
                      }));
                    },
                    child: Text("Cancel",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green),)),
                  Text("Done",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green),)
                ],
              ),
              const SizedBox(height: 50,),
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle
                ),
                child: Image.network("lib/images/profileIcon.png"),
              ),
              const SizedBox(height: 10,),
              Container(
                margin:const EdgeInsets.only(bottom: 15,top: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text("Upload new profile"),
                ),
              ),
              Align(alignment: Alignment.centerLeft ,child: Text("User Information",style:TextStyle(color:Colors.grey.shade500))),
              const SizedBox(height: 10,),
            
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  children: [
                    TextField(controller: userController.fullname,decoration: InputDecoration(hintText:"Full name",border: InputBorder.none)),
                    TextField(controller: userController.email,decoration: InputDecoration(hintText:"Email",border: InputBorder.none)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showImagePickerOption(BuildContext context){
    showModalBottomSheet(context: context, builder: (context){
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/4,
        child: Column(children: [
          IconButton(
            onPressed: ( )async{
              PermissionStatus cameraStatus =await Permission.camera.request();
              if(cameraStatus == PermissionStatus.granted){
                // perform operation
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Permission Granted")));
              }
              if(cameraStatus == PermissionStatus.denied){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("You need to provide camera permission")));
              }
              if(cameraStatus == PermissionStatus.limited){
                openAppSettings();
              }
            }, 
            icon: Icon(Icons.camera_alt)),
            IconButton(
            onPressed: ( ){} ,
            icon: Icon(Icons.image))
        ]),
      );
    });
  }
}