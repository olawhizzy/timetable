import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
class ViewLectures extends StatefulWidget {
  const ViewLectures({Key? key}) : super(key: key);

  @override
  _ViewLecturesState createState() => _ViewLecturesState();
}

class _ViewLecturesState extends State<ViewLectures> {
  final _auth = FirebaseAuth.instance;
  TextEditingController _courceCode = TextEditingController();
  TextEditingController _courceTitle = TextEditingController();
  TextEditingController _lecturername = TextEditingController();
  TextEditingController _venue = TextEditingController();
  final firestoreInstance = FirebaseFirestore.instance;

  var datee;
  var startTime;
  var endTime;
  var snapp;
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Lectures'),
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
                  controller: _lecturername,
                  decoration: InputDecoration(
                      hintText: 'Lecturer Name'
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
                            startTime = date;
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Text(datee == null ? 'Select start date' : '${datee.toLocal()}'),
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
                            endTime = date;
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Text(datee == null ? 'Select end date' : '${datee.toLocal()}'),
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
                      _venue.text.isNotEmpty &&
                      _lecturername.text.isNotEmpty
                  ) {
                    firestoreInstance.collection("users").doc(_auth.currentUser!.uid).collection('lectures').add(
                        {
                          "courseCode" : _courceCode.text,
                          "courseTitle" : _courceTitle.text,
                          "venue" : _venue.text,
                          "lecturerName": _lecturername.text,
                          "startTime" : startTime,
                          "endTime" : endTime,
                          "date" : DateTime.now(),
                        }).then((value){
                      print(value.id);
                    }).then((result) => {
                      print(result),
                      Navigator.pop(context),
                      _courceTitle.clear(),
                      _courceCode.clear(),
                      _venue.clear(),
                      _lecturername.clear()
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
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lectures'),
        actions: [
          IconButton(
              onPressed: () => _showMyDialog(),
              icon: Icon(Icons.add),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreInstance.collection('users').doc(_auth.currentUser!.uid).collection('lectures').snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index){
                  DateTime dt = (snapshot.data!.docs[index]['startTime'] as Timestamp).toDate();
                  DateTime dt1 = (snapshot.data!.docs[index]['endTime'] as Timestamp).toDate();

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
                                ],
                              ),
                              Text(snapshot.data!.docs[index]['venue'])
                            ],
                          ),
                          SizedBox(height: 10,),
                          Text('${DateFormat.MMMEd().add_jm().format(dt)} - ${DateFormat.MMMEd().add_jm().format(dt1)}'),

                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(snapshot.data!.docs[index]['courseTitle']),
                              IconButton(
                                  onPressed: () => firestoreInstance.collection('users').doc(_auth.currentUser!.uid).collection('lectures').doc(snapshot.data!.docs[index].id).delete(),
                                  icon: Icon(Icons.highlight_remove, color: Colors.red,))
                            ],
                          ),
                          SizedBox(height: 10,),
                          Text(snapshot.data!.docs[index]['lecturerName'])
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
