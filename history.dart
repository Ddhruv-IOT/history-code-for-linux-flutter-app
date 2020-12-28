import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var stat = false;
var collectiond = "default";
List<Widget> y = [];

class MyHistory extends StatefulWidget {
  @override
  MyHistoryState createState() => MyHistoryState();
}

class MyHistoryState extends State<MyHistory> {
  var authc = FirebaseAuth.instance;
  List<String> y = [];

  getmsg() async {
    await for (var ry in fsconnect.collection("$collectiond").snapshots()) {
      for (var er in ry.docs) {
        print(er.data());
      }
    }
  }

  var fsconnect = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    var user;
    setState(() {
      user = authc.currentUser;
      collectiond = user.email;
    });
    getmsg();
  }

  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var deviceheight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(
            'HISTORY',
            style: TextStyle(color: Colors.lime),
          ),
          backgroundColor: Colors.black,
          actions: <Widget>[
            IconTheme(
              data: IconThemeData(color: Colors.lime),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                  //Navigator.pushNamed(context, "linux");
                },
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "https://media.giphy.com/media/WoD6JZnwap6s8/giphy.gif"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: deviceheight * 0.80,
                width: deviceWidth * 1.00,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.fromLTRB(25, 25, 25, 25),
                  child: StreamBuilder<QuerySnapshot>(
                    builder: (context, snapshot) {
                      var mg = snapshot.data.docs;
                      List<Widget> y = [];
                      for (var d in mg) {
                        var dta1 = d.data().keys.join("\n");
                        var dta = d.data().values.join("\n");
                        var mgWidget = Text(
                          "$dta1 : $dta \n",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        );
                        y.add(mgWidget);
                      }

                      print("it is Y:->");
                      print(y);
                      return Card(
                        color: Colors.black,
                        child: Container(
                          child: Column(
                            children: y,
                          ),
                        ),
                      );
                    },
                    stream: fsconnect.collection("$collectiond").snapshots(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
