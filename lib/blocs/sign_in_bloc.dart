import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackbangla/core/utils/initial_bindings.dart';

class SignInBloc extends ChangeNotifier {
  SignInBloc() {
    checkSignIn();
    checkGuestUser();
    initPackageInfo();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googlSignIn = new GoogleSignIn();
  final String defaultUserImageUrl =
      'https://www.seekpng.com/png/detail/115-1150053_avatar-png-transparent-png-royalty-free-default-user.png';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool _guestUser = false;
  bool get guestUser => _guestUser;

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;

  bool _hasError = false;
  bool get hasError => _hasError;

  bool isEmailVerified = false;

  late String _errorCode;
  String get errorCode => _errorCode;

  late String _name;
  String get name => _name;

  late String _uid;
  String get uid => _uid;

  late String _email;
  String get email => _email;

  late String _imageUrl;
  String get imageUrl => _imageUrl;

  late String _joiningDate;
  String get joiningDate => _joiningDate;

  late String _signInProvider;
  String get signInProvider => _signInProvider;

  //late String timestamp;

  String _appVersion = '0.0';
  String get appVersion => _appVersion;

  String _packageName = '';
  String get packageName => _packageName;

  Future setName(String name) async {
    _name = name;
  }

  Future setEmail(String email) async {
    _email = email;
  }

  Future setImageUrl(String imageUrl) async {
    _imageUrl = imageUrl;
  }

  Future setUid(String uid) async {
    _uid = uid;
  }

  Future setSignInProvider(String signInProvider) async {
    _signInProvider = signInProvider;
  }

  void initPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appVersion = packageInfo.version;
    _packageName = packageInfo.packageName;
    notifyListeners();
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googlSignIn
        .signIn()
        .catchError((error) => print('error : $error'));
    if (googleUser != null) {
      try {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        User userDetails =
            (await _firebaseAuth.signInWithCredential(credential)).user!;

        _name = userDetails.displayName!;
        _email = userDetails.email!;
        _imageUrl = userDetails.photoURL!;
        _uid = userDetails.uid;
        _signInProvider = 'google';

        _hasError = false;
        notifyListeners();
      } catch (e) {
        _hasError = true;
        _errorCode = e.toString();
        notifyListeners();
      }
    } else {
      _hasError = true;
      notifyListeners();
    }
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        _uid = user.uid;
        _signInProvider = 'email';
        _hasError = false;
        isEmailVerified = user.emailVerified;
        notifyListeners();
        return user;
      } else {
        _hasError = true;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _hasError = true;
      _errorCode = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.updatePassword(newPassword);
    } else {
      throw Exception('No user is currently signed in.');
    }
  }

  Future<bool> checkUserExists() async {
    DocumentSnapshot snap = await firestore.collection('users').doc(_uid).get();
    if (snap.exists) {
      print('User Exists');
      return true;
    } else {
      print('new user');
      return false;
    }
  }

  Future saveToFirebase() async {
    final DocumentReference ref =
        FirebaseFirestore.instance.collection('users').doc(_uid);
    var userData = {
      'name': _name,
      'email': _email,
      'uid': _uid,
      'sign_in_provider': _signInProvider,
      'image url': _imageUrl,
      'joining date': _joiningDate,
      'loved blogs': [],
      'loved places': [],
      'bookmarked blogs': [],
      'bookmarked places': []
    };
    await ref.set(userData);
  }

  Future getJoiningDate() async {
    DateTime now = DateTime.now();
    String _date = DateFormat('dd-MM-yyyy').format(now);
    _joiningDate = _date;
    notifyListeners();
  }

  Future saveDataToSP() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    await sp.setString('name', _name);
    await sp.setString('email', _email);
    await sp.setString('image_url', _imageUrl);
    await sp.setString('uid', _uid);
    await sp.setString('joining_date', _joiningDate);
    await sp.setString('sign_in_provider', _signInProvider);
  }

  Future getDataFromSp() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _name = sp.getString('name') ?? '';
    _email = sp.getString('email') ?? '';
    _imageUrl = sp.getString('image_url') ?? '';
    _uid = sp.getString('uid') ?? '';
    _joiningDate = sp.getString('joining_date') ?? '';
    _signInProvider = sp.getString('sign_in_provider') ?? '';
    notifyListeners();
  }

  Future getUserDatafromFirebase(uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        _name = documentSnapshot['name'];
        _email = documentSnapshot['email'];
        _imageUrl = documentSnapshot['image url'];
        _uid = documentSnapshot['uid'];
        _joiningDate = documentSnapshot['joining date'];
        //_signInProvider = documentSnapshot['sign_in_provider']!;
      }
    });
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('signed_in', true);
    _isSignedIn = true;
    notifyListeners();
  }

  void checkSignIn() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _isSignedIn = sp.getBool('signed_in') ?? false;
    notifyListeners();
  }

  Future userSignout() async {
    await _firebaseAuth.signOut();
    await _googlSignIn.signOut();
    await clearAllData();
    _isSignedIn = false;
    _guestUser = false;
    InitialBindings().dependencies();
    notifyListeners();
  }

  Future setGuestUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('guest_user', true);
    _guestUser = true;
    notifyListeners();
  }

  void checkGuestUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    _guestUser = sp.getBool('guest_user') ?? false;
    notifyListeners();
  }

  Future clearAllData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.clear();
  }

  Future guestSignout() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('guest_user', false);
    _guestUser = false;
    notifyListeners();
  }

  Future updateUserProfile(String newName, String newImageUrl) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .update({'name': newName, 'image url': newImageUrl});

    sp.setString('name', newName);
    sp.setString('image url', newImageUrl);
    _name = newName;
    _imageUrl = newImageUrl;

    notifyListeners();
  }

  Future<int> getTotalUsersCount() async {
    final String fieldName = 'count';
    final DocumentReference ref =
        firestore.collection('item_count').doc('users_count');
    DocumentSnapshot snap = await ref.get();
    if (snap.exists == true) {
      int itemCount = snap[fieldName] ?? 0;
      return itemCount;
    } else {
      await ref.set({fieldName: 0});
      return 0;
    }
  }

  Future increaseUserCount() async {
    await getTotalUsersCount().then((int documentCount) async {
      await firestore
          .collection('item_count')
          .doc('users_count')
          .update({'count': documentCount + 1});
    });
  }
}
