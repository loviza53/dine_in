import 'package:dine_in/src/app/admin/orders/orders_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dine_in/src/constants/colors.dart';
import 'package:dine_in/src/app/admin/add_item/add_item.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                      color: accentColor,
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
                InkWell(
                  onTap: () => Get.to(() => const AddItem()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add_circle,
                          size: 26,
                          color: Colors.black.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 20),
                        const Text(
                          'Add Item',
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
                InkWell(
                  onTap: () => Get.to(() => const OrdersScreen()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.emoji_food_beverage_rounded,
                          size: 26,
                          color: Colors.black.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 20),
                        const Text(
                          'Orders',
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
