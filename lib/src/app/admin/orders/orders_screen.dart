import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:dine_in/src/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  RxBool isPaid = true.obs;
  int monthlyBill = 0;

  final currentUser = FirebaseAuth.instance.currentUser?.uid;
  final userCollection = FirebaseFirestore.instance.collection('Users');
  final orderCollection = FirebaseFirestore.instance.collection('Orders');

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
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: StreamBuilder(
                    stream: orderCollection.where('Status', whereNotIn: ['Delivered', 'Cancelled']).orderBy('Time', descending: true).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final orderSnapshot = snapshot.data!.docs[index];
                            Color statusColor = Colors.blue;
                            RxBool isLoading = false.obs;
                            if (orderSnapshot['Status'] == 'Preparing') {
                              statusColor = Colors.green;
                            } else if (orderSnapshot['Status'] == 'Delivered') {
                              statusColor = Colors.amber;
                            } else if (orderSnapshot['Status'] == 'Cancelled') {
                              statusColor = Colors.red;
                            } else {
                              statusColor = Colors.blue;
                            }
                            return Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (orderSnapshot['Customer ID'] != null)
                                    StreamBuilder(
                                      stream: userCollection.doc(orderSnapshot['Customer ID']).snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final userSnapshot = snapshot.data!;
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                userSnapshot['Full Name'],
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                              Text(
                                                'ID: ${userSnapshot.id}',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black.withValues(alpha: 0.5),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return SizedBox();
                                        }
                                      },
                                    ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            orderSnapshot['Table'],
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('hh:mm a, dd MMMM yyyy').format(orderSnapshot['Time'].toDate()).toLowerCase(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black.withValues(alpha: 0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Obx(
                                        () {
                                          if (isLoading.value) {
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                                              child: SizedBox(
                                                height: 18,
                                                width: 18,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: Colors.black.withValues(alpha: 0.4),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Container(
                                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                              decoration: BoxDecoration(
                                                color: statusColor.withValues(alpha: 0.2),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                orderSnapshot['Status'],
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.w500,
                                                  color: statusColor,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: orderSnapshot['Items'].length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${orderSnapshot['Items'][index]['Item Name']}${orderSnapshot['Items'][index]['Size'] == null ? '' : ' ${orderSnapshot['Items'][index]['Size']}'} ${orderSnapshot['Items'][index]['Quantity']}x${orderSnapshot['Items'][index]['Sugar'] == null ? '' : '\nSugar: ${orderSnapshot['Items'][index]['Sugar']}'}',
                                            ),
                                            Text(
                                              'PKR ${orderSnapshot['Items'][index]['Total Price']}',
                                              style: TextStyle(
                                                color: Colors.black.withValues(alpha: 0.5),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total',
                                      ),
                                      Text(
                                        'PKR ${orderSnapshot['Total Bill'].toString()}',
                                        style: TextStyle(
                                          color: Colors.black.withValues(alpha: 0.5),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  if (currentUser != null)
                                    Obx(
                                      () => Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              isPaid.value = !isPaid.value;
                                            },
                                            child: Icon(
                                              Icons.check_box_rounded,
                                              size: 25,
                                              color: isPaid.value ? Colors.brown : Colors.black.withValues(alpha: 0.2),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text("Bill paid"),
                                        ],
                                      ),
                                    ),
                                  Obx(
                                    () {
                                      if (isLoading.value) {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: Container(
                                                height: 35,
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withValues(alpha: 0.2),
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    color: Colors.black.withValues(alpha: 0.4),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            if (orderSnapshot['Status'] == 'Pending')
                                              Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: Container(
                                                  height: 35,
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black.withValues(alpha: 0.2),
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                                  child: Text(
                                                    'Prepare',
                                                    style: TextStyle(
                                                      color: Colors.black.withValues(alpha: 0.4),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            Container(
                                              height: 35,
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withValues(alpha: 0.2),
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: Text(
                                                'Mark as Deliver',
                                                style: TextStyle(
                                                  color: Colors.black.withValues(alpha: 0.4),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            if (orderSnapshot['Status'] != 'Delivered' && orderSnapshot['Status'] != 'Cancelled')
                                              Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: InkWell(
                                                  onTap: () async {
                                                    await orderCollection.doc(orderSnapshot.id).update({
                                                      'Status': 'Cancelled',
                                                      'Cancelled Time': FieldValue.serverTimestamp(),
                                                    });
                                                    isLoading.value = false;
                                                  },
                                                  borderRadius: BorderRadius.circular(35),
                                                  child: Container(
                                                    height: 35,
                                                    alignment: Alignment.center,
                                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius: BorderRadius.circular(35),
                                                    ),
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            if (orderSnapshot['Status'] == 'Pending')
                                              Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: InkWell(
                                                  onTap: () async {
                                                    isLoading.value = true;
                                                    await orderCollection.doc(orderSnapshot.id).update({
                                                      'Status': 'Preparing',
                                                      'Preparing Time': FieldValue.serverTimestamp(),
                                                    });
                                                    isLoading.value = false;
                                                  },
                                                  borderRadius: BorderRadius.circular(35),
                                                  child: Container(
                                                    height: 35,
                                                    alignment: Alignment.center,
                                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius: BorderRadius.circular(35),
                                                    ),
                                                    child: Text(
                                                      'Prepare',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            if (orderSnapshot['Status'] != 'Delivered' && orderSnapshot['Status'] != 'Cancelled' && orderSnapshot['Status'] != 'Pending')
                                              InkWell(
                                                onTap: () async {
                                                  isLoading.value = true;
                                                  if (!isPaid.value && currentUser != null) {
                                                    await userCollection.doc(currentUser).get().then((userSnapshot) async {
                                                      if (userSnapshot.data()!.containsKey('Monthly Bill')) {
                                                        monthlyBill = userSnapshot.data()!['Monthly Bill'] + orderSnapshot['Total Bill'];
                                                        await userCollection.doc(currentUser).update({
                                                          'Monthly Bill': monthlyBill,
                                                        });
                                                      } else {
                                                        await userCollection.doc(currentUser).update({
                                                          'Monthly Bill': orderSnapshot['Total Bill'],
                                                        });
                                                      }
                                                    });
                                                  }
                                                  await orderCollection.doc(orderSnapshot.id).update({
                                                    'Status': 'Delivered',
                                                    'Delivered Time': FieldValue.serverTimestamp(),
                                                  });
                                                  isLoading.value = false;
                                                },
                                                borderRadius: BorderRadius.circular(35),
                                                child: Container(
                                                  height: 35,
                                                  alignment: Alignment.center,
                                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                                  decoration: BoxDecoration(
                                                    color: Colors.amber,
                                                    borderRadius: BorderRadius.circular(35),
                                                  ),
                                                  child: Text(
                                                    'Mark as Deliver',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 200,
                              width: double.infinity,
                              margin: EdgeInsets.only(bottom: 10),
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
