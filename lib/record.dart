import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_app/add_students.dart';
import 'package:project_app/add_user.dart';
import 'package:project_app/delete_history.dart';

import 'package:project_app/delete_students.dart';
import 'package:project_app/delete_user.dart';
import 'package:project_app/search.dart';
import 'package:project_app/upload_data.dart';
import 'history.dart';
import 'add_students.dart';
import 'search.dart';
import 'delete_user.dart';

class Record extends StatefulWidget {
  const Record({super.key});

  @override
  State<Record> createState() => _RecordState();
}

class _RecordState extends State<Record> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          centerTitle: true,
          title: Text(
            "RECORD PAGE",
            style: TextStyle(fontSize: 25),
          ),
          automaticallyImplyLeading: false,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AuthScreen()));
                },
                style: ElevatedButton.styleFrom(fixedSize: Size(350, 50)
                ,backgroundColor: Colors.blue),
                child: Text("Add User"),
              ),
              SizedBox(height: 15),
               ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteUserPage()));
                },
                style: ElevatedButton.styleFrom(fixedSize: Size(350, 50)
                                ,backgroundColor: Colors.blue,
),
                child: Text("Delete User"),
              ),
               SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UploadDataWidget()));
                },
                style: ElevatedButton.styleFrom(fixedSize: Size(350, 50)                                ,backgroundColor: Colors.blue,
),
                child: Text("Upload Data"),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AttendanceWidget()));
                },
                style: ElevatedButton.styleFrom(fixedSize: Size(350, 50)                                ,backgroundColor: Colors.blue,
),
                child: Text("History"),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddStudentWidget()));
                },
                style: ElevatedButton.styleFrom(fixedSize: Size(350, 50)                                ,backgroundColor: Colors.blue,
),
                child: Text("Add Students"),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteStudentWidget()));
                },
                style: ElevatedButton.styleFrom(fixedSize: Size(350, 50)                                ,backgroundColor: Colors.blue,
),
                child: Text("Delete Student"),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationSearchPage()));
                },
                style: ElevatedButton.styleFrom(fixedSize: Size(350, 50)                                ,backgroundColor: Colors.blue,
),
                child: Text("Search Details"),
              ),
              SizedBox(height: 15),
               ElevatedButton(
                onPressed: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteHistory()));
                },
                style: ElevatedButton.styleFrom(fixedSize: Size(350, 50)                                ,backgroundColor: Colors.blue,
),
                child: Text("Delete Student from History"),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
