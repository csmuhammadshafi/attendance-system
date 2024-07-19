import 'package:flutter/material.dart';
import 'package:project_app/login.dart';
import 'admin_page.dart';
import 'login.dart';
class Myscaffold extends StatefulWidget {
  const Myscaffold({super.key});

  @override
  State<Myscaffold> createState() => _MyscaffoldState();
}

class _MyscaffoldState extends State<Myscaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  PreferredSize( //wrap with PreferredSize
                preferredSize: Size.fromHeight(100), //height of appbar
                child: 
      AppBar(

            centerTitle: true, 
            
            title: Text(
              "ATTENDANCE SYSTEM",
              style: TextStyle(fontSize: 25),
            ),
            
          )
          ),
          body: Center(
            child: Container(
              child: Column(children: [
            SizedBox(
height: 250,
),
            ElevatedButton(
    onPressed: () {Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  LoginScreen()),
  );},
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
        ),
        fixedSize: const Size(170, 60)
    ),
    child: Text(
        "Login",
        style: TextStyle(color: Colors.white, fontSize: 17),
    ),
),
SizedBox(
height: 30,
),
ElevatedButton(
    onPressed: () {Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  AdminLoginScreen()),
  );
},
    style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,

        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0)
        ),

        fixedSize: const Size(170, 60)
    ),
    // ignore: prefer_const_constructors
    child: Text(
        "Admin",
        style: TextStyle(color: Colors.white, fontSize: 17),
    ),
)
          ],),),
          ),
         );
  }
}
  
