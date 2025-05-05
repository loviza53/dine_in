import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_in/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageItemsScreen extends StatefulWidget {
  const ManageItemsScreen({super.key});

  @override
  State<ManageItemsScreen> createState() => _ManageItemsScreenState();
}

class _ManageItemsScreenState extends State<ManageItemsScreen> {
  final itemCollection = FirebaseFirestore.instance.collection('Items');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor,
      body: Column(
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
            child: StreamBuilder(
              stream: itemCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final items = snapshot.data!.docs;
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Item Name')),
                          DataColumn(label: Text('Category')),
                          DataColumn(label: Text('Price')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('')),
                        ],
                        rows: items.map(
                          (doc) {
                            final itemSnapshot = doc.data();
                            final itemId = doc.id;
                            return DataRow(
                              cells: [
                                DataCell(Text(itemSnapshot['Item Name']!.toString())),
                                DataCell(Text(itemSnapshot['Category'].toString())),
                                DataCell(Text(itemSnapshot['Price'].toString())),
                                DataCell(Text(itemSnapshot['Status'].toString())),
                                DataCell(
                                  PopupMenuButton(
                                    color: Colors.white,
                                    position: PopupMenuPosition.under,
                                    icon: const Icon(
                                      Icons.more_vert_rounded,
                                      color: Colors.black,
                                    ),
                                    onSelected: (value) async {
                                      if (value == 'option') {
                                        if (itemSnapshot["Status"] == "available") {
                                          await itemCollection.doc(itemId).update({
                                            'Status': "unavailable",
                                          });
                                        } else {
                                          await itemCollection.doc(itemId).update({
                                            'Status': "available",
                                          });
                                        }
                                      }
                                    },
                                    itemBuilder: (BuildContext context) => [
                                      PopupMenuItem(
                                        value: 'option',
                                        child: Text(
                                          itemSnapshot["Status"] == "available" ? 'Mark as unavailable' : 'Mark as available',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
