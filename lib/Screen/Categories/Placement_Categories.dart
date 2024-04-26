import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Home Screen/DetailsPage.dart';

class Placement_Categories extends StatefulWidget {
  @override
  State<Placement_Categories> createState() => _Placement_CategoriesState();
}

class _Placement_CategoriesState extends State<Placement_Categories> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('cards')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var filteredDocs = snapshot.data!.docs.where((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  var title = data['title'].toString().toLowerCase();
                  var content = data['content'].toString().toLowerCase();
                  var searchTerm = _searchController.text.toLowerCase();
                  return (title.contains(searchTerm) ||
                          content.contains(searchTerm)) &&
                      data['tag'] == 'Placement';
                }).toList();

                return ListView(
                  children: filteredDocs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsPage(
                              title: data['title'],
                              content: data['content'],
                              webLink: data['webLink'],
                              imageUrl: data['imageUrl'],
                              timeDate: data['timeDate'],
                              studentCood: data['studentCood'],
                              facultyCood: data['facultyCood'],
                              department: data['department'],
                            ),
                          ),
                        );
                      },
                      child: buildCard(
                        data['title'],
                        data['content'],
                        Colors.brown,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(String title, String content, Color tagColor) {
    final int maxWords = 50;
    final List<String> words = content.split(' ');
    final String truncatedContent = words.take(maxWords).join(' ');
    final bool isTruncated = words.length > maxWords;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'RobotoSlab',
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  truncatedContent + (isTruncated ? '...' : ''),
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: tagColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              child: Text(
                'Placement',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'RobotoSlab',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
