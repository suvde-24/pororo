import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pororo/controller/user_controller.dart';

import '../utils/b_colors.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
          "Сагс",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: BColors.primaryNavyBlack),
        ),
      ),
      body: SizedBox(
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
            const SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable: UserController.instance.cartItems,
              builder: (context, data, child) {
                if (data.isEmpty) return const Offstage();

                return Text('${data.length} бараа сагсалсан байна');
              },
            ),
          ],
        ),
      ),
    );
  }
}
