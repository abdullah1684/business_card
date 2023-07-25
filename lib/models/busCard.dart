import 'dart:io';

class BusCard {
  const BusCard({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.phoneNumber,
    required this.location,
    required this.web,
    required this.image,
  });
  final String id;
  final String name;
  final String jobTitle;
  final String phoneNumber;
  final String location;
  final String web;
  final File image;
}
