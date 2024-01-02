// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartshop/views/nav_page/widgets/category_home.dart';
import 'package:smartshop/views/nav_page/widgets/main_product.dart';

import '../../../services/service_firebase.dart';
import '../../buyers/main_page.dart';

class CategoryText extends StatefulWidget {
  const CategoryText({super.key});

  @override
  State<CategoryText> createState() => _CategoryTextState();
}

class _CategoryTextState extends State<CategoryText> {
  String? _selectCategory;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _categoryStream =
        FirebaseFirestore.instance.collection('categories').snapshots();
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Categories',
                style: styles(fontSize: 18, color: Colors.black54),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _categoryStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: const LinearProgressIndicator(
                    color: Colors.green,
                  ),
                ));
              }

              return Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Flexible(
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final categoryData = snapshot.data!.docs[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 9.5),
                                child: ActionChip(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 0),
                                    shadowColor: Colors.black,
                                    elevation: 4,
                                    backgroundColor: _selectCategory !=
                                            categoryData['categoryName']
                                        ? Colors.black12
                                        : Colors.yellow.shade900,
                                    onPressed: () {
                                      setState(() {
                                        _selectCategory =
                                            categoryData['categoryName'];
                                      });
                                    },
                                    labelPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    label: Text(
                                      categoryData['categoryName'],
                                      style: styles(
                                          color: Colors.white, fontSize: 12),
                                    )),
                              ),
                            );
                          }),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainPage()));
                        },
                        icon: const Icon(
                          Icons.replay_outlined,
                          size: 24,
                          color: Colors.black45,
                        ))
                  ],
                ),
              );
            },
          ),
          _selectCategory != null
              ? CategoryHome(categoryName: _selectCategory!)
              : const MainProductPage(),
        ],
      ),
    );
  }
}
