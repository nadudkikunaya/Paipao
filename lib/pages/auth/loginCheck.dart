import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:paipao/pages/mainWrapper.dart';

import 'login.dart';

// This widget just check the status of the user, if the user is already logged in from past sessions, and take them to appropiate pages.
// TODO: Splash screen (https://docs.flutter.dev/development/ui/advanced/splash-screen)

// You can't just push to the navigator before the return of the build method. (cause an exception: setState() or markNeedsBuild() called during build.)
// First, I found this: https://stackoverflow.com/questions/59804090/how-to-navigate-in-flutter-during-widget-build (Future.microtask)
// but I think this is more elegant: https://stackoverflow.com/questions/65150258/flutter-push-navigator-route-in-build-method (initState --> addPostFrameCallback)
class LoginCheck extends StatefulWidget {
  const LoginCheck({super.key});

  @override
  State<LoginCheck> createState() => _LoginCheckState();
}

class _LoginCheckState extends State<LoginCheck> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Originally wanted to use listener, but I can't wrap my mind around it
      // A listener than will activate when there is an auth state change (https://firebase.google.com/docs/auth/flutter/manage-users)
      // var authListener = FirebaseAuth.instance
      //     .authStateChanges()
      //     .listen((User? user) {
      //       if (user != null) { // If the user is logged in
      //         print('Logged in: ${user.uid}', user.uid);
      //       } else {
      //         print('Not logged in');
      //       }
      //     });
      // Do something ???
      // await authListener.cancel();
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainWrapper()),
        );
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}