import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_hive/services/auth_notifiier.dart';
import 'package:todo_hive/services/todo_notifier.dart';
import 'package:todo_hive/view/edit_todo_page.dart';
import 'package:todo_hive/view/home_page.dart';
import 'package:todo_hive/view/login_screen.dart';
import 'package:todo_hive/view/profile_page.dart';
import 'package:todo_hive/view/signup_screen.dart';
import 'package:todo_hive/view/welcome_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Supabase.initialize(
      url: 'https://jpvhhaphzdzhiklxwbpr.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpwdmhoYXBoemR6aGlrbHh3YnByIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQzNDU4ODUsImV4cCI6MjA0OTkyMTg4NX0.fvq2p_dLIIh0D0QZpw-DxMqVktKzzpQRlxDCjdmo-c0');

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context)=>TodoNotifier()),
    ChangeNotifierProvider(create: (context)=>AuthNotifier()),
  ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
    initialLocation: '/welcome',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        name: WelcomeScreen.routerName,
        path: '/welcome',
        builder: (context,state) => const WelcomeScreen(),
        routes: [
          GoRoute(
            name: LoginScreen.routerName,
            path: '/login',
            builder: (context,state) => const LoginScreen(),
          ),
          GoRoute(
            name: SignupScreen.routerName,
            path: '/signup',
            builder: (context,state) => const SignupScreen(),
          ),
          GoRoute(
            name: HomeScreen.routerName,
            path: '/home',
            builder: (context,state) => const HomeScreen(),
            routes: [
              GoRoute(
                name: ProfilePage.routerName,
                path: '/profile',
                builder: (context,state) => const ProfilePage(),),
              GoRoute(
                name: EditTaskScreen.routerName,
                path: '/edit',
                builder: (context,state) => const EditTaskScreen(),),
            ],
          ),
        ],
      ),
]);


