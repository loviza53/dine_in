import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/src/app/admin/pin_password/pin_password_screen.dart';
import 'package:dine_in/src/app/core/home/home_screen.dart';
import 'package:dine_in/src/constants/values.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dine_in/src/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  RxString table = tables.first.obs;
  final currentUser = FirebaseAuth.instance.currentUser?.uid;
  bool showAdmin = false;

  @override
  void initState() {
    super.initState();
    loadTableName();
  }

  Future<void> loadTableName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      table.value = prefs.getString('table') ?? tables.first;
    });
  }

  Future<void> _handleSwipeDown() async {
    setState(() {
      // showAdmin = true;
      Get.to(() => const PinPasswordScreen());
    });

    // await Future.delayed(const Duration(seconds: 5));
    // setState(() {
    //   showAdmin = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/upper_background_image.svg',
              fit: BoxFit.cover,
            ),
          ),
          RefreshIndicator(
            onRefresh: _handleSwipeDown,
            elevation: 0,
            color: Colors.transparent,
            backgroundColor: Colors.transparent,
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                Container(
                  height: 60,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 0.5,
                        color: Colors.black.withValues(alpha: 0.2),
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
                            color: Colors.black.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          'Setting',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (currentUser != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('Users')
                                .doc(currentUser)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                int monthlyBill = 0;
                                if (snapshot.data!.data()!.containsKey('Monthly Bill')) {
                                  monthlyBill = snapshot.data!['Monthly Bill'];
                                }
                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Monthly Bill',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '$monthlyBill PKR',
                                        style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            },
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 10, top: 10),
                        child: PopupMenuButton(
                          elevation: 0,
                          color: buttonColor,
                          offset: const Offset(0, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    table.value,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: buttonColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onSelected: (String? value) async {
                            setState(() {
                              table.value = value!;
                            });
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setString('table', value!);
                          },
                          itemBuilder: (BuildContext context) {
                            return tables.map<PopupMenuItem<String>>((String value) {
                              return PopupMenuItem(
                                value: value,
                                child: SizedBox(
                                  width: 200,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      if (showAdmin)
                        InkWell(
                          onTap: () => Get.to(() => const PinPasswordScreen()),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.admin_panel_settings_rounded,
                                  size: 26,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 20),
                                Text(
                                  'Admin',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (currentUser != null)
                        InkWell(
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            Get.offAll(HomeScreen());
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.login_rounded,
                                  size: 26,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 20),
                                Text(
                                  'Log out',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
