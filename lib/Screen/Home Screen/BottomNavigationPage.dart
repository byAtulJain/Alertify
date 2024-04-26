import 'package:alertify/Screen/Home%20Screen/Alert.dart';
import 'package:alertify/Screen/Categories/Categories.dart';
import 'package:alertify/Screen/Home%20Screen/Home.dart';
import 'package:alertify/Screen/Home%20Screen/Setting.dart';
import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';

class BottomNavigationPage extends StatefulWidget {
  @override
  State<BottomNavigationPage> createState() => _HomePageState();
}

class _HomePageState extends State<BottomNavigationPage> {
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
            label: 'Home',
            labelStyle: TextStyle(
              fontFamily: 'RobotoSlab',
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.chat_bubble_outline),
            label: 'Alert',
            labelStyle: TextStyle(
              fontFamily: 'RobotoSlab',
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.list),
            label: 'Categories',
            labelStyle: TextStyle(
              fontFamily: 'RobotoSlab',
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.settings_outlined),
            label: 'Setting',
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
        widget = Home();
        break;
      case 1:
        widget = Alert();
        break;
      case 2:
        widget = Categories();
        break;
      case 3:
        widget = Setting();
        break;
      default:
        widget = Home();
    }
    return widget;
  }
}
