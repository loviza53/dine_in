import 'package:dine_in/src/app/authentications/splash_screen/splash_screen.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dine_in/src/constants/colors.dart';
import 'package:dine_in/src/app/controllers/cart_controller.dart';
import 'package:dine_in/src/app/controllers/order_controller.dart';

Future<void> main() async {
  Get.put(CartController());
  Get.put(OrderController());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: accentColor),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
