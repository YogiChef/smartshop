// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshop/products/product_detail.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class MainProductPage extends StatelessWidget {
  const MainProductPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
        .collection('products')
        .where('approved', isEqualTo: true)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _productStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("");
        }

        return Container(
            height: 320,
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(0)),
            child: StaggeredGridView.countBuilder(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final productData = snapshot.data!.docs[index];
                return GestureDetector(
                  onTap: productData['qty'] <= 0
                      ? null
                      : () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetail(
                                        productData: productData,
                                      )));
                        },
                  child: Column(
                    children: [
                      productData['qty'] <= 0
                          ? Stack(children: [
                              Image(
                                image: NetworkImage(productData['imageUrl'][0]),
                                fit: BoxFit.cover,
                              ),
                              Positioned.fill(
                                  child: Container(
                                color: Colors.black87.withOpacity(0.6),
                                child: Center(
                                  child: Text(
                                    'Out of Sevice',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.righteous(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                              ))
                            ])
                          : Container(
                              padding: const EdgeInsets.only(right: 0, left: 0),
                              constraints: const BoxConstraints(
                                minHeight: 90,
                                maxHeight: 200,
                                minWidth: double.infinity,
                              ),
                              // height: 90,
                              width: double.infinity,
                              child: Hero(
                                tag: 'proName${productData['imageUrl']}',
                                child: Image(
                                    image: NetworkImage(
                                        productData['imageUrl'][0]),
                                    fit: BoxFit.cover),
                              )),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 5, top: 7, right: 5),
                        child: Text(
                          productData['proName'],
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.righteous(fontSize: 14),
                        ),
                      ),
                      Text(
                        '฿${productData['price'].toStringAsFixed(2)}',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.righteous(fontSize: 14),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                );
              },
              staggeredTileBuilder: (context) => const StaggeredTile.fit(1),
            ));
      },
    );
  }
}
