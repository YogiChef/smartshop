import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../products/product_detail.dart';
import '../../services/service_firebase.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchInput = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          // leading: Padding(
          //   padding: const EdgeInsets.only(left: 20),
          //   child: IconButton(
          //       onPressed: () {
          //         Navigator.pushNamed(context, 'customer_home');
          //       },
          //       icon: const Icon(
          //         Icons.arrow_back_ios,
          //         size: 20,
          //         color: Colors.black,
          //       )),
          // ),
          title: SizedBox(
            height: 43,
            child: CupertinoSearchTextField(
              itemSize: 24,
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  searchInput = value;
                });
              },
            ),
          )),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: searchInput == ''
            ? Padding(
                padding: const EdgeInsets.only(bottom: 200),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            // border: Border.all(width: 1, color: Colors.red),
                            image: DecorationImage(
                              image: AssetImage(
                                'images/search.png',
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Search for\nany products',
                          // maxLines: 2,
                          style: GoogleFonts.righteous(
                              fontSize: 26, color: Colors.yellow.shade900),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Material(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final result = snapshot.data!.docs.where(
                    (e) => e['proName']
                        .toLowerCase()
                        .contains(searchInput.toLowerCase()),
                  );
                  return ListView(
                    children: result.map((e) => SearchModel(e: e)).toList(),
                  );
                }),
      ),
    );
  }
}

class SearchModel extends StatelessWidget {
  final dynamic e;
  const SearchModel({super.key, required this.e});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: e['qty'] <= 0
          ? null
          : () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetail(
                            productData: e,
                          )));
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          width: double.infinity,
          height: 110,
          child: Row(
            children: [
              e['qty'] <= 0
                  ? Stack(children: [
                      SizedBox(
                        height: 70,
                        width: 80,
                        child: Image(
                          image: NetworkImage(e['imageUrl'][0]),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned.fill(
                          child: Container(
                        color: Colors.black87.withOpacity(0.6),
                        child: Center(
                          child: Text(
                            'Out of Stock',
                            style: styles(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ))
                    ])
                  : ClipRRect(
                      // borderRadius: BorderRadius.circular(5),
                      child: SizedBox(
                        height: 60,
                        width: 80,
                        child: Image(
                          image: NetworkImage(e['imageUrl'][0]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                  child: Column(
                children: [
                  Text(
                    e['proName'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    e['description'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey, height: 1),
                  ),
                  // const SizedBox(
                  //   height: 12,
                  // ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '฿ ${e['price'].toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 14,
                              color: e['qty'] <= 10 ? Colors.red : Colors.grey,
                              height: 1),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.shopping_basket_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              e['qty'].toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: e['qty'] <= 10
                                      ? Colors.red
                                      : Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
