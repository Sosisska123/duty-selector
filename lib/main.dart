import 'package:flutter/material.dart';

import 'package:duty_selector/design.dart';
import 'package:duty_selector/features/presentation/screens/main.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const DutySelectorApp());
}

class DutySelectorApp extends StatelessWidget {
  const DutySelectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Duty Selector',
      theme: getTheme(),
      darkTheme: getTheme(),
      home: MainScreen(),
      supportedLocales: [const Locale('ru', 'RU'), const Locale('en', 'EN')],
      locale: const Locale('ru'),
      localizationsDelegates: [
        GlobalMaterialLocalizations
            .delegate, // Provides Russian for Material widgets
        GlobalCupertinoLocalizations
            .delegate, // Provides Russian for Cupertino widgets
        GlobalWidgetsLocalizations.delegate, // General text direction handling
      ],
    );
  }
}
