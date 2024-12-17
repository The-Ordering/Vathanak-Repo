import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_hive/main.dart';
import 'package:todo_hive/view/welcome_screen.dart';

import '../services/auth_notifiier.dart';

class ProfilePage extends StatelessWidget {
  static const String routerName = 'profilePage';
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authenNotifier = Provider.of<AuthNotifier>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 350,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/gradient mesh.png"),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: IconButton(onPressed: (){
                          context.pop();
                        }, icon: Icon(Icons.arrow_back_ios_new))),
                  ),
                  SizedBox(height: 10,),
                  Hero(
                    tag: 'profile_tag',
                    child: Image(image: AssetImage(
                      "assets/images/profile_image.png",
                    ),width: 200,),
                  ),
                   SizedBox(height: 20,),
                   Text(
                    "${authenNotifier.getName()}",
                    style: TextStyle(fontSize: 26),
                  )
                ],
              ),
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Username"),
                  const SizedBox(height: 5),
                  Container(
                    width: 350,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 5),
                      child: TextField(
                        controller: authenNotifier.editUsernameCon,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Username',
                          hintStyle: const TextStyle(
                            color: Colors.black54,
                            fontFamily: "poppins",
                            fontSize: 15,
                          ),
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("Email"),
                  const SizedBox(height: 5),
                  Container(
                    width: 350,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 5),
                      child: TextField(
                        controller: authenNotifier.editEmailCon,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                          hintStyle: const TextStyle(
                              color: Colors.black54,
                              fontFamily: "inter",
                              fontSize: 15),
                          icon: const Icon(Icons.email_outlined),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("Password"),
                  const SizedBox(height: 5),
                  Container(
                    width: 350,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 5),
                      child: TextField(
                        controller: authenNotifier.editPassCon,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: const TextStyle(
                              color: Colors.black54,
                              fontFamily: "poppins",
                              fontSize: 15),
                          icon: const Icon(Icons.lock_open),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                            color: const Color(0xFFFF5757),
                            borderRadius: BorderRadius.circular(12)),
                        child: TextButton(onPressed: (){
                          authenNotifier.logout();
                          context.goNamed(WelcomeScreen.routerName);
                        }, child: Text(
                          "Log Out",
                          style:
                          TextStyle(color: Colors.white, fontSize: 15),
                        )),
                      ),

                      Container(
                        width: 100,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12)),
                        child: TextButton(onPressed: () async{
                          if(authenNotifier.editPassCon != null && authenNotifier.editPassCon.text.isNotEmpty ){
                            authenNotifier.showLoading(context, authenNotifier.updateUser(context));
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Error Update',
                                message: 'Fill in all the Text',
                                contentType: ContentType.warning,
                                inMaterialBanner: true,

                              ),
                              duration: Duration(seconds: 2),
                            ));
                          }
                        }, child: Text(
                          "Update",
                          style:
                          TextStyle(color: Colors.white, fontSize: 15),
                        )),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
