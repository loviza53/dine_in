import 'package:dine_in/src/app/admin/add_staff/add_staff_screen.dart';
import 'package:dine_in/src/app/admin/manage_customers/manage_customers_screen.dart';
import 'package:dine_in/src/app/admin/manage_items/manage_items_screen.dart';
import 'package:dine_in/src/app/admin/staff_members/staff_members_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dine_in/src/constants/colors.dart';
import 'package:dine_in/src/app/admin/add_item/add_item.dart';
import 'package:dine_in/src/app/admin/orders/orders_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              width: double.infinity,
              child: SvgPicture.asset(
                'assets/upper_background_image.svg',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Column(
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
                        'Admin',
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
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => Get.to(() => const AddItem()),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.add_circle,
                                    size: 40,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Add Item',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: InkWell(
                            onTap: () => Get.to(() => const OrdersScreen()),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.emoji_food_beverage_rounded,
                                    size: 40,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Orders',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => Get.to(() => const ManageItemsScreen()),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.emoji_food_beverage_rounded,
                                    size: 40,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Manage Items',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: InkWell(
                            onTap: () => Get.to(() => const AddStaffScreen()),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.person_add_alt_1,
                                    size: 40,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Add Staff',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => Get.to(() => const StaffMembersScreen()),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.people_rounded,
                                    size: 40,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Staff Members',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: InkWell(
                            onTap: () => Get.to(() => const ManageCustomersScreen()),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Customers',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
