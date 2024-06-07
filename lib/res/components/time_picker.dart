import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomTextFieldTime extends StatelessWidget {
  final String hint;
  final TextEditingController textController;
  final Function()? onPressed;

  CustomTextFieldTime({required this.hint, required this.textController, this.onPressed});

  void selectTime(BuildContext context) {
    showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        }).then((pickedTime) {
      if (pickedTime != null) {
        final formattedTime = DateFormat.Hm().format(DateTime(2022, 1, 1, pickedTime.hour, pickedTime.minute));
        textController.text = formattedTime;
      }
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
        onPressed!();
        selectTime(context);
      },
    );
  }
}