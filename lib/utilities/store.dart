import 'dart:async';

import 'package:localstore/localstore.dart';

enum StoreCollection { favourite, weather }

abstract class Storable<T> {
  String get docId;
  Map<String, dynamic> toMap();
}

abstract class Store {
  void saveList(
      StoreCollection collection, List<Storable> items, Storable storable);
  void save(StoreCollection collection, Storable item, {String? docId});
  void delete(StoreCollection collection, String id);
  Future<Map<String, dynamic>?> get(StoreCollection collection, String id);
  Future<Map<String, dynamic>?> getList(StoreCollection collection);
  Stream<StoreCollection> stream();
  Future<bool> exist(StoreCollection collection, String id);
}

class AppStore extends Store {
  final LocalstoreImpl db = Localstore.instance;
  final StreamController<StoreCollection> didUpdate = StreamController();

  @override
  void saveList(StoreCollection collection, List<Storable> items,
      Storable storable) async {
    // for (var item in items) {
    //   await db.collection(collection.name).doc(item.docId).set(item.toMap());
    // }
  }

  @override
  void save(StoreCollection collection, Storable item, {String? docId}) async {
    didUpdate.add(collection);
    await db
        .collection(collection.name)
        .doc(docId ?? item.docId)
        .set(item.toMap());
  }

  @override
  void delete(StoreCollection collection, String id) async {
    didUpdate.add(collection);
    await db.collection(collection.name).doc(id).delete();
  }

  @override
  Future<Map<String, dynamic>?> get(StoreCollection collection, String id) {
    return db.collection(collection.name).doc(id).get();
  }

  @override
  Future<Map<String, dynamic>?> getList(StoreCollection collection) {
    return db.collection(collection.name).get();
  }

  @override
  Stream<StoreCollection> stream() {
    return didUpdate.stream;
  }

  @override
  Future<bool> exist(StoreCollection collection, String id) {
    return db
        .collection(collection.name)
        .doc(id)
        .get()
        .then((doc) => doc != null);
  }
}
