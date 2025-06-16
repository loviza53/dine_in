import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/src/app/authentications/verify_email/verify_email_screen.dart';
import 'package:dine_in/src/app/core/home/home_screen.dart';
import 'package:dine_in/src/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  RxBool isLoading = false.obs;
  RxBool obscureText = true.obs;
  RxBool isButtonDisabled = true.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void errorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(
                      Icons.error_rounded,
                      color: Colors.red.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'OOPS!',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        message,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Container(
            height: 50,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                InkWell(
                  onTap: () => Get.back(),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    'Log in',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      isCollapsed: true,
                      hintText: 'Enter Username or E-mail',
                      fillColor: filledTextFieldColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                      prefixIcon: Icon(
                        Icons.mail_outline_rounded,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: focusBorderColor,
                          width: 1,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r' ')),
                    ],
                    onChanged: (value) {
                      if (value.length > 4 && passwordController.text.trim().length > 7) {
                        isButtonDisabled.value = false;
                      } else {
                        isButtonDisabled.value = true;
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  Obx(
                    () => TextFormField(
                      controller: passwordController,
                      obscureText: obscureText.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        isCollapsed: true,
                        hintText: 'Enter Password',
                        fillColor: filledTextFieldColor,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                        prefixIcon: Icon(
                          Icons.fingerprint_rounded,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: accentColor.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                        suffix: GestureDetector(
                          onTap: () {
                            obscureText.value = !obscureText.value;
                          },
                          child: Text(
                            obscureText.value ? 'View' : 'Hide',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length > 7 && emailController.text.trim().length > 4) {
                          isButtonDisabled.value = false;
                        } else {
                          isButtonDisabled.value = true;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Obx(
              () => SizedBox(
                height: 50,
                width: double.infinity,
                child: isButtonDisabled.value
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : isLoading.value
                        ? Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 1.5,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Loading...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              isLoading.value = true;
                              if (emailController.text.contains('@')) {
                                try {
                                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );
                                } catch (e) {
                                  errorMessage('Incorrect email or password');
                                }
                              } else {
                                await FirebaseFirestore.instance.collection('Users').where('Username', isEqualTo: emailController.text.trim()).get().then((userSnapshot) async {
                                  if (userSnapshot.docs.isNotEmpty) {
                                    try {
                                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                                        email: userSnapshot.docs.first.data()['Email'],
                                        password: passwordController.text.trim(),
                                      );
                                    } catch (e) {
                                      errorMessage('Incorrect password, please try again.');
                                    }
                                  } else {
                                    errorMessage('We cannot find an account for this username.');
                                  }
                                });
                              }
                              User? currentUser = FirebaseAuth.instance.currentUser;
                              if (currentUser != null) {
                                if (currentUser.emailVerified) {
                                  Get.offAll(() => const HomeScreen());
                                } else {
                                  Get.offAll(() => const VerifyEmailScreen());
                                }
                              }
                              isLoading.value = false;
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Log In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
