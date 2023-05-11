import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pororo/utils/b_colors.dart';

import '../screen/search_screen.dart';

class SearchWidget extends StatelessWidget {
  final bool isSearchScreen;
  final Function(String)? onChanged;
  const SearchWidget({this.isSearchScreen = false, this.onChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BColors.secondaryOffGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        onTap: () {
          if (!isSearchScreen) Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SearchScreen()));
        },
        onChanged: onChanged,
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Бараа бүтээгдэхүүн хайх',
          hintStyle: TextStyle(color: BColors.secondaryHalfGrey, fontSize: 14, fontWeight: FontWeight.w400),
          suffixIcon: IconButton(onPressed: () {}, icon: SvgPicture.asset('assets/icons/search.svg')),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
