import 'package:flutter/material.dart';

enum InitiativeTypeEnum { computer, science, art }

class MyRadioButton extends StatelessWidget {
  final String title;
  final InitiativeTypeEnum value;
  final InitiativeTypeEnum? initiativeTypeEnum;
  final Function(InitiativeTypeEnum?)? onChanged;

  const MyRadioButton(
      {Key? key,
      required this.title,
      required this.value,
      required this.onChanged,
      required this.initiativeTypeEnum})
      : super(key: key);

  @override
  Widget build(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipOval(
              child: Image.asset(
                "assets/images/defaultImage.png",
                fit: BoxFit.cover,
                width: 40.0,
                height: 40.0,
              ),
            ),
            const SizedBox(width: 40,),
            Text(title),
          ],
        ),
        Radio<InitiativeTypeEnum>(
            value: value, groupValue: initiativeTypeEnum, onChanged: onChanged),
      ],
    );
  }
}
