import 'package:flutter/material.dart';
import 'package:pororo/screen/auth/register_screen.dart';
import 'package:pororo/utils/b_colors.dart';
import 'package:scale_button/scale_button.dart';

import 'auth/login_screen.dart';

class LoginRequiredScreen extends StatelessWidget {
  const LoginRequiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/icons/emoji.png'),
        const SizedBox(height: 10),
        Text(
          'Энэ үйлдлийг хийхийн тулд нэвтрэх шаардлагатай.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: BColors.primaryNavyBlack,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(children: [
            Expanded(
              child: ScaleButton(
                bound: 0.1,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterScreen())),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: BColors.primaryNavyBlack, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    'Бүртгүүлэх',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: BColors.primaryNavyBlack,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: ScaleButton(
                bound: 0.1,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginScreen())),
                child: Container(
                  decoration: BoxDecoration(
                    color: BColors.primaryBlueOcean,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    'Нэвтрэх',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: BColors.primaryPureWhite,
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
