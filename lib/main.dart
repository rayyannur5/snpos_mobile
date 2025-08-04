import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snpos/app/data/providers/db_helper.dart';

import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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

      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
