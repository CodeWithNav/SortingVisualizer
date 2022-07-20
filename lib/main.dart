import 'package:algo/ui/pages/sorting_page.dart';
import 'package:flutter/material.dart';

main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
          primary: Color(0xff003865),
          onPrimary: Color(0xff3CCF4E),
          onSecondary: Color(0xff003865),
          secondary: Color(0xff3CCF4E),
        )),
        home: const SortingPage());
  }
}
