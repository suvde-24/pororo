import 'package:flutter/material.dart';
import 'package:pororo/utils/b_colors.dart';

class SeeAllTitle extends StatelessWidget {
  final String title;
  final Function() onTap;
  const SeeAllTitle({required this.title, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 25),
        Expanded(
          child: Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: BColors.primaryNavyBlack),
          ),
        ),
        const SizedBox(width: 25),
        InkWell(
          onTap: onTap,
          child: Text(
            'See All',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: BColors.primaryBlueOcean),
          ),
        ),
        const SizedBox(width: 25),
      ],
    );
  }
}
