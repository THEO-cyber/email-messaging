import 'package:email_service/presentation/email_home.dart';
import 'package:email_service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'presentation/email_home.dart';
import 'theme/theme.dart';

void main() {
  runApp(const EmailApp());
}

class EmailApp extends StatelessWidget {
  const EmailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HIMS Email App',
      theme: AppTheme.themeData,
      home: const EmailHome(),
    );
  }
}
