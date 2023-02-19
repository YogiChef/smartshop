import 'package:flutter/cupertino.dart';

class ProductProvider with ChangeNotifier {
  Map<String, dynamic> productData = {};

  getFormData({String? productName,
    double? productPrice,
    int? qty,
    String? category,
    String? description,
    DateTime? date, List<String>? imageUrlList,
  }) {
    if (productName != null) {
      productData['productName'] = productName;
    }
    if (productPrice != null) {
      productData['productPrice'] = productPrice;
    }
    if (qty != null) {
      productData['quantity'] = qty;
    }
    if (category != null) {
      productData['category'] = category;
    }
    if (description != null) {
      productData['description'] = description;
    }
     if (date != null) {
      productData['date'] = date;
    }
    if (imageUrlList != null) {
      productData['imageUrlList'] = imageUrlList;
    }
  }
}
