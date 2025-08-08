import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snpos/app/data/providers/db_helper.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final box = GetStorage();
  final token = box.read('token');

  final isLoggedIn = token != null && token.toString().isNotEmpty;
  final initialRoute = isLoggedIn ? Routes.MAIN_NAV : Routes.LOGIN;

  runApp(
    GetMaterialApp(
      title: "Application",
      theme: ThemeData(
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
        scaffoldBackgroundColor: Color(0xffF2F4F7),
        appBarTheme: AppBarTheme(
          color: Color(0xffF2F4F7)
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF4D81F1),
          primary: Color(0xFF4D81F1),
          secondary: Colors.orange,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          )
        ),
      ),

      initialRoute: initialRoute,
      getPages: AppPages.routes,
    ),
  );
}
