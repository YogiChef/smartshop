// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartshop/services/service_firebase.dart';
import 'package:smartshop/views/nav_page/widgets/dialog.dart';
import 'package:smartshop/views/nav_page/widgets/visit_store.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../../auth/login_page.dart';

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
      // if (user != null) {
      //   setState(() {
      //     documentid = user.uid;
      //   });
      // } else {
      //   setState(() {
      //     documentid = null;
      //   });
      // }
      user != null ? documentid = user.uid : documentid = null;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _vendorStream = FirebaseFirestore.instance
        .collection('vendors')
        // .where('approved', isEqualTo: true)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _vendorStream,
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

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Stores',
              style: styles(fontSize: 20, color: Colors.black54),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
            child: StaggeredGridView.countBuilder(
              shrinkWrap: true,
              crossAxisCount: 3,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final storeData = snapshot.data!.docs[index];
                return GestureDetector(
                  onTap: storeData['approved'] == false
                      ? null
                      : () {
                          auth.currentUser == null
                              ? MyAlertDialog.showMyDialog(
                                  contant: 'Please Sigin ',
                                  context: context,
                                  img: const AssetImage('images/login.jpeg'),
                                  tabNo: () {
                                    Navigator.pop(context);
                                  },
                                  tabYes: () async {
                                    await auth.signOut().whenComplete(() =>
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage())));

                                    await Future.delayed(
                                        const Duration(microseconds: 100));
                                  },
                                  title: 'Log Out')
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VisitStore(
                                            vendorid: snapshot.data!.docs[index]
                                                ['vendorId'],
                                          )));
                        },
                  child: Column(
                    children: [
                      storeData['approved'] == false
                          ? Stack(children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: SizedBox(
                                  height: 90,
                                  width: double.infinity,
                                  child: Image(
                                    image: NetworkImage(storeData['image']),
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
                                      style: styles(
                                          fontSize: 12, color: Colors.white),
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
                                image: NetworkImage(storeData['image']),
                                fit: BoxFit.cover,
                              ),
                            ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 8, top: 8, right: 8),
                        child: Text(
                          storeData['bussinessName'],
                          style: styles(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Text(
                        storeData['country'],
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                        style: styles(color: Colors.black54, fontSize: 10),
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
        );
      },
    );
  }
}
