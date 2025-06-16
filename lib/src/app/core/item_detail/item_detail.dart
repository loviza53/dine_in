import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dine_in/src/constants/colors.dart';
import 'package:dine_in/src/constants/values.dart';
import 'package:dine_in/src/app/controllers/cart_controller.dart';

class ItemDetail extends StatefulWidget {
  const ItemDetail({
    super.key,
    required this.id,
    required this.itemName,
    required this.price,
    required this.category,
    required this.imageURL,
    required this.description,
  });

  final String id;
  final String itemName;
  final String price;
  final String category;
  final String imageURL;
  final String description;

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  String size = sizes.first;
  String sugar = '1 Cube';
  int quantity = 1;
  int? totalPrice;

  final CartController controller = Get.find<CartController>();

  @override
  void initState() {
    totalPrice = int.tryParse(widget.price);
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
              child: SvgPicture.asset('assets/upper_background_image.svg', fit: BoxFit.fill),
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
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LayoutBuilder(
                              builder: (BuildContext context, BoxConstraints constraints) {
                                double containerWidth = constraints.maxWidth / 1.8;
                                return Container(
                                  height: containerWidth,
                                  width: containerWidth,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: secondaryColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.brown.withValues(alpha: 0.15),
                                        spreadRadius: 0,
                                        blurRadius: 6,
                                        offset: const Offset(4, 4),
                                      ),
                                    ],
                                  ),
                                  child: Image.network(
                                    widget.imageURL,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        height: containerWidth,
                                        width: containerWidth,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: containerWidth,
                                        width: containerWidth,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
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
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
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
                        if (widget.category == 'Breakfast')
                          Text(
                            widget.description,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        if (widget.category != 'Breakfast')
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 5),
                            child: Text(
                              'Size',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        if (widget.category != 'Breakfast')
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
                        if (widget.category != 'Breakfast')
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 5),
                            child: Text(
                              'Sugar (In Cubes)',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        if (widget.category != 'Breakfast')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    sugar = 'none';
                                  });
                                },
                                child: Icon(
                                  Icons.cancel_rounded,
                                  size: 35,
                                  color: sugar == 'none' ? Colors.black : Colors.black.withValues(alpha: 0.2),
                                ),
                              ),
                              SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    sugar = '1 Cube';
                                  });
                                },
                                child: Icon(
                                  CupertinoIcons.cube_fill,
                                  size: 35,
                                  color: sugar == '1 Cube' ? Colors.black : Colors.black.withValues(alpha: 0.2),
                                ),
                              ),
                              SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    sugar = '2 Cubes';
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.cube_fill,
                                      size: 35,
                                      color: sugar == '2 Cubes' ? Colors.black : Colors.black.withValues(alpha: 0.2),
                                    ),
                                    Icon(
                                      CupertinoIcons.cube_fill,
                                      size: 35,
                                      color: sugar == '2 Cubes' ? Colors.black : Colors.black.withValues(alpha: 0.2),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    sugar = '3 Cubes';
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.cube_fill,
                                      size: 35,
                                      color: sugar == '3 Cubes' ? Colors.black : Colors.black.withValues(alpha: 0.2),
                                    ),
                                    Icon(
                                      CupertinoIcons.cube_fill,
                                      size: 35,
                                      color: sugar == '3 Cubes' ? Colors.black : Colors.black.withValues(alpha: 0.2),
                                    ),
                                    Icon(
                                      CupertinoIcons.cube_fill,
                                      size: 35,
                                      color: sugar == '3 Cubes' ? Colors.black : Colors.black.withValues(alpha: 0.2),
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
                    if (widget.category == 'Breakfast') {
                      controller.cartItems.add({
                        "Id": widget.id,
                        "Quantity": quantity,
                        "Item Name": widget.itemName,
                        "Image URL": widget.imageURL,
                        'Category': widget.category,
                        "Price": widget.price,
                        "Total Price": totalPrice,
                      });
                    } else {
                      controller.cartItems.add({
                        "Id": widget.id,
                        "Size": size,
                        "Sugar": sugar,
                        "Quantity": quantity,
                        "Item Name": widget.itemName,
                        "Image URL": widget.imageURL,
                        'Category': widget.category,
                        "Price": widget.price,
                        "Total Price": totalPrice,
                      });
                    }
                    Get.back();
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 45,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: buttonColor,
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
        ],
      ),
    );
  }
}
