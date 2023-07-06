import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get displayName {
    try {
      return _auth.currentUser!.displayName!;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign up with email
  Future<UserCredential> signUpWithEmailAndPassword(
      String displayName, String email, String password) async {
    try {
      //create user in Firebase auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      //update displayname in Firebase auth
      userCredential.user!.updateDisplayName(displayName);
      //create a document with user in Firestore
      _firestore.collection("users").doc(userCredential.user!.uid).set({
        "email": email,
        "displayName": displayName,
        "status": "Hey there! I am using MessageApp",
        "profilePicture": "None",
      });
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
      {String? displayName, String? status, String? downloadURL}) async {
    if (status == null && downloadURL == null && displayName != null) {
      try {
        await _auth.currentUser!.updateDisplayName(displayName);
        await _firestore.collection("users").doc(_auth.currentUser!.uid).set({
          "displayName": displayName,
        }, SetOptions(merge: true));
      } catch (e) {
        throw Exception(e.toString());
      }
    } else if (displayName == null && downloadURL == null && status != null) {
      try {
        await _auth.currentUser!.updateDisplayName(displayName);
        await _firestore.collection("users").doc(_auth.currentUser!.uid).set({
          "status": status,
        }, SetOptions(merge: true));
      } catch (e) {
        throw Exception(e.toString());
      }
    } else if (status == null && displayName == null && downloadURL != null) {
      try {
        await _auth.currentUser!.updateDisplayName(displayName);
        await _firestore.collection("users").doc(_auth.currentUser!.uid).set({
          "profilePicture": downloadURL,
        }, SetOptions(merge: true));
      } catch (e) {
        throw Exception(e.toString());
      }
    } else if (displayName == null && status != null && downloadURL != null) {
      try {
        await _auth.currentUser!.updateDisplayName(displayName);
        await _firestore.collection("users").doc(_auth.currentUser!.uid).set({
          "status": status,
          "profilePicture": downloadURL,
        }, SetOptions(merge: true));
      } catch (e) {
        throw Exception(e.toString());
      }
    } else if (status == null && displayName != null && downloadURL != null) {
      try {
        await _auth.currentUser!.updateDisplayName(displayName);
        await _firestore.collection("users").doc(_auth.currentUser!.uid).set({
          "displayName": displayName,
          "profilePicture": downloadURL,
        }, SetOptions(merge: true));
      } catch (e) {
        throw Exception(e.toString());
      }
    } else if (status != null && displayName != null && downloadURL == null) {
      try {
        await _auth.currentUser!.updateDisplayName(displayName);
        await _firestore.collection("users").doc(_auth.currentUser!.uid).set({
          "displayName": displayName,
          "status": status,
        }, SetOptions(merge: true));
      } catch (e) {
        throw Exception(e.toString());
      }
    } else if (displayName != null && status != null && downloadURL != null) {
      try {
        await _auth.currentUser!.updateDisplayName(displayName);
        await _firestore.collection("users").doc(_auth.currentUser!.uid).set({
          "displayName": displayName,
          "status": status,
          "profilePicture": downloadURL,
        }, SetOptions(merge: true));
      } catch (e) {
        throw Exception(e.toString());
      }
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
