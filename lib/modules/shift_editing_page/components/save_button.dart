import 'package:flutter/material.dart';

class StatusSaveButton extends StatelessWidget {
  final Function()? onPressed;
  final String title;
  final IconData icon;
  const StatusSaveButton(
      {super.key, this.onPressed, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              const SizedBox(
                width: 16,
              ),
              Text(title),
            ],
          )),
    );
  }
}
