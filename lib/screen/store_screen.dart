import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pororo/controller/product_controller.dart';
import 'package:pororo/models/product.dart';
import 'package:pororo/models/store.dart';
import 'package:pororo/screen/search_screen.dart';
import 'package:pororo/widgets/product_list_widget.dart';
import 'package:pororo/widgets/sort_dialog.dart';
import 'package:scale_button/scale_button.dart';

import '../utils/b_colors.dart';
import '../widgets/cart_button.dart';

class StoreScreen extends StatefulWidget {
  final Store store;
  const StoreScreen({required this.store, super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  ProductController productController = ProductController();
  List<Product>? _products;
  int value = 0;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() async {
    _products = await productController.getStoreProducts(widget.store.id);
    setState(() {
      _products;
    });
  }

  void _sortProducts(int result) {
    value = result;
    switch (value) {
      case 0:
        _products!.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 1:
        _products!.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 2:
        _products!.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 3:
        _products!.sort((a, b) => a.price.compareTo(b.price));
        break;
    }
    setState(() {
      _products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Борлуулагчийн мэдээлэл",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: BColors.primaryNavyBlack),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchScreen(store: widget.store)));
            },
            icon: SvgPicture.asset('assets/icons/search.svg'),
          ),
          const CartButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            _storeItem(),
            const SizedBox(height: 20),
            _address(),
            const SizedBox(height: 20),
            _info(),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Divider(color: BColors.secondarySoftGrey, height: 1, thickness: 1),
            ),
            const SizedBox(height: 15),
            ColoredBox(
              color: BColors.secondaryOffGrey,
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  if (_products != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: ProductListWidget(products: _products!),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            if (_products != null) _sortWidget(),
          ],
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
                    widget.store.avatar ?? 'https://eshop.belike.gr/wp-content/themes/estore/images/placeholder-shop.jpg',
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
                        widget.store.title,
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

  Widget _address() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/pin.svg'),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.store.location ?? 'Мэдээлэл олдсонгүй.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: BColors.primaryNavyBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _info() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 64,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Хүргэлтийн үйлчилгээ',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: BColors.secondaryDarkGrey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.store.hasDelivery ? 'Байгаа' : 'Байхгүй',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: BColors.primaryNavyBlack,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 64,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Бүтээгдэхүүн',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: BColors.secondaryDarkGrey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _products == null ? '---' : '${_products!.length}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: BColors.primaryNavyBlack,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 64,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Нэгдсэн огноо',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: BColors.secondaryDarkGrey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    DateFormat('yyyy-MM-dd').format(widget.store.createdAt.toDate()),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: BColors.primaryNavyBlack,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sortWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
      child: ScaleButton(
        onTap: () async {
          int? result = await showDialog(
            context: context,
            builder: (context) => SortDialog(value: value),
          );

          if (result == null || result == value) {
            return;
          }

          _sortProducts(result);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: BColors.primaryNavyBlack,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 50,
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(
            'Эрэмбэлэх',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: BColors.primaryNavyBlack),
          ),
        ),
      ),
    );
  }
}
