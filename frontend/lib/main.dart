import 'package:flutter/material.dart';
import 'package:plan_pm/global/notifiers.dart';
import 'package:plan_pm/global/widgets/navigation_bar.dart';
import 'package:plan_pm/pages/home/home_page.dart';
import 'package:plan_pm/pages/lectures/lectures_page.dart';
import 'package:plan_pm/pages/menu/menu_page.dart';
import 'package:plan_pm/pages/welcome/input_page.dart';
import 'package:plan_pm/pages/welcome/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://nfujukqusxcwkewpeikw.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5mdWp1a3F1c3hjd2tld3BlaWt3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ0MTAyODcsImV4cCI6MjA2OTk4NjI4N30.UbH0dCf15sJxq-aI1HlFt2XxrPAIerod1KeHdEKA6WA",
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // Tutaj jest głowa aplikacji, najlepiej aby nic nie zmieniać.
  @override
  Widget build(BuildContext context) {
    Future<bool> checkSkip() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.containsKey("skip_welcome");
    }

    return FutureBuilder<bool>(
      future: checkSkip(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        return MaterialApp(
          title: 'Plan PM',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: "Inter",
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          home: snapshot.data == true ? const InputPage() : const WelcomePage(),
        );
      },
    );
  }
}

// To jest nasz główny widok aplikacji. Tutaj mamy zakładki, po których będzie mozna się poruszać w apce.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// To jest lista ze wszystkimi stronami i ich tytułami. W przyszłości będzie mozna dodać więcej parametrów.
List<Map<String, dynamic>> pages = [
  {"widget": const HomePage(), "title": "Home"},
  {"widget": const LecturesPage(), "title": "Lectures"},
  {"widget": const MenuPage(), "title": "Menu"},
];

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // Jezeli wartosc notifiera selectedTab sie zmieni - przebuduj cala strone.
    return ValueListenableBuilder(
      builder: (context, selectedTab, child) {
        return Scaffold(
          appBar: AppBar(
            // Tytul jest brany dynamicznie z listy pages.
            title: Text(pages[selectedTab]['title']),
          ),
          bottomNavigationBar: CustomNavigationBar(),
          body: pages[selectedTab]['widget'],
        );
      },
      // Wartość, którą zmian nasłuchujemy
      valueListenable: Notifiers.selectedTab,
    );
  }
}
