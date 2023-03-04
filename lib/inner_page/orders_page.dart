// ignore_for_file: depend_on_referenced_packages, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/service_firebase.dart';
import 'package:intl/intl.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('buyerId', isEqualTo: auth.currentUser!.uid)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade900,
        title: Text(
          'Orders ',
          style: GoogleFonts.righteous(fontSize: 20),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.yellow.shade900),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          radius: 14,
                          child: document['accepted'] == true
                              ? const Icon(
                                  Icons.delivery_dining,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.access_time,
                                  color: Colors.grey,
                                ),
                        ),
                        title: document['accepted'] == true
                            ? Text(
                                'Accepted',
                                style: GoogleFonts.righteous(
                                    fontSize: 16, color: Colors.green),
                              )
                            : Text(
                                'Not Accepted',
                                style: GoogleFonts.righteous(
                                    fontSize: 16, color: Colors.grey),
                              ),
                        subtitle: Text(
                          DateFormat('dd/MM/yyyy - hh:mm')
                              .format(document['oderDate'].toDate()),
                          style: GoogleFonts.righteous(
                              fontSize: 14,
                              color: document['accepted'] == true
                                  ? Colors.green
                                  : Colors.grey),
                        ),
                        trailing: Text(
                          'Amount: ฿${document['price'] * document['qty'].floor()} ',
                          style: GoogleFonts.righteous(
                              fontSize: 14,
                              color: document['accepted'] == true
                                  ? Colors.green
                                  : Colors.grey),
                        ),
                      ),
                      ExpansionTile(
                        title: Text(
                          'Order Datails',
                          style: GoogleFonts.righteous(
                              fontSize: 16, color: Colors.black54),
                        ),
                        // subtitle: Text('View'),
                        children: [
                          ListTile(
                            leading: SizedBox(
                              height: 60,
                              width: 80,
                              child: Image.network(
                                document['productImage'][0],
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(document['proName']),
                                Text(
                                    '฿ ${document['price'].toStringAsFixed(2)}')
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'Quantity',
                                      style: GoogleFonts.righteous(
                                          fontSize: 16, color: Colors.black54),
                                    ),
                                    Text(
                                      document['qty'].toString(),
                                      style: GoogleFonts.righteous(
                                          fontSize: 14, color: Colors.black54),
                                    )
                                  ],
                                ),
                                document['accepted'] == true
                                    ? Text(
                                        'Delivery Date: ${DateFormat('dd/MM/yyyy - hh:mm').format(document['scheduleDate'].toDate())}',
                                        style: GoogleFonts.righteous(
                                            fontSize: 14,
                                            color: Colors.yellow.shade900),
                                      )
                                    : const Text(''),
                                ListTile(
                                    title: Text(
                                      'Buyer Details',
                                      style:
                                          GoogleFonts.righteous(fontSize: 16),
                                    ),
                                    subtitle: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            document['fullName'],
                                            style: GoogleFonts.righteous(
                                                fontSize: 14,
                                                color: Colors.black54),
                                          ),
                                          Text(
                                            document['phone'],
                                            style: GoogleFonts.righteous(
                                                fontSize: 14,
                                                color: Colors.black54),
                                          ),
                                          Text(
                                            document['email'],
                                            style: GoogleFonts.righteous(
                                                fontSize: 14,
                                                color: Colors.black54),
                                          ),
                                          Text(
                                            document['address'],
                                            style: GoogleFonts.righteous(
                                                fontSize: 14,
                                                color: Colors.black54),
                                          )
                                        ])),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
