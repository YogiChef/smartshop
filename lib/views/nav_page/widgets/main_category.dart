// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../../../products/product_detail.dart';

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
      body: StreamBuilder<QuerySnapshot>(
        stream: _categoryStream,
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
                                  image:
                                      NetworkImage(productData['imageUrl'][0]),
                                  fit: BoxFit.cover,
                                ),
                                Positioned.fill(
                                    child: Container(
                                  color: Colors.black87.withOpacity(0.6),
                                  child: Center(
                                    child: Text(
                                      'Out of Stock',
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
      ),
    );
  }
}
