import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteStudentWidget extends StatefulWidget {
  @override
  _DeleteStudentWidgetState createState() => _DeleteStudentWidgetState();
}

class _DeleteStudentWidgetState extends State<DeleteStudentWidget> {
  final _formKey = GlobalKey<FormState>();
  final _registrationController = TextEditingController();
  bool _isDeleting = false; // Added state variable for deletion process

  void _deleteStudent() async {
    if (_formKey.currentState!.validate()) {
      String registration = _registrationController.text;

      // Set the deletion process to true
      setState(() {
        _isDeleting = true;
      });

      try {
        // Delete data from Firestore
        await FirebaseFirestore.instance
            .collection('Students_Data')
            .where('Registration', isEqualTo: registration)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });

        // Display a success message using SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data Deleted Successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        // Clear the registration field
        _registrationController.clear();
      } catch (error) {
        // An error occurred while deleting data
        // Handle the error accordingly
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${error.toString()}'),
            duration: Duration(seconds: 2),
          ),
        );
      } finally {
        // Set the deletion process to false
        setState(() {
          _isDeleting = false;
        });
      }
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
            "DELETE STUDENTS",
            style: TextStyle(fontSize: 25),
          ),
          automaticallyImplyLeading: false,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [SizedBox(height: 20,),
              TextFormField(
                controller: _registrationController,
                decoration: InputDecoration(labelText: 'Registration', border:OutlineInputBorder() ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter registration';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Conditional rendering of the Delete button or loader
              _isDeleting
                  ? CircularProgressIndicator() // Show loader when deleting
                  : ElevatedButton(
                      onPressed: _deleteStudent,
                      child: Text('Delete'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
