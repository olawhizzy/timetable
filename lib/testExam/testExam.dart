import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
class TestExam extends StatefulWidget {
  const TestExam({Key? key}) : super(key: key);

  @override
  _TestExamState createState() => _TestExamState();
}

class _TestExamState extends State<TestExam> {
  @override
  final _auth = FirebaseAuth.instance;
  TextEditingController _courceCode = TextEditingController();
  TextEditingController _courceTitle = TextEditingController();
  TextEditingController _lecturername = TextEditingController();
  TextEditingController _venue = TextEditingController();
  final firestoreInstance = FirebaseFirestore.instance;

  var startTime;
  var endTime;
  var snapp;
  var datee;
  var time;
  var selectedDate = DateTime.now();
  var selectedTime = TimeOfDay(hour: 00, minute: 00);

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context, StateSetter setState){
              return AlertDialog(
                title: Text('Add Test / Exam'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      TextField(
                        controller: _courceCode,
                        decoration: InputDecoration(
                            hintText: 'Course Code'
                        ),
                      ),
                      TextField(
                        controller: _courceTitle,
                        decoration: InputDecoration(
                            hintText: 'Course Title'
                        ),
                      ),
                      TextField(
                        controller: _venue,
                        decoration: InputDecoration(
                            hintText: 'Venue'
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2018, 3, 5),
                              maxTime: DateTime(2019, 6, 7), onChanged: (date) {
                                print('change $date');
                              }, onConfirm: (date) {
                                print('confirm $date');
                                setState(() {
                                  datee = date.toLocal();
                                  selectedDate = date;
                                });
                              }, currentTime: DateTime.now(), locale: LocaleType.en);
                        },
                        child: Text(datee == null ? 'Select date' : '${datee.toLocal()}'),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Save'),
                    onPressed: () {
                      print(_auth.currentUser!.uid);
                      try{
                        if (_courceTitle.text.isNotEmpty &&
                            _courceCode.text.isNotEmpty &&
                            _venue.text.isNotEmpty
                            //_lecturername.text.isNotEmpty
                        ) {
                          firestoreInstance.collection("users").doc(_auth.currentUser!.uid).collection('testExam').add(
                              {
                                "courseCode" : _courceCode.text,
                                "courseTitle" : _courceTitle.text,
                                "venue" : _venue.text,
                                "date" : selectedDate,
                              }).then((value){
                            print(value.id);
                          }).then((result) => {
                            print(result),
                            Navigator.pop(context),
                            _courceTitle.clear(),
                            _courceCode.clear(),
                            _venue.clear(),
                            datee = 'Select date'
                          }).catchError((err) => print(err));
                        }
                      } catch (e){
                        print(e);
                      }
                    },
                  ),
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();

                    },
                  ),
                ],
              );
            });
      },
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        datee = DateFormat.yMd().format(selectedDate);
      });
  }

  _selectTimeDate() async {
    DateTimePicker(
      type: DateTimePickerType.dateTimeSeparate,
      dateMask: 'd MMM, yyyy',
      initialValue: DateTime.now().toString(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      icon: Icon(Icons.event),
      dateLabelText: 'Date',
      timeLabelText: "Hour",
      selectableDayPredicate: (date) {
        // Disable weekend days to select from the calendar
        if (date.weekday == 6 || date.weekday == 7) {
          return false;
        }

        return true;
      },
      onChanged: (val) => print(val),
      validator: (val) {
        print(val);
        return null;
      },
      onSaved: (val) => print(val),
    );
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        /*_hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();*/
      });
    print(picked);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test/Exams'),
        actions: [
          IconButton(
            onPressed: () => _showMyDialog(),
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: firestoreInstance.collection('users').doc(_auth.currentUser!.uid).collection('testExam').snapshots(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index){
                    DateTime dt = (snapshot.data!.docs[index]['date'] as Timestamp).toDate();
                    firestoreInstance.collection('users').doc(_auth.currentUser!.uid).collection('testExam').doc(index.toString()).delete();
                    return Container(
                      margin: EdgeInsets.all(5),
                      child: Card(
                        child: Container(
                          //margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(snapshot.data!.docs[index]['courseCode']),
                                      SizedBox(width: 10,),
                                      Text('${DateFormat.MMMEd().add_jm().format(dt)}'),
                                    ],
                                  ),
                                  Text(snapshot.data!.docs[index]['venue'])
                                ],
                              ),
                              SizedBox(height: 20,),
                              //Text(DateFormat.yMd().format(DateTime.parse(snapshot.data!.docs[index]['date']).toDate())),
                             // SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(snapshot.data!.docs[index]['courseTitle']),
                                  IconButton(
                                      onPressed: () => firestoreInstance.collection('users').doc(_auth.currentUser!.uid).collection('testExam').doc(snapshot.data!.docs[index].id).delete(),
                                      icon: Icon(Icons.highlight_remove, color: Colors.red,))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    return Text(snapshot.data!.docs[index]['courseTitle']);
                  });
              /*return ListView(
              children: snapshot.data!.docs.map((doc){
                return Card(
                  child: ListTile(
                    title: Text(doc!.data()?['title'].toString()),
                  ),
                );
              }).toList(),
            );*/
            } else {
              return Text('data');
            }
          }
      ),
    );
  }
}
