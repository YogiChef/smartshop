import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshop/services/service_firebase.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../../../products/product_detail.dart';

class VisitStore extends StatefulWidget {
  final String vendorid;
  const VisitStore({super.key, required this.vendorid});

  @override
  State<VisitStore> createState() => _VisitStoreState();
}

class _VisitStoreState extends State<VisitStore> {
  bool following = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CollectionReference supplier =
        FirebaseFirestore.instance.collection('vendors');
    final Stream<QuerySnapshot> productsStream = firestore
        .collection('products')
        .where('vendorId', isEqualTo: widget.vendorid)
        .where('approved', isEqualTo: true)
        .snapshots();

    return FutureBuilder<DocumentSnapshot>(
      future: supplier.doc(widget.vendorid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black54,
                  )),
              title: Row(
                children: [
                  Container(
                    height: 55,
                    width: 57,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.cyan,
                        ),
                        borderRadius: BorderRadius.circular(15)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        data['image'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: size.width * 0.7,
                      child: Stack(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  data['bussinessName'].toUpperCase(),
                                  style: styles(color: Colors.black87),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        data['vendorId'] == auth.currentUser!.uid
                            ? Container(
                                height: 30,
                                width: size.width * 0.3,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.teal, width: 1.5),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                child: MaterialButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => EditStore(
                                    //               data: data,
                                    //             )));
                                  },
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('Edit'),
                                      Icon(
                                        Icons.edit_outlined,
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: 24,
                                  width: size.width * 0.24,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: following == true
                                              ? Colors.teal
                                              : Colors.red,
                                          width: 1.5),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        following = !following;
                                      });
                                    },
                                    child: following == true
                                        ? Text('Following',
                                            overflow: TextOverflow.ellipsis,
                                            style: styles(
                                                color: Colors.teal,
                                                fontSize: 14))
                                        : Text(
                                            'Follow',
                                            overflow: TextOverflow.ellipsis,
                                            style: styles(
                                                color: Colors.red,
                                                fontSize: 14),
                                          ),
                                  ),
                                ),
                              )
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: productsStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text(
                    'This category \n\n has no items yet !',
                    textAlign: TextAlign.center,
                    style: styles(
                        fontSize: 26,
                        color: Colors.yellow.shade900,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5),
                  ));
                }
                return SingleChildScrollView(
                  child: StaggeredGridView.countBuilder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    crossAxisCount: 3,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    itemBuilder: (BuildContext context, int index) {
                      final productData = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: GestureDetector(
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
                                            'Out of Stock',
                                            style: styles(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ))
                                    ])
                                  : Hero(
                                      tag: 'proName${productData['imageUrl']}',
                                      child: Image(
                                          image: NetworkImage(
                                              productData['imageUrl'][0]),
                                          fit: BoxFit.cover),
                                    ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 6, top: 8, right: 6),
                                child: Text(
                                  productData['proName'],
                                  style: GoogleFonts.righteous(fontSize: 14),
                                ),
                              ),
                              Text(
                                '฿${productData['price'].toStringAsFixed(2)}',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.righteous(fontSize: 14),
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    staggeredTileBuilder: (context) =>
                        const StaggeredTile.fit(1),
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green,
              child: const Icon(
                Icons.sms_failed_outlined,
                size: 35,
              ),
              onPressed: () {},
            ),
          );
        }

        return const Center(
            child: CircularProgressIndicator(
          color: Colors.pinkAccent,
        ));
      },
    );
  }
}
