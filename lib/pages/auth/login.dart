import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:laravelsingup/controller/login.dart';
import 'package:laravelsingup/controller/register.dart';
import 'package:laravelsingup/home.dart';
import 'package:laravelsingup/pages/auth/register.dart';
import 'package:laravelsingup/widgets/form/custom_text_field.dart';
import 'package:laravelsingup/widgets/form/input_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginController login = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(
          children: [
            SafeArea(
              child: Scaffold(
                  body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
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
                        "Login",
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Obx(() => login.errorMessage.isEmpty
                        ? SizedBox()
                        : Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 20),
                            alignment: Alignment.centerLeft,
                            height: 70,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.red, width: 2),
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(5)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Text(login.errorMessage.toString()),
                          )),
                    Obx(() => CustomTextField(
                        label: "Email",
                        controller: login.emailController,
                        validation: login.emailValidation.toString(),
                        gapHeight: 15)),
                    Obx(() => CustomTextField(
                          label: "Password",
                          controller: login.passwordController,
                          validation: login.passwordValidation.toString(),
                          gapHeight: 15,
                          obscureText: true,
                        )),
                    GestureDetector(
                      onTap: () {},
                      child: Align(
                        child: Text("Forgot Password ?"),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(children: [
                      Text("Don't have an account yet ?"),
                      GestureDetector(
                          onTap: () {
                            Get.to(RegisterPage());
                          },
                          child: Text(
                            "Signup",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ))
                    ]),
                    const SizedBox(
                      height: 20,
                    ),
                    InputButton(
                        label: "Login",
                        onPress: () async {
                          await login.loginWithEmailandPassword();
                          if (login.isSuccess.value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(login.message.toString(),
                                    style: TextStyle(color: Colors.white)),
                              ),
                            );
                            // Direct to the login page after successful registration
                            await Future.delayed(Duration(seconds: 2));
                            Get.off(const HomePage());
                          }
                        },
                        backgroundColor: Colors.green,
                        color: Colors.white),
                    const SizedBox(
                      height: 25,
                    ),
                    Align(
                      child: Text("or Login with google"),
                      alignment: Alignment.center,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    MaterialButton(
                        onPressed: () {},
                        child:  SizedBox(
                          child: Image.network(
                            "lib/images/google.png",
                            fit: BoxFit.contain,
                          ),
                          width: 200,
                          height: 40,
                        )),
                  ]),
                ),
              )),
            ),
            if (login.isLoading.value)
              // Show circular progress indicator in the middle of the screen
              Container(
                color: Colors.black.withOpacity(
                    0.2), // Semi-transparent black color for the backdrop
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ));
  }
}
