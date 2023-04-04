// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/cart_provider.dart';
import '../services/service_firebase.dart';
import '../views/buyers/main_page.dart';

class PlaceOrderPage extends StatefulWidget {
  const PlaceOrderPage(
      {super.key,
      });


  @override
  State<PlaceOrderPage> createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  
  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    CollectionReference users = firestore.collection('buyers');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(auth.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return
     Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'images/delivery.webp',
              width: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan.shade600,
                  padding: const EdgeInsets.symmetric(horizontal: 10)),
              onPressed: () {
                _cartProvider.getCartItem.forEach((key, item) {
                                final orderId = const Uuid().v4();

                                firestore
                                    .collection('orders')
                                    .doc(orderId)
                                    .set({
                                  'orderId': orderId,
                                  'vendorId': item.venderId,
                                  'email': data['email'],
                                  'phone': data['phone'],
                                  'address': data['address'],
                                  'buyerId': data['buyerId'],
                                  'fullName': data['fullName'],
                                  'buyerImage': data['profileImage'],
                                  'proName': item.proName,
                                  'price': item.price,
                                  'proId': item.proId,
                                  'productImage': item.imageUrl,
                                  'qty': item.quantity,
                                  'productSize': item.productSize,
                                  'scheduleDate': item.scheduleDate,
                                  'oderDate': DateTime.now(),
                                  'accepted': false,
                                }).whenComplete(() async {
                                  firestore.runTransaction((transaction) async {
                                    DocumentReference rf = FirebaseFirestore
                                        .instance
                                        .collection('products')
                                        .doc(item.proId);
                                    DocumentSnapshot spshot =
                                        await transaction.get(rf);
                                    transaction.update(rf,
                                        {'qty': spshot['qty'] - item.quantity});
                                  });
                                  setState(() {
                                    _cartProvider.getCartItem.clear();
                                  });

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MainPage())).whenComplete(
                                      () => Navigator.pop(context));
                                });
                              });
              },
              icon: const Icon(Icons.gif_box_rounded),
              label: Text(
                'Place Order',
                style: styles(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              )),
        ],
      ),
    );
  }
return const Center(
          child: CircularProgressIndicator(
            color: Colors.teal,
          ),
        );
      },
    );
  }
}
