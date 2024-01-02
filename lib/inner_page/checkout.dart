// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartshop/address/book_address.dart';
import 'package:smartshop/services/service_firebase.dart';
import '../../providers/cart_provider.dart';
// import 'edit_profile.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
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
          // Map<String, dynamic> data =
          //     snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'การสั่งซื้อ',
                style: styles(fontSize: 20, color: Colors.black87),
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
            body: Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _cartProvider.getCartItem.length,
                  itemBuilder: (context, index) {
                    final cartData =
                        _cartProvider.getCartItem.values.toList()[index];
                    return Card(
                      child: SizedBox(
                          height: 110,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                        left: 12, right: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          cartData.proName,
                                          style: styles(),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${cartData.price.toStringAsFixed(1)} x ${cartData.quantity}  ',
                                              style: styles(
                                                color: Colors.red,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              '${cartData.price * cartData.quantity.floor() + cartData.charge}',
                                              style: styles(
                                                color: Colors.red,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 30,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.yellow.shade900,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                  5,
                                                ))),
                                            onPressed: () {},
                                            child: Text(
                                              cartData.productSize,
                                              style: styles(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                    );
                  }),
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total:฿${_cartProvider.totalPrice.toStringAsFixed(1)}',
                    style: styles(
                        fontSize: 14,
                        fontWeight: FontWeight.w200,
                        color: Colors.red),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: /* data['address'] == ""
                        ? ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan.shade500,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            label: Text(
                              'Address',
                              style: styles(fontSize: 11),
                            ),
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfile(
                                            userData: data,
                                          )));
                            },
                            icon: const Icon(
                              Icons.pin_drop_outlined,
                              size: 20,
                              color: Colors.white,
                            ),
                          )
                        : */
                        ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow.shade900,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      label: Text(
                        'คำสั่งซื้อ',
                        style: styles(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () async {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddressBook()));
                      },
                      icon: const Icon(
                        Icons.padding,
                        size: 20,
                        color: Colors.white,
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
