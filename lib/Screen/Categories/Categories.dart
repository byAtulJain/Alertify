import 'package:alertify/Screen/Categories/Alert_Categories.dart';
import 'package:alertify/Screen/Categories/Event_Categories.dart';
import 'package:alertify/Screen/Categories/Internship_Categories.dart';
import 'package:alertify/Screen/Categories/Placement_Categories.dart';
import 'package:alertify/Screen/Categories/Training_Categories.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2EFE5),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: <Widget>[
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Training_Categories(),
                    ),
                  );
                },
                child: buildCard(context, 'Trainings')),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Placement_Categories(),
                    ),
                  );
                },
                child: buildCard(context, 'Placements')),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Alert_Categories(),
                    ),
                  );
                },
                child: buildCard(context, 'Alerts')),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Event_Categories(),
                    ),
                  );
                },
                child: buildCard(context, 'Events')),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Internship_Categories(),
                    ),
                  );
                },
                child: buildCard(context, 'Internships')),
          ],
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context, String text) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = (screenWidth - 32) / 2;
    double fontSize = cardWidth * 0.1;

    return Card(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  fontFamily: 'RobotoSlab',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
