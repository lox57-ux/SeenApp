import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  BackgroundImage({super.key, required this.image});
  String image;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
    );
  }
}
