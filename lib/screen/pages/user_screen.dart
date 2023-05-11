import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pororo/widgets/alert_dialog.dart';
import 'package:scale_button/scale_button.dart';

import '../../controller/user_controller.dart';
import '../../utils/b_colors.dart';
import '../login_required_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String name = '', address = '';

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: UserController.instance.currentUserData,
      builder: (context, data, child) {
        if (data.isEmpty) return const LoginRequiredScreen();
        name = data['name'];
        address = data['address'];

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              ClipOval(
                child: Image.asset(
                  'assets/images/profile.png',
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${data['email']}',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: BColors.primaryNavyBlack),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Divider(color: BColors.secondarySoftGrey, height: 1, thickness: 1),
              ),
              const SizedBox(height: 20),
              _nameField(),
              const SizedBox(height: 20),
              _addressField(),
              const SizedBox(height: 30),
              _actionButtons(),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }

  Widget _nameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Хэрэглэгчийн нэр',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: BColors.primaryNavyBlack),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: BColors.secondaryOffGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 50,
            child: TextFormField(
              initialValue: name,
              onChanged: (v) {
                name = v;
              },
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Хэрэглэгчийн нэр',
                hintStyle: TextStyle(color: BColors.secondaryHalfGrey, fontSize: 14, fontWeight: FontWeight.w400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Хаяг байршил',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: BColors.primaryNavyBlack),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: BColors.secondaryOffGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 50,
            child: TextFormField(
              initialValue: address,
              onChanged: (v) {
                address = v;
              },
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Хаяг байршилын оруулна уу',
                hintStyle: TextStyle(color: BColors.secondaryHalfGrey, fontSize: 14, fontWeight: FontWeight.w400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(
            child: ScaleButton(
              bound: 0.1,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => CustomAlertDialog(
                    header: 'Хэрэглэгч гарах',
                    title: 'Та гарах гэж байна',
                    text: 'Та энэ үйлдлийг хийснээр системээс гарах болно.',
                    actionTitle: 'Гарах',
                    action: UserController.instance.signOut,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: BColors.secondaryRedVelvet,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  'Гарах',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: BColors.primaryPureWhite,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: ScaleButton(
              bound: 0.1,
              onTap: () {
                if (name == UserController.instance.currentUserData.value['name'] &&
                    address == UserController.instance.currentUserData.value['address']) {
                  return;
                }
                if (name.isEmpty) {
                  EasyLoading.showInfo('Нэрээ оруулна уу');
                  return;
                }
                FocusManager.instance.primaryFocus?.unfocus();
                UserController.instance.updateUserInfo(name: name, address: address);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: BColors.primaryBlueOcean,
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  'Хадгалах',
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
    );
  }
}
