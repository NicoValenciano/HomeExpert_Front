import 'package:flutter/material.dart';

class CardScreen extends StatelessWidget {
  final String imagePath;
  final String title;

  const CardScreen({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 10.0,
        margin: const EdgeInsets.all(10.0),
        color: Colors.grey[100],
        shadowColor: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(imagePath,
                    width: 150, height: 150, fit: BoxFit.cover),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
