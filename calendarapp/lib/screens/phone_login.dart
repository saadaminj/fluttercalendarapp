import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = "";
  String _phoneNumber = "";
  String _smsCode = "";

  void _verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Automatically sign in the user
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
        print(e.toString());
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  void _signInWithPhoneNumber() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsCode,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Navigate to the home screen or whatever screen after login
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      print('Failed to sign in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phone Authentication')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.phone,
              decoration:
                  InputDecoration(labelText: 'Phone number (+x xxx-xxx-xxxx)'),
              onChanged: (value) {
                _phoneNumber = value;
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _verifyPhoneNumber,
              child: Text('Verify Phone Number'),
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'SMS Code'),
              onChanged: (value) {
                _smsCode = value;
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _signInWithPhoneNumber,
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
