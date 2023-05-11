import 'package:flutter/material.dart';

import '../controller/product_controller.dart';
import '../models/product.dart';
import 'product_item.dart';
import 'see_all_title.dart';

class NewProductListWidget extends StatefulWidget {
  const NewProductListWidget({super.key});

  @override
  State<NewProductListWidget> createState() => _NewProductListWidgetState();
}

class _NewProductListWidgetState extends State<NewProductListWidget> {
  ProductController productController = ProductController();
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _fetchList();
  }

  void _fetchList() async {
    products = await productController.getNewProducts();
    setState(() {
      products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SeeAllTitle(title: 'Шинэ бүтээгдэхүүн', onTap: () {}),
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
