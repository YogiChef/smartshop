// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'widgets/main_category.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream =
        FirebaseFirestore.instance.collection('categories').snapshots();
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

        return Stack(
          children: [
            Positioned(
              top: 30,
              left: MediaQuery.of(context).size.width * 0.4,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Categories',
                  style: GoogleFonts.righteous(
                      fontSize: 20, color: Colors.black54),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
              child: StaggeredGridView.countBuilder(
                shrinkWrap: true,
                crossAxisCount: 3,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final productData = snapshot.data!.docs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainCategoryPage(
                                    prorist: productData,
                                  )));
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 8),
                          height: 90,
                          width: double.infinity,
                          child: Image(
                            image: NetworkImage(productData['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 8, top: 8, right: 8),
                          child: Text(
                            productData['categoryName'],
                            style: GoogleFonts.righteous(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
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
            ),
          ],
        );
      },
    );
  }
}
