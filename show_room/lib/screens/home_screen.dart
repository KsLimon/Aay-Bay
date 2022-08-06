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
    print(formattedDate);
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
    return Scaffold(
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
                            );
                          }).toList(), //akhane
                        ); //vnfjvjvjfhjbjbnbjnbjbnbj n jbn jbn jbn
                      }),
                ],
              ),
            ),
            GestureDetector(
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
            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size(185, 30),
                // backgroundColor: Colors.redAccent,
                // primary: Colors.black,
                  primary: Colors.redAccent,
              ),
              onPressed: () {},
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
            ),

            TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size(185, 30),
                // backgroundColor: Colors.tealAccent.shade700,
                // primary: Colors.black,
                primary: Colors.tealAccent.shade700,
              ),
              onPressed: () {
                showDialog(
                  barrierColor: Colors.black26,
                  context: context,
                  builder: (context) {
                    return uptotal();
                  },
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
            ),
          ],
        ),
      ],
    );
  }
  uptotal() {
    TextEditingController _totalController = TextEditingController();
    return Dialog(
      elevation: 0,
      backgroundColor: Color(0xFF223A7E),
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
}
