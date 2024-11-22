import 'package:flutter/material.dart';

class ImageMessageBubble extends StatelessWidget {
  final String imageUrl;

  const ImageMessageBubble({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            imageUrl,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
