import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ManageCustomersScreen extends StatefulWidget {
  const ManageCustomersScreen({super.key});

  @override
  State<ManageCustomersScreen> createState() => _ManageCustomersScreenState();
}

class _ManageCustomersScreenState extends State<ManageCustomersScreen> {
  final userCollection = FirebaseFirestore.instance.collection('Users');

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
                    const Center(
                      child: Text(
                        'Customers',
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: StreamBuilder(
                    stream: userCollection.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final userSnapshot = snapshot.data!.docs[index];
                              return Container(
                                padding: EdgeInsets.all(15),
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userSnapshot['Full Name'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (userSnapshot.data().containsKey('Monthly Bill'))
                                      Text(
                                        'Bill: PKR ${userSnapshot['Monthly Bill']}',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      )
                                    else
                                      Text(
                                        'No Bill',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    SizedBox(height: 20),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () {
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
                                                        Icons.lock_reset,
                                                        color: selectedOptionColor,
                                                        size: 100,
                                                      ),
                                                      SizedBox(height: 10),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                                        child: Text(
                                                          'Are you sure you want to reset the bill? This action cannot be undone.',
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
                                                              onTap: () async {
                                                                Get.back();
                                                                userCollection.doc(userSnapshot.id).update({
                                                                  'Monthly Bill': 0,
                                                                });
                                                              },
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
                                                                  'Reset',
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


                                        },
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            'Reset Bill',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      } else {
                        return SizedBox();
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
