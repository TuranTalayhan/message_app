import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DatabaseService {
  final FirebaseAuth _auth;

  final FirebaseFirestore _firestore;

  DatabaseService(this._auth, this._firestore);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  //sign up with email
  Future<UserCredential> signUpWithEmailAndPassword(
      String displayName, String email, String password) async {
    try {
      //create user in Firebase auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      //create a document with user in Firestore
      _firestore.collection("users").doc(userCredential.user!.uid).set({
        "email": email,
        "displayName": displayName,
        "status": "Hey there! I am using MessageApp",
        "profilePicture": null,
        "contacts": null,
      }, SetOptions(merge: true));
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign in with email
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign in with Google account
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> updateInfo(
      {String? displayName, String? status, String? profilePicture}) async {
    DocumentReference ref =
        _firestore.collection("users").doc(_auth.currentUser!.uid);
    if (displayName != null) {
      await updateDisplayName(ref, displayName);
    }
    if (status != null) {
      await updateStatus(ref, status);
    }
    if (profilePicture != null) {
      await updateProfilePicture(ref, profilePicture);
    }
  }

  Future<void> updateDisplayName(
      DocumentReference ref, String displayName) async {
    try {
      await ref.set({
        "displayName": displayName,
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateStatus(DocumentReference ref, String status) async {
    try {
      await ref.set({
        "status": status,
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateProfilePicture(
      DocumentReference ref, String profilePicture) async {
    try {
      await ref.set({
        "profilePicture": profilePicture,
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void changeEmail(String newEmail) {
    try {
      _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .set({"email": newEmail});
      _auth.currentUser!.updateEmail(newEmail);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void changePassword(String newPassword) {
    try {
      _auth.currentUser!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
}
