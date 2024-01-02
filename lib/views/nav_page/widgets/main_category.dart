// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../../../products/product_detail.dart';
import '../../../services/service_firebase.dart';

class MainCategoryPage extends StatelessWidget {
  const MainCategoryPage({
    super.key,
    required this.prorist,
  });
  final dynamic prorist;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _categoryStream = FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: prorist['categoryName'])
        .where('approved', isEqualTo: true)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          prorist['categoryName'],
          style: GoogleFonts.righteous(fontSize: 24, color: Colors.black87),
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
              color: Colors.black87,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: StreamBuilder<QuerySnapshot>(
          stream: _categoryStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("");
            }

            return StaggeredGridView.countBuilder(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 6,
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
                                image: NetworkImage(
                                    productData['imageUrl'][0]),
                                fit: BoxFit.cover,
                              ),
                              Positioned.fill(
                                  child: Container(
                                color: Colors.black87.withOpacity(0.6),
                                child: Center(
                                  child: Text(
                                    'Out of Sevice',
                                    textAlign: TextAlign.center,
                                    style: styles(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ),
                              ))
                            ])
                          : Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              // height: 90,
                              width: double.maxFinite,
                              constraints: const BoxConstraints(
                                minHeight: 90,
                                maxHeight: 220,
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
                        padding: const EdgeInsets.only(
                            left: 5, top: 7, right: 5),
                        child: Text(
                          productData['proName'],
                          overflow: TextOverflow.ellipsis,
                          style: styles(),
                        ),
                      ),
                      Text(
                        '฿${productData['price'].toStringAsFixed(2)}',
                        overflow: TextOverflow.ellipsis,
                        style: styles(),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                );
              },
              staggeredTileBuilder: (context) => const StaggeredTile.fit(1),
            );
          },
        ),
      ),
    );
  }
}
