import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scale_button/scale_button.dart';

import '../utils/b_colors.dart';

class SortDialog extends StatefulWidget {
  final int value;
  const SortDialog({required this.value, super.key});

  @override
  State<SortDialog> createState() => _SortDialogState();
}

class _SortDialogState extends State<SortDialog> {
  late int value = widget.value;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: BColors.primaryPureWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      titlePadding: const EdgeInsets.fromLTRB(25, 10, 10, 0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Эрэмбэлэх',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: BColors.primaryNavyBlack),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: SvgPicture.asset('assets/icons/close.svg'),
          ),
        ],
      ),
      children: [
        Divider(color: BColors.secondarySoftGrey, height: 1, thickness: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    value = 0;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Нэр (A-Z)',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: BColors.primaryNavyBlack),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (value == 0) SvgPicture.asset('assets/icons/check.svg'),
                    ],
                  ),
                ),
              ),
              Divider(color: BColors.secondarySoftGrey, height: 1, thickness: 1),
              InkWell(
                onTap: () {
                  setState(() {
                    value = 1;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Нэр (Z-A)',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: BColors.primaryNavyBlack),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (value == 1) SvgPicture.asset('assets/icons/check.svg'),
                    ],
                  ),
                ),
              ),
              Divider(color: BColors.secondarySoftGrey, height: 1, thickness: 1),
              InkWell(
                onTap: () {
                  setState(() {
                    value = 2;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Үнэ буурахаар',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: BColors.primaryNavyBlack),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (value == 2) SvgPicture.asset('assets/icons/check.svg'),
                    ],
                  ),
                ),
              ),
              Divider(color: BColors.secondarySoftGrey, height: 1, thickness: 1),
              InkWell(
                onTap: () {
                  setState(() {
                    value = 3;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Үнэ өсөхөөр',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: BColors.primaryNavyBlack),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (value == 3) SvgPicture.asset('assets/icons/check.svg'),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ScaleButton(
                      bound: 0.1,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: BColors.primaryNavyBlack,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          'Хаах',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: BColors.primaryNavyBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ScaleButton(
                      bound: 0.1,
                      onTap: () {
                        Navigator.of(context).pop(value);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: BColors.primaryBlueOcean,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          'Харах',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: BColors.primaryPureWhite,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
