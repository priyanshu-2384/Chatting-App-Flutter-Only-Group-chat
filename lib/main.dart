import 'package:blink_talk/screens/authentication_screen.dart';
import 'package:blink_talk/screens/chat_screen.dart';
import 'package:blink_talk/screens/loading_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'BlinkTalk',
        theme: ThemeData().copyWith(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 63, 17, 177)),
        ),
        //Stream Builder is like a future builder, it listens to a stream an then according to that we can display different Screens for different stream values
        home: StreamBuilder(
          /*here we are listening to our firebase.instance.authStateChanges() , this will give us details of user,
           for example if a user has logged in or signed up , in the backend user's data is stored than backend 
           creates a token and store it on user's device, so if the token is stored in user's device it 
           means user has logged in past, therefore we will show our chatScreen, else will sow auth screen*/
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen(); //If we are taking some time to get data of snapshot
            }
            if (snapshot.hasData) {
              //has token on user's device
              return const ChatScreen();
            }
            return const AuthenticationScreen();
          },
        ));
  }
}
