import 'package:flutter/material.dart';

class WoodTile extends StatelessWidget {
  final int value;
  final VoidCallback onTap;

  WoodTile({required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: value == 0 ? Colors.brown[300] : Colors.brown[700],
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Text(
            value == 0 ? '' : value.toString(),
            style: TextStyle(
                fontSize: 24,
                color: value == 0 ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
