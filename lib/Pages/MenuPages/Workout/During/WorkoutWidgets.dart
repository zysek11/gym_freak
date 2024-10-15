import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class TrainingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;

  const TrainingButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color(0xFF2A8CBB),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.black, width: 2),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon, color: Colors.black),
              if (icon != null) SizedBox(width: 10), // Dodaj odstęp, jeśli jest ikona
              Text(
                text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontFamily: 'Jaapokki',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
