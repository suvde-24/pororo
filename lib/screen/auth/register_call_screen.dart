import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pororo/controller/user_controller.dart';
import 'package:pororo/screen/auth/login_screen.dart';
import 'package:scale_button/scale_button.dart';

import '../../utils/b_colors.dart';

class RegisterCallScreen extends StatefulWidget {
  final String email;
  const RegisterCallScreen({required this.email, super.key});

  @override
  State<RegisterCallScreen> createState() => _RegisterCallScreenState();
}

class _RegisterCallScreenState extends State<RegisterCallScreen> {
  String name = '', password = '';
  bool passwordHidden = true;

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
                  'Бүртгэл, нууц үг',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: BColors.primaryNavyBlack,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Пороро платформд бүртгүүлэхийн тулд дараах өгөгдлийг бөглөнө үү',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: BColors.secondaryDarkGrey,
                  ),
                ),
                const SizedBox(height: 50),
                _nameField(),
                const SizedBox(height: 30),
                _passwordField(),
              ],
            ),
            _button(),
          ],
        ),
      ),
    );
  }

  Widget _nameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Овог нэр',
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
                  name = v;
                });
              }
            },
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Овог нэрээ оруулна уу',
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

  Widget _passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Нууц үг',
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
            obscureText: passwordHidden,
            onChanged: (v) {
              if (mounted) {
                setState(() {
                  password = v;
                });
              }
            },
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Нууц үгээ оруулна уу',
              hintStyle: TextStyle(color: BColors.secondaryHalfGrey, fontSize: 14, fontWeight: FontWeight.w400),
              suffixIcon: IconButton(
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      passwordHidden = !passwordHidden;
                    });
                  }
                },
                icon: Icon(
                  passwordHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: BColors.primaryNavyBlack,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (password.length < 8)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset('assets/icons/info.svg', height: 14, width: 14),
              const SizedBox(width: 10),
              Text(
                'Нууц үг 8 тэмдэгтээс дээш байх ёстой',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: BColors.secondaryDarkGrey),
              ),
            ],
          ),
      ],
    );
  }

  Widget _button() {
    return ScaleButton(
      bound: 0.1,
      onTap: () {
        if (name.isEmpty) {
          EasyLoading.showInfo('Шаардлагтай талбарыг бөглөнө үү!', dismissOnTap: true);
          return;
        }
        if (password.length < 8) {
          EasyLoading.showInfo('Нууц үг шаардлага хангахгүй байна!', dismissOnTap: true);
          return;
        }

        UserController.instance.registerUser(email: widget.email, password: password, name: name).then((value) {
          if (value) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
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
          'Баталгаажуулах',
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
