import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_hive/main.dart';
import 'package:todo_hive/view/home_page.dart';
import 'package:todo_hive/view/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const String routerName = 'welcomeScreen';
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: AnimatedContainer(
          duration: const Duration(seconds: 3),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFEE9B00), Color(0xFFC8B6FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          constraints: const BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    margin: const EdgeInsets.only(right: 10),
                    child: Image.asset(
                      "assets/images/todo_logo.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Text(
                    'TodoHive',
                    style: TextStyle(
                      fontFamily: 'poppins',
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Innovative, user-friendly,',
                    style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 18, color: Colors.black54),
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    " and easy.",
                    style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 18, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                      color: Colors.white.withOpacity(0.15),
                    ),
                    child: TextButton(
                      onPressed: () => context.goNamed(LoginScreen.routerName),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Get started', style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'poppins',
                              fontSize: 13)),
                          SizedBox(width: 8,),
                          Icon(Icons.arrow_forward,color: Colors.black,size: 15,),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
