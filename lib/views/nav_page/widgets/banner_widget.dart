// ignore_for_file: no_leading_underscores_for_local_identifiers


import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../services/service_firebase.dart';

class BrandnerWidget extends StatefulWidget {
  const BrandnerWidget({super.key});

  @override
  State<BrandnerWidget> createState() => _BrandnerWidgetState();
}

class _BrandnerWidgetState extends State<BrandnerWidget> {
  final List _bannerImage = [];

  getBanners() {
    return firestore.collection('banners').get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        setState(() {
          _bannerImage.add(doc['image']);
        });
      }
    });
  }

  @override
  void initState() {
    getBanners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _bannerStream =
        FirebaseFirestore.instance.collection('banners').snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _bannerStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.yellow.shade900,
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.yellow.shade900.withOpacity(0.2),
                borderRadius: BorderRadius.circular(5)),
            child: Swiper(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final bannerImage = snapshot.data!.docs[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                    imageUrl: bannerImage['image'],
                    placeholder: (context, url) => Shimmer(
                      duration: const Duration(seconds: 3),
                      interval: const Duration(seconds: 5),
                      color: Colors.yellow.shade900,
                      colorOpacity: 0,
                      enabled: true,
                      direction: const ShimmerDirection.fromLTRB(),
                      child: Container(
                        color: Colors.yellow.shade900.withOpacity(0.3),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                );
              },
              autoplay: true,
              pagination: SwiperPagination(
                alignment: Alignment.bottomCenter,
                builder: DotSwiperPaginationBuilder(
                  color: Colors.white,
                  activeColor: Colors.yellow.shade900,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
