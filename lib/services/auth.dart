
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tmu_direct/services/storage_methods.dart';
import 'firebase_services.dart';
import 'package:tmu_direct/model/user.dart' as model;
class Auth {

  FirebaseServices firebaseServices = FirebaseServices();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
    await _firestore.collection('users_data').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  Future<String> addUserDatatoDb({required var email,
    required var first_name,    required var last_name,
    required var bio,
    required Uint8List file}) async {
    String res = "Some error Occurred";
    try {
      if (first_name.isNotEmpty || last_name.isNotEmpty ||
          bio.isNotEmpty ) {

        String photoUrl =
        await StorageMethods().uploadImageToStorage('profilePics', file, false);
        model.User _user = model.User(
          username: first_name,
          uid: _auth.currentUser!.uid,
          photoUrl: photoUrl,
          email: email,
          bio: bio,
          followers: [],
          following: [],
        );

        // adding user in our database
        await _firestore
            .collection("users")
            .doc(_auth.currentUser!.uid)
            .set(_user.toJson());

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<String> signUpUser({
    required String email,
    required String password,

  }) async {
    String res = "Some error Occurred";
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty
      ) {
        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
        // addUserDatatoDb(email: email, password: password,
        //     username: username, bio: bio, file: file, cred: cred);

        // adding user in our database
      }
    } catch (err) {
      return err.toString();
    }
    return res;

  }


  Future<void> signOut() async {
    await _auth.signOut();
  }



  }

