import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../../../services/service_firebase.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Howdy , What Are You\nLooking For ',
            style: styles(
              fontSize: 22,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
              height: 20,
              child: IconButton(
                icon: const Icon(IconlyLight.buy),
                onPressed: () {},
              ))
        ],
      ),
    );
  }
}

class SearchIputWidget extends StatelessWidget {
  const SearchIputWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: SizedBox(
        height: 40,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: TextField(
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                fillColor: Colors.yellow.shade900.withOpacity(0.2),
                filled: true,
                hintText: 'Search For Products',
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                prefixIcon: const Icon(CupertinoIcons.search)),
          ),
        ),
      ),
    );
  }
}
