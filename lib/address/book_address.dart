import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshop/inner_page/place_order.dart';
import 'package:smartshop/services/service_firebase.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../inner_page/edit_profile.dart';

class AddressBook extends StatefulWidget {
  const AddressBook({
    super.key, 
  });
  
  

  @override
  State<AddressBook> createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {
  

  @override
  Widget build(BuildContext context) {
    CollectionReference users = firestore.collection('buyers');
    final Stream<QuerySnapshot> addressStream = firestore
        .collection('buyers')
        .doc(
          auth.currentUser!.uid,
        )
        .collection('address')
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back,color: Colors.yellow.shade900,)),
        title: Text(
          'Address Book',
          style: styles(
              fontSize: 20, color: Colors.yellow.shade900),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: addressStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Material(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          'You have set \n\n an address yet !',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.acme(
                            color: Colors.blueGrey,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var customer = snapshot.data!.docs[index];
                          return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) async => await firestore
                                .runTransaction((transaction) async {
                              DocumentReference docRf = firestore
                                  .collection('buyers')
                                  .doc(auth.currentUser!.uid)
                                  .collection('address')
                                  .doc(customer['addressId']);
                              transaction.delete(docRf);
                            }),
                            child: GestureDetector(
                              onTap: () async {
                                showprogress();

                                for (var item in snapshot.data!.docs) {
                                  await dfAddressFalse(item);
                                }
                                await dfAddressTrue(customer).whenComplete(
                                    () => updateProfile(customer));
                                Future.delayed(
                                        const Duration(microseconds: 100))
                                    .whenComplete(() {
                                  Navigator.pop(context);
                                  
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  color: customer['default'] == true
                                      ? Colors.teal.shade100
                                      : Colors.grey.shade200,
                                  child: ListTile(
                                    trailing: customer['default'] == true
                                        ? IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(
                                              Icons.home,
                                              color: Colors.deepOrange,
                                            ),
                                          )
                                        : const SizedBox(),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${customer['fullName']} ',
                                          style: const TextStyle(height: 2),
                                        ),
                                        Text("${customer['phone']}")
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'city/state: ${customer['address']} ${customer['city']}  ${customer['state']} ',
                                          style: const TextStyle(height: 2),
                                        ),
                                        Text(
                                            "country:  ${customer['country']}  ${customer['zipcode']}"),
                                      customer['default'] == true ?  Center(
                                        child: ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.yellow.shade900,
                                            ),
                                            label: Text(
                                              'Place Order ',
                                              style: styles(
                                                  fontSize: 16),
                                            ),
                                            onPressed: () async {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => const PlaceOrderPage()));
                                            },
                                            icon: const Icon(
                                              Icons.padding,
                                              size: 20,
                                            ),
                                          ),
                                      ):const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  })),
          
          
          const SizedBox(
            height: 20,
          )
        ],
      )),
      bottomSheet:FutureBuilder<DocumentSnapshot>(
      future: users.doc(auth.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
            ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow.shade900,
                  ),
                  label: Text(
                    'Add New Address',
                    style: styles(fontSize: 16),
                  ),
                  onPressed: () async {
                     Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditProfile(
                                                  userData: data,
                                                )));
                  },
                  icon: const Icon(
                    Icons.padding,
                    size: 20,
                  ),
                ),
                  ],
                 ),
          );
  }
  return Center(
          child: CircularProgressIndicator(
            color: Colors.yellow.shade900,
          ),
        );
      },
    ));
  }

  Future dfAddressFalse(dynamic item) async {
    await firestore.runTransaction((transaction) async {
      DocumentReference dRf = firestore
          .collection('buyers')
          .doc(auth.currentUser!.uid)
          .collection('address')
          .doc(item.id);
      transaction.update(dRf, {'default': false});
    });
  }

  Future dfAddressTrue(QueryDocumentSnapshot<Object?> customer) async {
    await firestore.runTransaction(
      (transaction) async {
        DocumentReference dRf = firestore
            .collection('buyers')
            .doc(auth.currentUser!.uid)
            .collection('address')
            .doc(customer['addressId']);
        transaction.update(dRf, {'default': true});
      },
    );
  }

  Future updateProfile(QueryDocumentSnapshot<Object?> customer) async {
    await firestore.runTransaction(
      (transaction) async {
        DocumentReference dRf =
            firestore.collection('buyers').doc(auth.currentUser!.uid);
        transaction.update(dRf, {
          'address':
              '${customer['address']} ${customer['city']}  ${customer['state']}  ${customer['country']} ${customer['zipcode']}',
          'phone': customer['phone']
        });
      },
    );
  }

  void showprogress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(max: 100, msg: 'please wait..', msgColor: Colors.red);
  }

  void hideprogress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.close();
  }
}