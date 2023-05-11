import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pororo/screen/auth/login_screen.dart';
import 'package:pororo/screen/auth/register_call_screen.dart';
import 'package:scale_button/scale_button.dart';

import '../../utils/b_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: Icon(
            Icons.chevron_left_rounded,
            color: BColors.primaryNavyBlack,
          ),
        ),
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 72, 25, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Бүртгүүлэх',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: BColors.primaryNavyBlack,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Шинэ хэрэглэгч болох гэж байгаад баярлалаа',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: BColors.secondaryDarkGrey,
                  ),
                ),
                const SizedBox(height: 50),
                _emailField(),
                const SizedBox(height: 80),
              ],
            ),
            _button(),
            _switch(),
          ],
        ),
      ),
    );
  }

  Widget _emailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Цахим шуудан',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: BColors.primaryNavyBlack),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: BColors.secondaryOffGrey,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 50,
          child: TextField(
            onChanged: (v) {
              if (mounted) {
                setState(() {
                  email = v;
                });
              }
            },
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Цахим шуудангаа оруулна уу',
              hintStyle: TextStyle(color: BColors.secondaryHalfGrey, fontSize: 14, fontWeight: FontWeight.w400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _button() {
    return ScaleButton(
      bound: 0.1,
      onTap: () {
        if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
          EasyLoading.showInfo('Цахим хаягаа зөв оруулна уу!', dismissOnTap: true);
          return;
        }
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterCallScreen(email: email)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: BColors.primaryBlueOcean,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 50,
        alignment: Alignment.center,
        child: Text(
          'Үргэлжлүүлэх',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: BColors.primaryPureWhite,
          ),
        ),
      ),
    );
  }

  Widget _switch() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Бүртгэлтэй хэрэглэгч? ',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: BColors.secondaryDarkGrey),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
          },
          child: Text(
            'Нэвтрэх',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: BColors.primaryBlueOcean),
          ),
        ),
      ],
    );
  }
}
