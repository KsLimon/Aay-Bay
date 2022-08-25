import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:show_room/menubar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../appback.dart';
import '../constants.dart';
import '../database.dart';
import '../services/auth_service.dart';

class Homescreen extends StatefulWidget {
  Homescreen({Key? key}) : super(key: key);

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  AuthClass authClass = AuthClass();

  List totallist = [];
  List itemlist = [];
  late String bill;

  @override
  void initState() {
    super.initState();
    printdate();
    whosbill();
    totalamount();
    catloading();
  }

  printdate(){
    // DateTime now = DateTime.now();
    // var newDt = DateFormat.yMMMMd().format(now);
    // print(newDt);
    // var ss = DateFormat.yMd().add_jm().format(now);
    // print(ss);
    DateTime now = DateTime.now();
    var formattedDate = DateFormat('d,MMM HH:mm a').format(now);
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

  catloading() async {
    dynamic item = await DatabaseManager().catload();
    if (item==null){
      print("unable to retrive");
    }
    else{
      setState(() {
        itemlist = item;
      });
    }
  }

  whosbill() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser!;
    String usr = 'Users', col = 'dates';
    bill = '$usr/${user?.email}/$col';
  }

  amountUpdate(var amount){
    setState(() {
      totallist[0]['amount'] -= int.parse(amount);
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
                              height: 71,
                              // margin: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(left: 10, right: 10,top: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0x8C203AA4),
                                boxShadow: const [BoxShadow(
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
                                  child: Container(
                                    height: 71,
                                    // margin: const EdgeInsets.only(left: 10, right: 10,top: 2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0x8C203AA4),
                                    ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(
                                            '${document["comment"]}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              // fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Color(0xE7FFDCF9),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          child: (document["Type"] == 0) ?
                                          Text(
                                            '${document["amount"]}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              // fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              // color: Color(0xFFB71C1C),
                                              color: Color(0xFFB71C1C),
                                            ),
                                          ) : Text(
                                            '${document["amount"]}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              // fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              // color: Color(0xFF00796B),
                                              color: Color(0xFF00796B),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [

                                        Container(
                                          padding: const EdgeInsets.only(left: 10, bottom: 10),
                                          child: Text(
                                            '${document["at"]}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              // fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Color(0xE7FFDCF9),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ))
                            );
                          }).toList(), //akhane
                        ); //vnfjvjvjfhjbjbnbjnbjbnbj n jbn jbn jbn
                      }),
                ],
              ),
            ),
            InkWell(
              onTap: () => {
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
          ],
        ),
      ),
      persistentFooterButtons: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
            child: TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size(185, 30),
                // backgroundColor: Colors.redAccent,
                // primary: Colors.black,
                  primary: Colors.redAccent,
              ),
              onPressed: () {
                showModalBottomSheet(context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    backgroundColor: Color(0xFF203AA4),
                    builder: (context) => uptype()
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Icon(Icons.remove),
                  new Text(' CASH OUT',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),),

            Flexible(
            child: TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size(185, 30),
                // backgroundColor: Colors.tealAccent.shade700,
                // primary: Colors.black,
                primary: Colors.tealAccent.shade700,
              ),
              onPressed: () {
                showModalBottomSheet(context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    backgroundColor: Color(0xFF203AA4),
                    builder: (context) => uptotal()
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Icon(Icons.add),
                  new Text(' CASH IN',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),)
          ],
        ),
      ],
    ),
      onWillPop: () async{
        return false;
      },
    );
  }
  uptotal() {
    TextEditingController _totalController = TextEditingController();
    TextEditingController _coment = TextEditingController();
    return Container(

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
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextFormField(
              controller: _coment,
              decoration: const InputDecoration(
                labelText: "Remark",
                labelStyle: TextStyle(
                  color: Color(0xE7FFDCF9),
                  fontSize: 17,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xE7FFDCF9), width: 1),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextFormField(
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
          ),
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
                  DatabaseManager().totalupload(_totalController.text),
                  DatabaseManager().cashin(_totalController.text, _coment.text),
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

  uptype() {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _amountController = TextEditingController();
    return Container(

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 15),
          const Text(
            "Cash Out",
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
                labelText: "Remark",
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
                  DatabaseManager().cashout(_nameController.text, _amountController.text),
                  Navigator.of(context, rootNavigator: true).pop(),
                  amountUpdate(_amountController.text),
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
      child: Text(
        "YES",
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed:  () {
        DatabaseManager().deletefromlist(doc_id);
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
}
