import 'package:flutter/material.dart';
import 'package:pororo/controller/product_controller.dart';
import 'package:pororo/controller/store_controller.dart';
import 'package:pororo/utils/b_colors.dart';
import 'package:pororo/widgets/banner_list_widget.dart';
import 'package:pororo/widgets/best_seller_list_widget.dart';
import 'package:pororo/widgets/category_list_widget.dart';
import 'package:pororo/widgets/discounted_list_widget.dart';
import 'package:pororo/widgets/monitize.dart';
import 'package:pororo/widgets/new_product_list_widget.dart';
import 'package:pororo/widgets/search_widget.dart';
import 'package:pororo/widgets/top_rated_list_widget.dart';

import '../../models/product.dart';
import '../../models/store.dart';
import '../../widgets/special_products_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  final StoreController storeController = StoreController();
  final ProductController productController = ProductController();
  Store? firstStore;
  Product? firstProduct;

  @override
  void initState() {
    super.initState();
    _fetchFirstStore();
    _fetchFirstProduct();
  }

  void _fetchFirstStore() async {
    firstStore = await storeController.getFirstStore();
    setState(() {
      firstStore;
    });
  }

  void _fetchFirstProduct() async {
    firstProduct = await productController.getFirstProduct();
    setState(() {
      firstProduct;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 30),
      children: [
        const SearchWidget(),
        const SizedBox(height: 30),
        BannerListWidget(),
        const SizedBox(height: 30),
        const CategoryListWidget(),
        const SizedBox(height: 15),
        ColoredBox(
          color: BColors.secondaryOffGrey,
          child: Column(
            children: [
              const SizedBox(height: 15),
              const SpecialProductsWidget(),
              const SizedBox(height: 15),
              Monitize(image: 'banner_1', product: firstProduct),
              const SizedBox(height: 15),
              const BestSellerListWidget(),
              const SizedBox(height: 15),
              Monitize(image: 'banner_2', store: firstStore),
              const SizedBox(height: 15),
              const NewProductListWidget(),
              const SizedBox(height: 15),
              const TopRatedListWidget(),
              const SizedBox(height: 15),
              const DiscountedListWidget(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
