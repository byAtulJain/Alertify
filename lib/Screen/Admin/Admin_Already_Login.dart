import 'package:alertify/Screen/Admin/Admin_BottomNavigationPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Admin_Login_Page.dart';

class AdminAlreadyLogin extends StatelessWidget {
  AdminAlreadyLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (FirebaseAuth.instance.currentUser != null)
          ? AdminBottomNavigationPage()
          : AdminLoginPage(),
    );
  }
}
