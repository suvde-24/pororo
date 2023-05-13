import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pororo/controller/user_controller.dart';
import 'package:scale_button/scale_button.dart';

import '../utils/b_colors.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/product_item.dart';
import '../widgets/shimmer_product.dart';
import 'login_required_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    double width = (MediaQuery.of(context).size.width - 63) / 2;

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
          "Сагс",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: BColors.primaryNavyBlack),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: UserController.instance.currentUserData,
        builder: (context, data, child) {
          if (data.isEmpty) return const LoginRequiredScreen();

          return ValueListenableBuilder(
            valueListenable: UserController.instance.cartItems,
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
                        'Сагсалсан бараа бүтээгдэхүүн олдсонгүй.',
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

              return Stack(
                children: [
                  Positioned.fill(
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 13,
                      childAspectRatio: 0.55,
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(25, 25, 25, 100),
                      children: data1.map((e) {
                        return ValueListenableBuilder(
                          valueListenable: e.product,
                          builder: (context, data2, child) {
                            if (data2 == null) return const ShimmerProduct();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    ProductItem(product: data2, width: width),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        onPressed: () => removeFromCarts(e.id),
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
                                ),
                                Container(
                                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: BColors.secondaryHalfGrey))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          if (e.count.value == 1) {
                                            removeFromCarts(e.id);
                                            return;
                                          } else {
                                            e.minus();
                                            await UserController.instance.updateCartItem(e.id, e.count.value);
                                            setState(() {});
                                          }
                                        },
                                        icon: const Text('-', style: TextStyle(fontSize: 16)),
                                      ),
                                      ValueListenableBuilder(
                                        valueListenable: e.count,
                                        builder: (context, count, child) {
                                          return Text(
                                            '$count',
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          if (e.count.value == data2.quantity) {
                                            showDialog(
                                              context: context,
                                              builder: (context) => CustomAlertDialog(
                                                header: 'Анхааруулга',
                                                title: 'Үлдэгдэл хүрэлцэхгүй байна',
                                                text: 'Бараа боломжит үлдэгдэл хүрэлцэхгүй байна.',
                                                actionTitle: 'OK',
                                                action: () {},
                                              ),
                                            );
                                            return;
                                          } else {
                                            e.plus();
                                            await UserController.instance.updateCartItem(e.id, e.count.value);
                                            setState(() {});
                                          }
                                        },
                                        icon: const Text('+', style: TextStyle(fontSize: 16)),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 25,
                    right: 25,
                    child: ScaleButton(
                      bound: 0.1,
                      onTap: () async {
                        final status = await UserController.instance.newOrder();
                        if (status) {
                          EasyLoading.showSuccess('Амжилттай', dismissOnTap: true);
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: BColors.primaryBlueOcean,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          'Захиалга үүсгэх \n${UserController.instance.totalCartPrice}₮',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: BColors.primaryPureWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  void removeFromCarts(String id) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        header: 'Анхааруулга',
        title: 'Та энэ барааг сагснаасаа устгах гэж байна',
        text: 'Энэ үйлдлийг хийснээр энэ бараа сагснаас хасагдах болно.',
        actionTitle: 'Устгах',
        action: () => UserController.instance.removeFromCarts(id),
      ),
    );
  }
}
