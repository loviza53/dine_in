import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dine_in/src/constants/colors.dart';
import 'package:dine_in/src/app/controllers/cart_controller.dart';
import 'package:dine_in/src/app/core/checkout/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  RxInt totalBill = 0.obs;

  final CartController controller = Get.find<CartController>();

  void updateTotalBill() {
    if (controller.cartItems.isNotEmpty) {
      totalBill.value = controller.cartItems.map((item) => item['Total Price']).reduce((value, element) => value + element);
    }
  }

  @override
  void initState() {
    updateTotalBill();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor,
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
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.black.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Order Summary',
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
          if (controller.cartItems.isNotEmpty)
            Expanded(
              child: Column(
                children: [
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
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Image.network(
                                        controller.cartItems[index]['Image URL'],
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Container(
                                            height: 50,
                                            width: 50,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            height: 50,
                                            width: 50,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${controller.cartItems[index]['Item Name']}${controller.cartItems[index]['Size'] == null ? '' : ', ${controller.cartItems[index]['Size']}\n${controller.cartItems[index]['Sugar'] == null ? '' : 'Sugar: ${controller.cartItems[index]['Sugar']}'}'}',
                                        style: TextStyle(
                                          fontSize: 14,
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
                                  color: surfaceColor,
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
                                            updateTotalBill();
                                          } else {
                                            controller.cartItems[index]['Quantity']--;
                                            controller.cartItems[index]['Total Price'] = controller.cartItems[index]['Total Price']! - int.parse(controller.cartItems[index]['Price']);
                                            updateTotalBill();
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
                                          updateTotalBill();
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
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Subtotal',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Text(
                                "PKR ${totalBill.toString()}",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Divider(),
                          SizedBox(height: 5),
                          Obx(
                            () => Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Total',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Text(
                                  "PKR $totalBill",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: Center(
                child: Text(
                  'Cart is empty',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: Colors.black.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ),
          if (controller.cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
              child: InkWell(
                onTap: () => Get.to(() => CheckoutScreen()),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.withValues(alpha: 0.15),
                        spreadRadius: 0,
                        blurRadius: 6,
                        offset: const Offset(4, 4),
                      ),
                    ],
                    color: surfaceColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Go to Checkout',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
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
