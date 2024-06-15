import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: size.height,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: size.height * 0.53,
                width: size.width,
                decoration: const BoxDecoration(
                    color: Colors.amber,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey, spreadRadius: 1, blurRadius: 15)
                    ],
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Lottie.asset('assets/animations/reminder.json',
                    fit: BoxFit.contain, width: 400, height: 400, repeat: true),
              ),
            ),
            Positioned(
                top: size.height * 0.6,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    children: [
                      const Text(
                        "Welcome to \nyour Reminder App",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.black,
                            height: 1.2),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        "Never miss a moment. Your tasks, our reminders",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            color: Colors.amber,
                            height: 1.2),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          height: size.height * 0.08,
                          width: size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.white)),
                          child: SignInButton(
                            Buttons.google,
                            text: "Sign up with Google",
                            onPressed: () async {
                              await signInWithGoogle();
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      print(credential);

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e); // Handle the error
      return null;
    }
  }
}
