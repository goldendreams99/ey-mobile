part of employ.provider;

final FirebaseDatabase _database = FirebaseDatabase.instance;

class Database {
  FirebaseDatabase get admin => _database;

  void init() {
    // _database.setPersistenceEnabled(true);
    // _database.setPersistenceCacheSizeBytes(10000000);
  }

  Future<dynamic> once(String ref) async {
    DatabaseReference reference = _database.ref().child(ref);
    return (await reference.once()).snapshot.value?.toDynamic();
  }

  Future<void> remove(String ref) async {
    DatabaseReference reference = _database.ref().child(ref);
    await reference.remove();
  }

  Future<void> update(String ref, Map<String, dynamic> data) async {
    DatabaseReference db = _database.ref().child(ref);
    await db.update(data);
  }

  Future<void> setData(String ref, dynamic data) async {
    DatabaseReference db = _database.ref().child(ref);
    await db.set(data);
  }

  Future<String?> push(String ref, dynamic data) async {
    DatabaseReference db = _database.ref().child(ref);
    DatabaseReference newDb = db.push();
    await newDb.set(Map.from(data)..addAll({'id': newDb.key}));
    return newDb.key;
  }

  Future<void> put(String ref, dynamic data) async {
    DatabaseReference db = _database.ref().child(ref);
    await db.set(data);
  }

  Future<Stream<DatabaseEvent>> getStream(String ref) async {
    DatabaseReference dbRef = _database.ref().child(ref);
    await dbRef.keepSynced(true);
    return dbRef.onValue;
  }
}
