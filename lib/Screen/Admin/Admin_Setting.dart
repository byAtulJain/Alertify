import 'package:alertify/Screen/Home%20Screen/BottomNavigationPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminSetting extends StatefulWidget {
  const AdminSetting({Key? key}) : super(key: key);

  @override
  State<AdminSetting> createState() => _SettingState();
}

class _SettingState extends State<AdminSetting> {
  void logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottomNavigationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2EFE5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Color(0xffF2EFE5),
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.black54,
            fontFamily: 'LeckerliOne',
            fontSize: 26,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        children: [
          _buildSettingItem(
            icon: Icons.exit_to_app,
            text: 'Logout',
            onTap: () {
              logOut(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String text,
    required void Function() onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: onTap,
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.black54,
            size: 30,
          ),
          title: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              fontFamily: 'RobotoSlab',
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.black54,
            size: 20,
          ),
        ),
      ),
    );
  }
}
