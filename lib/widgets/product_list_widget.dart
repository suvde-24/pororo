import 'package:flutter/material.dart';
import 'package:pororo/models/product.dart';
import 'package:pororo/utils/b_colors.dart';
import 'package:pororo/widgets/product_item.dart';
import 'package:pororo/widgets/shimmer_product.dart';

class ProductListWidget extends StatelessWidget {
  final List<Product>? products;
  const ProductListWidget({this.products, super.key});

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 63) / 2;

    if (products == null) {
      return GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 13,
        childAspectRatio: 0.7,
        physics: const ClampingScrollPhysics(),
        children: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
            .map(
              (e) => const ShimmerProduct(),
            )
            .toList(),
      );
    } else if (products!.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Image.asset('assets/icons/emoji.png'),
            const SizedBox(height: 10),
            Text(
              'Бараа бүтээгдэхүүн олдсонгүй.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: BColors.primaryNavyBlack,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 20,
      crossAxisSpacing: 13,
      childAspectRatio: 0.7,
      physics: const ClampingScrollPhysics(),
      children: products!.map((e) => ProductItem(product: e, width: width)).toList(),
    );
  }
}
