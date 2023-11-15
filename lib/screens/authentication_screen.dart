import 'dart:io';

import 'package:blink_talk/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthenticationScreen();
  }
}

class _AuthenticationScreen extends State<AuthenticationScreen> {
  File? _selectedImage;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  final _formKey = GlobalKey<
      FormState>(); //creating a form key which can be used to control and access many things of forms
  var _isLogin = true;
  var _isAuthenticating = false;

  void _onSubmit() async {
    bool isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    if (!_isLogin) {
      //showing error message on snackbar if image is not selected
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please Upload your image')));
        return;
      }
    }
    _formKey.currentState!
        .save(); //this will trigger all the onSaved functions of all input fields
    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        // creating new users
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        //we have to access our firebase projects storage section
        //therefore creating or getting an object from firebase storage
        final storageRef = FirebaseStorage.instance
            .ref() //getting access to our projects storage
            .child(
                'user-images') //getting access to our userimages folder in it(if not exists will be created by firebase)
            .child(
                '${userCredentials.user!.uid}.jpg'); //getting access or creating an file jpg whose name is usercredentials unique id
        await storageRef
            .putFile(_selectedImage!); //storing our image in that location
        final imageUrl = await storageRef
            .getDownloadURL(); //getting the url of our uploaded image for future use

        await FirebaseFirestore
            .instance //Creating object in a database where we will store all the user's data
            .collection('users') //Created or accessed user's collection
            .doc(userCredentials.user!.uid)
            .set({
          //creatsed//accessed a user with its userCredential id as a name
          'username':
              _enteredUsername, //setting the data which we want to store in that user's id
          'email': _enteredEmail,
          'imageUrl': imageUrl
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {}
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authentication Failed')));
    }
    setState(() {
      _isAuthenticating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 30, bottom: 20, left: 20, right: 20),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                        key: _formKey, //assigning a global form key
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!_isLogin)
                              UserImagePicker(
                                onPickImage: (pickedImage) {
                                  _selectedImage =
                                      pickedImage; //getting our image from imagePicker widget
                                },
                              ), //If signing up then showing image picker
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Email Address'),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return 'Please Enter a valid Email Address';
                                } //Validating user input
                                return null;
                              },
                              onSaved: (value) {
                                _enteredEmail =
                                    value!; //saving email in our variable
                              },
                            ),
                            if (!_isLogin)
                              TextFormField(
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length < 4) {
                                    return 'Please enter at least 4 characters';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                ),
                                enableSuggestions: false,
                                onSaved: (newValue) {
                                  _enteredUsername = newValue!;
                                },
                              ),
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Password'),
                              obscureText:
                                  true, //Hides the character when you type
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return 'Password must be atleast 6 characters long';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredPassword =
                                    value!; //saving password in our variable
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            if (_isAuthenticating)
                              const CircularProgressIndicator(),
                            if (!_isAuthenticating)
                              ElevatedButton(
                                  onPressed: _onSubmit,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer),
                                  child: Text(_isLogin ? 'Login' : 'Sign Up')),
                            if (!_isAuthenticating)
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isLogin = !_isLogin;
                                    });
                                  },
                                  child: Text(_isLogin
                                      ? 'Create an Account'
                                      : 'I Already Have an Account'))
                          ],
                        )),
                  ),
                ),
              )
            ]),
          ),
        ));
  }
}
