import 'dart:io';

import 'package:business_card/widgets/card_item.dart';
import 'package:business_card/widgets/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredName = '';
  var _enteredJobTitle = '';
  var _enteredLocation = '';
  var _enteredPhoneNumber = '';
  var _enteredEmail = '';
  var _isCardData = false;
  var _isUploadingCard = false;
  final authUser = FirebaseAuth.instance.currentUser!;
  File? _selectedImage;
  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid && _selectedImage == null) {
      return;
    } else {
      _formKey.currentState!.save();

      setState(() {
        _isUploadingCard = true;
        _isCardData = true;
      });

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${authUser.uid}.jpg');

      await storageRef.putFile(_selectedImage!);
      final imageUrl = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authUser.uid)
          .set({
        'username': _enteredName,
        'jobTitle': _enteredJobTitle,
        'phoneNumber': _enteredPhoneNumber,
        'userLocation': _enteredLocation,
        'email': _enteredEmail,
        'imageUrl': imageUrl,
      });
      setState(() {
        _isUploadingCard = false;
      });
    }
  }

  void _addCard(BuildContext context, Function submit) {
    final deviceSize = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(8),
            width: double.infinity,
            height: deviceSize.height * 0.6,
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    UserImagePicker(onPickImage: (onPickImage) {
                      _selectedImage = onPickImage;
                    }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: deviceSize.width * 0.45,
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              labelText: "Name",
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().length < 3) {
                                return 'Please Enter a valid name';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (newValue) {
                              _enteredName = newValue!;
                            },
                          ),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: deviceSize.width * 0.45,
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              labelText: "Job title",
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().length < 3) {
                                return 'Please Enter a valid job title';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (newValue) {
                              _enteredJobTitle = newValue!;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: deviceSize.width * 0.45,
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              labelText: "phone number",
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().length < 10 &&
                                      value.trim().length > 10) {
                                return 'Please Enter a valid phone number';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (newValue) {
                              _enteredPhoneNumber = newValue!;
                            },
                          ),
                        ),
                        const SizedBox(width: 5),
                        SizedBox(
                          width: deviceSize.width * 0.45,
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              labelText: "location",
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().length < 3) {
                                return 'Please Enter a valid location';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (newValue) {
                              _enteredLocation = newValue!;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: deviceSize.width * 0.9,
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          labelText: "Email",
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().length < 10) {
                            return 'Please Enter a valid email';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (newValue) {
                          _enteredEmail = newValue!;
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    _isUploadingCard
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer),
                            onPressed: () {
                              submit();
                              Navigator.of(context).pop();
                            },
                            child: const Text("Add Card"),
                          ),
                  ],
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout))
          ],
          title: const Text("Your cards"),
        ),
        body: !_isCardData
            ? Center(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Text(
                    "Create your own business card!",
                    style: GoogleFonts.quicksand(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : BusinessCard(
                enteredName: _enteredName,
                jobTitle: _enteredJobTitle,
                phoneNumber: _enteredPhoneNumber,
                email: _enteredEmail,
                location: _enteredLocation,
                selectedImage: _selectedImage!,
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addCard(context, _submit),
          child: const Icon(Icons.add_card),
        ));
  }
}
