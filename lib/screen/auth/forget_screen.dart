import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pororo/controller/user_controller.dart';
import 'package:scale_button/scale_button.dart';

import '../../utils/b_colors.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({super.key});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
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
          children: [
            Text(
              'Нууц үгээ сэргээх',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: BColors.primaryNavyBlack,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Нууц үгээ сэргээхийн тулд цахим шуудангаа оруулна уу',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: BColors.secondaryDarkGrey,
              ),
            ),
            const SizedBox(height: 50),
            _emailField(),
            const SizedBox(height: 60),
            _button(),
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

        UserController.instance.resetPassword(email: email).then((value) {
          if (value) Navigator.of(context).pop();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: BColors.primaryBlueOcean,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 50,
        alignment: Alignment.center,
        child: Text(
          'Сэргээх',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: BColors.primaryPureWhite,
          ),
        ),
      ),
    );
  }
}
