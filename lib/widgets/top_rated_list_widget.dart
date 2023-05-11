import 'package:flutter/material.dart';

import '../controller/product_controller.dart';
import '../models/product.dart';
import 'product_item.dart';
import 'see_all_title.dart';

class TopRatedListWidget extends StatefulWidget {
  const TopRatedListWidget({super.key});

  @override
  State<TopRatedListWidget> createState() => _TopRatedListWidgetState();
}

class _TopRatedListWidgetState extends State<TopRatedListWidget> {
  ProductController productController = ProductController();
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _fetchList();
  }

  void _fetchList() async {
    products = await productController.getProducts();
    setState(() {
      products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SeeAllTitle(title: 'Өндөр үнэлгээтэй', onTap: () {}),
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
