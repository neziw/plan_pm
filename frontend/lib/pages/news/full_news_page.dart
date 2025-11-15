import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:plan_pm/global/colors.dart';

class FullNewsPage extends StatelessWidget {
  const FullNewsPage({
    super.key,
    required this.title,
    required this.messageType,
    required this.description,
    required this.timestamp,
    this.imageUrl,
  });

  final String title;
  final String messageType;
  final String description;
  final DateTime timestamp;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            LucideIcons.chevronLeft,
            color: AppColor.onBackgroundVariant,
          ),
        ),
        backgroundColor: AppColor.background,
        shape: Border(bottom: BorderSide(color: AppColor.outline)),
        title: Text(
          "Szczegóły",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColor.onBackground,
          ),
        ),
      ),
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
                if (imageUrl != null)
                  CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 300,
                    imageUrl: imageUrl!,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(LucideIcons.eggFried),
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
                      Html(
                        data: description,
                        style: {
                          "body": Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                          ),
                          "p": Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                            fontSize: FontSize.medium,
                            color: AppColor.onSurfaceVariant,
                          ),
                          "a": Style(
                            color: Colors.blue,
                            textDecoration: TextDecoration.underline,
                          ),
                          "h1": Style(
                            fontSize: FontSize.xxLarge,
                            fontWeight: FontWeight.bold,
                          ),
                        },
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
