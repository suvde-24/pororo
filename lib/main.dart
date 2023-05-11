import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pororo/controller/database.dart';
import 'package:pororo/controller/user_controller.dart';
import 'package:pororo/screen/main_screen.dart';
import 'package:pororo/utils/b_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Database.initDatabase();
  UserController.instance.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'DMSans',
        primaryColor: BColors.primaryBlueOcean,
        scaffoldBackgroundColor: BColors.primaryPureWhite,
        appBarTheme: AppBarTheme(backgroundColor: BColors.primaryPureWhite),
      ),
      home: const MainScreen(),
      builder: EasyLoading.init(),
    );
  }
}
