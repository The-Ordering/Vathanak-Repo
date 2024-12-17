import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_hive/services/auth_notifiier.dart';
import 'package:todo_hive/services/todo_notifier.dart';
import 'dart:async';

import 'package:todo_hive/view/login_screen.dart';

class SignupScreen extends StatelessWidget {
  static const String routerName = 'signupScreen';
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authenNotifier = Provider.of<AuthNotifier>(context);
    final todoNotifier = Provider.of<TodoNotifier>(context);
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        child: Image.asset(
                          "assets/images/todo_logo.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "TodoHive",
                        style: TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Column(
                    children: [
                      Text(
                        'Sign Up',
                        style: TextStyle(
                            fontFamily: 'poppins',
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                      "assets/images/profile_image.png",
                    ),
                   backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(height: 10),

                  // Username field
                  TextField(
                    controller: authenNotifier.usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(fontFamily: 'poppins',),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: authenNotifier.emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(fontFamily: 'poppins',),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: authenNotifier.passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(fontFamily: 'poppins',),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: authenNotifier.passwordConfirmController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(fontFamily: 'poppins',),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                      ),
                      onPressed: () async{
                        if(authenNotifier.passwordController.text == authenNotifier.passwordConfirmController.text){
                          todoNotifier.pageChange = OnPageChange.create;
                          authenNotifier.showLoading(context, authenNotifier.signUp(context));
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Error',
                              message: 'Password Not Match!',
                              contentType: ContentType.warning,
                              inMaterialBanner: true,

                            ),
                            duration: Duration(seconds: 2),
                          ));
                        }
                      },
                      child: const Text('Sign up', style: TextStyle(
                          fontFamily: 'poppins',
                          color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white.withOpacity(0.3),
                    ),
                    child: TextButton(onPressed: (){}, child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/google_icon.png',scale: 15,),
                        SizedBox(width: 10,),
                        Text('Sign in with Google', style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'poppins',
                            color: Colors.black))
                      ],
                    )),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? ",style: TextStyle(fontFamily: 'poppins',),),
                      GestureDetector(
                        onTap: () {
                          context.goNamed(LoginScreen.routerName);
                        },
                        child: const Text(
                          'Sign in',
                          style: TextStyle(
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
