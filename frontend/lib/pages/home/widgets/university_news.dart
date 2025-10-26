import 'package:flutter/material.dart';
import 'package:plan_pm/global/colors.dart';

class UniversityNews extends StatelessWidget {
  const UniversityNews({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Nowości z uczelni",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        NewsCard(),
      ],
    );
  }
}

class NewsCard extends StatelessWidget {
  const NewsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
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
          Image(
            image: AssetImage("assets/pmapp.png"),
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
                      "Komunikat",
                      style: TextStyle(color: AppColor.onSurfaceVariant),
                    ),
                    Text(
                      "•",
                      style: TextStyle(color: AppColor.onSurfaceVariant),
                    ),
                    Text(
                      "2h temu",
                      style: TextStyle(color: AppColor.onSurfaceVariant),
                    ),
                  ],
                ),
                Text(
                  "Pierwsze beta testy aplikacji PM-APP ruszyły!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColor.onSurface,
                  ),
                ),
                Text(
                  "Testuj aplikacje i bądź na bieząco z najnowszy...",
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
    );
  }
}
