import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pororo/controller/user_controller.dart';
import 'package:pororo/screen/auth/forget_screen.dart';
import 'package:pororo/screen/auth/register_screen.dart';
import 'package:pororo/utils/b_colors.dart';
import 'package:scale_button/scale_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '', password = '';
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
                  'Пороро хүүхдийн платформ',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: BColors.primaryNavyBlack,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Эргэн тавтай морил ',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: BColors.secondaryDarkGrey,
                  ),
                ),
                const SizedBox(height: 50),
                _emailField(),
                const SizedBox(height: 30),
                _passwordField(),
              ],
            ),
            _loginButton(),
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
      ],
    );
  }

  Widget _loginButton() {
    return ScaleButton(
      bound: 0.1,
      onTap: () {
        if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
          EasyLoading.showInfo('Цахим хаягаа зөв оруулна уу!', dismissOnTap: true);
          return;
        }
        if (password.isEmpty) {
          EasyLoading.showInfo('Нууц үгээ оруулна уу!', dismissOnTap: true);
          return;
        }
        UserController.instance.loginUser(email: email, password: password).then((value) {
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
          'Нэвтрэх',
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ForgetScreen())),
          child: Text(
            'Нууц үгээ мартсан',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: BColors.primaryNavyBlack),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const RegisterScreen()));
          },
          child: Text(
            'Бүртгүүлэх',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: BColors.primaryBlueOcean),
          ),
        ),
      ],
    );
  }
}
