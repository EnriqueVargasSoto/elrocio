import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'pages/login.dart';

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('es'), const Locale('ES')],
      theme: ThemeData(primaryColor: Color.fromRGBO(97, 0, 236, 1)),
      debugShowCheckedModeBanner: false,
      home: LoginPage(), //Scaffold(
      //body: LoginPage(),
      /*)*/
    );
  }
}
