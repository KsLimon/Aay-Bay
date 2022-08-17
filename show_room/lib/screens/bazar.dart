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
                                      onTap: () => {
                                        showDialog(
                                          barrierColor: Colors.black26,
                                          context: context,
                                          builder: (context) {
                                            return alertbuild(document.id, document['value'], document['value'], document['check'], document['name']);
                                          },
                                        ),
                                      },
                                      child:Container( child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          SizedBox(
                                            width: 10,
                                          ),
                                          document["check"] ? Icon(Icons.beenhere, color: Colors.greenAccent,) :Icon(Icons.cancel_outlined, color: Colors.redAccent,),

                                          Flexible(child: Text(
                                            '  ',
                                            style: TextStyle(fontSize: 25),
                                          ),),

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
  @override
  alertbuild(var id, var amount, var pay, var whopaid, var scname) {
    return Dialog(
      elevation: 0,
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 15),
          Text(
            "Make Sure",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff000000),
            ),
          ),
          SizedBox(height: 15),
          Text("Would you like to continue?",
              style: TextStyle(
                color: Color(0xff000000),
              )
          ),
          SizedBox(height: 20),
          Divider(
            height: 1,
          ),
          Container(
            // width: MediaQuery.of(context).size.width,
            height: 50,
            width: 170,
            // margin: const EdgeInsets.only(
            //     left: 30, top: 25, right: 10),
            child: InkWell(
              highlightColor: Colors.grey[200],
              onTap: () => {
                if (pay == "due"){
                  DatabaseManager().dataupload(id),
                  DatabaseManager().selectedcashout(scname, amount),
                  Navigator.of(context, rootNavigator: true).pop(),
                  // amountUpdate(amount),
                }
                else{
                  Navigator.of(context, rootNavigator: true).pop(),
                  // showAlertDialog(whopaid),
                  // showDialog(context: context, builder: Text(document['amount']))
                }
              },
              child: Center(
                child: Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          Divider(
            height: 1,
          ),
          Container(
            // width: MediaQuery.of(context).size.width,
            height: 50,
            width: 130,
            child: InkWell(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
              highlightColor: Colors.grey[200],
              onTap: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: Center(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                    color: Color(0xff800808),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
