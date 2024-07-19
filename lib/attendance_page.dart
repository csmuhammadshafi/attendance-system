import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QRcode extends StatefulWidget {
  const QRcode({Key? key}) : super(key: key);

  @override
  State<QRcode> createState() => _QRcodeState();
}

class _QRcodeState extends State<QRcode> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String result = '';
  Map<String, List<String>> scannedRegistrations = {};
  Set<String> studentsAddedToAttendance = {};
  bool attendanceMarkedForToday = false;
  bool isProcessing = false;
  List<QueryDocumentSnapshot<Object?>> studentsData = [];

  Future<void> initSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool attendanceMarked = prefs.getBool('attendance_marked_today') ?? false;
    if (attendanceMarked) {
      setState(() {
        attendanceMarkedForToday = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    fetchStudentsData();
  }

  bool hasScannedToday(String registrationNumber) {
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return scannedRegistrations[registrationNumber]?.contains(currentDate) ?? false;
  }

  void markAttendanceForToday(String registrationNumber) {
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    scannedRegistrations[registrationNumber] ??= [];
    scannedRegistrations[registrationNumber]!.add(currentDate);
  }

  Future<void> addAllStudentsToAttendance(BuildContext context) async {
    final DateTime currentTime = DateTime.now();
    final Timestamp timestamp = Timestamp.fromDate(currentTime);

    // Check if attendance has already been marked for today
    if (attendanceMarkedForToday) {
      print('Attendance has already been marked for today.');
      return;
    }

    for (final studentSnapshot in studentsData) {
      final studentData = studentSnapshot.data() as Map<String, dynamic>;
      final registration = studentData['Registration'] as String;

      if (!studentsAddedToAttendance.contains(registration)) {
        try {
          if (!hasScannedToday(registration)) {
            await FirebaseFirestore.instance.collection('Attendance').add({
              'Registration': studentData['Registration'],
              'Name': studentData['Name'],
              'Father Name': studentData['Father Name'],
              'Department': studentData['Department'],
              'College': studentData['College'],
              'Status': 'Absent',
              'Timestamp': timestamp,
            });

            markAttendanceForToday(studentData['Registration']);
            studentsAddedToAttendance.add(registration);

            // Mark attendance as done for the current date
            attendanceMarkedForToday = true;
          }
        } catch (e) {
          print('Error adding student to attendance: $e');
        }
      }
    }

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: const Text('Attendance Finished'),
        duration: const Duration(seconds: 2),
      ),
    );

    print('All students added to Attendance at $currentTime');
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData.code!;
      });
    });
  }

  Future<void> checkQRCodeData() async {
    if (result.isEmpty || studentsAddedToAttendance.contains(result)) {
      return;
    }

    if (hasScannedToday(result)) {
      print('QR code has already been scanned today.');
      showResultDialog(false);
      return;
    }

    final QueryDocumentSnapshot<Object?>? studentSnapshot = await checkInStudentsData(result);

    if (studentSnapshot != null) {
      try {
        final DateTime currentTime = DateTime.now();
        final Timestamp timestamp = Timestamp.fromDate(currentTime);

        final studentData = studentSnapshot.data() as Map<String, dynamic>;

        await FirebaseFirestore.instance.collection('Attendance').add({
          'Registration': result,
          'Name': studentData['Name'],
          'Father Name': studentData['Father Name'],
          'Department': studentData['Department'],
          'College': studentData['College'],
          'Status': 'Present',
          'Timestamp': timestamp,
        });

        print('Attendance recorded for registration number: $result at $currentTime');

        markAttendanceForToday(result);
        studentsAddedToAttendance.add(result);

        await showResultDialog(true);

        setState(() {
          result = '';
        });
      } catch (e) {
        print('Error recording attendance: $e');
      }
    } else {
      print('Registration number not found, marking as absent.');
      await showResultDialog(false);
    }
  }

  Future<QueryDocumentSnapshot<Object?>?> checkInStudentsData(String registrationNumber) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Students_Data')
          .where('Registration', isEqualTo: registrationNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      }
    } catch (e) {
      print('Error checking registration number: $e');
    }
    return null;
  }

  Future<void> showResultDialog(bool exists) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Result'),
        content: Text(exists ? 'Yes, registration number found!' : 'No, registration number not found!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> fetchStudentsData() async {
    try {
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Students_Data').get();

      studentsData = querySnapshot.docs;
    } catch (e) {
      print('Error retrieving students data: $e');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          centerTitle: true,
          title: Text(
            "QR SCANNER",
            style: TextStyle(fontSize: 25),
          ),
          automaticallyImplyLeading: false,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Scan Result: $result',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.blue,
                  child: const Text('Check'),
                  onPressed: checkQRCodeData,
                ),
                Visibility(
                  visible: !isProcessing, // Show the "Finish" button if not processing
                  child: ElevatedButton(
                    child: const Text('Finish'),
                    onPressed: () async {
                      setState(() {
                        isProcessing = true; // Set processing to true when "Finish" is pressed
                      });
                      await addAllStudentsToAttendance(context);
                      setState(() {
                        isProcessing = false; // Set processing to false after processing is complete
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: isProcessing, // Show a loading indicator if processing
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
