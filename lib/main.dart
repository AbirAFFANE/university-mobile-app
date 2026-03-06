import 'package:flutter/material.dart';
import 'package:memoire/firstp.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
    WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ojdywygaynkiqtntfiqv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9qZHl3eWdheW5raXF0bnRmaXF2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ2Mzk4MTMsImV4cCI6MjA2MDIxNTgxM30.bfNy9aeBpQtIubiaQ54i7p8EJPHw6Mw9_4goyAOPDLo', // Replace with your Supabase anon key
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp( home: Firstp(),);
  }
}