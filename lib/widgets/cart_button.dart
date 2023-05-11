import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pororo/controller/user_controller.dart';
import 'package:pororo/screen/cart_screen.dart';
import 'package:pororo/utils/b_colors.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder(
        valueListenable: UserController.instance.cartItems,
        builder: (context, value, child) {
          return IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CartScreen()));
            },
            icon: Stack(
              children: [
                SvgPicture.asset('assets/icons/cart.svg'),
                if (value.isNotEmpty)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: BColors.secondaryRedVelvet,
                      ),
                      height: 9,
                      width: 9,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
