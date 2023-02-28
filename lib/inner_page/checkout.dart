// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smartshop/services/service_firebase.dart';
import 'package:uuid/uuid.dart';
import '../../providers/cart_provider.dart';
import '../views/buyers/main_page.dart';
import 'edit_profile.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');

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
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Checkout',
                style:
                    GoogleFonts.righteous(fontSize: 20, color: Colors.black87),
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black54,
                  )),
            ),
            body: ListView.builder(
                shrinkWrap: true,
                itemCount: _cartProvider.getCartItem.length,
                itemBuilder: (context, index) {
                  final cartData =
                      _cartProvider.getCartItem.values.toList()[index];
                  return Card(
                    child: SizedBox(
                        height: 90,
                        child: Row(
                          children: [
                            SizedBox(
                              height: 70,
                              width: 90,
                              child: Image.network(
                                cartData.imageUrl[0],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, top: 8, bottom: 8, right: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      cartData.proName,
                                      style: GoogleFonts.righteous(
                                          fontSize: 16, color: Colors.black54),
                                    ),
                                    Text(
                                      cartData.price.toStringAsFixed(2),
                                      style: GoogleFonts.righteous(
                                          fontSize: 16, color: Colors.red),
                                    ),
                                    SizedBox(
                                      height: 24,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.pink.shade100),
                                        onPressed: () {},
                                        child: Text(
                                          cartData.productSize,
                                          style: GoogleFonts.righteous(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                  );
                }),
            bottomSheet: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'Total:  ฿${_cartProvider.totalPrice.toStringAsFixed(2)}',
                      style: GoogleFonts.righteous(
                          fontSize: 18,
                          fontWeight: FontWeight.w200,
                          color: Colors.red),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: data['address'] == ''
                        ? TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfile(
                                            userData: data,
                                          )));
                            },
                            child: Text(
                              'Enter Billing Address',
                              style: GoogleFonts.righteous(
                                  fontSize: 18, color: Colors.cyan.shade400),
                            ))
                        : ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow.shade900,
                            ),
                            label: Text(
                              'Place Order ',
                              style: GoogleFonts.righteous(fontSize: 16),
                            ),
                            onPressed: () {
                              EasyLoading.show(status: 'Placing Order');
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
                                  'accepted':false,
                                }).whenComplete(() {
                                  setState(() {
                                    _cartProvider.getCartItem.clear();
                                  });
                                  EasyLoading.dismiss();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MainPage())).whenComplete(
                                      () => Navigator.pop(context));
                                });
                              });
                            },
                            icon: const Icon(
                              Icons.padding,
                              size: 20,
                            ),
                          ),
                  ),
                ],
              ),
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
