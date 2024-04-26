import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'Add_Message.dart';

class AdminDetailsPage extends StatelessWidget {
  final String title;
  final String content;
  final String webLink;
  final String? timeDate;
  final String? imageUrl;
  final String? studentCood;
  final String? facultyCood;
  final String? department;
  final String? tag;
  final String? docId;

  const AdminDetailsPage({
    Key? key,
    required this.title,
    required this.content,
    required this.webLink,
    required this.timeDate,
    required this.imageUrl,
    required this.studentCood,
    required this.facultyCood,
    required this.department,
    required this.tag,
    required this.docId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isValidUrl(String url) {
      final RegExp urlRegex = RegExp(r'http(s)?://\S+');
      return urlRegex.hasMatch(url);
    }

    bool isLink = isValidUrl(webLink);

    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: Color(0xffF2EFE5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xffF2EFE5),
        automaticallyImplyLeading: false,
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
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.brown,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMessage(
                    title: title,
                    content: content,
                    webLink: webLink,
                    timeDate: timeDate,
                    imageUrl: imageUrl,
                    studentCood: studentCood,
                    facultyCood: facultyCood,
                    department: department,
                    tag: tag,
                    docId: docId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: fontSize * 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: fontSize * 1.5),
              if (imageUrl != null) ...[
                Center(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!,
                    width: screenWidth * 0.8,
                    height: screenWidth * 0.8,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.black12,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: fontSize * 1.5),
              ],
              Linkify(
                onOpen: (link) async {
                  try {
                    final AndroidIntent intent = AndroidIntent(
                      action: 'action_view',
                      data: Uri.encodeFull(link.url),
                      package: 'com.android.chrome',
                    );
                    await intent.launch();
                  } catch (e) {
                    print('Error launching link: $e');
                  }
                },
                text: content,
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: fontSize, fontFamily: 'RobotoSlab'),
              ),
              if (webLink != "null" && isLink) ...[
                SizedBox(height: fontSize * 1.5),
                GestureDetector(
                  onTap: () async {
                    final AndroidIntent intent = AndroidIntent(
                      action: 'action_view',
                      data: Uri.encodeFull(webLink),
                      package: 'com.android.chrome',
                    );
                    await intent.launch();
                  },
                  child: Text.rich(
                    TextSpan(
                      text: 'Link: ',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RobotoSlab',
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: webLink,
                          style: TextStyle(
                            fontSize: fontSize,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontFamily: 'RobotoSlab',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (timeDate != null) SizedBox(height: fontSize * 1.5),
              if (timeDate != null)
                Row(
                  children: [
                    Text(
                      'Date & Time: ',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RobotoSlab',
                      ),
                    ),
                    Text(
                      '$timeDate',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: 'RobotoSlab',
                      ),
                    ),
                  ],
                ),
              if (department != null) SizedBox(height: fontSize * 1.5),
              if (department != null)
                Row(
                  children: <Widget>[
                    Text(
                      'Department: ',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: 'RobotoSlab',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$department',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: 'RobotoSlab',
                      ),
                    ),
                  ],
                ),
              if (studentCood != null) SizedBox(height: fontSize * 1.5),
              if (studentCood != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Student Coordinator: ',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RobotoSlab',
                      ),
                    ),
                    Text(
                      '$studentCood',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: 'RobotoSlab',
                      ),
                    ),
                  ],
                ),
              if (facultyCood != null) SizedBox(height: fontSize * 1.5),
              if (facultyCood != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Faculty Coordinator: ',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: 'RobotoSlab',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$facultyCood',
                      style: TextStyle(
                        fontSize: fontSize,
                        fontFamily: 'RobotoSlab',
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
