import 'package:alertify/Screen/Admin/Admin_BottomNavigationPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Addons/ToastHelper.dart';

class AdminLoginPage extends StatefulWidget {
  AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  void adminLogin(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == "" || password == "") {
      print('Please fill all details!');
      ToastHelper.showToast('Please fill all details!');
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          print('User logged in!');
          ToastHelper.showToast('User logged In!');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => AdminBottomNavigationPage()),
            (route) => false, // This removes all previous routes
          );
        }
      } on FirebaseAuthException catch (ex) {
        print(ex.code.toString());
        ToastHelper.showToast(ex.code.toString());
      }
    }
  }

  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2EFE5),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffF2EFE5),
        title: Center(
          child: Text(
            'Alertify',
            style: TextStyle(
              color: Colors.brown,
              fontFamily: 'LeckerliOne',
              fontSize: 30,
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(75),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.message_rounded,
                    color: Colors.brown,
                    size: 100,
                  ),
                ),
                Text(
                  'Admin Login',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: _obscureText,
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    adminLogin(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
