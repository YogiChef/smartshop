// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cart_stepper/cart_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smartshop/views/nav_page/widgets/dialog.dart';
import '../../inner_page/checkout.dart';
import '../../providers/cart_provider.dart';
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Cart',
            style: GoogleFonts.righteous(fontSize: 20, color: Colors.black87),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () {
                  MyAlertDialog.showMyDialog(
                      context: context,
                      title: 'Delete',
                      contant: 'Are you sure delete Items',
                      tabNo: () {
                        Navigator.pop(context);
                      },
                      tabYes: () {
                        _cartProvider.removeAllItem();
                        Navigator.pop(context);
                      });
                },
                icon: const Icon(
                  CupertinoIcons.delete,
                  color: Colors.black54,
                  size: 20,
                ))
          ]),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: _cartProvider.getCartItem.length,
          itemBuilder: (context, index) {
            final cartData = _cartProvider.getCartItem.values.toList()[index];
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
                              left: 12, bottom: 8, right: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                cartData.proName,
                                style: GoogleFonts.righteous(
                                    fontSize: 16, color: Colors.black54),
                              ),
                              SizedBox(
                                height: 20,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      cartData.price.toStringAsFixed(2),
                                      style: GoogleFonts.righteous(
                                          height: 0.5,
                                          fontSize: 16,
                                          color: Colors.red),
                                    ),
                                    cartData.quantity < 1
                                        ? IconButton(
                                            icon: const Icon(
                                              CupertinoIcons.delete_left_fill,
                                              size: 20,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              _cartProvider
                                                  .removeItem(cartData.proId);
                                            },
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 24,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
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

                                    cartData.quantity < 1
                                        ? const SizedBox()
                                        : CartStepperInt(
                                            value: cartData.quantity,
                                            didChangeCount: (int value) {
                                              if (value < 0) {
                                                return;
                                              }
                                              cartData.proqty == value
                                                  ? Fluttertoast.showToast(
                                                      msg: 'msg',
                                                    )
                                                  : setState(() {
                                                      cartData.quantity = value;
                                                    });
                                            },
                                            size: 28,
                                            style: CartStepperTheme.of(context)
                                                .copyWith(
                                                    activeForegroundColor:
                                                        Colors.red,
                                                    activeBackgroundColor:
                                                        Colors.white,
                                                    textStyle:
                                                        GoogleFonts.righteous(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                    border: Border.all(
                                                      color: Colors.green,
                                                    ),
                                                    radius:
                                                        const Radius.circular(
                                                            3)))
                                    // Container(
                                    //   height: 30,
                                    //   decoration: BoxDecoration(
                                    //       border: Border.all(
                                    //           color: Colors.grey, width: 0.5),
                                    //       borderRadius: BorderRadius.circular(3)),
                                    //   child: Row(
                                    //     children: [
                                    //       IconButton(
                                    //           onPressed: cartData.quantity == 1
                                    //               ? null
                                    //               : () {
                                    //                   _cartProvider
                                    //                       .dereament(cartData);
                                    //                 },
                                    //           icon: const Icon(
                                    //             Icons.remove,
                                    //             size: 16,
                                    //           )),
                                    //       Text(
                                    //         cartData.quantity.toString(),
                                    //         style: GoogleFonts.righteous(
                                    //             fontSize: 14,
                                    //             fontWeight: FontWeight.bold),
                                    //       ),
                                    //       IconButton(
                                    //           onPressed: () {
                                    //             _cartProvider
                                    //                 .increament(cartData);
                                    //           },
                                    //           icon: const Icon(
                                    //             Icons.add,
                                    //             size: 16,
                                    //           ))
                                    //     ],
                                    //   ),
                                    // )
                                  ],
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
      //   body: Center(
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     Text(
      //       'Your Cart Is Empty !',
      //       style: GoogleFonts.righteous(
      //           color: Colors.blue.shade700,
      //           fontSize: 30,
      //           fontWeight: FontWeight.w300),
      //     ),
      //     const SizedBox(
      //       height: 30,
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 20),
      //       child: ElevatedButton(
      //           style: ElevatedButton.styleFrom(
      //             backgroundColor: Colors.yellow.shade900,
      //           ),
      //           onPressed: () {
      //             Navigator.canPop(context)
      //                 ? Navigator.pop(context)
      //                 : Navigator.pushReplacementNamed(
      //                     context, ('customer_home'));
      //           },
      //           child: Text(
      //             'Continue Shopping',
      //             style: GoogleFonts.righteous(
      //               fontSize: 20,
      //               fontWeight: FontWeight.w500,
      //             ),
      //           )),
      //     )
      //   ],
      // ),
      // ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _cartProvider.totalPrice == 0 ? const SizedBox(): Row(
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
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow.shade900,
                ),
                label: Text(
                  'CheckOut ',
                  style: GoogleFonts.righteous(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CheckOutPage()));
                },
                icon: const Icon(
                  Icons.check_circle_outline,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
