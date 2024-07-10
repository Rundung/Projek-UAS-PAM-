import 'package:flutter/material.dart';

class WoodBackground extends StatelessWidget {
  final Widget child;

  WoodBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/wood_texture.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
