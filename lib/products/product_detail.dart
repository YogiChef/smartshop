// ignore_for_file: depend_on_referenced_packages, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:smartshop/providers/cart_provider.dart';
import 'package:intl/intl.dart';
import 'package:smartshop/services/service_firebase.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key, this.productData});
  final dynamic productData;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int imageIndex = 0;
  String? selectSized;

  String formatedDate(date) {
    final outputDateFormate = DateFormat('dd/MM/yyyy');
    final ouputDate = outputDateFormate.format(date);
    return ouputDate;
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                  child: Hero(
                    tag: 'proName${widget.productData['proName']}',
                    child: ClipRect(
                      child: PhotoView(
                          imageProvider: NetworkImage(
                              widget.productData['imageUrl'][imageIndex]),
                          initialScale: PhotoViewComputedScale.covered),
                    ),
                  ),
                ),
                Positioned(
                    top: 40,
                    left: 18,
                    child: CircleAvatar(
                      backgroundColor: Colors.yellow.shade50,
                      radius: 18,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )),
                Positioned(
                    bottom: 0,
                    child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.productData['imageUrl'].length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  imageIndex = index;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Container(
                                  height: 60,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.yellow.shade900),
                                  ),
                                  child: Image.network(
                                    widget.productData['imageUrl'][index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }),
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      widget.productData['price'].toStringAsFixed(2),
                      style: styles(fontSize: 18),
                    ),
                  ),
                  Text(
                    widget.productData['proName'],
                    style: styles(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 30,
                    child: _cartProvider.getCartItem
                            .containsKey(widget.productData['proId'])
                        ? Text(
                            'This item you have in cart already.!',
                            style: styles(
                                fontSize: 20, color: Colors.red),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.productData['size'].length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: selectSized !=
                                              widget.productData['size'][index]
                                          ? Colors.pink.shade500
                                          : Colors.transparent),
                                  onPressed: () {
                                    setState(() {
                                      selectSized =
                                          widget.productData['size'][index];
                                    });
                                  },
                                  child: Text(
                                    widget.productData['size'][index],
                                    style: styles(
                                        color: Colors.white),
                                  ),
                                ),
                              );
                            }),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Shipping On',
                          style: styles(fontSize: 14),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy - hh:mm')
                              .format(widget.productData['date'].toDate()),
                          style: styles(
                              fontSize: 14, color: Colors.black87),
                        )
                      ],
                    ),
                  ),
                  ExpansionTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Description',
                          style: styles(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'view',
                          style: styles(fontSize: 16),
                        ),
                      ],
                    ),
                    children: [
                      Text(
                        widget.productData['description'],
                        style: styles(
                            fontSize: 16, color: Colors.black54),
                      ),
                      Text(
                        'Quantity:  ${widget.productData['qty'].toString()}',
                        style: styles(
                            fontSize: 16, color: Colors.black54),
                      ),
                      Text(
                        'Shipping Charge:  ${widget.productData['shippingCharge'].toString()}',
                        style: styles(
                            fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: selectSized == null
              ? const SizedBox()
              : ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow.shade900,
                  ),
                  label: Text(
                    'Add to Cart',
                    style: styles(fontSize: 16),
                  ),
                  onPressed: () {
                    _cartProvider.addProductToCart(
                      widget.productData['proName'],
                      widget.productData['proId'],
                      widget.productData['imageUrl'],
                      1,
                      widget.productData['qty'],
                      widget.productData['price'],
                      widget.productData['vendorId'],
                      selectSized!,
                      widget.productData['date'],
                    );
                    Navigator.pop(context);
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const MainPage()));
                    Fluttertoast.showToast(
                        msg:
                            'You Added ${widget.productData['proName']} To Your Cart');
                  },
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    size: 20,
                  ),
                ),
        ),
      ),
    );
  }
}
