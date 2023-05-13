import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pororo/controller/user_controller.dart';
import 'package:pororo/utils/b_colors.dart';
import 'package:scale_button/scale_button.dart';

import '../models/order.dart';
import 'alert_dialog.dart';
import 'product_item.dart';
import 'shimmer_product.dart';

class OrderWidget extends StatefulWidget {
  final Order order;
  const OrderWidget({required this.order, super.key});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  @override
  Widget build(BuildContext context) {
    Color color;
    String status;

    switch (widget.order.status) {
      case OrderStatus.paid:
        color = BColors.primaryBlueOcean;
        status = 'Төлбөр төлөгдсөн';
        break;
      case OrderStatus.shipping:
        color = BColors.primaryNavyBlack;
        status = 'Хүргэлтэнд гарсан';
        break;
      case OrderStatus.completed:
        color = BColors.secondaryEarthGreen;
        status = 'Захиалга амжилттай дууссан';
        break;
      case OrderStatus.canceled:
        color = BColors.secondaryRedVelvet;
        status = 'Захиалга цуцлагдсан';
        break;
      case OrderStatus.pending:
        color = BColors.primaryOrangeFresh;
        status = 'Төлбөр хүлээгдэж байна';
        break;
    }
    return InkWell(
      onTap: () => showOrderDetailDialog(color, status),
      child: Container(
        decoration: BoxDecoration(
          color: BColors.primaryPureWhite,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              offset: const Offset(0, 1),
              color: BColors.secondaryHalfGrey,
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Захиалгын төлөв:  ',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    status,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.w600, color: color),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Захиалгын дүн:  ',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${widget.order.totalPayment}₮',
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Нийт захиалсан бараа:  ',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${widget.order.orderItems.length}',
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showOrderDetailDialog(Color color, String status) async {
    double width = (MediaQuery.of(context).size.width - 63) / 2;

    await showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
          child: Material(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                        color: BColors.secondaryHalfGrey,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Text(
                          'Захиалгын төлөв:  ',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: Text(
                          status,
                          textAlign: TextAlign.start,
                          style: TextStyle(fontWeight: FontWeight.w600, color: color),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        icon: SvgPicture.asset(
                          'assets/icons/close.svg',
                          colorFilter: ColorFilter.mode(BColors.primaryNavyBlack, BlendMode.srcIn),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 13,
                          childAspectRatio: 0.6,
                          physics: const ClampingScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(25, 25, 25, widget.order.status == OrderStatus.pending ? 100 : 25),
                          children: widget.order.orderItems.map((e) {
                            return ValueListenableBuilder(
                              valueListenable: e.product,
                              builder: (context, data2, child) {
                                if (data2 == null) return const ShimmerProduct();

                                return ProductItem(product: data2, width: width);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      if (widget.order.status == OrderStatus.pending)
                        Positioned(
                          bottom: 20,
                          left: 25,
                          right: 25,
                          child: ScaleButton(
                            bound: 0.1,
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (context) => CustomAlertDialog(
                                  header: 'Анхааруулга',
                                  title: 'Та захиалгаа цуцлах гэж байна',
                                  text: 'Анхаар та захиалгаа цуцлах гэж байна.',
                                  actionTitle: 'Цуцлах',
                                  action: () async => await UserController.instance.cancelOrder(widget.order.id, widget.order.transactionId!),
                                ),
                              );

                              Navigator.of(context).pop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: BColors.secondaryRedVelvet,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 50,
                              alignment: Alignment.center,
                              child: Text(
                                'Захиалга цуцлах',
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
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    setState(() {});
  }
}
