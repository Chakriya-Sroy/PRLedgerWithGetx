import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/login.dart';
import 'package:laravelsingup/widgets/form/input_text.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
                Text("Forgot Password", style: TextStyle(color: Colors.green)),
            iconTheme: IconThemeData(color: Colors.green),
            centerTitle: true),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                Text(
                    "Input your email address, and we will send the verify link to set new password"),
                const SizedBox(
                  height: 15,
                ),
                InputTextField(
                  label: "",
                  controller: loginController.emailController,
                  hintText: "Your Email",
                ),
                const SizedBox(
                  height: 15,
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () async {
                        await loginController.forgotPasswordResetLink();
                        if (loginController.isSuccess.value) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Obx(() => Text(loginController.message.toString(),
                                  style: TextStyle(color: Colors.white))),
                            ),
                          );
                        }
                      },
                      child: Text(
                        "Send",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}
