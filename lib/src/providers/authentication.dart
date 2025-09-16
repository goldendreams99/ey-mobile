part of employ.provider;

final auth = FirebaseAuth.instance;

class Authentication {
  // final FirebaseAuth auth;

  // Authentication._({
  //   required this.auth,
  // });

  // factory Authentication() {
  //   var _auth = FirebaseAuth.instance;
  //   return Authentication._(auth: _auth);
  // }

  FirebaseAuth get provider {
    return auth;
  }

  Future<String?> signIn(String token) async {
    UserCredential result = await auth.signInWithCustomToken(token);
    User? user = result.user;
    user?.reload();
    return user?.uid;
  }

  Future<String?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    UserCredential result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    User? user = result.user;
    return user?.uid;
  }

  Future<String?> currentId() async {
    User? user = auth.currentUser;
    user?.reload();
    return user?.uid;
  }

  Future<dynamic> me() async {
    // FirebaseUser user = await auth.currentUser();
    // String encoded = await user.getIdToken();
    // var jws = JsonWebSignature.fromCompactSerialization(encoded);
    // var payload = jws.unverifiedPayload;
    // return Me.fromJson(Map.from(jsonDecode(payload.stringContent))
    //   ..addAll(<String, dynamic>{'id': user.uid, 'token': encoded}));
  }

  Future<void> forgotPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  Future<void> changePassword(String password) async {
    User? user = auth.currentUser;
    await user?.updatePassword(password);
    await user?.reload();
  }

  Future<void> signOut() async {
    auth.signOut();
  }
}
