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
          transform: GradientRotation(100),
          colors: [
            Color.fromARGB(255, 241, 237, 192),
            Color(0xFFEDEFF5),
            Color.fromARGB(255, 238, 195, 227),
          ],
        ),
      ),
    );
  }
}
