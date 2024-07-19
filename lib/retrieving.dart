import 'package:flutter/material.dart';
import 'history.dart';
class Retrieve extends StatefulWidget {
  const Retrieve({super.key});

  @override
  State<Retrieve> createState() => _RetrieveState();
}

class _RetrieveState extends State<Retrieve> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Retrieve Data"),
    ),
    body: AttendanceWidget(),
    );
  }
}