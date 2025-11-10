import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plan_pm/api/models/news_model.dart';
import 'package:plan_pm/global/colors.dart';
import 'package:plan_pm/pages/news/full_news_page.dart';
import 'package:plan_pm/pages/news/widgets/news_loading.dart';
import 'package:plan_pm/service/backend_service.dart';
import 'package:flutter_html/flutter_html.dart';

class UniversityNews extends StatelessWidget {
  const UniversityNews({super.key});

  @override
  Widget build(BuildContext context) {
    final _backendService = BackendService();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nowości z uczelni",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColor.onBackground,
          ),
        ),
        FutureBuilder<List<NewsModel>>(
          future: _backendService.fetchNews(limit: 3),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Błąd w FutureBuilder ${snapshot.error}'),
              );
            }
            if (snapshot.connectionState != ConnectionState.done) {
              return NewsLoading();
            }
            if (snapshot.data != null && snapshot.data!.isEmpty) {
              return Text("No news for u");
            }
            final List<NewsModel> data = snapshot.data!;
            return Column(
              children: data
                  .map(
                    (news) => NewsCard(
                      title: news.title,
                      messageType: news.messageType,
                      description: news.content,
                      timestamp: news.createdAt,
                      image: news.thumbnail,
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class NewsCard extends StatelessWidget {
  const NewsCard({
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
  final NetworkImage? image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullNewsPage(
              title: title,
              messageType: messageType,
              description: description,
              timestamp: timestamp,
              image: image,
            ),
          ),
        );
      },
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
                height: 150,
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
                    data: "${description.substring(0, 45)}...",
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
    );
  }
}
