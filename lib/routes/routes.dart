import 'package:get/get.dart';
import 'package:laravelsingup/home.dart';
import 'package:laravelsingup/pages/auth/Register.dart';
import 'package:laravelsingup/pages/auth/authcheck.dart';
import 'package:laravelsingup/pages/auth/login.dart';
import 'package:laravelsingup/pages/merchant/customer/customer.dart';
import 'package:laravelsingup/pages/merchant/customer/customer_form.dart';

class Routes {
  static String home = '/home';
  static String customer = '/customer';
  static String customerForm='/customer/create';
  static String auth = '/';
  static String login = '/login';
  static String register = '/register';
 // static String screen6 = '/screen6;
 static String getHomeRoute()=>home;
 static String getCustomerRoute()=>customer;
 static String getLoginRoute()=>login;
 static String getAuthRoute()=>auth;
 static String getRegisterRoute()=>register;
 static String getCustomerCreateRoute()=>customerForm;
 static List <GetPage> getPages = [
  GetPage(
    name: Routes.auth,
    page: ()=>AuthCheck()),
  GetPage(
    name: Routes.home,
    page: () => const HomePage(),
  ),
  GetPage(
    name: Routes.login,
    page: () => const Login(),
  ),
  GetPage(
    name: Routes.register,
    page: () => const RegisterPage(),
  ),
  GetPage(name: Routes.customer,page: ()=>const CustomerPage()),
  GetPage(name: Routes.customerForm, page: ()=>const CustomerForm())
];
}