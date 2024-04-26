import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Addons/ToastHelper.dart';

class AddMessage extends StatefulWidget {
  final String? title;
  final String? content;
  final String? webLink;
  final String? timeDate;
  final String? imageUrl;
  final String? studentCood;
  final String? facultyCood;
  final String? department;
  final String? tag;
  final String? docId;

  AddMessage({
    this.title,
    this.content,
    this.webLink,
    this.timeDate,
    this.imageUrl,
    this.studentCood,
    this.facultyCood,
    this.department,
    this.tag,
    this.docId,
  });

  @override
  _MessageUploadPageState createState() => _MessageUploadPageState();
}

class _MessageUploadPageState extends State<AddMessage> {
  String? _imageUrl;

  @override
  void initState() {
    super.initState();

    _titleController.text = widget.title ?? '';
    _contentController.text = widget.content ?? '';
    _linkController.text = widget.webLink ?? '';
    _timeDateController.text = widget.timeDate ?? '';
    _facultyCoodController.text = widget.facultyCood ?? '';
    _studentCoodController.text = widget.studentCood ?? '';
    _departmentController.text = widget.department ?? '';
    _selectedTag = widget.tag ?? '';
    _imageUrl = widget.imageUrl;
  }

  File? _imageFile;
  final picker = ImagePicker();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  TextEditingController _linkController = TextEditingController();
  TextEditingController _timeDateController = TextEditingController();
  TextEditingController _facultyCoodController = TextEditingController();
  TextEditingController _studentCoodController = TextEditingController();
  TextEditingController _departmentController = TextEditingController();
  String _selectedTag = '';

  void _handleTagSelection(String? value) {
    setState(() {
      _selectedTag = value!;
    });
  }

  Future<void> _uploadData() async {
    if (_titleController.text.isEmpty) {
      ToastHelper.showToast('Please type a title for message');
      return;
    }
    if (_contentController.text.isEmpty) {
      ToastHelper.showToast('Please type a content for message');
      return;
    }
    if (_selectedTag.isEmpty) {
      ToastHelper.showToast('Please select a type of a message');
      return;
    }

    var currentTime = FieldValue.serverTimestamp();

    Map<String, dynamic> data = {
      'title': _titleController.text,
      'content': _contentController.text,
      'timestamp': currentTime,
      'tag': _selectedTag,
      'webLink': "null",
    };

    if (_linkController.text.isNotEmpty) {
      data['webLink'] = _linkController.text;
    }
    if (_timeDateController.text.isNotEmpty) {
      data['timeDate'] = _timeDateController.text;
    }
    if (_facultyCoodController.text.isNotEmpty) {
      data['facultyCood'] = _facultyCoodController.text;
    }
    if (_studentCoodController.text.isNotEmpty) {
      data['studentCood'] = _studentCoodController.text;
    }
    if (_departmentController.text.isNotEmpty) {
      data['department'] = _departmentController.text;
    }

    if (_imageFile != null) {
      String fileName = _imageFile!.path.split('/').last;
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('images/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      data['imageUrl'] = imageUrl;
      _imageUrl = imageUrl;
    }

    if (widget.docId != null) {
      await FirebaseFirestore.instance
          .collection('cards')
          .doc(widget.docId)
          .update(data);
    } else {
      await FirebaseFirestore.instance.collection('cards').add(data);
    }

    setState(() {
      _titleController.clear();
      _contentController.clear();
      _linkController.clear();
      _timeDateController.clear();
      _facultyCoodController.clear();
      _studentCoodController.clear();
      _departmentController.clear();
      _imageFile = null;
      _selectedTag = '';
      _imageUrl = null;
    });

    ToastHelper.showToast('Message uploaded successfully');
  }

  // Future<void> _getImage() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //
  //   setState(() {
  //     if (pickedFile != null) {
  //       _imageFile = File(pickedFile.path);
  //     } else {}
  //   });
  // }

  Future<void> _getImage() async {
    final actionSheet = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Photo Library'),
                  onTap: () async {
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        _imageFile = File(pickedFile.path);
                      });
                    }
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Camera'),
                  onTap: () async {
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.camera);
                    if (pickedFile != null) {
                      setState(() {
                        _imageFile = File(pickedFile.path);
                      });
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });

    if (actionSheet == null) return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2EFE5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: _getImage,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 300.0,
                      color: Colors.grey[200],
                      child: _imageFile != null
                          ? Image.file(_imageFile!, fit: BoxFit.cover)
                          : (_imageUrl != null
                              ? Image.network(_imageUrl!, fit: BoxFit.cover)
                              : null),
                    ),
                    if (_imageFile == null &&
                        (_imageUrl == null || _imageUrl!.isEmpty))
                      Text(
                        'Tap to select image',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'RobotoSlab',
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white70,
                ),
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(
                      fontFamily: 'RobotoSlab',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white70,
                ),
                child: TextFormField(
                  controller: _contentController,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Content',
                    labelStyle: TextStyle(
                      fontFamily: 'RobotoSlab',
                    ),
                    hintText: 'Description',
                    hintStyle: TextStyle(
                      fontFamily: 'RobotoSlab',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white70,
                ),
                child: TextFormField(
                  controller: _linkController,
                  decoration: InputDecoration(
                    labelText: 'Link',
                    labelStyle: TextStyle(
                      fontFamily: 'RobotoSlab',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              // Radio buttons for selecting tags
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Radio<String>(
                      value: 'Alert',
                      groupValue: _selectedTag,
                      onChanged: _handleTagSelection,
                    ),
                    Text(
                      'Alert',
                      style: TextStyle(
                        fontFamily: 'RobotoSlab',
                      ),
                    ),
                    Radio<String>(
                      value: 'Internship',
                      groupValue: _selectedTag,
                      onChanged: _handleTagSelection,
                    ),
                    Text(
                      'Internship',
                      style: TextStyle(
                        fontFamily: 'RobotoSlab',
                      ),
                    ),
                    Radio<String>(
                      value: 'Training',
                      groupValue: _selectedTag,
                      onChanged: _handleTagSelection,
                    ),
                    Text(
                      'Training',
                      style: TextStyle(
                        fontFamily: 'RobotoSlab',
                      ),
                    ),
                    Radio<String>(
                      value: 'Placement',
                      groupValue: _selectedTag,
                      onChanged: _handleTagSelection,
                    ),
                    Text(
                      'Placement',
                      style: TextStyle(
                        fontFamily: 'RobotoSlab',
                      ),
                    ),
                    Radio<String>(
                      value: 'Event',
                      groupValue: _selectedTag,
                      onChanged: _handleTagSelection,
                    ),
                    Text(
                      'Event',
                      style: TextStyle(
                        fontFamily: 'RobotoSlab',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white70,
                ),
                child: TextFormField(
                  controller: _timeDateController,
                  decoration: InputDecoration(
                    labelText: 'Date & Time',
                    labelStyle: TextStyle(
                      fontFamily: 'RobotoSlab',
                    ),
                    hintText: '2nd March, 7pm - 8pm',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white70,
                ),
                child: TextFormField(
                  controller: _facultyCoodController,
                  decoration: InputDecoration(
                    labelText: 'Faculty Coordinator',
                    labelStyle: TextStyle(
                      fontFamily: 'RobotoSlab',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white70,
                ),
                child: TextFormField(
                  controller: _studentCoodController,
                  decoration: InputDecoration(
                    labelText: 'Student Coordinator',
                    labelStyle: TextStyle(
                      fontFamily: 'RobotoSlab',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white70,
                ),
                child: TextFormField(
                  controller: _departmentController,
                  decoration: InputDecoration(
                    labelText: 'Message for which department',
                    labelStyle: TextStyle(
                      fontFamily: 'RobotoSlab',
                    ),
                    hintText: "Leave this field for all department",
                    hintStyle: TextStyle(
                      fontFamily: 'RobotoSlab',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                  onPressed: _uploadData,
                  child: Text(
                    'Upload Message',
                    style: TextStyle(
                      fontFamily: 'RobotoSlab',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
