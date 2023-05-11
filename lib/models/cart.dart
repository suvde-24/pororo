import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pororo/controller/product_controller.dart';
import 'package:pororo/models/product.dart';

class Cart {
  String id;
  String productId;
  int count;
  ValueNotifier<Product?> product = ValueNotifier(null);

  Cart({
    required this.id,
    required this.productId,
    required this.count,
    Product? product,
  }) {
    this.product.value = product;
  }

  factory Cart.fromSnapshot(DocumentSnapshot data) {
    dynamic json = data.data();
    return Cart(id: data.id, productId: json['product_id'], count: json['count']);
  }

  fetchProductData() async {
    if (product.value != null) return;

    product.value = await ProductController().getProduct(productId);
  }
}
