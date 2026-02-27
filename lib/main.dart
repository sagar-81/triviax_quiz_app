import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:triviax/core/theme/theme.dart';
import 'features/quiz/view/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: TriviaXApp()));
}

class TriviaXApp extends StatelessWidget {
  const TriviaXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
