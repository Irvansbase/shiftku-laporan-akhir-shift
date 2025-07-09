import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Category {
  String name;
  bool isCurrency;
  List<TextEditingController> controllers;

  Category({
    required this.name,
    this.isCurrency = false,
  }) : controllers = List.generate(6, (index) => TextEditingController());
}

class ShiftData {
  int target;
  int actual;

  ShiftData({required this.target, required this.actual});
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final cleanText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanText.isEmpty) {
      return const TextEditingValue();
    }

    final number = int.tryParse(cleanText) ?? 0;
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: '',
      decimalDigits: 0,
    );

    String formattedText = formatter.format(number).trim();
    formattedText = formattedText.replaceAll(',', '.');

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}