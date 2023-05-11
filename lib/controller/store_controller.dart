import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pororo/controller/database.dart';

import '../models/store.dart';

class StoreController {
  CollectionReference store = Database.firestore.collection('sellers');

  Future<Store> getStore(String id) async {
    final result = await store.doc(id).get();
    Store data = Store.fromSnapshot(result);

    return data;
  }

  Future<Store> getFirstStore() async {
    final result = await store.limit(1).get();
    Store data = Store.fromSnapshot(result.docs.first);

    return data;
  }
}
