import 'package:flutter/material.dart';
import 'package:reminder_app/ui/theme.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  
  const MyButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap:  onTap,
      child: Container(
        width: 120,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: primaryClr),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
