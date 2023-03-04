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
        // .where('approved', isEqualTo: true)
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
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final productData = snapshot.data!.docs[index];
                return GestureDetector(
                  onTap: productData['approved'] == false
                      ? null
                      : () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetail(
                                        productData: productData,
                                      )));
                        },
                  child: Card(
                      child: Column(
                    children: [
                      productData['approved'] == false
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
                                    style: GoogleFonts.righteous(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                              ))
                            ])
                          : Container(
                              constraints: const BoxConstraints(
                                minHeight: 120,
                                maxHeight: 250,
                                minWidth: double.infinity,
                              ),
                              child: Hero(
                                tag: 'proName${productData['proName']}',
                                child: Image(
                                    image: NetworkImage(
                                        productData['imageUrl'][0]),
                                    fit: BoxFit.cover),
                              )),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 8, top: 8, right: 8),
                        child: Text(
                          productData['proName'],
                          style: GoogleFonts.righteous(fontSize: 18),
                        ),
                      ),
                      Text(
                        '฿${productData['price'].toStringAsFixed(2)}',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.righteous(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  )),
                );
              },
              staggeredTileBuilder: (context) => const StaggeredTile.fit(1),
            ));
      },
    );
  }
}
