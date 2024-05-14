import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laravelsingup/controller/register.dart';
import 'package:laravelsingup/pages/auth/login.dart';
import 'package:laravelsingup/widgets/form/custom_text_field.dart';
import 'package:laravelsingup/widgets/form/input_button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterationController register =Get.put(RegisterationController());
     return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                child: Image.network(
                  "lib/images/logo.png",
                  fit: BoxFit.contain,
                ),
                width: 200,
                height: 100,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Signup",
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Obx(() => 
              register.errorMessage.isEmpty ? SizedBox() :
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                alignment: Alignment.centerLeft,
                height: 70,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.red, width: 2),
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(5)),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Text(register.errorMessage.toString()),
              ),),
            Obx(() =>    CustomTextField(
                label: "Fullname",
                controller: register.nameController,
                validation: register.nameValidation.toString(),
                gapHeight: 15),),
            Obx(() =>  CustomTextField(
                label: "Email",
                controller: register.emailController,
                validation: register.emailValidation.toString(),
                gapHeight: 15)),
            Obx(() =>  CustomTextField(
              label: "Password",
              controller: register.passwordController,
              validation: register.confirmPasswordValidation.toString(),
              gapHeight: 15,
              obscureText: true,
            )),
            Obx(() => CustomTextField(
              label: "Confirm Password",
              controller: register.confirmPasswordController,
              validation: register.confirmPasswordValidation.toString(),
              gapHeight: 15,
              obscureText: true,
            )),
            Row(
              children: [
                Text("Already have an account ?"),
                TextButton(
                    onPressed: (){Get.to(Login());},
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            InputButton(
                label: "Signup",
                onPress: () {
                  register.registerWithEmailandPassword();
                },
                backgroundColor: Colors.green,
                color: Colors.white),
            const SizedBox(
              height: 25,
            ),
            Align(
              child: Text("or Signup with google"),
              alignment: Alignment.center,
            ),
            const SizedBox(
              height: 25,
            ),
            MaterialButton(
                onPressed: () {},
                child: SizedBox(
                  child: Image.network(
                    "lib/images/google.png",
                    fit: BoxFit.contain,
                  ),
                  width: 200,
                  height: 40,
                )),
          ]),
        ),
            ),
      ));
  }
}
