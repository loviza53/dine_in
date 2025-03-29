import 'package:dine_in/src/constants/values.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:dine_in/src/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({
    super.key,
    required this.orderId,
  });

  final String orderId;

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  int currentStep = 1;

  final orderCollection = FirebaseFirestore.instance.collection('Orders');

  void nextStep() {
    if (currentStep < 3) {
      setState(() {
        currentStep++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your order',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              InkWell(
                onTap: () => Get.back(),
                borderRadius: BorderRadius.circular(35),
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Icon(
                    Icons.coffee_maker_rounded,
                    color: accentColor,
                    size: 150,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Order Successfully Placed',
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    'On the way to your table',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 20),
                  StreamBuilder(
                    stream: orderCollection.doc(widget.orderId).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final orderSnapshot = snapshot.data!;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 35),
                              child: Column(
                                children: [
                                  TimelineTile(
                                    isFirst: true,
                                    alignment: TimelineAlign.start,
                                    indicatorStyle: IndicatorStyle(
                                      width: 30,
                                      color: orderSnapshot['Status'] == 'Pending' ||
                                              orderSnapshot['Status'] == 'Preparing' ||
                                              orderSnapshot['Status'] == 'Delivered' ||
                                              orderSnapshot['Status'] == 'Cancelled'
                                          ? Colors.black
                                          : accentColor,
                                      iconStyle: orderSnapshot['Status'] == 'Pending' ||
                                              orderSnapshot['Status'] == 'Preparing' ||
                                              orderSnapshot['Status'] == 'Delivered' ||
                                              orderSnapshot['Status'] == 'Cancelled'
                                          ? IconStyle(
                                              iconData: Icons.check,
                                              color: Colors.white,
                                              fontSize: 18,
                                            )
                                          : null,
                                    ),
                                    beforeLineStyle: LineStyle(
                                      thickness: 4,
                                      color: orderSnapshot['Status'] == 'Pending' ||
                                              orderSnapshot['Status'] == 'Preparing' ||
                                              orderSnapshot['Status'] == 'Delivered' ||
                                              orderSnapshot['Status'] == 'Cancelled'
                                          ? Colors.black
                                          : accentColor,
                                    ),
                                    afterLineStyle: LineStyle(
                                      thickness: 4,
                                      color: orderSnapshot['Status'] == 'Pending' ||
                                              orderSnapshot['Status'] == 'Preparing' ||
                                              orderSnapshot['Status'] == 'Delivered' ||
                                              orderSnapshot['Status'] == 'Cancelled'
                                          ? Colors.black
                                          : accentColor,
                                    ),
                                    endChild: Padding(
                                      padding: const EdgeInsets.only(left: 50, top: 30, bottom: 30),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Order Placed',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: accentColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('hh:mm a, dd MMMM yyyy').format(orderSnapshot['Time'].toDate()!),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black.withValues(alpha: 0.5),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TimelineTile(
                                    alignment: TimelineAlign.start,
                                    indicatorStyle: IndicatorStyle(
                                      width: 30,
                                      color: orderSnapshot['Status'] == 'Cancelled'
                                          ? Colors.red
                                          : (orderSnapshot['Status'] == 'Preparing' || orderSnapshot['Status'] == 'Delivered')
                                              ? Colors.black
                                              : accentColor,
                                      iconStyle: orderSnapshot['Status'] == 'Cancelled'
                                          ? IconStyle(
                                              iconData: Icons.close,
                                              color: Colors.white,
                                              fontSize: 18,
                                            )
                                          : (orderSnapshot['Status'] == 'Preparing' || orderSnapshot['Status'] == 'Delivered')
                                              ? IconStyle(
                                                  iconData: Icons.check,
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                )
                                              : null,
                                    ),
                                    beforeLineStyle: LineStyle(
                                      thickness: 4,
                                      color: orderSnapshot['Status'] == 'Preparing' || orderSnapshot['Status'] == 'Delivered' || orderSnapshot['Status'] == 'Cancelled' ? Colors.black : accentColor,
                                    ),
                                    afterLineStyle: LineStyle(
                                      thickness: 4,
                                      color: orderSnapshot['Status'] == 'Cancelled'
                                          ? accentColor
                                          : (orderSnapshot['Status'] == 'Preparing' || orderSnapshot['Status'] == 'Delivered')
                                              ? Colors.black
                                              : accentColor,
                                    ),
                                    endChild: Padding(
                                      padding: const EdgeInsets.only(left: 50, top: 30, bottom: 30),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (orderSnapshot['Status'] == 'Preparing' || orderSnapshot['Status'] == 'Delivered')
                                            Text(
                                              'Preparing your Order',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: accentColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          if (orderSnapshot['Status'] == 'Preparing' || orderSnapshot['Status'] == 'Delivered')
                                            Text(
                                              DateFormat('hh:mm a, dd MMMM yyyy').format(orderSnapshot['Preparing Time'].toDate()!),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black.withValues(alpha: 0.5),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          if (orderSnapshot['Status'] == 'Cancelled')
                                            Text(
                                              'Cancelled',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.red,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          if (orderSnapshot['Status'] == 'Cancelled')
                                            Text(
                                              DateFormat('hh:mm a, dd MMMM yyyy').format(orderSnapshot['Cancelled Time'].toDate()!),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black.withValues(alpha: 0.5),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TimelineTile(
                                    isLast: true,
                                    alignment: TimelineAlign.start,
                                    indicatorStyle: IndicatorStyle(
                                      width: 30,
                                      color: orderSnapshot['Status'] == 'Delivered' ? Colors.black : accentColor,
                                      iconStyle: orderSnapshot['Status'] == 'Delivered'
                                          ? IconStyle(
                                              iconData: Icons.check,
                                              color: Colors.white,
                                              fontSize: 18,
                                            )
                                          : null,
                                    ),
                                    beforeLineStyle: LineStyle(
                                      thickness: 4,
                                      color: orderSnapshot['Status'] == 'Delivered' ? Colors.black : accentColor,
                                    ),
                                    afterLineStyle: LineStyle(
                                      thickness: 4,
                                      color: orderSnapshot['Status'] == 'Delivered' ? Colors.black : accentColor,
                                    ),
                                    endChild: Padding(
                                      padding: const EdgeInsets.only(left: 50, top: 30, bottom: 30),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (orderSnapshot['Status'] == 'Delivered')
                                            Text(
                                              'Delivered',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: accentColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          if (orderSnapshot['Status'] == 'Delivered')
                                            Text(
                                              DateFormat('hh:mm a, dd MMMM yyyy').format(orderSnapshot['Delivered Time'].toDate()!),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black.withValues(alpha: 0.5),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                              decoration: BoxDecoration(
                                color: selectedOptionColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                orderSnapshot['Table'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black.withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: orderSnapshot['Items'].length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${orderSnapshot['Items'][index]['Item Name']} ${orderSnapshot['Items'][index]['Size']} ${orderSnapshot['Items'][index]['Quantity']}x",
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "PKR ${orderSnapshot['Items'][index]['Total Price']}",
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
                            SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.5),
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
                                        "PKR ${orderSnapshot['Total Bill']}",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Delivery fee',
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'PKR 100',
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
                                        "PKR ${orderSnapshot['Total Bill']! + deliveryFee}",
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 50),
                          ],
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
