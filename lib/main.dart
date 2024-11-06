import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: 'https://ewlgxyfzzjocmpufowkh.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV3bGd4eWZ6empvY21wdWZvd2toIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzA5MDA5OTQsImV4cCI6MjA0NjQ3Njk5NH0.QRrio0Lmu-0Q-9r_KmtlB7aXI7aue0kFkmba5RkuI4U');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Library',
      home: BookListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}