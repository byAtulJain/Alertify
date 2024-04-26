import 'dart:async';
import 'package:alertify/Screen/Home%20Screen/BottomNavigationPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              BottomNavigationPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2EFE5),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              'Alertify',
              style: TextStyle(
                color: Colors.brown,
                fontFamily: 'LeckerliOne',
                fontSize: 40,
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          SpinKitWave(
            color: Colors.brown,
            size: 40.0,
          ),
        ],
      ),
    );
  }
}
