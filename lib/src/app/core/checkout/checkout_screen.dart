import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dine_in/src/constants/colors.dart';
import 'package:dine_in/src/constants/values.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/src/app/widgets/message_box.dart';
import 'package:dine_in/src/app/core/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dine_in/src/app/controllers/cart_controller.dart';
import 'package:dine_in/src/app/controllers/order_controller.dart';
import 'package:dine_in/src/app/core/order_tracking/order_tracking_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int? totalBill;
  RxString selectedTable = ''.obs;
  RxBool isLoading = false.obs;

  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.find<OrderController>();

  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  final orderCollection = FirebaseFirestore.instance.collection('Orders');

  void orderTracking(String id) {
    showModalBottomSheet(
      context: context,
      elevation: 0,
      useSafeArea: true,
      isDismissible: false,
      isScrollControlled: true,
      barrierColor: Colors.white,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      builder: (context) {
        return OrderTrackingScreen(orderId: id);
      },
    );
  }

  Future<void> messageBox() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MessageBox();
      },
    );
  }

  @override
  void initState() {
    totalBill = cartController.cartItems.map((e) => e['Total Price']).reduce((value, element) => value + element);
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
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        'Payment Method',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: cartController.cartItems.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    "${cartController.cartItems[index]['Item Name']}${cartController.cartItems[index]['Size'] == null ? '' : ' ${cartController.cartItems[index]['Size']}'} ${cartController.cartItems[index]['Quantity']}x${cartController.cartItems[index]['Sugar'] == null ? '' : '\nSugar: ${cartController.cartItems[index]['Sugar']}'}",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Text(
                                  "PKR ${cartController.cartItems[index]['Total Price']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
                          Row(
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
                                "PKR $totalBill!",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_box_rounded, color: Colors.brown),
                          SizedBox(width: 10),
                          Text("Payment by Cash"),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15, left: 15, right:15),
                    child: Text(
                      'Select table',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: StreamBuilder(
                      stream: orderCollection.where('Status', whereNotIn: ['Delivered', 'Cancelled']).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final RxList bookedTables = snapshot.data!.docs.map((e) => e['Table']).toSet().toList().obs;
                          return GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              mainAxisExtent: 40,
                            ),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: tables.length,
                            itemBuilder: (context, index) {
                              return Obx(() {
                                if (bookedTables.contains(tables[index])) {
                                  return Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      tables[index],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black.withValues(alpha: 0.4),
                                        fontSize: 14,
                                      ),
                                    ),
                                  );
                                } else {
                                  return InkWell(
                                    onTap: () {
                                      selectedTable.value = tables[index];
                                    },
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: selectedTable.value == tables[index] ? selectedOptionColor : surfaceColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        tables[index],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black.withValues(alpha: 0.8),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              });
                            },
                          );
                        } else {
                          return GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              mainAxisExtent: 40,
                            ),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: tables.length,
                            itemBuilder: (context, index) {
                              return Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(() {
            if (selectedTable.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Place Order',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            } else {
              if (isLoading.value) {
                return Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: Container(
                    height: 45,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Placing Order...',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: InkWell(
                    onTap: () async {
                      isLoading.value = true;
                      final SharedPreferences memory = await SharedPreferences.getInstance();
                      if (memory.containsKey('Order ID')) {
                        await messageBox();
                      } else {
                        await orderCollection.add({
                          'Items': cartController.cartItems,
                          'Table': selectedTable.value,
                          'Time': FieldValue.serverTimestamp(),
                          'Total Bill': totalBill!,
                          'Status': 'Pending',
                          'Customer ID': currentUser,
                        }).then((value) async {
                          DocumentSnapshot orderSnapshot = await value.get();
                          await memory.setString('Order ID', orderSnapshot.id);
                          orderController.orderedItems.value = orderSnapshot['Items'];
                          orderController.orderTime = orderSnapshot['Time'].toDate();
                          orderController.table.value = orderSnapshot['Table'];
                          orderController.status.value = orderSnapshot['Status'];
                          orderController.totalBill?.value = totalBill!;
                          orderController.orderId.value = orderSnapshot.id;
                          cartController.cartItems.clear();
                          Get.offAll(() => HomeScreen());
                          orderTracking(orderSnapshot.id);
                        });
                      }
                      isLoading.value = false;
                    },
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
                          'Place Order',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
          }),
        ],
      ),
    );
  }
}
