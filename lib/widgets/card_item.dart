import 'dart:io';

import 'package:flutter/material.dart';

class BusinessCard extends StatelessWidget {
  const BusinessCard({
    super.key,
    required this.enteredName,
    required this.jobTitle,
    required this.phoneNumber,
    required this.email,
    required this.location,
    required this.selectedImage,
  });
  final String enteredName;
  final String jobTitle;
  final String phoneNumber;
  final String email;
  final String location;
  final File selectedImage;

  @override
  Widget build(BuildContext context) {
    final deviceData = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        height: deviceData.height * 0.25,
        width: deviceData.width * 0.9,
        child: Card(
          color: Theme.of(context).primaryColor,
          elevation: 10,
          shadowColor: Colors.black54,
          child: Column(children: [
            const SizedBox(height: 10),
            ListTile(
              leading: CircleAvatar(
                radius: 50,
                foregroundImage: FileImage(
                  selectedImage,
                ),
              ),
              title: Text(
                enteredName,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                jobTitle,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5),
              width: deviceData.width * 0.9,
              child: Row(
                children: [
                  const Icon(
                    Icons.phone,
                  ),
                  Text(phoneNumber)
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(5),
              width: deviceData.width * 0.9,
              child: Row(
                children: [
                  const Icon(
                    Icons.email_rounded,
                  ),
                  Text(email)
                ],
              ),
            ),
            Container(
              width: deviceData.width * 0.9,
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                  ),
                  Text(location),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
