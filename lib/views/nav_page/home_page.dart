import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartshop/views/nav_page/widgets/banner_widget.dart';
import 'package:smartshop/views/nav_page/widgets/category_text.dart';
import 'widgets/welcom_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: const [
        WelcomeText(),
        SearchIputWidget(),
        BrandnerWidget(),
        Padding(
          padding: EdgeInsets.only(
            bottom: 4,
          ),
          child: CategoryText(),
        ),
      ],
    );
  }
}
