import 'package:flutter/material.dart';
import 'package:pororo/controller/product_controller.dart';
import 'package:pororo/models/product.dart';

import 'product_item.dart';
import 'see_all_title.dart';

class SpecialProductsWidget extends StatefulWidget {
  const SpecialProductsWidget({super.key});

  @override
  State<SpecialProductsWidget> createState() => _SpecialProductsWidgetState();
}

class _SpecialProductsWidgetState extends State<SpecialProductsWidget> {
  ProductController productController = ProductController();
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _fetchList();
  }

  void _fetchList() async {
    products = await productController.getSpecialProducts();
    setState(() {
      products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SeeAllTitle(title: 'Онцлох бүтээгдэхүүн', onTap: () {}),
        const SizedBox(height: 20),
        SizedBox(
          height: 242,
          width: double.infinity,
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
