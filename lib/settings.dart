
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/auth.dart';
import 'package:laravelsingup/controller/subscription.dart';
import 'package:laravelsingup/controller/user.dart';
import 'package:laravelsingup/pages/settings/notification.dart';
import 'package:laravelsingup/pages/settings/password.dart';
import 'package:laravelsingup/pages/settings/qrcode.dart';
import 'package:laravelsingup/pages/settings/subscription.dart';
import 'package:laravelsingup/profile/profile.dart';
import 'package:laravelsingup/widgets/attribute_row.dart';
import 'home.dart';


class SettingPage extends StatelessWidget {
  const SettingPage({super.key});
  // final user = FirebaseAuth.instance.currentUser!;
  
  @override
  Widget build(BuildContext context) {
    final UserController userController=Get.put(UserController());
    final AuthCheckController authCheckController=Get.put(AuthCheckController());
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        iconTheme: IconThemeData(color: Colors.green),
        actions: [
          IconButton(onPressed:(){Get.to(UserQRCode());}, icon: Icon(Icons.qr_code, size: 30))
        ],
        leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){Get.to(HomePage());},
        ), 
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: Column(children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Image.network("lib/images/profileIcon.png"),
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(() => AttributeRow(attribute: "Subscription Plan", value: userController.subscription.value!.type)),
                const SizedBox(
                  height: 10,
                ),
                Obx(() => AttributeRow(attribute: "Total Customers", value: userController.totalCustomers.toString())),
                const SizedBox(
                  height: 10,
                ),
                Obx(() => AttributeRow(attribute: "Total Suppliers", value: userController.totalSuppliers.toString()))
                
              ]),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  //border: Border.all(color: Colors.grey.shade200)
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              child: SettingItem(
                  title: "Profile",
                  icon: Icons.person,
                  backgroundIcon: Colors.blue,
                  onTap:(){
                     Get.to(UserProfile());
                  }
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  //border: Border.all(color: Colors.grey.shade200)
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  SettingItem(
                      title: "Notifications",
                      icon: Icons.notifications_sharp,
                      backgroundIcon: Colors.orange.shade300,
                      onTap: (){Get.to(NotificationSetting());}
                    ),
                  SettingItem(
                      title: "Premium Subscriptions",
                      icon: Icons.star_half_outlined,
                      backgroundIcon: Colors.green,
                      onTap: (){Get.to(SubscriptionSetting());}
                    ),
                  SettingItem(
                      title: "Change Password",
                      icon: Icons.lock,
                      backgroundIcon: Colors.grey,
                      onTap:(){Get.to(ChangePassword());}
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 55,
            ),
            GestureDetector(
              onTap: (){authCheckController.Logout();},
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: Text(
                    "Sign out",
                    style:
                        TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  ListTile SettingItem(
      {required String title,
      required IconData icon,
      required Color backgroundIcon,
      required Function () onTap}) {
    return ListTile(
      leading: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3), color: backgroundIcon),
          child: Icon(
            icon,
            color: Colors.white,
          )),
      title: Text(title),
      trailing: GestureDetector(
          onTap: onTap,
          child: Icon(
            Icons.arrow_forward_ios_outlined,
            color: Colors.grey.shade300,
          )),
    );
  }
}

// StreamBuilder getUserDetail(String id){
//   FireStoreServices firebase = FireStoreServices();
//   return StreamBuilder(stream: firebase.getUserDetail(id), builder: (context,snapshot){
//     if(snapshot.hasData){
//       DocumentSnapshot doc =snapshot.data;  
//       return Expanded(child: Text(doc["fullname"] ?? "no name"));
//     }else{
//       return SizedBox();
//     }
//   });
// }