import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_hive/services/auth_api.dart';
import 'package:todo_hive/services/todo_notifier.dart';
import 'package:todo_hive/view/edit_todo_page.dart';
import 'package:todo_hive/view/home_page.dart';

class AuthNotifier extends ChangeNotifier{
  final authenApi = AuthApi();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();

  final TextEditingController emailLoginController = TextEditingController();
  final TextEditingController passwordLoginController = TextEditingController();

  final TextEditingController editUsernameCon = TextEditingController();
  final TextEditingController editEmailCon = TextEditingController();
  final TextEditingController editPassCon = TextEditingController();

  String? userName;

  void editUserProfile(){
    editUsernameCon.text = authenApi.getCurrentUsername()!;
    editEmailCon.text = authenApi.getCurrentEmail()!;
  }

  String? getName(){
    userName = authenApi.getCurrentUsername();
    return userName;
  }

  void getEditName(){
    userName = authenApi.getCurrentUsername();
    notifyListeners();
  }

  void logout() async{
    await authenApi.signOut();
  }

  void clearUpdateUser(){
    editUsernameCon.clear();
    editEmailCon.clear();
    editPassCon.clear();
  }

  Future<void> updateUser(BuildContext context) async{
    try{
      await authenApi.updateUser(editUsernameCon.text.trim(), editEmailCon.text.trim(), editPassCon.text.trim());
      final session = Supabase.instance.client.auth.currentSession;
      if(session != null){
        clearUpdateUser();
        getEditName();
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Update User',
            message: 'Update user Success',
            contentType: ContentType.success,
            inMaterialBanner: true,
          ),
          duration: Duration(seconds: 2),
        ));
      }else{
        throw Exception('Failed to retrieve Session');
      }
    }catch(e){
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error Update',
          message: 'Update user Failed!',
          contentType: ContentType.warning,
          inMaterialBanner: true,
        ),
        duration: Duration(seconds: 2),
      ));
    }
  }


  Future<void> signUp(BuildContext context) async{
    try{
      await authenApi.signUp(context, emailController.text.trim(), passwordController.text.trim(), usernameController.text.trim());
      final session = Supabase.instance.client.auth.currentSession;
      if(session != null){
        clearSignIn();
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("todos").get();
        if(querySnapshot.docs.isEmpty){
          context.goNamed(EditTaskScreen.routerName);
        }else{
          context.goNamed(HomeScreen.routerName);
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Welcome!',
            message: 'SignUp Success',
            contentType: ContentType.success,
            inMaterialBanner: true,
          ),
          duration: Duration(seconds: 2),
        ));
      }else{
        throw Exception('Failed to retrieve Session');
      }
    }catch(e){
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error SignUp',
          message: 'Email already in use or Password Weak',
          contentType: ContentType.warning,
          inMaterialBanner: true,
        ),
        duration: Duration(seconds: 2),
      ));
    }
  }

  Future<void> login(BuildContext context) async{
    try{
      await authenApi.login(context, emailLoginController.text.trim(), passwordLoginController.text.trim());
      final session = Supabase.instance.client.auth.currentSession;
      if(session != null){
        clearLogin();
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("todos").get();
        if(querySnapshot.docs.isEmpty){
          context.goNamed(EditTaskScreen.routerName);
        }else{
          context.goNamed(HomeScreen.routerName);
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Welcome Back!',
            message: 'Login Success',
            contentType: ContentType.success,
            inMaterialBanner: true,
          ),
          duration: Duration(seconds: 2),
        ));
      }else{
        throw Exception('Failed To Retrieve Session');
      }
    }catch(e){
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error Login',
          message: 'Incorrect Email or Password',
          contentType: ContentType.warning,
          inMaterialBanner: true,
        ),
        duration: Duration(seconds: 2),
      ));
    }
  }

  void clearSignIn(){
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    passwordConfirmController.clear();
  }

  void clearLogin(){
    emailLoginController.clear();
    passwordLoginController.clear();
  }

  Future<void> showLoading(BuildContext context,Future<void> futureOperation) async{
    showDialog(context: context, builder: (_)=>Center(
      child: CircularProgressIndicator(),
    ));
    try{
      await futureOperation;
    }catch(e){
      log('Error showLoading: $e');
    }
  }
}