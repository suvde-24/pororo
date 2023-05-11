import 'package:flutter/material.dart';
import 'package:pororo/widgets/monitize.dart';

class BannerListWidget extends StatelessWidget {
  BannerListWidget({super.key});

  final List<String> banners = ['banner_3', 'banner_1', 'banner_2'];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 50;
    double height = width * 151 / 325;
    return SizedBox(
      height: height + 5,
      child: ListView.separated(
        itemCount: banners.length,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 25),
        separatorBuilder: (context, index) => const SizedBox(width: 15),
        itemBuilder: (context, index) => Monitize(image: banners.elementAt(index)),
      ),
    );
  }
}
