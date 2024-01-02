import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:smartshop/views/nav_page/search.page.dart';
import 'package:smartshop/views/nav_page/widgets/qr_code.dart';
import '../../../services/service_firebase.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 20, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Howdy , What Are\nYou Looking For ',
            style: styles(
                fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
          ),
          SizedBox(
              height: 20,
              child: IconButton(
                icon: const Icon(IconlyLight.scan),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QrCodePage(),
                      ));
                },
              ))
        ],
      ),
    );
  }
}

class SearchIputWidget extends StatelessWidget {
  const SearchIputWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: SizedBox(
        height: 40,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: TextField(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchPage(),
              ),
            ),
            readOnly: true,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                fillColor: Colors.grey.withOpacity(0.2),
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
