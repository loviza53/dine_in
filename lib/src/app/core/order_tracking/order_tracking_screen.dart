import 'package:get/get.dart';
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
      padding: EdgeInsets.all(15),
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
              color: accentColor,
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
                    TimelineTile(
                      isFirst: true,
                      alignment: TimelineAlign.start,
                      indicatorStyle: IndicatorStyle(
                        width: 30,
                        color: orderSnapshot['Status'] == 'Pending' || orderSnapshot['Status'] == 'Preparing' || orderSnapshot['Status'] == 'Delivered' ? Colors.black : accentColor,
                      ),
                      beforeLineStyle: LineStyle(
                        thickness: 4,
                        color: orderSnapshot['Status'] == 'Pending' || orderSnapshot['Status'] == 'Preparing' || orderSnapshot['Status'] == 'Delivered' ? Colors.black : accentColor,
                      ),
                      afterLineStyle: LineStyle(
                        thickness: 4,
                        color: orderSnapshot['Status'] == 'Pending' || orderSnapshot['Status'] == 'Preparing' || orderSnapshot['Status'] == 'Delivered' ? Colors.black : accentColor,
                      ),
                      endChild: Container(
                        margin: EdgeInsets.only(left: 10),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          // color: accentColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          'Order Placed',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.brown,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    TimelineTile(
                      alignment: TimelineAlign.start,
                      indicatorStyle: IndicatorStyle(
                        width: 30,
                        color: orderSnapshot['Status'] == 'Preparing' || orderSnapshot['Status'] == 'Delivered' ? accentColor : Colors.black,
                      ),
                      beforeLineStyle: LineStyle(
                        thickness: 4,
                        color: orderSnapshot['Status'] == 'Preparing' || orderSnapshot['Status'] == 'Delivered' ? accentColor : Colors.black.withValues(alpha: 0.2),
                      ),
                      afterLineStyle: LineStyle(
                        thickness: 4,
                        color: orderSnapshot['Status'] == 'Preparing' || orderSnapshot['Status'] == 'Delivered' ? accentColor : Colors.black.withValues(alpha: 0.2),
                      ),
                      endChild: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Preparing your Order',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    TimelineTile(
                      isLast: true,
                      alignment: TimelineAlign.start,
                      indicatorStyle: IndicatorStyle(
                        width: 30,
                        color: orderSnapshot['Status'] == 'Delivered' ? Colors.black : accentColor,
                      ),
                      beforeLineStyle: LineStyle(
                        thickness: 4,
                        color: orderSnapshot['Status'] == 'Delivered' ? accentColor : Colors.black.withValues(alpha: 0.2),
                      ),
                      afterLineStyle: LineStyle(
                        thickness: 4,
                        color: orderSnapshot['Status'] == 'Delivered' ? accentColor : Colors.black.withValues(alpha: 0.2),
                      ),
                      endChild: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('Order Placed', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}
