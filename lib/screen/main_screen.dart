import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pororo/screen/pages/favorite_screen.dart';
import 'package:pororo/screen/pages/home_screen.dart';
import 'package:pororo/screen/pages/order_screen.dart';
import 'package:pororo/screen/pages/user_screen.dart';
import 'package:pororo/utils/b_colors.dart';
import 'package:pororo/widgets/cart_button.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  void onPageChanged(int page) {
    if (mounted) {
      setState(() {
        _currentPage = page;
      });
    }
    _pageController.animateToPage(_currentPage, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "Пороро",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: BColors.primaryBlueOcean),
        ),
        actions: const [
          // IconButton(onPressed: () {}, icon: SvgPicture.asset('assets/icons/bell.svg')),
          CartButton(),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomeScreen(),
          FavoriteScreen(),
          OrderScreen(),
          UserScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: BColors.primaryPureWhite,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentPage,
        items: _bottomNavBarItems(),
        onTap: onPageChanged,
        enableFeedback: true,
        selectedFontSize: 11,
        unselectedFontSize: 10,
        selectedItemColor: BColors.primaryBlueOcean,
        unselectedItemColor: BColors.primaryNavyBlack,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  List<BottomNavigationBarItem> _bottomNavBarItems() => [
        BottomNavigationBarItem(
          label: 'НҮҮР',
          icon: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SvgPicture.asset(
              'assets/icons/home.svg',
              height: 20,
              width: 20,
              colorFilter: ColorFilter.mode(_currentPage == 0 ? BColors.primaryBlueOcean : BColors.primaryNavyBlack, BlendMode.srcIn),
            ),
          ),
        ),
        BottomNavigationBarItem(
          label: 'ХАДГАЛСАН',
          icon: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SvgPicture.asset(
              'assets/icons/heart.svg',
              height: 20,
              width: 20,
              colorFilter: ColorFilter.mode(_currentPage == 1 ? BColors.primaryBlueOcean : BColors.primaryNavyBlack, BlendMode.srcIn),
            ),
          ),
        ),
        BottomNavigationBarItem(
          label: 'ЗАХИАЛГА',
          icon: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SvgPicture.asset(
              'assets/icons/bag.svg',
              height: 20,
              width: 20,
              colorFilter: ColorFilter.mode(_currentPage == 2 ? BColors.primaryBlueOcean : BColors.primaryNavyBlack, BlendMode.srcIn),
            ),
          ),
        ),
        BottomNavigationBarItem(
          label: 'ХЭРЭГЛЭГЧ',
          icon: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SvgPicture.asset(
              'assets/icons/profile.svg',
              height: 20,
              width: 20,
              colorFilter: ColorFilter.mode(_currentPage == 3 ? BColors.primaryBlueOcean : BColors.primaryNavyBlack, BlendMode.srcIn),
            ),
          ),
        ),
      ];
}
