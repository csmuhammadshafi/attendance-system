import 'package:flutter/material.dart';
import 'package:project_app/attendance_page.dart';
import 'admin_page.dart';


class After_login extends StatefulWidget {
  const After_login({super.key});

  @override
  State<After_login> createState() => _After_loginState();
}

class _After_loginState extends State<After_login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar:  PreferredSize( //wrap with PreferredSize
                preferredSize: Size.fromHeight(100), //height of appbar
                child: 
      AppBar(

            centerTitle: true, 
            
            title: Text(
              "ATTENDANCE",
              style: TextStyle(fontSize: 25),
            ),
            automaticallyImplyLeading: false,
          )
          ),
          body: SingleChildScrollView(child: Column(children: [Center(
            child: Container(child: Column(children: [
            SizedBox(
height: 250,
),
            ElevatedButton(
    onPressed: () { Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  QRcode()),
  );},
    style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
        ),
        fixedSize: const Size(170, 60)
    ),
    child: Text(
        "Attendence",
        style: TextStyle(color: Colors.white, fontSize: 17),
    ),
),
SizedBox(
height: 30,
),

          ],),),
          )],),)
          );
  }
}