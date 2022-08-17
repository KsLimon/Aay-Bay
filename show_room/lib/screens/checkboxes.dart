import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:show_room/database.dart';
import 'package:show_room/menubar.dart';
import 'package:show_room/screens/home_screen.dart';
import 'package:firebase_database/firebase_database.dart';


import '../appback.dart';
import '../constants.dart';
import '../services/auth_service.dart';
import 'checkboxes.dart';


class Bazarscreen extends StatefulWidget {
  Bazarscreen({Key? key}) : super(key: key);

  @override
  _BazarscreenState createState() => _BazarscreenState();
}

class _BazarscreenState extends State<Bazarscreen> {
  AuthClass authClass = AuthClass();
  bool isChecked = false;
  late String bazar;

  void initState() {
    super.initState();
    whosbazar();
  }

  whosbazar() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser!;
    String usr = 'Users', col = 'bazar';
    bazar = '$usr/${user?.email}/$col';
  }


  @override
  Widget build(BuildContext context){
    return WillPopScope(
      child: Scaffold(
        appBar: menubar(),
        body: Appback(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
            child: Stack(
              children: <Widget>[
                StreamBuilder(
                    stream: FirebaseFirestore.instance.collection(bazar).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return ListView(
                        children: snapshot.data!.docs.map((document) {
                          return GestureDetector(
                              onLongPress: () => {},
                              onTap: () => {},
                              child:Container( child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Checkbox(
                                    value: document["check"],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        this.isChecked = value!;
                                      });
                                    },
                                  ),
                                  Flexible(child: Text(
                                    '${document["name"]}',
                                    style: TextStyle(fontSize: 25),
                                  ),),

                                  Flexible(child: Container(
                                    height: 30,
                                    width: 50,
                                    margin: const EdgeInsets.only(
                                        left: 15, top: 10),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                      color: Color(0xFF1F1C56),
                                    ),
                                    child: Text(
                                      "${document["value"]}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Color(0xE7FFDCF9),
                                      ),
                                    ),
                                  ),),
                                  SizedBox(width: 10,)
                                ],
                              )));
                        }).toList(), //akhane
                      );
                    }),
              ],
            ),
          ),])
        ),
      ),
      onWillPop: () async{
        return false;
      },
    );
  }

}
