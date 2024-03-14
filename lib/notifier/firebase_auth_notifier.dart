import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthNotifier extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  ValueNotifier _userCredential = ValueNotifier('');

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  bool _isEmail = false;
  bool _isPhone = false;
  bool _isGoogle = false;
  bool _options = true;

  String _errorMessage = '';
  String _verificationId = '';

  Future<void> verifyPhoneNumber() async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Verification Failed: $e');
        },
        codeSent: (String verificationId, int? resendToken) {
          verificationId = verificationId;
          print('Code Sent to $phoneController');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
        },
      );
    } catch (e) {
      print('Error during phone number verification: $e');
    }
  }

  Future<void> signInWithPhoneNumber() async {
    print('id $verificationId');
    print('id ${phoneController.text}');
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: phoneController.text,
      );
      print('credential check');
      userCredential.value = await auth.signInWithCredential(credential);
      print('Phone number authenticated');
    } catch (e) {
      print('Error during phone number verification: $e');
    }
  }

  Future<dynamic> signInWithGoogle() async {
    print('call signin');
    try {

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken,
          accessToken: googleAuth?.accessToken
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      // TODO
      print('exception issue-> $e');
    }
  }

  Future<bool> signOutFromGoogle() async {
    try {
      FirebaseAuth.instance.signOut();
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  emailSignIn() async {
    String email = emailController.text;
    String password = passController.text;

    if (email == '') {
      errorMessage = 'Enter email ';
    } else if (password == '') {
      errorMessage = 'Enter password';
    } else {
      try {
        userCredential.value = await auth
            .signInWithEmailAndPassword(
            email: email, password: password);
        emailController.clear();
        passController.clear();
        print(
            'Signed up: ${userCredential.value.user!.uid}');
      } catch (e) {
        if (e is FirebaseAuthException) {
          // Handle FirebaseAuthException
          errorMessage = e.message ?? '';
          print('exception error ${e.message}');
        } else {
          // Handle other exceptions
          print('exception error $e');
        }
      }
    }
  }

  emailSignUp() async {
    String email = emailController.text;
    String password = passController.text;

    if (email == '') {
      errorMessage = 'Enter email ';
    } else if (password == '') {
      errorMessage = 'Enter password';
    } else {
      try {
        userCredential.value = await auth
            .createUserWithEmailAndPassword(
            email: email, password: password);
        emailController.clear();
        passController.clear();
        print(
            'Signed up: ${userCredential.value.user!.uid}');
      } catch (e) {
        if (e is FirebaseAuthException) {
          // Handle FirebaseAuthException
          errorMessage = e.message ?? '';
          print('exception error ${e.message}');
        } else {
          // Handle other exceptions
          print('exception error $e');
        }
      }
    }
  }

  FirebaseAuth get auth => _auth;

  set auth(FirebaseAuth value) {
    _auth = value;
    notifyListeners();
  }

  ValueNotifier get userCredential => _userCredential;

  set userCredential(ValueNotifier value) {
    _userCredential = value;
    notifyListeners();
  }

  TextEditingController get emailController => _emailController;

  set emailController(TextEditingController value) {
    _emailController = value;
    notifyListeners();
  }

  TextEditingController get passController => _passController;

  set passController(TextEditingController value) {
    _passController = value;
    notifyListeners();
  }

  TextEditingController get phoneController => _phoneController;

  set phoneController(TextEditingController value) {
    _phoneController = value;
    notifyListeners();
  }

  String get errorMessage => _errorMessage;

  set errorMessage(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  bool get isEmail => _isEmail;

  set isEmail(bool value) {
    _isEmail = value;
    notifyListeners();
  }

  get isPhone => _isPhone;

  set isPhone(value) {
    _isPhone = value;
    notifyListeners();
  }

  get isGoogle => _isGoogle;

  set isGoogle(value) {
    _isGoogle = value;
    notifyListeners();
  }

  bool get options => _options;

  set options(bool value) {
    _options = value;
    notifyListeners();
  }

  String get verificationId => _verificationId;

  set verificationId(String value) {
    _verificationId = value;
    notifyListeners();
  }
}