
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthApi{
  final SupabaseClient supabaseClient = Supabase.instance.client;

  Future<UserResponse> updateUser(String username,String email,String password) async{
    return await supabaseClient.auth.updateUser(UserAttributes(
      data: {'display_name' : username},
      email:  email,
      password:  password,
    ));
  }

  Future<AuthResponse> signUp(BuildContext context,String email,String password,String username) async{
    return await supabaseClient.auth.signUp(
      email: email,
      password: password,
      data: {'display_name': username},
    );
  }

  Future<AuthResponse> login(BuildContext context,String email,String password) async{
    return await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password);
  }

  Future<void> signOut() async{
    await supabaseClient.auth.signOut();
  }

  String? getCurrentUsername(){
    final session = supabaseClient.auth.currentSession;
    final user  = session?.user;
    return user?.userMetadata?['display_name'];
  }

  String? getCurrentEmail(){
    final session = supabaseClient.auth.currentSession;
    final user  = session?.user;
    return user?.email;
  }
}