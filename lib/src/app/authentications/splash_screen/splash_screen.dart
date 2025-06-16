import 'package:dine_in/src/app/authentications/authentication_home/authentication_home_screen.dart';
import 'package:dine_in/src/app/authentications/verify_email/verify_email_screen.dart';
import 'package:dine_in/src/app/core/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void checkAuthentication() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user.emailVerified) {
        Get.offAll(() => const HomeScreen());
      } else {
        Get.offAll(() => const VerifyEmailScreen());
      }
    } else {
      Get.offAll(() => const AuthenticationHomeScreen());
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      checkAuthentication();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
    );
  }
}
