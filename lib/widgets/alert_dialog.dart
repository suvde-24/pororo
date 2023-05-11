import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scale_button/scale_button.dart';

import '../utils/b_colors.dart';

class CustomAlertDialog extends StatefulWidget {
  final String header;
  final String title;
  final String text;
  final String actionTitle;
  final Function() action;
  const CustomAlertDialog({
    required this.header,
    required this.title,
    required this.text,
    required this.actionTitle,
    required this.action,
    super.key,
  });

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
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
            widget.header,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset('assets/icons/emoji.png'),
              const SizedBox(height: 10),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: BColors.primaryNavyBlack),
              ),
              const SizedBox(height: 20),
              Text(
                widget.text,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: BColors.secondaryDarkGrey),
              ),
              const SizedBox(height: 30),
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
                        Navigator.of(context).pop();
                        widget.action();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: BColors.primaryBlueOcean,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          widget.actionTitle,
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
