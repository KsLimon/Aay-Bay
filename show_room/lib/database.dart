import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager{

  late String Bill;
  late String wallet;

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
}