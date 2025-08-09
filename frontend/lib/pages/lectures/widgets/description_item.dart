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
    return Row(
      spacing: 10,
      children: [
        CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name),
              Text(content, style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}
