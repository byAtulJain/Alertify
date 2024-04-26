import 'package:flutter/material.dart';

class Faltu extends StatelessWidget {
  const Faltu({super.key});

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
                fontSize: 110,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
