import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pororo/controller/product_controller.dart';
import 'package:pororo/models/product.dart';
import 'package:pororo/models/store.dart';
import 'package:pororo/widgets/product_list_widget.dart';
import 'package:pororo/widgets/search_widget.dart';

import '../utils/b_colors.dart';

class SearchScreen extends StatefulWidget {
  final Store? store;
  const SearchScreen({this.store, super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ProductController productController = ProductController();
  final SearchDebounce _searchDebounce = SearchDebounce(milliseconds: 500);

  String value = '';

  List<Product>? products;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() async {
    setState(() {
      products = null;
    });
    products = await productController.searchProducts(value: value, storeId: widget.store?.id);
    setState(() {
      products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset('assets/icons/chevron_back.svg'),
          ),
          title: Text(
            widget.store == null ? "Хайлт" : "Дэлгүүрээс хайх",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: BColors.primaryNavyBlack),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              SearchWidget(
                isSearchScreen: true,
                onChanged: (val) {
                  _searchDebounce.run(() {
                    value = val;
                    _fetchProducts();
                  });
                },
              ),
              const SizedBox(height: 15),
              if (widget.store != null) ...[
                Divider(color: BColors.secondarySoftGrey, height: 1, thickness: 1),
                const SizedBox(height: 15),
                _storeItem(),
                const SizedBox(height: 15),
                Divider(color: BColors.secondarySoftGrey, height: 1, thickness: 1),
              ],
              const SizedBox(height: 15),
              ColoredBox(
                color: BColors.secondaryOffGrey,
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: ProductListWidget(products: products),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _storeItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          SizedBox(
            height: 45,
            child: Row(
              children: [
                ClipOval(
                  child: ExtendedImage.network(
                    widget.store!.avatar ?? 'https://eshop.belike.gr/wp-content/themes/estore/images/placeholder-shop.jpg',
                    height: 45,
                    width: 45,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.store!.title,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: BColors.primaryNavyBlack),
                      ),
                      Row(
                        children: [
                          Text(
                            'Баталгаажсан борлуулагч',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: BColors.primaryNavyBlack),
                          ),
                          const SizedBox(width: 5),
                          SvgPicture.asset('assets/icons/shield.svg'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchDebounce {
  final int milliseconds;

  SearchDebounce({required this.milliseconds});

  Timer? _timer;

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
