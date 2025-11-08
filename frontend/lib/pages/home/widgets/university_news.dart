import 'package:flutter/material.dart';
import 'package:plan_pm/global/colors.dart';
import 'package:plan_pm/pages/news/full_news_page.dart';

class UniversityNews extends StatelessWidget {
  const UniversityNews({super.key});

  @override
  Widget build(BuildContext context) {
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
        NewsCard(
          title: "Pierwsze beta testy aplikacji PM-APP ruszyły!",
          messageType: "Komunikat",
          description:
              "Testuj aplikację i bądź na bieżąco z najnowszymi aktualizacjami. Znalazłeś jakiś błąd? Daj nam znać! Twoje uwagi pomagają usprawnić PM-APP — raportuj problemy, propozycje funkcji i sugestie dotyczące użyteczności. Dziękujemy za wsparcie i zaangażowanie.",
          timestamp: DateTime(2025, 10, 26),
          image: AssetImage("assets/pmapp.png"),
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
  final AssetImage? image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
                  Text(
                    "${description.substring(0, 45)}...",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColor.onSurfaceVariant,
                    ),
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
