part of employ.provider;

final FirebaseStorage storage = FirebaseStorage.instance;

class Storage {
  Future<void> upload(
    String path,
    String ref,
    ValueChanged<String> success,
  ) async {
    File file = File(path);
    UploadTask task = storage.ref().child(ref).putFile(file);
    await task.then((t) async {
      String url = await t.ref.getDownloadURL();
      success(url);
    });
  }
}
