import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pororo/controller/product_controller.dart';
import 'package:pororo/models/product.dart';

class Favorite {
  String id;
  String productId;
  ValueNotifier<Product?> product = ValueNotifier(null);

  Favorite({
    required this.id,
    required this.productId,
    Product? product,
  }) {
    this.product.value = product;
    if (this.product.value == null) fetchProductData();
  }

  factory Favorite.fromSnapshot(DocumentSnapshot data) {
    dynamic json = data.data();
    return Favorite(id: data.id, productId: json['product_id']);
  }

  fetchProductData() async {
    if (product.value != null) return;

    product.value = await ProductController().getProduct(productId);
  }
}
