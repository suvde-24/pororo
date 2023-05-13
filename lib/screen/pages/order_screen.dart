import 'package:flutter/material.dart';
import 'package:pororo/models/order.dart';
import 'package:pororo/widgets/order_widget.dart';

import '../../controller/user_controller.dart';
import '../../utils/b_colors.dart';
import '../login_required_screen.dart';

class OrderScreen extends StatelessWidget {
  OrderScreen({super.key});

  final ValueNotifier<List<OrderStatus>> filterStatus = ValueNotifier(OrderStatus.values);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: UserController.instance.currentUserData,
      builder: (context, data, child) {
        if (data.isEmpty) return const LoginRequiredScreen();

        return ValueListenableBuilder(
          valueListenable: UserController.instance.userOrders,
          builder: (context, data1, child) {
            return Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: OrderStatus.values.map((e) {
                    Color color;
                    switch (e) {
                      case OrderStatus.pending:
                        color = BColors.primaryOrangeFresh;
                        break;
                      case OrderStatus.canceled:
                        color = BColors.secondaryRedVelvet;
                        break;
                      case OrderStatus.completed:
                        color = BColors.secondaryEarthGreen;
                        break;
                      case OrderStatus.paid:
                        color = BColors.primaryBlueOcean;
                        break;
                      case OrderStatus.shipping:
                        color = Colors.purple;
                        break;
                    }
                    return Expanded(
                      child: IconButton(
                        onPressed: () {
                          if (filterStatus.value.contains(e)) {
                            filterStatus.value = filterStatus.value.where((el) => e != el).toList();
                          } else {
                            filterStatus.value = [...filterStatus.value, e];
                          }
                        },
                        icon: ValueListenableBuilder(
                          valueListenable: filterStatus,
                          builder: (context, filter, child) {
                            return Container(
                              decoration: BoxDecoration(
                                color: filter.contains(e) ? color : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: color, width: 2),
                              ),
                              height: 20,
                              width: 20,
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: filterStatus,
                    builder: (context, filter, child) {
                      List<Order> orders = data1.where((e) => filter.contains(e.status)).toList();

                      if (orders.isEmpty) {
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
                                'Захиалгын мэдээлэл олдсонгүй.',
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

                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: orders.length,
                        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                        itemBuilder: (context, index) {
                          return OrderWidget(order: orders.elementAt(index));
                        },
                        separatorBuilder: (context, index) => Divider(color: BColors.secondarySoftGrey, height: 30, thickness: 1),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
