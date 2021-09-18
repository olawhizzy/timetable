import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timetable/login.dart';
import 'package:timetable/settings/about.dart';
class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _auth = FirebaseAuth.instance;
  TextEditingController _email = TextEditingController();
  TextEditingController _firstname = TextEditingController();
  TextEditingController _lastname = TextEditingController();
  TextEditingController _level = TextEditingController();
  TextEditingController _matric = TextEditingController();
  TextEditingController _phone = TextEditingController();
  final firestoreInstance = FirebaseFirestore.instance;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Colors.black),),
        automaticallyImplyLeading: true,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: <Widget>[
                  InkWell(
                    onTap: () => _showMyDialog(),
                    /*onTap: () {
                      print(firestoreInstance.collection("users").doc(_auth.currentUser!.uid).collection('details').get().then((value) => print(value.docs.first.id)));
                      //print(firestoreInstance.collection("users").doc(_auth.currentUser!.uid).collection('details').get().then((value) => value.docs.length));
                    },*/
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child:  Column(
                        children: [
                          Image.asset('images/edit.png', height: 100,),
                          SizedBox(height: 10,),
                          Text("Edit profile", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                        ],
                      ),
                      //color: Colors.teal[100],
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AboutDev())),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child:  Column(
                        children: [
                          Image.asset('images/user.png', height: 100,),
                          SizedBox(height: 10,),
                          Text("About Developer", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                        ],
                      ),
                      //color: Colors.teal[100],
                    ),
                  ),
                  InkWell(
                    onTap: () => _auth.signOut().then((value) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                            (Route<dynamic> route) => false,
                      );
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                    }),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child:  Column(
                        children: [
                          Image.asset('images/logout.png', height: 100,),
                          SizedBox(height: 10,),
                          Text("Logout", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                        ],
                      ),
                      //color: Colors.teal[100],
                    ),
                  ),
                  InkWell(
                    onTap: () => exit(0),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child:  Column(
                        children: [
                          //Image.asset('images/information.png', height: 100,),
                          SizedBox(height: 30,),
                          Text("Exit", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),)
                        ],
                      ),
                      //color: Colors.teal[100],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _firstname,
                  decoration: InputDecoration(
                      hintText: 'First Name'
                  ),
                ),
                TextField(
                  controller: _lastname,
                  decoration: InputDecoration(
                      hintText: 'Last Name'
                  ),
                ),
                TextField(
                  controller: _level,
                  decoration: InputDecoration(
                      hintText: 'Level'
                  ),
                ),
                TextField(
                  controller: _matric,
                  decoration: InputDecoration(
                      hintText: 'Matric No.'
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                print(_auth.currentUser!.uid);
                var id;
                firestoreInstance.collection("users").doc(_auth.currentUser!.uid).collection('details').get().then((value) => id = value.docs.first.id);
                try{
                    firestoreInstance.collection("users").doc(_auth.currentUser!.uid).collection('details').doc(id).update(
                        {
                          "firstname" : _firstname.text,
                          "lastname" : _lastname.text,
                          "level" : _level.text,
                          "matric": _matric.text,
                        }).then((value){
                      //print(value);
                    }).then((result) => {
                      print(result),
                      Navigator.pop(context),
                      _firstname.clear(),
                      _lastname.clear(),
                      _level.clear(),
                      _matric.clear()
                    }).catchError((err) {
                      Navigator.pop(context);
                      _firstname.clear();
                      _lastname.clear();
                      _level.clear();
                      _matric.clear();
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title:
                            Text(' Ops! Login Failed'),
                            content: Text('${err.message}'),
                          )
                      );
                    });
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

}
