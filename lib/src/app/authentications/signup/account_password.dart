import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/src/app/authentications/login/login_screen.dart';
import 'package:dine_in/src/app/authentications/verify_email/verify_email_screen.dart';
import 'package:dine_in/src/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountPassword extends StatefulWidget {
  const AccountPassword({
    super.key,
    required this.email,
    required this.fullName,
    required this.userType,
  });

  final String email;
  final String fullName;
  final String userType;

  @override
  State<AccountPassword> createState() => _AccountPasswordState();
}

class _AccountPasswordState extends State<AccountPassword> {
  RxBool isLoading = false.obs;
  RxBool isValueEmpty = true.obs;
  RxBool isButtonDisabled = true.obs;

  TextEditingController passwordController = TextEditingController();

  final userCollection = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Step 3 of 3',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
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
                    'Create password',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
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
                    onChanged: (value) {
                      if (value.isEmpty) {
                        isValueEmpty.value = true;
                      } else if (value.isNotEmpty) {
                        isValueEmpty.value = false;
                      }
                      if (value.length < 8) {
                        isButtonDisabled.value = true;
                      } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                        isButtonDisabled.value = true;
                      } else if (!RegExp(r'\d').hasMatch(value)) {
                        isButtonDisabled.value = true;
                      } else if (!RegExp(r'[!@#$&*~]').hasMatch(value)) {
                        isButtonDisabled.value = true;
                      } else {
                        isButtonDisabled.value = false;
                      }
                    },
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Obx(
                      () => isButtonDisabled.value && !isValueEmpty.value
                          ? const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 15,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Your password is weak',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
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
                            'Sign Up',
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
                              color: buttonColor,
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
                              final userData = {
                                'Full Name': widget.fullName,
                                'Email': widget.email,
                                'User Type': widget.userType,
                                'Password': passwordController.text.trim(),
                              };
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: widget.email,
                                password: passwordController.text,
                              )
                                  .then((authentication) async {
                                await userCollection.doc(authentication.user?.uid).set(userData);
                              });
                              FirebaseAuth.instance.idTokenChanges().listen((User? user) {
                                if (user != null) {
                                  Get.offAll(() => const VerifyEmailScreen());
                                } else {
                                  Get.offAll(() => const LoginScreen());
                                }
                              });
                              isLoading.value = false;
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Sign Up',
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
