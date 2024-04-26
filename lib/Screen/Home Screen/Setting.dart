import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import '../Admin/Admin_Already_Login.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2EFE5),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
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
            icon: Icons.person,
            text: 'Admin',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminAlreadyLogin()),
              );
            },
          ),
          // _buildSettingItem(
          //   icon: Icons.notifications,
          //   text: 'Notifications',
          //   onTap: () {},
          // ),
          _buildSettingItem(
            icon: Icons.help,
            text: 'Help & Support',
            onTap: () async {
              final AndroidIntent intent = AndroidIntent(
                action: 'action_view',
                data: 'https://wa.me/+918962490765',
                package: 'com.android.chrome',
              );
              await intent.launch();
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
