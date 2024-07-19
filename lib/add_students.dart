import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddStudentWidget extends StatefulWidget {
  @override
  _AddStudentWidgetState createState() => _AddStudentWidgetState();
}

class _AddStudentWidgetState extends State<AddStudentWidget> {
  final _formKey = GlobalKey<FormState>();
  final _registrationController = TextEditingController();
  final _nameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _departmentController = TextEditingController();
  final _collegeController = TextEditingController();
  bool _isLoading = false; // Track loading state

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading indicator
      });

      FirebaseFirestore.instance.collection('Students_Data').add({
        'Registration': _registrationController.text,
        'Name': _nameController.text,
        'Father Name': _fatherNameController.text,
        'Department': _departmentController.text,
        'College': _collegeController.text,
      }).then((value) {
        // Data saved successfully
        // Display a success message using SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data Added Successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        // Reset the form and loading state
        _formKey.currentState!.reset();
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        // An error occurred while saving data
        // Handle the error accordingly
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${error.toString()}'),
            duration: Duration(seconds: 2),
          ),
        );

        // Reset the loading state
        setState(() {
          _isLoading = false;
        });
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
            "ADD STUDENTS",
            style: TextStyle(fontSize: 25),
          ),
          automaticallyImplyLeading: false,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                controller: _registrationController,
                decoration: InputDecoration(
                  labelText: 'Registration',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter registration';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _fatherNameController,
                decoration: InputDecoration(
                  labelText: 'Father Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter father name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _departmentController,
                decoration: InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter department';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _collegeController,
                decoration: InputDecoration(
                  labelText: 'College',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter college';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm, // Disable button during loading
                child: _isLoading
                    ? CircularProgressIndicator() // Show loading indicator
                    : Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
