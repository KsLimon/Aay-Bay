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
  List totallist = [];

  void initState() {
    super.initState();
    whosbazar();
    totalamount();
  }

  totalamount() async {
    dynamic total = await DatabaseManager().dataload();
    if (total==null){
      print("unable to retrive");
    }
    else{
      setState(() {
        totallist = total;
      });
    }
  }

  amountUpdate(var amount){
    setState(() {
      if (totallist.length != 0){
        totallist[1]['amount'] += int.parse(amount);
      }
      else{
        totallist.add({'amount':int.parse(amount)});
      }
    },);
  }

  amountUpdate2(){
    setState(() {
      int x = totallist[1]['amount'];
      totallist[1]['amount'] -= x;
    },);
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
                                  return InkWell(
                                      onLongPress: () => {
                                        deleteDialog(document.id)
                                      },
                                      onTap: () => {
                                        showDialog(
                                          barrierColor: Colors.black26,
                                          context: context,
                                          builder: (context) {
                                            return alertbuild(document.id, document['value'], document['check'], document['name'], document['count']);
                                          },
                                        ),
                                      },
                                      child:Container(
                                          child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          document["check"] ? Icon(Icons.beenhere, color: Colors.greenAccent,) :Icon(Icons.cancel_outlined, color: Colors.redAccent,),

                                          const Text(
                                            '  ',
                                            style: TextStyle(fontSize: 25),
                                          ),

                                          Flexible(child: Text(
                                            '${document["name"]} ~ ${document['count']}',
                                            style: TextStyle(fontSize: 20),
                                          ),),

                                          Container(
                                            height: 22,
                                            width: 60,
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
                                          ),
                                          SizedBox(width: 10,),
                                        ],
                                      )));
                                }).toList(), //akhane
                              );
                            }),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => {
                      savetotalDialog()
                    },
                    child: Container(
                      width: 280,
                      decoration: BoxDecoration(
                        color: kBackgrondColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(
                          offset: Offset(3, 3),
                          blurRadius: 10,
                          color: Colors.black, // Black color with 12% opacity
                        )],
                      ),
                      child: Text(
                        // 'In Wallet: ${totallist[0]['amount']}',
                        'Total Cost: ${(totallist.length > 0 ? totallist[1]['amount']:'')}',
                        // 'Total Cost',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Color(0xBAD627D3),
                        ),
                      ),
                    ),
                  ),
                ])
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                backgroundColor: const Color(0xFF06124A),
                builder: (context) => upcat()
            );
          },
          backgroundColor: Color(0xBAD627D3),
          tooltip: 'Increment',
          child: Icon(Icons.add, size: 40,),
        ),
      ),
      onWillPop: () async{
        return false;
      },
    );
  }
  @override
  alertbuild(var id, var amount, var check, var scname, var count) {
    TextEditingController _totalController = TextEditingController();
    return Dialog(
      elevation: 0,
      backgroundColor: const Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          Text(
            "$scname",
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff000000),
            ),
          ),
          const SizedBox(height: 15),
          const Text("Write how many you paid:",
              style: TextStyle(
                color: Color(0xff000000),
              )
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _totalController,
            style: TextStyle(color: Colors.black, fontSize: 20),
            decoration: const InputDecoration(
              hintText: "123...",
              hintStyle: TextStyle(
                color: Color(0xFF181642),
                fontSize: 17,
              ),
            ),
          ),
          const Divider(
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
                DatabaseManager().bazarupload(_totalController.text, id, scname, count),
                DatabaseManager().totalbazar(_totalController.text),
                amountUpdate(_totalController.text),
                Navigator.of(context, rootNavigator: true).pop(),
                // amountUpdate2(_totalController.text),
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
              onTap: () => {
                DatabaseManager().undobazar(_totalController.text, id, scname, count),
                Navigator.of(context, rootNavigator: true).pop(),
              },
              child: Center(
                child: Text(
                  "Not Done",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
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

  upcat() {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _amountController = TextEditingController();
    TextEditingController _countController = TextEditingController();
    return Container(

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          const Text(
            "Add to Bazar list",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xE7FFDCF9),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "name",
                labelStyle: TextStyle(
                  color: Color(0xE7FFDCF9),
                  fontSize: 17,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xE7FFDCF9), width: 1),
                ),
              ),
            ),),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: "amount",
                labelStyle: TextStyle(
                  color: Color(0xE7FFDCF9),
                  fontSize: 17,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xE7FFDCF9), width: 1),
                ),
              ),
            ),),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextFormField(
              controller: _countController,
              decoration: const InputDecoration(
                labelText: "count",
                labelStyle: TextStyle(
                  color: Color(0xE7FFDCF9),
                  fontSize: 17,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xE7FFDCF9), width: 1),
                ),
              ),
            ),),
          const Divider(
            height: 1,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: InkWell(
                highlightColor: Colors.grey[200],
                onTap: () => {
                  DatabaseManager().addto_bazar(_nameController.text, _amountController.text, _countController.text),
                  Navigator.of(context, rootNavigator: true).pop(),
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
            ),),

          const Divider(
            height: 1,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: InkWell(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
                highlightColor: Colors.grey[200],
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: const Center(
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
            ),),

        ],
      ),
    );
  }
  deleteDialog(var doc_id) {

    Widget continueButton = FlatButton(
      child: const Text(
        "YES",
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed:  () {
        DatabaseManager().deletebazar(doc_id);
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: const Text(
          "Do you want to delete?",
          style: TextStyle(
            color: Color(0xff000000),
          )
      ),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  savetotalDialog() {

    Widget continueButton = FlatButton(
      child: const Text(
        "YES",
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed:  () {
        DatabaseManager().cashout2("Total Bazar", totallist[1]['amount']);
        DatabaseManager().refreshbazartotal();
        amountUpdate2();
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: const Text(
          "Do you want to save and clear the total cost section?",
          style: TextStyle(
            color: Color(0xff000000),
          )
      ),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
