import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pororo/controller/user_controller.dart';
import 'package:pororo/screen/login_required_screen.dart';
import 'package:pororo/widgets/product_item.dart';
import 'package:pororo/widgets/shimmer_product.dart';

import '../../utils/b_colors.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 63) / 2;

    return ValueListenableBuilder(
      valueListenable: UserController.instance.currentUserData,
      builder: (context, data, child) {
        if (data.isEmpty) return const LoginRequiredScreen();

        return ValueListenableBuilder(
          valueListenable: UserController.instance.favoriteItems,
          builder: (context, data1, child) {
            if (data1.isEmpty) {
              return SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    Image.asset('assets/icons/emoji.png'),
                    const SizedBox(height: 10),
                    Text(
                      'Хадгалсан бараа бүтээгдэхүүн олдсонгүй.',
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
              padding: const EdgeInsets.all(25),
              children: data1.map((e) {
                return ValueListenableBuilder(
                  valueListenable: e.product,
                  builder: (context, data2, child) {
                    if (data2 == null) return const ShimmerProduct();

                    return Stack(
                      children: [
                        ProductItem(product: data2, width: width),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            onPressed: () => UserController.instance.removeFromFavorites(e.id),
                            visualDensity: VisualDensity.compact,
                            icon: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: BColors.secondaryRedVelvet,
                              ),
                              padding: const EdgeInsets.all(5),
                              child: SvgPicture.asset(
                                'assets/icons/close.svg',
                                colorFilter: ColorFilter.mode(BColors.primaryPureWhite, BlendMode.srcIn),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}
