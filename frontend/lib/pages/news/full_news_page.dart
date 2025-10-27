import 'package:flutter/material.dart';
import 'package:plan_pm/global/colors.dart';

class FullNewsPage extends StatelessWidget {
  const FullNewsPage({
    super.key,
    required this.title,
    required this.messageType,
    required this.description,
    required this.timestamp,
    this.image,
  });

  final String title;
  final String messageType;
  final String description;
  final DateTime timestamp;
  final AssetImage? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Szczegóły")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            color: AppColor.surface,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: AppColor.outline, width: 1),
            ),
            elevation: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (image != null)
                  Image(
                    image: image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 300,
                  ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 5,
                        children: [
                          Text(
                            messageType,
                            style: TextStyle(color: AppColor.onSurfaceVariant),
                          ),
                          Text(
                            "•",
                            style: TextStyle(color: AppColor.onSurfaceVariant),
                          ),
                          Text(
                            "${DateTime.now().difference(timestamp).inDays} dni temu",
                            style: TextStyle(color: AppColor.onSurfaceVariant),
                          ),
                        ],
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColor.onSurface,
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
