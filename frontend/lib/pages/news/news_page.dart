import 'package:flutter/material.dart';
import 'package:plan_pm/api/models/news_model.dart';
import 'package:plan_pm/pages/home/widgets/university_news.dart';
import 'package:plan_pm/pages/news/widgets/news_loading.dart';
import 'package:plan_pm/service/backend_service.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _backendService = BackendService();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FutureBuilder<List<NewsModel>>(
              future: _backendService.fetchNews(),
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
        ),
      ),
    );
  }
}
