import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DatabaseManager{

  late String Bill;
  late String wallet;
  late String dates;
  late String Bazar;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future dataload() async {
    final User? user = auth.currentUser!;
    wallet = 'Users/${user?.email}/Total';
    final CollectionReference col = FirebaseFirestore.instance.collection(wallet);

    List itemlist = [];
    try{
      await col.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemlist.add(element.data());
        });
      });
      return itemlist;
    } catch (e){
      print(e.toString());
      return null;
    }
  }

  Future catload() async {
    final User? user = auth.currentUser!;
    wallet = 'Users/${user?.email}/dates';
    final CollectionReference col = FirebaseFirestore.instance.collection(wallet);

    List itemlist = [];
    try{
      await col.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemlist.add(element.data());
        });
      });
      return itemlist;
    } catch (e){
      print(e.toString());
      return null;
    }
  }

  Future dataupload(var id) async {
    final User? user = auth.currentUser!;
    Bill = 'Users/${user?.email}/Bills';
    wallet = 'Users/${user?.email}/Total';

    dynamic username = await displayname();

    var collection = FirebaseFirestore.instance.collection(Bill).doc(id);
    var totalcollection = FirebaseFirestore.instance.collection(wallet).doc('123A');
    var querySnapshot = await collection.get();
    Map<String, dynamic>? data = querySnapshot.data();
    var amount = data!['amount'];
    dynamic total = await dataload();
    var totalamount = total[0]['amount'] - amount;

    Map<String, dynamic> tamountmap = {
      "amount": totalamount
    };

    Map<String, dynamic> cost = {
      "Name": data['Name'],
      "amount": amount,
      "pay": "paid",
      "Paid by": username,
    };

    totalcollection.set(tamountmap).whenComplete(() => {});
    collection.set(cost).whenComplete(() => {});
  }

  Future displayname() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser!;
    var col = FirebaseFirestore.instance.collection('Users').doc(user?.email);
    var querySnapshot = await col.get();
    Map<String, dynamic>? data = querySnapshot.data();
    var name = data!['Name'];
    return name;
  }

  Future totalupload(var amount) async {
    final User? user = auth.currentUser!;
    wallet = 'Users/${user?.email}/Total';
    var totalcollection = FirebaseFirestore.instance.collection(wallet).doc('123A');
    dynamic total = await dataload();
    var totalamount;
    if (total.length != 0){
      totalamount = total[0]['amount']  + int.parse(amount);
    }
    else{
      totalamount  = int.parse(amount);
    }

    Map<String, dynamic> tamountmap = {
      "amount": totalamount
    };
    totalcollection.set(tamountmap).whenComplete(() => {});
  }

  Future categoryupload(var name, var amount) async {
    final User? user = auth.currentUser!;
    Bill = 'Users/${user?.email}/Bills';
    var collection = FirebaseFirestore.instance.collection(Bill).doc();

    Map<String, dynamic> tamountmap = {
      "Name": name,
      "amount": int.parse(amount),
      "pay": "due",
      "Paid by": "Limon",
    };
    collection.set(tamountmap).whenComplete(() => {});
  }

  Future deletecat(var id) async{
    final User? user = auth.currentUser!;
    Bill = 'Users/${user?.email}/Bills';
    var collection = FirebaseFirestore.instance.collection(Bill);
    await collection.doc(id).delete();
  }

  Future cashin(var amount, var comment) async {
    final User? user = auth.currentUser!;
    wallet = 'Users/${user?.email}/dates';
    var totalcollection = FirebaseFirestore.instance.collection(wallet).doc();

    DateTime now = DateTime.now();
    var formattedDate = DateFormat('d,MMM HH:mm a').format(now);

    Map<String, dynamic> tamountmap = {
      "amount": amount,
      "Type": 1,
      "comment": comment,
      "at": formattedDate,
    };
    totalcollection.set(tamountmap).whenComplete(() => {});
  }

  Future cashout(var name, var amount) async {
    final User? user = auth.currentUser!;

    dates = 'Users/${user?.email}/dates';
    wallet = 'Users/${user?.email}/Total';
    var totaldates = FirebaseFirestore.instance.collection(dates).doc();
    var totalcollection = FirebaseFirestore.instance.collection(wallet).doc('123A');
    dynamic total = await dataload();
    var amnt = int.parse(amount);
    var totalamount = total[0]['amount'] - amnt;

    DateTime now = DateTime.now();
    var formattedDate = DateFormat('d,MMM HH:mm a').format(now);
    Map<String, dynamic> cash = {
      "amount": amount,
      "Type": 0,
      "comment": name,
      "at": formattedDate,
    };


    Map<String, dynamic> tamountmap = {
      "amount": totalamount
    };

    totalcollection.set(tamountmap).whenComplete(() => {});
    totaldates.set(cash).whenComplete(() => {});
  }

  Future selectedcashout(var name, var amount) async {
    final User? user = auth.currentUser!;
    wallet = 'Users/${user?.email}/dates';
    var totalcollection = FirebaseFirestore.instance.collection(wallet).doc();

    DateTime now = DateTime.now();
    var formattedDate = DateFormat('d,MMM HH:mm a').format(now);

    Map<String, dynamic> tamountmap = {
      "amount": amount,
      "Type": 0,
      "comment": name,
      "at": formattedDate,
    };
    totalcollection.set(tamountmap).whenComplete(() => {});
  }

  Future deletefromlist(var id) async{
    final User? user = auth.currentUser!;
    Bill = 'Users/${user?.email}/dates';
    var collection = FirebaseFirestore.instance.collection(Bill);
    await collection.doc(id).delete();
  }

  //BAZAR PAGE DATABASE

  Future bazarupload(var amount, var id, var name, var count) async {
    final User? user = auth.currentUser!;
    wallet = 'Users/${user?.email}/bazar';
    var bazarcollection = FirebaseFirestore.instance.collection(wallet).doc(id);

    Map<String, dynamic> tamountmap = {
      "name": name,
      "check": true,
      "value": amount,
      "count": count,
    };
    bazarcollection.set(tamountmap).whenComplete(() => {});
  }
  Future undobazar(var amount, var id, var name, var count) async {
    final User? user = auth.currentUser!;
    wallet = 'Users/${user?.email}/bazar';
    var bazarcollection = FirebaseFirestore.instance.collection(wallet).doc(id);

    Map<String, dynamic> tamountmap = {
      "name": name,
      "check": false,
      "value": amount,
      "count": count,
    };
    bazarcollection.set(tamountmap).whenComplete(() => {});
  }

  Future addto_bazar(var name, var amount, var count) async {
    final User? user = auth.currentUser!;
    Bazar = 'Users/${user?.email}/bazar';
    var collection = FirebaseFirestore.instance.collection(Bazar).doc();

    Map<String, dynamic> tamountmap = {
      "name": name,
      "value": int.parse(amount),
      "check": false,
      "count": count,

    };
    collection.set(tamountmap).whenComplete(() => {});
  }
  Future deletebazar(var id) async{
    final User? user = auth.currentUser!;
    Bazar = 'Users/${user?.email}/bazar';
    var collection = FirebaseFirestore.instance.collection(Bazar);
    await collection.doc(id).delete();
  }
}