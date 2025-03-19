import 'package:dine_in/src/app/controllers/cart_controller.dart';
import 'package:dine_in/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: controller.cartItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.cartItems[index]['Item Name'],
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "PKR ${controller.cartItems[index]['Total Price']}",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (controller.cartItems[index]['Quantity'] > 1) {
                                    controller.cartItems[index]['Quantity']--;
                                    controller.cartItems[index]['Total Price'] = controller.cartItems[index]['Total Price']! - int.parse(controller.cartItems[index]['Price']);
                                  } else {
                                    controller.cartItems.removeAt(index);
                                  }
                                });
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: const Icon(
                                Icons.remove,
                              ),
                            ),
                            SizedBox(width: 15),
                            Text(
                              controller.cartItems[index]['Quantity'].toString(),
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 15),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  controller.cartItems[index]['Quantity']++;
                                  controller.cartItems[index]['Total Price'] = controller.cartItems[index]['Total Price']! + int.parse(controller.cartItems[index]['Price']);
                                });
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: const Icon(
                                Icons.add,
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
