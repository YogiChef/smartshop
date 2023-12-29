import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/cart_attributes.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartAttr> _cartItems = {};

  Map<String, CartAttr> get getCartItem {
    return _cartItems;
  }

  

  double get totalPrice {
    var total = 0.0;

    _cartItems.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return  total ;
  }

  void addProductToCart(
    String proName,
    String proId,
    List imageUrl,
    int quantity,
    int qty,
    double price,
    double charge,
    String venderId,
    String productSize,
    Timestamp scheduleDate,
  ) {
    if (_cartItems.containsKey(proId)) {
      _cartItems.update(
          proId,
          (exitingCart) => CartAttr(
                proName: exitingCart.proName,
                proId: exitingCart.proId,
                imageUrl: exitingCart.imageUrl,
                quantity: exitingCart.quantity + 1,
                proqty: exitingCart.proqty,
                price: exitingCart.price,
                charge: exitingCart.charge,
                venderId: exitingCart.venderId,
                productSize: exitingCart.productSize,
                scheduleDate: exitingCart.scheduleDate,
              ));
      notifyListeners();
    } else {
      _cartItems.putIfAbsent(
          proId,
          () => CartAttr(
              proName: proName,
              proId: proId,
              imageUrl: imageUrl,
              quantity: quantity,
              proqty: qty,
              price: price,
              charge: charge,
              venderId: venderId,
              productSize: productSize,
              scheduleDate: scheduleDate));
      notifyListeners();
    }
  }

  void increament(CartAttr cartAttr) {
    cartAttr.increase();
    notifyListeners();
  }

  void dereament(CartAttr cartAttr) {
    cartAttr.decrease();
    notifyListeners();
  }

  removeItem(proId) {
    _cartItems.remove(proId);
    notifyListeners();
  }

  removeAllItem() {
    _cartItems.clear();
    notifyListeners();
  }
}
