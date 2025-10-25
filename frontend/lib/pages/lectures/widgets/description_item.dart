import 'package:flutter/material.dart';

class DescriptionItem extends StatelessWidget {
  const DescriptionItem({
    super.key,
    required this.icon,
    required this.color,
    required this.name,
    required this.content,
  });

  final IconData icon;
  final Color color;
  final String name;
  final String content;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xf4f5f8FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          spacing: 10,
          children: [
            CircleAvatar(
              backgroundColor: color.withAlpha(40),
              child: Icon(icon),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(color: Colors.black.withAlpha(180)),
                  ),
                  Text(content, style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
