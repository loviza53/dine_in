import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dine_in/src/constants/colors.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({
    super.key,
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
              Container(
                height: 100,
                width: 5,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
