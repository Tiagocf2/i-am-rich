import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class Stats extends ChangeNotifier {
  int mpsInterval = 150;
  double _money = 0;
  int clicks = 0;
  int tapValue = 1;
  int mps = 0;

  Stats() {
    fireTimer();
  }

  final Map<int, Item> items = {};

  void addItems(List<Item> list) {
    for (Item item in list) {
      items[item.id] = item;
    }
    calculateValues();
  }

  void calculateValues() {
    //TODO: do stuff
    double mps = 0;
    double tapValue = 1;
    items.forEach((_, item) {
      mps += item.moneyPerSecond * item.amount;
      tapValue += item.tapPower * item.amount;
    });

    this.mps = mps.round();
    this.tapValue = tapValue.round();
    notifyListeners();
  }

  void tap() {
    clicks++;
    _money += tapValue;
    notifyListeners();
  }

  bool upgrade(itemId, {int? amount, double? multiplier}) {
    Item? item = items[itemId];
    if (item == null) return false;

    if (amount != null) {
      double? leftovers = item.buy(_money, amount);
      if (leftovers == null) return false;
      _money = leftovers;
    }
    calculateValues();
    return true;
  }

  void addMPS(timer) {
    _money += mps / (1000 / mpsInterval);
    notifyListeners();
  }

  void fireTimer() {
    Timer.periodic(Duration(milliseconds: mpsInterval), addMPS);
  }

  int get money {
    return _money.round();
  }

  bool canAfford(int id) {
    if (items.containsKey(id)) {
      return money >= items[id]!.price;
    }
    throw Exception("ID inválido");
  }
}

abstract class Item {
  static int availableId = 0;
  late int id;
  late String name;
  late String description;
  late int value;
  double moneyPerSecond = 0;
  double priceMultiplier = 0.3;
  int tapPower = 0;
  int amount = 0;

  Item(this.name, this.description, this.value,
      {double? mps, int? tapPower, double? priceMultiplier}) {
    id = Item.availableId++;
    if (mps != null) {
      moneyPerSecond = mps;
    }
    if (priceMultiplier != null) {
      this.priceMultiplier = priceMultiplier;
    }
    if (tapPower != null) {
      this.tapPower = tapPower;
    }
  }

  double? buy(double money, int quantity) {
    // double multiplier =
    //     (1 + (amount * pow(priceMultiplier, quantity) as double));
    // int price = ((value * quantity) * multiplier).toInt();
    final currentPrice = price;
    if (money < currentPrice) return null;
    amount++;
    return money - currentPrice;
  }

  int get price {
    double multiplier = pow(1 + priceMultiplier, amount) as double;
    return (value * multiplier).toInt();
  }
}

class Tap extends Item {
  static late int ID;
  Tap() : super('Tap', 'Increases tap power by 1', 20, tapPower: 1) {
    ID = id;
  }
}

class Clicker extends Item {
  static late int ID;
  Clicker()
      : super(
          'Clicker',
          'Generates \$1 per second',
          50,
          mps: 1,
          priceMultiplier: 0.18,
        ) {
    ID = id;
  }
}

class Farm extends Item {
  static late int ID;
  Farm()
      : super(
          'Farm',
          'Generates \$100 per second',
          2000,
          mps: 100,
          priceMultiplier: 0.5,
        ) {
    ID = id;
  }
}
