import 'package:flutter/material.dart';

import '../controller/product_controller.dart';
import '../models/product.dart';
import 'product_item.dart';
import 'see_all_title.dart';

class DiscountedListWidget extends StatefulWidget {
  const DiscountedListWidget({super.key});

  @override
  State<DiscountedListWidget> createState() => _DiscountedListWidgetState();
}

class _DiscountedListWidgetState extends State<DiscountedListWidget> {
  ProductController productController = ProductController();
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _fetchList();
  }

  void _fetchList() async {
    products = await productController.getDiscountedProducts();
    setState(() {
      products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SeeAllTitle(title: 'Хямдралтай бараа', onTap: () {}),
        const SizedBox(height: 20),
        SizedBox(
          height: 242,
          child: ListView.separated(
            itemCount: products.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 25),
            separatorBuilder: (context, index) => const SizedBox(width: 15),
            itemBuilder: (context, index) => ProductItem(product: products.elementAt(index)),
          ),
        ),
      ],
    );
  }
}
