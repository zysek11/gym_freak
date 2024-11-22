import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class TrainingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? textColor;

  const TrainingButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon, this.textColor,
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
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontFamily: 'Jaapokki',
                  ),
                ),
              ),
              if (icon != null) SizedBox(width: 20), // Dodaj odstęp, jeśli jest ikona
              if (icon != null) Icon(icon, color: textColor != null? textColor : Colors.black, size: 30,),
            ],
          ),
        ),
      ),
    );
  }
}
