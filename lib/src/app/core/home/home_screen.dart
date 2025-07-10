import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:dine_in/src/constants/colors.dart';
import 'package:dine_in/src/constants/values.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/src/app/core/setting/setting.dart';
import 'package:dine_in/src/app/core/cart/cart_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dine_in/src/app/controllers/cart_controller.dart';
import 'package:dine_in/src/app/core/item_detail/item_detail.dart';
import 'package:dine_in/src/app/controllers/order_controller.dart';
import 'package:dine_in/src/app/core/order_tracking/order_tracking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String orderId = '';
  RxBool isLoading = true.obs;
  String category = categories.first;

  final CartController cartController = Get.find<CartController>();
  final OrderController orderController = Get.find<OrderController>();

  final itemCollection = FirebaseFirestore.instance.collection('Items');
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

  Future<void> getOrderId() async {
    final SharedPreferences memory = await SharedPreferences.getInstance();
    if (memory.getString('Order ID') != null) {
      orderId = memory.getString('Order ID')!;
    }
    orderController.orderId.value = orderId;
    isLoading.value = false;
  }

  Future<void> resetOrderId() async {
    final SharedPreferences memory = await SharedPreferences.getInstance();
    orderController.orderId.value = '';
    await memory.clear();
  }

  @override
  initState() {
    getOrderId();
    super.initState();
  }

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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              width: double.infinity,
              child: SvgPicture.asset(
                'assets/lower_background_image.svg',
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
                      onTap: () => Get.to(() => const Setting()),
                      borderRadius: BorderRadius.circular(20),
                      child: const Icon(
                        Icons.settings,
                        size: 30,
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        height: 45,
                        width: 60,
                        child: SvgPicture.asset(
                          'assets/app_logo.svg',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Obx(
                      () => Positioned(
                        right: 0,
                        child: InkWell(
                          onTap: () => Get.to(() => const CartScreen()),
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 30,
                              ),
                              if (cartController.cartItems.isNotEmpty)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Container(
                                    height: 18,
                                    width: 18,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        cartController.cartItems.length.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
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
                    children: [
                      // Container(
                      //   height: 60,
                      //   width: double.infinity,
                      //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      //   child: InkWell(
                      //     onTap: () {},
                      //     borderRadius: BorderRadius.circular(50),
                      //     child: Container(
                      //       height: 40,
                      //       width: double.infinity,
                      //       padding: const EdgeInsets.only(left: 20, right: 7.5),
                      //       decoration: BoxDecoration(
                      //         color: secondaryColor,
                      //         borderRadius: BorderRadius.circular(50),
                      //       ),
                      //       child: Row(
                      //         children: [
                      //           Icon(
                      //             Icons.search_rounded,
                      //             color: Colors.black.withValues(alpha: 0.6),
                      //           ),
                      //           const SizedBox(width: 10),
                      //           Expanded(
                      //             child: Text(
                      //               'Search menu item or specials...',
                      //               style: TextStyle(
                      //                 fontSize: 16,
                      //                 fontWeight: FontWeight.w400,
                      //                 color: Colors.black.withValues(alpha: 0.6),
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Padding( 
                        padding: const EdgeInsets.all(15),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            mainAxisExtent: 40,
                          ),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: categories.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  category = categories[index];
                                });
                              },
                              borderRadius: BorderRadius.circular(40),
                              child: Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: categories[index] == category ? selectedOptionColor : secondaryColor,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Center(
                                  child: Text(
                                    categories[index],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: StreamBuilder(
                          stream: itemCollection.where('Category', isEqualTo: category).orderBy('Status', descending: false).snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 267,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                ),
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final itemSnapshot = snapshot.data!.docs[index];
                                  if (itemSnapshot['Status'] == 'available') {
                                    return InkWell(
                                      onTap: () => Get.to(
                                        () => ItemDetail(
                                          id: itemSnapshot.id,
                                          itemName: itemSnapshot['Item Name'],
                                          price: itemSnapshot['Price'],
                                          category: itemSnapshot['Category'],
                                          imageURL: itemSnapshot['Image URL'],
                                          description: itemSnapshot['Description'],
                                        ),
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: secondaryColor,
                                          borderRadius: BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.brown.withValues(alpha: 0.15),
                                              spreadRadius: 0,
                                              blurRadius: 6,
                                              offset: const Offset(4, 4),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(15),
                                                topLeft: Radius.circular(15),
                                              ),
                                              child: LayoutBuilder(
                                                builder: (BuildContext context, BoxConstraints constraints) {
                                                  double containerWidth = constraints.maxWidth;
                                                  return SizedBox(
                                                    height: containerWidth,
                                                    width: containerWidth,
                                                    child: Image.network(
                                                      itemSnapshot['Image URL'],
                                                      fit: BoxFit.cover,
                                                      loadingBuilder: (context, child, loadingProgress) {
                                                        if (loadingProgress == null) return child;
                                                        return Container(
                                                          height: containerWidth,
                                                          width: containerWidth,
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white.withValues(alpha: 0.2),
                                                          ),
                                                        );
                                                      },
                                                      errorBuilder: (context, error, stackTrace) {
                                                        return Container(
                                                          height: containerWidth,
                                                          width: containerWidth,
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white.withValues(alpha: 0.2),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'PKR ${itemSnapshot['Price']}',
                                                      textAlign: TextAlign.center,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      itemSnapshot['Item Name'],
                                                      maxLines: 1,
                                                      textAlign: TextAlign.center,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 18,
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
                                    );
                                  } else {
                                    return Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: secondaryColor,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.brown.withValues(alpha: 0.15),
                                            spreadRadius: 0,
                                            blurRadius: 6,
                                            offset: const Offset(4, 4),
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(15),
                                                  topLeft: Radius.circular(15),
                                                ),
                                                child: LayoutBuilder(
                                                  builder: (BuildContext context, BoxConstraints constraints) {
                                                    double containerWidth = constraints.maxWidth;
                                                    return SizedBox(
                                                      height: containerWidth,
                                                      width: containerWidth,
                                                      child: Image.network(
                                                        itemSnapshot['Image URL'],
                                                        fit: BoxFit.cover,
                                                        loadingBuilder: (context, child, loadingProgress) {
                                                          if (loadingProgress == null) return child;
                                                          return Container(
                                                            height: containerWidth,
                                                            width: containerWidth,
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                              color: Colors.white.withValues(alpha: 0.2),
                                                            ),
                                                          );
                                                        },
                                                        errorBuilder: (context, error, stackTrace) {
                                                          return Container(
                                                            height: containerWidth,
                                                            width: containerWidth,
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(
                                                              color: Colors.white.withValues(alpha: 0.2),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'PKR ${itemSnapshot['Price']}',
                                                        textAlign: TextAlign.center,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        itemSnapshot['Item Name'],
                                                        maxLines: 1,
                                                        textAlign: TextAlign.center,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.w300,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300.withValues(alpha: 0.5),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              );
                            } else {
                              return GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 200,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                ),
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 6,
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: accentColor.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(15),
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
              Obx(
                () {
                  if (orderController.orderId.isNotEmpty) {
                    return StreamBuilder(
                      stream: orderCollection.doc(orderController.orderId.value).snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data!.exists) {
                          final orderSnapshot = snapshot.data!;
                          if (orderSnapshot['Status'] == 'Delivered' || orderSnapshot['Status'] == 'Cancelled') {
                            resetOrderId();
                          }
                          return InkWell(
                            onTap: () => orderTracking(orderSnapshot.id),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.brown.withValues(alpha: 0.15),
                                    spreadRadius: 0,
                                    blurRadius: 10,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            orderSnapshot['Table'],
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Your order will arrive by ${DateFormat('hh:mm a').format(orderSnapshot['Time'].toDate()!.add(Duration(minutes: 20))).toLowerCase()}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black.withValues(alpha: 0.6),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          color: accentColor.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Icon(
                                          Icons.keyboard_arrow_up,
                                          color: accentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Preparing your order',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      },
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
