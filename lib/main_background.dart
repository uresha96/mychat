import 'package:flutter/material.dart';

class MainBackground extends StatelessWidget {
  const MainBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // transform: GradientRotation(100),
          colors: [
            Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 243, 244, 212),
            Color.fromARGB(255, 207, 215, 235),
            Color.fromARGB(255, 239, 203, 230),
          ],
        ),
      ),
    );
  }
}
