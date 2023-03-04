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
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              toolbarHeight: 80,
              flexibleSpace: Image.asset(
                'images/coverimage.jpg',
                fit: BoxFit.cover,
              ),
              title: Row(
                children: [
                  Container(
                    height: 75,
                    width: 80,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 4,
                          color: Colors.white,
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
                      height: 80,
                      width: size.width * 0.7,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      data['bussinessName'].toUpperCase(),
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
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: const [
                                          Text('Edit'),
                                          Icon(
                                            Icons.edit_outlined,
                                            color: Colors.black,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 35,
                                    width: size.width * 0.3,
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
                                              style: GoogleFonts.aBeeZee(
                                                  color: Colors.teal,
                                                  fontSize: 16))
                                          : Text(
                                              'Follow',
                                              style: GoogleFonts.aBeeZee(
                                                  color: Colors.red,
                                                  fontSize: 16),
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
                    style: TextStyle(
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
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 0,
                    itemBuilder: (BuildContext context, int index) {
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
                                          style: GoogleFonts.righteous(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ))
                                  ])
                                : Container(
                                    constraints: const BoxConstraints(
                                      minHeight: 90,
                                      maxHeight: 150,
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
                                  left: 8, top: 8, right: 8),
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
                        )),
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
