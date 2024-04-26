import 'package:alertify/Screen/Admin/Add_Message.dart';
import 'package:alertify/Screen/Admin/Admin_Home_Page.dart';
import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'Admin_Setting.dart';

class AdminBottomNavigationPage extends StatefulWidget {
  @override
  State<AdminBottomNavigationPage> createState() => _HomePageState();
}

class _HomePageState extends State<AdminBottomNavigationPage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2EFE5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
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
      body: getSelectedWidget(index: index),
      bottomNavigationBar: CurvedNavigationBar(
        index: index,
        color: Colors.white,
        backgroundColor: Color(0xffF2EFE5),
        animationDuration: Duration(milliseconds: 300),
        items: [
          CurvedNavigationBarItem(
            child: Icon(Icons.home_outlined),
            label: 'Admin Home',
            labelStyle: TextStyle(
              fontFamily: 'RobotoSlab',
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.add),
            label: 'Add Message',
            labelStyle: TextStyle(
              fontFamily: 'RobotoSlab',
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.settings_outlined),
            label: 'Admin Setting',
            labelStyle: TextStyle(
              fontFamily: 'RobotoSlab',
            ),
          ),
        ],
        buttonBackgroundColor: Colors.white,
        onTap: (selectedIndex) {
          setState(() {
            index = selectedIndex;
          });
        },
      ),
    );
  }

  Widget getSelectedWidget({required int index}) {
    Widget widget;
    switch (index) {
      case 0:
        widget = AdminHome();
        break;
      case 1:
        widget = AddMessage();
        break;
      case 2:
        widget = AdminSetting();
        break;
      default:
        widget = AdminHome();
    }
    return widget;
  }
}
