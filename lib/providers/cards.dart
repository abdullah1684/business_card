import 'package:flutter/material.dart';

import '../models/busCard.dart';

class Cards with ChangeNotifier {
  List<BusCard> _cards = [];

  List<BusCard> get cards {
    return [..._cards];
  }
}
