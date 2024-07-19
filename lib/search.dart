import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationSearchPage extends StatefulWidget {
  @override
  _RegistrationSearchPageState createState() =>
      _RegistrationSearchPageState();
}

class _RegistrationSearchPageState extends State<RegistrationSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _registrationDataList = [];
  int totalAbsent = 0;
  int totalPresent = 0;
  bool _isLoading = false;

  void _searchRegistration() async {
    final registrationNumber = _searchController.text;

    // Show loader when the search operation starts
    setState(() {
      _isLoading = true;
    });

    final querySnapshot = await FirebaseFirestore.instance
        .collection('Attendance')
        .where('Registration', isEqualTo: registrationNumber)
        .get();

    // Hide loader when the search operation is completed
    setState(() {
      _isLoading = false;
    });

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        _registrationDataList = querySnapshot.docs.map((doc) => doc.data()).toList();
        _calculateTotalStatus();
      });
    } else {
      setState(() {
        _registrationDataList.clear();
        _calculateTotalStatus();
      });
    }
  }

  void _calculateTotalStatus() {
    totalAbsent = 0;
    totalPresent = 0;
    for (var registrationData in _registrationDataList) {
      final status = registrationData['Status'];
      if (status == 'Absent') {
        totalAbsent++;
      } else if (status == 'Present') {
        totalPresent++;
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
            "REGISTRATION DETAILS",
            style: TextStyle(fontSize: 25),
          ),
          automaticallyImplyLeading: false,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(labelText: 'Enter Registration Number'),
              ),
              SizedBox(height: 20),
              Stack(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => _searchRegistration(),
                    child: Text('Search'),
                  ),
                  if (_isLoading)
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
              SizedBox(height: 20),
              if (_registrationDataList.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Registration')),
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Father Name')),
                        DataColumn(label: Text('Department')),
                        DataColumn(label: Text('College')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: _registrationDataList.map((registrationData) {
                        return DataRow(cells: [
                          DataCell(Text(registrationData['Registration'] ?? '')),
                          DataCell(Text(registrationData['Name'] ?? '')),
                          DataCell(Text(registrationData['Father Name'] ?? '')),
                          DataCell(Text(registrationData['Department'] ?? '')),
                          DataCell(Text(registrationData['College'] ?? '')),
                          DataCell(Text(registrationData['Status'] ?? '')),
                        ]);
                      }).toList()
                        ..add(DataRow(cells: [
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('Total Absent: $totalAbsent')),
                          DataCell(Text('Total Present: $totalPresent')),
                        ])),
                    ),
                  ),
                )
              else
                Text('Registration not found'),
            ],
          ),
        ),
      ),
    );
  }
}
