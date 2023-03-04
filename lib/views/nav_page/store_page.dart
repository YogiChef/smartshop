// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshop/services/service_firebase.dart';
import 'package:smartshop/views/nav_page/widgets/visit_store.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  String? documentid;
  @override
  void initState() {
    auth.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          documentid = user.uid;
        });
      } else {
        setState(() {
          documentid = null;
        });
      }
    });
    super.initState();
  }

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

        return Stack(
          children: [
            Positioned(
              top: 30,
              left: MediaQuery.of(context).size.width * 0.4,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Store',
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
                    onTap: productData['approved'] == false
                        ? null
                        : () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VisitStore(
                                          vendorid: snapshot.data!.docs[index]
                                              ['vendorId'],
                                        )));
                          },
                    child: Column(
                      children: [
                        productData['approved'] == false
                            ? Stack(children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: SizedBox(
                                    height: 90,
                                    width: double.infinity,
                                    child: Image(
                                      image: NetworkImage(productData['image']),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                    child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Container(
                                    color: Colors.black87.withOpacity(0.6),
                                    child: Center(
                                      child: Text(
                                        'waiting for approval',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.righteous(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ))
                              ])
                            : Container(
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
                            productData['bussinessName'],
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
