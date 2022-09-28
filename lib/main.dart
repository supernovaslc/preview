import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:voice_chat_app/constants/global_variables.dart';
import 'package:voice_chat_app/features/auth/controller/auth_controller.dart';
import 'package:voice_chat_app/features/auth/screens/auth.dart';
import 'package:voice_chat_app/responsive/mobile_screen_layout.dart';
import 'package:voice_chat_app/responsive/responsive_layout.dart';
import 'package:voice_chat_app/responsive/web_screen_layout.dart';
import 'package:voice_chat_app/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_chat_app/widgets/error.dart';
import 'package:voice_chat_app/widgets/loader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCXId4zPlZZLhYLRhPEhUB-ZKNOXe8lYog",
        projectId: "voice-chat-app-da44b",
        messagingSenderId: "768602854153",
        appId: "1:768602854153:web:3876810fa3477334a479d8",
        measurementId: "G-210EGR0PXN",
        authDomain: "voice-chat-app-da44b.firebaseapp.com",
        storageBucket: "voice-chat-app-da44b.appspot.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        useMaterial3: false,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const AuthScreen();
              }
              return const ResponsiveLayout(
                mobileScreenLayout: MobileLayoutScreen(),
                webScreenLayout: WebScreenLayout(),
              );
            },
            error: (err, trace) {
              return ErrorScreen(
                error: err.toString(),
              );
            },
            loading: () => const Loader(),
          ),
    );
  }
}
