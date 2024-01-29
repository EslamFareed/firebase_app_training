import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(controller: emailController),
            TextField(controller: passwordController),
            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential data =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  if (data.user != null) {
                    print(data.user!.email);
                  } else {
                    print("error");
                  }
                } catch (e) {
                  print(e.toString());
                }
              },
              child: const Text("Login"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential data = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  if (data.user != null) {
                    print(data.user!.email);
                  } else {
                    print("error");
                  }
                } catch (e) {
                  print(e.toString());
                }
              },
              child: const Text("Create Account"),
            ),
            TextField(controller: phoneController),
            ElevatedButton(
              onPressed: () async {
                FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: phoneController.text,
                  verificationCompleted: (phoneAuthCredential) async {
                    var data = await FirebaseAuth.instance
                        .signInWithCredential(phoneAuthCredential);
                    if (data.user != null) {
                      print("success ${data.user!.phoneNumber}");
                    }
                  },
                  verificationFailed: (error) {
                    print(error.toString());
                  },
                  codeAutoRetrievalTimeout: (verificationId) {
                    print("time out");
                  },
                  codeSent: (verificationId, forceResendingToken) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: SizedBox(
                            width: 200,
                            height: 300,
                            child: Column(
                              children: [
                                TextField(controller: codeController),
                                ElevatedButton(
                                  onPressed: () async {
                                    PhoneAuthCredential credential =
                                        PhoneAuthProvider.credential(
                                      verificationId: verificationId,
                                      smsCode: codeController.text,
                                    );

                                    var data = await FirebaseAuth.instance
                                        .signInWithCredential(credential);
                                    if (data.user != null) {
                                      print(
                                          "success ${data.user!.phoneNumber}");
                                    }
                                  },
                                  child: const Text("Verify Code"),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  timeout: const Duration(seconds: 90),
                );
              },
              child: const Text("Sign in with phone number"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  var data = await signInWithGoogle();

                  if (data.user != null) {
                    print("success ${data.user!.email}");
                  }
                } catch (e) {}
              },
              child: const Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
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

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
