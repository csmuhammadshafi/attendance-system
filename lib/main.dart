import 'package:flutter/material.dart';
import 'package:project_app/after_login.dart';
import 'Myscaffold.dart';
import 'admin_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
    home: Myscaffold(
    ),
      initialRoute: '/main',
      routes: {
        '/home': (context) => After_login(),
      },
    );
    
;  }
}

