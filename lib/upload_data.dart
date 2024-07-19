import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class UploadDataWidget extends StatefulWidget {
  @override
  _UploadDataWidgetState createState() => _UploadDataWidgetState();
}
class _UploadDataWidgetState extends State<UploadDataWidget> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

 Future<void> _uploadData() async {
  String jsonData = await rootBundle.loadString('assets/data.json');
  var dataList = jsonDecode(jsonData) as List<dynamic>;

  for (var data in dataList) {
    await firestore.collection('Students_Data').add(data);
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Success'),
        content: Text('Data uploaded to Firestore.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          centerTitle: true,
          title: Text(
            "UPLOAD DATA TO FIREBASE",
            style: TextStyle(fontSize: 25),
          ),
          automaticallyImplyLeading: false,
        ),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Upload Data'),
          onPressed: _uploadData,
        ),
      ),
    );
  }
}

