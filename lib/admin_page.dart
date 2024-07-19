import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'record.dart';

class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
   final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Admin credentials
  final String adminEmail = 'admin';
  final String adminPassword = 'admin';

  Future<void> _signIn() async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      if (email == adminEmail && password == adminPassword) {
        // Create a custom claim for the admin user
        final currentUser = _auth.currentUser;
        if (currentUser != null) {
          await ({'role': 'admin'});
        }

        // Navigate to the admin page
        await
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Record()),
        );
      } else {
        // Show an error message or handle the case when the credentials are incorrect
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Access Denied'),
              content: Text('You do not have admin privileges.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle login failure
      print('Error signing in: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar:  PreferredSize( //wrap with PreferredSize
                preferredSize: Size.fromHeight(100), //height of appbar
                child: 
      AppBar(

            centerTitle: true, 
            
            title: Text(
              "ADMIN LOGIN",
              style: TextStyle(fontSize: 25),
            ),
            automaticallyImplyLeading: false,
          )
          ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
                decoration: InputDecoration(  
                      border: OutlineInputBorder(),  
                      labelText: 'Username',  
                      hintText: 'Enter Username',  
                    ),
            ),
            SizedBox(height: 7,),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(  
                      border: OutlineInputBorder(),  
                      labelText: 'Password',  
                      hintText: 'Enter Your Password',  
                    ),

              obscureText: true,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,

              ),
              onPressed: _signIn,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
