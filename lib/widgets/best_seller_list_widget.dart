import 'package:flutter/material.dart';
import 'package:pororo/controller/product_controller.dart';
import 'package:pororo/models/product.dart';
import 'package:pororo/widgets/product_item.dart';
import 'package:pororo/widgets/see_all_title.dart';

class BestSellerListWidget extends StatefulWidget {
  const BestSellerListWidget({super.key});

  @override
  State<BestSellerListWidget> createState() => _BestSellerListWidgetState();
}

class _BestSellerListWidgetState extends State<BestSellerListWidget> {
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
        SeeAllTitle(title: 'Шилдэг борлуулалттай', onTap: () {}),
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
