import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/item_screen.dart';
import 'viewmodels/item_viewmodel.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => QuotationViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quotation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const QuotationScreen(),
    );
  }
}
