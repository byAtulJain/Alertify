import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Admin_Details_Page.dart';
import '../Addons/ToastHelper.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key});

  @override
  State<AdminHome> createState() => _HomeState();
}

class _HomeState extends State<AdminHome> {
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
    return Column(
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
              hintStyle: TextStyle(
                fontFamily: 'RobotoSlab',
              ),
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
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                return title.contains(searchTerm) ||
                    content.contains(searchTerm);
              }).toList();

              return ListView(
                children: filteredDocs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  return Dismissible(
                    key: Key(document.id),
                    direction: DismissDirection.startToEnd,
                    confirmDismiss: (left) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Color(0xffF2EFE5),
                            title: const Text(
                              "CONFIRM",
                              style: TextStyle(
                                fontFamily: 'RobotoSlab',
                              ),
                            ),
                            content: const Text(
                              "Are you sure you wish to delete this message?",
                              style: TextStyle(
                                fontFamily: 'RobotoSlab',
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text(
                                    "DELETE",
                                    style: TextStyle(
                                      color: Colors.brown,
                                      fontFamily: 'RobotoSlab',
                                    ),
                                  )),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text(
                                  "CANCEL",
                                  style: TextStyle(
                                      fontFamily: 'RobotoSlab',
                                      color: Colors.grey),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (direction) async {
                      await FirebaseFirestore.instance
                          .collection('cards')
                          .doc(document.id)
                          .delete();
                      ToastHelper.showToast('Message Deleted');
                    },
                    background: Container(
                      color: Color(0xffF2EFE5),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 40,
                            ),
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.brown,
                                fontFamily: 'RobotoSlab',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminDetailsPage(
                              title: data['title'],
                              content: data['content'],
                              webLink: data['webLink'],
                              imageUrl: data['imageUrl'],
                              timeDate: data['timeDate'],
                              studentCood: data['studentCood'],
                              facultyCood: data['facultyCood'],
                              department: data['department'],
                              tag: data['tag'],
                              docId: document.id,
                            ),
                          ),
                        );
                      },
                      child: buildCard(
                        data['title'],
                        data['content'],
                        data['tag'],
                        Colors.brown,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildCard(String title, String content, String tag, Color tagColor) {
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
                tag,
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
