import 'package:flutter/material.dart';

import '../../controller/user_controller.dart';
import '../../utils/b_colors.dart';
import '../login_required_screen.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: UserController.instance.currentUserData,
      builder: (context, data, child) {
        if (data.isEmpty) return const LoginRequiredScreen();

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
      },
    );
  }
}
