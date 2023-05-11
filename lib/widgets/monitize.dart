import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:pororo/screen/product_screen.dart';
import 'package:pororo/screen/store_screen.dart';

import '../models/product.dart';
import '../models/store.dart';

class Monitize extends StatelessWidget {
  final String image;
  final Product? product;
  final Store? store;
  const Monitize({required this.image, this.product, this.store, super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 50;
    double height = width * 151 / 325;
    return InkWell(
      onTap: () {
        if (store != null) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => StoreScreen(store: store!)));
        } else if (product != null) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductScreen(product: product!)));
        }
      },
      child: ExtendedImage.asset(
        'assets/images/$image.png',
        height: height,
        width: width,
      ),
    );
  }
}
