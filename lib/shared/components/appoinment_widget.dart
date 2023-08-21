import 'dart:math';

import 'package:flutter/material.dart';

class AppointmentWidget extends StatelessWidget {
  final String appointmentTitle;
  const AppointmentWidget({super.key, required this.appointmentTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        color: generateRandomColor(appointmentTitle),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Color generateRandomColor(String factor) {
    int seed =
        factor.hashCode; // Get the consistent numeric value for the string

    Random random = Random(seed);
    int red = random
        .nextInt(256); // Generate a random value between 0 and 255 for red
    int green = random
        .nextInt(256); // Generate a random value between 0 and 255 for green
    int blue = random
        .nextInt(256); // Generate a random value between 0 and 255 for blue

    return Color.fromARGB(255, red, green, blue); // Create and return the color
  }
}
