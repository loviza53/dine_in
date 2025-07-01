import 'package:dine_in/src/app/authentications/login/login_screen.dart';
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
  RxBool payLater = false.obs;
  RxString deliveryPlace = 'Table'.obs;
  RxString userType = userTypes.first.obs;
  RxString office = offices.first.obs;

  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.find<OrderController>();

  final currentUser = FirebaseAuth.instance.currentUser?.uid;
  final orderCollection = FirebaseFirestore.instance.collection('Orders');
  final userCollection = FirebaseFirestore.instance.collection('Users');

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
    userCollection.doc(currentUser).get().then((userSnapshot) {
      setState(() {
        userType.value = userSnapshot['User Type'];
      });
    });
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
                    'Payment Method',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                if(currentUser == null)
                Positioned(
                  right: 0,
                  child: InkWell(
                    onTap: () => Get.to(() => LoginScreen()),
                    borderRadius: BorderRadius.circular(20),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
                                "PKR $totalBill",
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
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.check_box_rounded, color: Colors.brown),
                              SizedBox(width: 10),
                              Text("Payment by Cash"),
                            ],
                          ),
                          SizedBox(height: 10),
                          Obx(
                            () => Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    payLater.value = !payLater.value;
                                  },
                                  child: Icon(
                                    Icons.check_box_rounded,
                                    size: 25,
                                    color: payLater.value ? Colors.brown : Colors.black.withValues(alpha: 0.2),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text("Pay bill later"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // if (userType.value == 'Professor')
                  //   Obx(
                  //     () => InkWell(
                  //       onTap: () {
                  //         setState(() {
                  //           if (deliveryPlace.value == 'Table') {
                  //             deliveryPlace.value = 'Office';
                  //           } else if (deliveryPlace.value == 'Office') {
                  //             deliveryPlace.value = 'Table';
                  //           }
                  //         });
                  //       },
                  //       borderRadius: BorderRadius.circular(15),
                  //       child: Container(
                  //         width: double.infinity,
                  //         padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                  //         margin: EdgeInsets.symmetric(horizontal: 15),
                  //         alignment: Alignment.center,
                  //         decoration: BoxDecoration(
                  //           boxShadow: [
                  //             BoxShadow(
                  //               color: Colors.brown.withValues(alpha: 0.15),
                  //               spreadRadius: 0,
                  //               blurRadius: 6,
                  //               offset: const Offset(4, 4),
                  //             ),
                  //           ],
                  //           color: buttonColor,
                  //           borderRadius: BorderRadius.circular(15),
                  //         ),
                  //         child: Text(
                  //           deliveryPlace.value == 'Table' ? 'Deliver to office' : 'Deliver to table',
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             color: Colors.white,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // if (deliveryPlace.value == 'Table')
                  //   Padding(
                  //     padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                  //     child: Text(
                  //       'Select table',
                  //       style: TextStyle(
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.w300,
                  //       ),
                  //     ),
                  //   ),
                  // if (deliveryPlace.value == 'Table')
                  //   Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  //     child: StreamBuilder(
                  //       stream: orderCollection.where('Status', whereNotIn: ['Delivered', 'Cancelled']).snapshots(),
                  //       builder: (context, snapshot) {
                  //         if (snapshot.hasData) {
                  //           final RxList bookedTables = snapshot.data!.docs.map((e) => e['Table']).toSet().toList().obs;
                  //           return GridView.builder(
                  //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //               crossAxisCount: 2,
                  //               crossAxisSpacing: 15,
                  //               mainAxisSpacing: 15,
                  //               mainAxisExtent: 40,
                  //             ),
                  //             shrinkWrap: true,
                  //             padding: EdgeInsets.zero,
                  //             physics: const NeverScrollableScrollPhysics(),
                  //             itemCount: tables.length,
                  //             itemBuilder: (context, index) {
                  //               return Obx(() {
                  //                 if (bookedTables.contains(tables[index])) {
                  //                   return Container(
                  //                     alignment: Alignment.center,
                  //                     decoration: BoxDecoration(
                  //                       color: Colors.black.withValues(alpha: 0.1),
                  //                       borderRadius: BorderRadius.circular(10),
                  //                     ),
                  //                     child: Text(
                  //                       tables[index],
                  //                       textAlign: TextAlign.center,
                  //                       style: TextStyle(
                  //                         color: Colors.black.withValues(alpha: 0.4),
                  //                         fontSize: 14,
                  //                       ),
                  //                     ),
                  //                   );
                  //                 } else {
                  //                   return InkWell(
                  //                     onTap: () {
                  //                       selectedTable.value = tables[index];
                  //                     },
                  //                     borderRadius: BorderRadius.circular(10),
                  //                     child: Container(
                  //                       alignment: Alignment.center,
                  //                       decoration: BoxDecoration(
                  //                         color: selectedTable.value == tables[index] ? selectedOptionColor : surfaceColor,
                  //                         borderRadius: BorderRadius.circular(10),
                  //                       ),
                  //                       child: Text(
                  //                         tables[index],
                  //                         textAlign: TextAlign.center,
                  //                         style: TextStyle(
                  //                           color: Colors.black.withValues(alpha: 0.8),
                  //                           fontSize: 14,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   );
                  //                 }
                  //               });
                  //             },
                  //           );
                  //         } else {
                  //           return GridView.builder(
                  //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //               crossAxisCount: 4,
                  //               crossAxisSpacing: 15,
                  //               mainAxisSpacing: 15,
                  //               mainAxisExtent: 40,
                  //             ),
                  //             shrinkWrap: true,
                  //             padding: EdgeInsets.zero,
                  //             physics: const NeverScrollableScrollPhysics(),
                  //             itemCount: tables.length,
                  //             itemBuilder: (context, index) {
                  //               return Container(
                  //                 alignment: Alignment.center,
                  //                 decoration: BoxDecoration(
                  //                   color: Colors.black.withValues(alpha: 0.05),
                  //                   borderRadius: BorderRadius.circular(10),
                  //                 ),
                  //               );
                  //             },
                  //           );
                  //         }
                  //       },
                  //     ),
                  //   ),
                  // if (deliveryPlace.value == 'Office')
                  //   Padding(
                  //     padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                  //     child: Text(
                  //       'Select office',
                  //       style: TextStyle(
                  //         fontSize: 18,
                  //         fontWeight: FontWeight.w300,
                  //       ),
                  //     ),
                  //   ),
                  // if (deliveryPlace.value == 'Office')
                  //   Padding(
                  //     padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
                  //     child: PopupMenuButton(
                  //       elevation: 0,
                  //       color: buttonColor,
                  //       offset: const Offset(0, 55),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(5),
                  //       ),
                  //       child: Container(
                  //         width: double.infinity,
                  //         decoration: BoxDecoration(
                  //           color: filledTextFieldColor,
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //         child: Padding(
                  //           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               Text(
                  //                 office.value,
                  //                 style: const TextStyle(
                  //                   color: Colors.white,
                  //                   fontSize: 14,
                  //                 ),
                  //               ),
                  //               const Icon(
                  //                 Icons.keyboard_arrow_down,
                  //                 color: buttonColor,
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //       onSelected: (String? value) {
                  //         setState(() {
                  //           office.value = value!;
                  //         });
                  //       },
                  //       itemBuilder: (BuildContext context) {
                  //         return offices.map<PopupMenuItem<String>>((String value) {
                  //           return PopupMenuItem(
                  //             value: value,
                  //             child: SizedBox(
                  //               width: 200,
                  //               child: Text(
                  //                 value,
                  //                 style: const TextStyle(
                  //                   color: Colors.black,
                  //                   fontSize: 14,
                  //                 ),
                  //               ),
                  //             ),
                  //           );
                  //         }).toList();
                  //       },
                  //     ),
                  //   ),
                ],
              ),
            ),
          ),
          Obx(() {
            // if (selectedTable.isEmpty && deliveryPlace.value == 'Table') {
            //   return Padding(
            //     padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            //     child: Container(
            //       height: 45,
            //       width: double.infinity,
            //       decoration: BoxDecoration(
            //         color: Colors.black.withValues(alpha: 0.1),
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //       child: Center(
            //         child: Text(
            //           'Place Order',
            //           style: TextStyle(
            //             fontSize: 16,
            //             color: Colors.black.withValues(alpha: 0.4),
            //           ),
            //         ),
            //       ),
            //     ),
            //   );
            // } else {
            //
            // }
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
                      if (payLater.value && currentUser == null) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              titlePadding: const EdgeInsets.all(0),
                              contentPadding: const EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              content: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: accentColor.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 10),
                                    Icon(
                                      Icons.login,
                                      color: selectedOptionColor,
                                      size: 100,
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        'You need to log in to enable the \'Pay bill later\' option.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black.withValues(alpha: 0.8)),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () => Get.back(),
                                            borderRadius: BorderRadius.circular(10),
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(vertical: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: buttonColor,
                                                  width: 2,
                                                ),
                                              ),
                                              child: Text(
                                                'Close',
                                                style: TextStyle(
                                                  color: buttonColor,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () => Get.off(() => LoginScreen()),
                                            borderRadius: BorderRadius.circular(10),
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(vertical: 10),
                                              decoration: BoxDecoration(
                                                color: buttonColor,
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: buttonColor,
                                                  width: 2,
                                                ),
                                              ),
                                              child: Text(
                                                'Login',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        await orderCollection.add({
                          'Items': cartController.cartItems,
                          'Table': tables.first,
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
          }),
        ],
      ),
    );
  }
}
