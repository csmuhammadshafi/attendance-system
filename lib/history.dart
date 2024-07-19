import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  final String registration;
  final Timestamp timestamp;
  final String status;
  final String name;
  final String fatherName;
  final String department;
  final String college;

  Attendance({
    required this.registration,
    required this.timestamp,
    required this.status,
    required this.name,
    required this.fatherName,
    required this.department,
    required this.college,
  });

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      registration: map['Registration'] ?? '',
      timestamp: map['Timestamp'] ?? Timestamp.now(),
      status: map['Status'] ?? '',
      name: map['Name'] ?? '',
      fatherName: map['Father Name'] ?? '',
      department: map['Department'] ?? '',
      college: map['College'] ?? '',
    );
  }
}

class AttendanceWidget extends StatefulWidget {
  @override
  _AttendanceWidgetState createState() => _AttendanceWidgetState();
}

class _AttendanceWidgetState extends State<AttendanceWidget> {
  late FirebaseFirestore _firestore;
  late CollectionReference _attendanceCollection;

  List<Attendance> attendanceList = [];

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _attendanceCollection = _firestore.collection('Attendance');
    fetchAttendanceData();
  }

  Future<void> fetchAttendanceData() async {
    try {
      final QuerySnapshot querySnapshot =
          await _attendanceCollection.orderBy('Timestamp', descending: true).get();

      final List<Attendance> tempAttendanceList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Attendance.fromMap(data);
      }).toList();

      // Filter out duplicates based on the 'Registration' field
      final Map<String, Attendance> uniqueAttendanceMap = {};

      tempAttendanceList.forEach((attendance) {
        if (!uniqueAttendanceMap.containsKey(attendance.registration)) {
          uniqueAttendanceMap[attendance.registration] = attendance;
        }
      });

      // Convert the unique map values back to a list
      attendanceList = uniqueAttendanceMap.values.toList();

      setState(() {});
    } catch (e) {
      print('Error fetching attendance data: $e');
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
            "ATTENDANCE HISTORY",
            style: TextStyle(fontSize: 25),
          ),
          automaticallyImplyLeading: false,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _attendanceCollection
            .orderBy('Timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('No.')), // Serial number column
                    DataColumn(label: Text('Registration')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Father Name')),
                    DataColumn(label: Text('Department')),
                    DataColumn(label: Text('College')),
                    DataColumn(label: Text('Timestamp')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: attendanceList.asMap().entries.map((entry) {
                    int serialNumber = entry.key + 1; // Generating serial number
                    Attendance attendance = entry.value;

                    return DataRow(cells: [
                      DataCell(Text(serialNumber.toString())), // Serial number cell
                      DataCell(Text(attendance.registration)),
                      DataCell(Text(attendance.name)),
                      DataCell(Text(attendance.fatherName)),
                      DataCell(Text(attendance.department)),
                      DataCell(Text(attendance.college)),
                      DataCell(Text(attendance.timestamp.toDate().toString())),
                      DataCell(Text(attendance.status.isEmpty ? 'Absent' : attendance.status)),
                    ]);
                  }).toList(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
