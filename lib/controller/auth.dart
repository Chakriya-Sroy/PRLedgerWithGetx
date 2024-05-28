import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCheckController extends GetxController {
  RxBool isUserLogin = false.obs;
  RxBool isMerchance =true.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    IdentifyUser();
    super.onInit();
  }

  Future<void> IdentifyUser() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("token") == null) {
      isUserLogin.value = false;
    } else {
      isUserLogin.value = true;
    }
  }
  Future<void> IdentifyUserRole() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("role") == "Collector") {
      isMerchance.value = false;
    } else {
      isMerchance.value = true;
    }
  }

  Future<void> Logout() async{
      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.remove("token");
      isUserLogin.value=false;
  }
}
