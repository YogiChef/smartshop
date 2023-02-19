// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream =
        FirebaseFirestore.instance.collection('vendors').snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _productStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.red,
          ));
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: StaggeredGridView.countBuilder(
            shrinkWrap: true,
            crossAxisCount: 3,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final productData = snapshot.data!.docs[index];
              return GestureDetector(
                onTap: productData['approved'] == false ? null : () {},
                child: Column(
                  children: [
                    productData['approved'] == false
                        ? Stack(
                            children: [
                              Image(
                                  image: NetworkImage(productData['image']),
                                  fit: BoxFit.cover),
                              Positioned.fill(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  color: Colors.white.withOpacity(0.7),
                                  constraints: const BoxConstraints(
                                    minHeight: 120,
                                    maxHeight: 250,
                                    minWidth: double.infinity,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Close',
                                      style: GoogleFonts.righteous(
                                          fontSize: 20,
                                          color: Colors.white,
                                          backgroundColor: Colors.black38),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            padding: const EdgeInsets.only(right: 8),
                            constraints: const BoxConstraints(
                              minHeight: 120,
                              maxHeight: 250,
                              minWidth: double.infinity,
                            ),
                            child: Image(
                                image: NetworkImage(productData['image']),
                                fit: BoxFit.cover)),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                      child: Text(
                        productData['bussinessName'],
                        style: GoogleFonts.righteous(fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              );
            },
            staggeredTileBuilder: (context) => const StaggeredTile.fit(1),
          ),
        );
      },
    );
  }
}
