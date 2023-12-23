import 'package:flutter/material.dart';

class ResponsiveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String imageUrl;
  final double size;
  final Color color;

  ResponsiveButton({
    Key? key,
    required this.onPressed,
    required this.imageUrl,
    this.size = 50.0,
    this.color = Colors.deepPurple,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(size * 0.2),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
      child: Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
