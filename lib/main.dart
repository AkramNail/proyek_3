import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:proyek_3/login/login.dart';
import 'package:proyek_3/login/daftar.dart';
import 'package:proyek_3/halaman/home.dart';
import 'package:proyek_3/halaman/profile.dart';
import 'package:proyek_3/mid_test.dart';
import 'package:proyek_3/navbar.dart';
//import 'package:flutter_localization/flutter_localization.dart';


var navBarIndex = 0;

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: const Color.fromARGB(255, 148, 255, 86)),
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
      //supportedLocales: localization.supportedLocales,
      //localizationsDelegates: localization.localizationsDelegates,
      routes: {
        '/main': (context) => MyHomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {

  int navBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            return NavbarUser(); 
            //return PaymentPage(); 
          } else {
            return HalamanLogin();
          }
        },
      ),
    );
  }
}