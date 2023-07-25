import 'package:business_card/screens/auth.dart';
import 'package:business_card/screens/cards_screen.dart';
import 'package:business_card/screens/loading_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromRGBO(102, 255, 178, 0.7),
          titleTextStyle: GoogleFonts.quicksand(
              fontSize: 26, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        textTheme: TextTheme(
            titleLarge: GoogleFonts.quicksand(
              fontSize: 15,
              color: Colors.black,
            ),
            bodyLarge:
                GoogleFonts.quicksand(fontSize: 15, color: Colors.black)),
        primaryColor: const Color.fromRGBO(102, 255, 178, 0.7),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(153, 255, 204, 0.6),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          if (snapshot.hasData) {
            return const CardScreen();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}
