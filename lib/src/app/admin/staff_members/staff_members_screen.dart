import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class StaffMembersScreen extends StatefulWidget {
  const StaffMembersScreen({super.key});

  @override
  State<StaffMembersScreen> createState() => _StaffMembersScreenState();
}

class _StaffMembersScreenState extends State<StaffMembersScreen> {
  final staffMemberCollection = FirebaseFirestore.instance.collection('Staff Members');

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
              StreamBuilder(
                stream: staffMemberCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final staffMemberSnapshot = snapshot.data!.docs[index];
                        return ListTile(
                          title: Text(staffMemberSnapshot['First Name']),
                          subtitle: Text(staffMemberSnapshot['Last Name']),
                        );
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
