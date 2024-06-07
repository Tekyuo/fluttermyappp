import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomTextFieldDate extends StatelessWidget {
  final String hint;
  final TextEditingController textController;
  final Function()? onPressed;

  CustomTextFieldDate({required this.hint, required this.textController, this.onPressed});

  void selectDate(BuildContext context) {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2024, 12, 31)).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      textController.text = DateFormat.yMd().format(pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      decoration: InputDecoration(
        hintText: hint,
      ),
      onTap: () {
        selectDate(context);
      },
    );
  }
}