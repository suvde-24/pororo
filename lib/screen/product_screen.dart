import 'package:card_swiper/card_swiper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pororo/controller/store_controller.dart';
import 'package:pororo/controller/user_controller.dart';
import 'package:pororo/models/cart.dart';
import 'package:pororo/models/favorite.dart';
import 'package:pororo/models/product.dart';
import 'package:pororo/models/store.dart';
import 'package:pororo/screen/store_screen.dart';
import 'package:pororo/widgets/cart_button.dart';
import 'package:pororo/widgets/special_products_widget.dart';
import 'package:scale_button/scale_button.dart';

import '../utils/b_colors.dart';

class ProductScreen extends StatefulWidget {
  final Product product;
  const ProductScreen({required this.product, super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  StoreController storeController = StoreController();
  Store? _store;

  @override
  void initState() {
    super.initState();
    _fetchStore();
  }

  void _fetchStore() async {
    _store = await storeController.getStore(widget.product.storeId);
    setState(() {
      _store;
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
          "Бүтээгдэхүүн",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: BColors.primaryNavyBlack),
        ),
        actions: const [
          CartButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            _productImages(),
            const SizedBox(height: 30),
            _titleWidget(),
            const SizedBox(height: 30),
            _storeItem(),
            const SizedBox(height: 30),
            _productDetail(),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Divider(color: BColors.secondarySoftGrey, height: 1, thickness: 1),
            ),
            const SizedBox(height: 18),
            ColoredBox(
              color: BColors.secondaryOffGrey,
              child: const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 20),
                child: SpecialProductsWidget(),
              ),
            ),
            const SizedBox(height: 16),
            _actionButtons(),
            const SizedBox(height: 21),
          ],
        ),
      ),
    );
  }

  Widget _productImages() {
    double size = MediaQuery.of(context).size.width - 50;
    List<String> images = widget.product.image;

    return Container(
      decoration: BoxDecoration(
        color: BColors.secondaryOffGrey,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            offset: const Offset(0, 1),
            color: BColors.secondaryHalfGrey,
          ),
        ],
      ),
      height: size,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(10),
      child: Swiper(
        itemCount: images.length,
        autoplay: false,
        indicatorLayout: PageIndicatorLayout.SCALE,
        pagination: DotSwiperPaginationBuilder(
          activeColor: BColors.primaryBlueOcean,
          color: BColors.secondaryDarkGrey,
        ),
        itemBuilder: (context, index) {
          return ExtendedImage.network(
            images.elementAt(index),
            fit: BoxFit.contain,
          );
        },
      ),
    );
  }

  Widget _titleWidget() {
    bool isDiscounted = (widget.product.discount ?? 0) != 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: BColors.primaryNavyBlack),
          ),
          const SizedBox(height: 5),
          Text(
            'MNT. ${widget.product.price - (widget.product.discount ?? 0)}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: BColors.secondaryRedVelvet),
          ),
          Row(
            children: [
              if (isDiscounted)
                Expanded(
                  child: Text(
                    'MNT. ${widget.product.price}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: BColors.secondaryHalfGrey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                )
              else
                const Expanded(child: Offstage()),
              const SizedBox(width: 30),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: BColors.labelOffGreen,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Text(
                  'Үлдэгдэл: ${widget.product.quantity}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: BColors.secondaryEarthGreen),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _storeItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          Divider(color: BColors.secondarySoftGrey, height: 1, thickness: 1),
          const SizedBox(height: 20),
          if (_store != null)
            SizedBox(
              height: 45,
              child: Row(
                children: [
                  ClipOval(
                    child: ExtendedImage.network(
                      _store!.avatar ?? 'https://eshop.belike.gr/wp-content/themes/estore/images/placeholder-shop.jpg',
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
                          _store!.title,
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
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => StoreScreen(store: _store!)));
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/chevron_right.svg',
                      colorFilter: ColorFilter.mode(BColors.secondaryDarkGrey, BlendMode.srcIn),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          Divider(color: BColors.secondarySoftGrey, height: 1, thickness: 1),
        ],
      ),
    );
  }

  Widget _productDetail() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Бүтээгдэхүүний дэлгэрэнгүй',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: BColors.primaryNavyBlack,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '- ${widget.product.description ?? 'Мэдээлэл олдсонгүй'}',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: BColors.primaryNavyBlack),
          ),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: UserController.instance.favoriteItems,
                builder: (context, data, child) {
                  Favorite? favorite;
                  bool inFavorite = data.any((e) => e.productId == widget.product.id);
                  if (inFavorite) favorite = data.firstWhere((e) => e.productId == widget.product.id);

                  return ScaleButton(
                    bound: 0.1,
                    onTap: () async {
                      bool status;
                      if (inFavorite) {
                        status = await UserController.instance.removeFromFavorites(favorite!.id);
                      } else {
                        status = await UserController.instance.addToFavorites(widget.product.id);
                      }
                      if (status && mounted) {
                        setState(() {
                          UserController.instance.favoriteItems.value;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: inFavorite ? BColors.primaryPureWhite : BColors.secondaryRedVelvet,
                        border: Border.all(width: 1, color: BColors.secondaryRedVelvet),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 50,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            inFavorite ? 'Хадгалсан' : 'Хадгалах',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: inFavorite ? BColors.secondaryRedVelvet : BColors.primaryPureWhite,
                            ),
                          ),
                          const SizedBox(width: 5),
                          SvgPicture.asset(
                            'assets/icons/heart${inFavorite ? '_filled' : ''}.svg',
                            colorFilter: ColorFilter.mode(inFavorite ? BColors.secondaryRedVelvet : BColors.primaryPureWhite, BlendMode.srcIn),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: UserController.instance.cartItems,
                builder: (context, data, child) {
                  Cart? cart;
                  bool inCart = data.any((e) => e.productId == widget.product.id);
                  if (inCart) cart = data.firstWhere((e) => e.productId == widget.product.id);

                  return ScaleButton(
                    bound: 0.1,
                    onTap: () async {
                      bool status;
                      if (inCart) {
                        status = await UserController.instance.removeFromCarts(cart!.id);
                      } else {
                        status = await UserController.instance.addToCarts(widget.product.id);
                      }
                      if (status && mounted) {
                        setState(() {
                          UserController.instance.cartItems.value;
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: inCart ? BColors.primaryPureWhite : BColors.primaryBlueOcean,
                        border: Border.all(width: 1, color: BColors.primaryBlueOcean),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(
                        inCart ? 'Сагснаас хасах' : 'Сагсанд нэмэх',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: inCart ? BColors.primaryBlueOcean : BColors.primaryPureWhite,
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
