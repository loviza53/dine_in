import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dine_in/src/constants/colors.dart';
import 'package:dine_in/src/constants/values.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/src/app/controllers/cart_controller.dart';

class ItemDetail extends StatefulWidget {
  const ItemDetail({
    super.key,
    required this.id,
    required this.itemName,
    required this.price,
    required this.category,
  });

  final String id;
  final String itemName;
  final String price;
  final String category;

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  String size = sizes.first;
  int sugar = 1;
  int quantity = 1;
  int? totalPrice;

  final CartController controller = Get.find<CartController>();

  final itemCollection = FirebaseFirestore.instance.collection('Items');

  @override
  void initState() {
    totalPrice = int.tryParse(widget.price);
    super.initState();
  }

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
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: const Icon(
                        Icons.coffee_rounded,
                        size: 150,
                      ),
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.itemName,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "PKR ${widget.price}",
                              style: TextStyle(fontSize: 20, color: accentColor),
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
                                    if (quantity > 1) {
                                      quantity--;
                                      totalPrice = totalPrice! - int.parse(widget.price);
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
                                quantity.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 15),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    quantity++;
                                    totalPrice = totalPrice! + int.parse(widget.price);
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
                    SizedBox(height: 20),
                    Text(
                      'Size',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.zero,
                        itemCount: sizes.length,
                        itemBuilder: (context, index) {
                          double iconSize = 0;
                          if (sizes[index] == 'Small') {
                            iconSize = 40;
                          } else if (sizes[index] == 'Medium') {
                            iconSize = 50;
                          } else if (sizes[index] == 'Large') {
                            iconSize = 60;
                          }
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  size = sizes[index];
                                });
                              },
                              child: Icon(
                                Icons.coffee_rounded,
                                size: iconSize,
                                color: sizes[index] == size ? Colors.black : Colors.black.withValues(alpha: 0.2),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Sugar (In Cubes)',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              sugar = 0;
                            });
                          },
                          child: Icon(
                            Icons.cancel_rounded,
                            size: 35,
                            color: sugar == 0 ? Colors.black : Colors.black.withValues(alpha: 0.2),
                          ),
                        ),
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              sugar = 1;
                            });
                          },
                          child: Icon(
                            CupertinoIcons.cube_fill,
                            size: 35,
                            color: sugar == 1 ? Colors.black : Colors.black.withValues(alpha: 0.2),
                          ),
                        ),
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              sugar = 2;
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.cube_fill,
                                size: 30,
                                color: sugar == 2 ? Colors.black : Colors.black.withValues(alpha: 0.2),
                              ),
                              Icon(
                                CupertinoIcons.cube_fill,
                                size: 30,
                                color: sugar == 2 ? Colors.black : Colors.black.withValues(alpha: 0.2),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              sugar = 3;
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.cube_fill,
                                size: 25,
                                color: sugar == 3 ? Colors.black : Colors.black.withValues(alpha: 0.2),
                              ),
                              Icon(
                                CupertinoIcons.cube_fill,
                                size: 25,
                                color: sugar == 3 ? Colors.black : Colors.black.withValues(alpha: 0.2),
                              ),
                              Icon(
                                CupertinoIcons.cube_fill,
                                size: 25,
                                color: sugar == 3 ? Colors.black : Colors.black.withValues(alpha: 0.2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  "PKR ${totalPrice.toString()}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: InkWell(
              onTap: () async {
                controller.cartItems.add({
                  "Id": widget.id,
                  "Size": size,
                  "Sugar": sugar,
                  "Quantity": quantity,
                  "Item Name": widget.itemName,
                  'Category': widget.category,
                  "Price": widget.price,
                  "Total Price": totalPrice,
                });
                Get.back();
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Add to cart',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
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
