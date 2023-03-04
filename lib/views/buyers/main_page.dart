// ignore_for_file: prefer_final_fields
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshop/views/nav_page/cart_page.dart';
import 'package:smartshop/views/nav_page/category_page.dart';
import 'package:smartshop/views/nav_page/home_page.dart';
import 'package:smartshop/views/nav_page/profile_page.dart';
import 'package:smartshop/views/nav_page/search.page.dart';
import 'package:smartshop/views/nav_page/store_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _pageIndex = 0;

  List<Widget> _pages = [
    const HomePage(),
    const CategoryPage(),
    const StorePage(),
    const CartPage(),
    const SearchPage(),
    const ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          currentIndex: _pageIndex,
          selectedLabelStyle: GoogleFonts.righteous(
            fontSize: 16,
          ),
          onTap: (value) {
            setState(() {
              _pageIndex = value;
            });
          },
          selectedItemColor: Colors.yellow.shade900,
          items: [
            BottomNavigationBarItem(
                icon:
                    Icon(_pageIndex == 0 ? IconlyBold.home : IconlyLight.home),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(_pageIndex == 1
                    ? IconlyBold.category
                    : IconlyLight.category),
                label: 'Categories'),
            BottomNavigationBarItem(
              icon: Icon(_pageIndex == 2
                  ? Icons.inventory_outlined
                  : Icons.inventory_outlined),
              label: 'Store',
            ),
            BottomNavigationBarItem(
                icon: Icon(_pageIndex == 3 ? IconlyBold.buy : IconlyLight.buy),
                label: 'Cart'),
            BottomNavigationBarItem(
                icon: Icon(
                    _pageIndex == 4 ? IconlyLight.search : IconlyLight.search),
                label: 'Search'),
            BottomNavigationBarItem(
              icon: Icon(
                  _pageIndex == 5 ? IconlyBold.profile : IconlyLight.profile),
              label: 'Profile',
            ),
          ]),
      body: _pages[_pageIndex],
    );
  }
}
