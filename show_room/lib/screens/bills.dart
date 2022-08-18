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


class Billscreen extends StatefulWidget {
  Billscreen({Key? key}) : super(key: key);

  @override
  _BillscreenState createState() => _BillscreenState();
}

class _BillscreenState extends State<Billscreen> {
  AuthClass authClass = AuthClass();

  List totallist = [];
  late String username;
  late String bill;

  @override
  void initState() {
    super.initState();
    totalamount();
    whosbill();
  }

  whosbill() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser!;
    String usr = 'Users', col = 'Bills';
    bill = '$usr/${user?.email}/$col';
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
      totallist[0]['amount'] -= amount;
    },);
  }
  amountUpdate2(var amount){
    setState(() {
      if (totallist.length != 0){
        totallist[0]['amount'] += int.parse(amount);
      }
      else{
        totallist.add({'amount':int.parse(amount)});
      }
    },);
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

            InkWell(
              onTap: () => {
                showDialog(
                  barrierColor: Colors.black26,
                  context: context,
                  builder: (context) {
                    return uptotal();
                  },
                ),
              },
              child: Container(
                height: 60,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kBackgrondColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(
                    offset: Offset(3, 3),
                    blurRadius: 10,
                    color: Colors.black, // Black color with 12% opacity
                  )],
                ),
                child: ListTile(
                  title: Text(
                    // 'In Wallet: ${totallist[0]['amount']}',
                    'In Wallet: ${(totallist.length > 0 ? totallist[0]['amount']:'')}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Color(0xBAD627D3),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                StreamBuilder(
                stream: FirebaseFirestore.instance.collection(bill).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView(
                      children: snapshot.data!.docs.map((document) {
                    return Container(
                      height: 130,
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xBAD627D3),
                        boxShadow: [BoxShadow(
                          offset: Offset(3, 3),
                          blurRadius: 10,
                          color: Colors.black, // Black color with 12% opacity
                        )
                        ],
                      ),
                      child: InkWell(
                        onLongPress: () => {
                          deleteDialog(document.id)
                        },
                        onTap: () => {
                        showDialog(
                        barrierColor: Colors.black26,
                        context: context,
                        builder: (context) {
                        return alertbuild(document.id, document['amount'], document['pay'], document['Paid by'], document['Name']);
                        },
                        ),
                        },
                        child: Container(
                          height: 130,
                          margin: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: kBackgrondColor,
                          ),

                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  '${document["Name"]} \n ${document["amount"]}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: Color(0xE7FFDCF9),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Flexible(
                                  child: Container(
                                    height: 30,
                                    width: 150,
                                    margin: const EdgeInsets.only(
                                        left: 30, top: 25, right: 10),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                      color: Color(0xFF1F1C56),
                                    ),
                                    child: Text(
                                      "Tap to PAY",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        // color: Color(0x5ED627D3),
                                        color: Color(0xE7FFDCF9),
                                      ),
                                    ),
                                  ),),
                                  Flexible(child:Container(
                                    height: 30,
                                    width: 50,
                                    margin: const EdgeInsets.only(
                                        left: 60, top: 25, right: 10),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                      color: Color(0xFF1F1C56),
                                    ),
                                    child: Text(
                                      "${document["pay"]}",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Color(0xE7FFDCF9),
                                      ),
                                    ),
                                  ),)
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                }).toList(), //akhane
                  ); //vnfjvjvjfhjbjbnbjnbjbnbj n jbn jbn jbn
    }),
                ],
              ),
            ),
            // Container(
            //   child: TextButton(
            //     onPressed: () {
            //       showModalBottomSheet(context: context,
            //           isScrollControlled: true,
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.vertical(
            //               top: Radius.circular(20),
            //             ),
            //           ),
            //           backgroundColor: Color(0xFF06124A),
            //           builder: (context) => upcat()
            //       );
            //     },
            //     child: const Icon(
            //       Icons.add_circle_outlined,
            //       color: Color(0xBAD627D3),
            //       size: 60,
            //     ),
            //     style: TextButton.styleFrom(
            //       padding: EdgeInsets.only(left: 300),
            //       // backgroundColor: Color(0xBAD627D3),
            //       minimumSize: Size(80, 60),
            //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //       alignment: Alignment.center,
            //     ),
            //
            //   ),
            // )
          ],
        ),
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
                  amountUpdate(amount),
                }
                else{
                  Navigator.of(context, rootNavigator: true).pop(),
                  showAlertDialog(whopaid),
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

  showAlertDialog(var username) {

    Widget continueButton = FlatButton(
      child: Text(
        "Ok",
        style: TextStyle(
        fontSize: 18.0,
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
      ),
    ),
      onPressed:  () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: Text(
          "PAID",
          style: TextStyle(
            color: Color(0xff000000),
          )
      ),
      content: Text(
          "Already paid by ${username}",
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

  deleteDialog(var doc_id) {

    Widget continueButton = FlatButton(
      child: Text(
        "YES",
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed:  () {
        DatabaseManager().deletecat(doc_id);
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Color(0xffffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: Text(
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

  @override
  uptotal() {
    TextEditingController _totalController = TextEditingController();
    return Dialog(
      elevation: 0,
      backgroundColor: Color(0xFF06124A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          const Text(
            "Add in Wallet",
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xE7FFDCF9),
            ),
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _totalController,
            decoration: const InputDecoration(
              labelText: "write to add",
              labelStyle: TextStyle(
                color: Color(0xE7FFDCF9),
                fontSize: 17,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xE7FFDCF9), width: 1),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(
            height: 1,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: InkWell(
              highlightColor: Colors.grey[200],
              onTap: () => {
                DatabaseManager().totalupload(_totalController.text),
                DatabaseManager().cashin(_totalController.text, "Monthly cash"),
                Navigator.of(context, rootNavigator: true).pop(),
                amountUpdate2(_totalController.text),
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
          const Divider(
            height: 1,
          ),
          Container(
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
          ),
        ],
      ),
    );
  }

  upcat() {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _amountController = TextEditingController();
    return Container(

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          const Text(
            "Add new category",
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
                  DatabaseManager().categoryupload(_nameController.text, _amountController.text),
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
}