import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeleteUserPage extends StatefulWidget {
  @override
  _DeleteUserPageState createState() => _DeleteUserPageState();
}

class _DeleteUserPageState extends State<DeleteUserPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String message = '';
  bool deleting = false; // Add a variable to track the deletion process

  Future<void> deleteUser() async {
    try {
      setState(() {
        deleting = true; // Start the deletion process, show loader
      });

      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if (email.isNotEmpty && password.isNotEmpty) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.delete();
          setState(() {
            message = 'User deleted successfully.';
          });
        } else {
          setState(() {
            message = 'User not found.';
          });
        }
      } else {
        setState(() {
          message = 'Please enter a valid email and password.';
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        deleting = false; // Deletion process is complete, hide loader
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          centerTitle: true,
          title: Text(
            "DELETE USER",
            style: TextStyle(fontSize: 25),
          ),
          automaticallyImplyLeading: false,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                hintText: 'Enter user email',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter user password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: deleting ? null : deleteUser, // Disable the button when deleting
              child: deleting
                  ? CircularProgressIndicator() // Show loader when deleting
                  : Text('Delete User'),
            ),
            SizedBox(height: 16.0),
            Text(
              message,
              style: TextStyle(
                color: Colors.red,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
