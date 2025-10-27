import 'package:flutter/material.dart';
import 'package:plan_pm/pages/home/widgets/university_news.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            NewsCard(
              title: "Pierwsze beta testy aplikacji PM-APP ruszyły!",
              messageType: "Komunikat",
              description:
                  "Testuj aplikację i bądź na bieżąco z najnowszymi aktualizacjami. Znalazłeś jakiś błąd? Daj nam znać! Twoje uwagi pomagają usprawnić PM-APP — raportuj problemy, propozycje funkcji i sugestie dotyczące użyteczności. Dziękujemy za wsparcie i zaangażowanie.",
              timestamp: DateTime(2025, 10, 26),
              image: AssetImage("assets/pmapp.png"),
            ),
            NewsCard(
              title: "Pierwsze beta testy aplikacji PM-APP ruszyły!",
              messageType: "Komunikat",
              description:
                  "Testuj aplikacje i bądź na bieząco z najnowszymi aktualizacjami aplikacji. Znalazłeś jakiś błąd? Daj nam znać!",
              timestamp: DateTime(2025, 10, 26),
            ),
            NewsCard(
              title: "Pierwsze beta testy aplikacji PM-APP ruszyły!",
              messageType: "Komunikat",
              description:
                  "Testuj aplikacje i bądź na bieząco z najnowszymi aktualizacjami aplikacji. Znalazłeś jakiś błąd? Daj nam znać!",
              timestamp: DateTime(2025, 10, 26),
            ),
          ],
        ),
      ),
    );
  }
}
