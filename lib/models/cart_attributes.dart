
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CartAttr with ChangeNotifier {
  final String proName;
  final String proId;
  final List imageUrl;
  int quantity;
  int proqty;
  final double price;
  final double charge;
  final String venderId;
  final String productSize;
  Timestamp scheduleDate;

  CartAttr({
    required this.proName,
    required this.proId,
    required this.imageUrl,
    required this.quantity,
    required this.proqty,
    required this.price,
    required this.charge,

    required this.venderId,
    required this.productSize,
    required this.scheduleDate,
  });

  void increase() {
    quantity++;
  }

  void decrease() {
    quantity--;
  }
}
