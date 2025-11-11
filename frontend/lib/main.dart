import 'package:flutter/material.dart';
import 'package:plan_pm/global/colors.dart';
import 'package:plan_pm/global/notifiers.dart';
import 'package:plan_pm/global/student.dart';
import 'package:plan_pm/global/widgets/navigation_bar.dart';
import 'package:plan_pm/pages/home/home_page.dart';
import 'package:plan_pm/pages/lectures/lectures_page.dart';
import 'package:plan_pm/pages/menu/menu_page.dart';
import 'package:plan_pm/pages/welcome/input_page.dart';
import 'package:plan_pm/pages/welcome/welcome_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:plan_pm/l10n/app_localizations.dart';
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
    Future<bool> skipWelcomeScreen() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.containsKey("skip_welcome");
    }

    Future<bool> skipStudentInfo() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      Student.course = prefs.getString("course");
      Student.degreeCourse = prefs.getString("degree_course");
      Student.faculty = prefs.getString("faculty");
      Student.specialisation = prefs.getString("specialisation");
      Student.year = prefs.getInt("year");
      Student.term = prefs.getString("term");
      Student.selectedGroups = prefs.getStringList("groups");

      print(
        'Student(name: ${Student.name ?? ""}, surname: ${Student.surname ?? ""}, course: ${Student.course ?? ""}, faculty: ${Student.faculty ?? ""}, degreeCourse: ${Student.degreeCourse ?? ""}, specialisation: ${Student.specialisation ?? ""}, year: ${Student.year?.toString() ?? ""}, term: ${Student.term ?? ""}, selectedGroups: ${Student.selectedGroups ?? []})',
      );

      final bool allNull =
          Student.course == null &&
          Student.degreeCourse == null &&
          Student.faculty == null &&
          Student.specialisation == null &&
          Student.year == null &&
          Student.term == null &&
          Student.selectedGroups == null;

      return !allNull;
    }

    return FutureBuilder<bool>(
      future: skipWelcomeScreen(),
      builder: (context, skipWelcome) {
        if (skipWelcome.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        return FutureBuilder(
          future: skipStudentInfo(),
          builder: (context, skipStudent) {
            return MaterialApp(
              title: 'Plan PM',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: "Inter",
                colorScheme: ColorScheme.fromSeed(seedColor: AppColor.primary),
              ),
              localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en'), // English
              Locale('pl'), // Polish
              Locale('uk'), // Ukrainian
            ],
              home: skipWelcome.data == true
                  ? skipStudent.data == true
                        ? MyHomePage(title: "Strona główna")
                        : const InputPage()
                  : const WelcomePage(),
            );
          },
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

List<Map<String, dynamic>> getPages(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return [
    {"widget": const HomePage(), "title": l10n.pageTitleHome},
    {"widget": const LecturesPage(), "title": l10n.pageTitleLectures},
    {"widget": const MenuPage(), "title": l10n.pageTitleMenu},
  ];
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final pages = getPages(context);
    // Jezeli wartosc notifiera selectedTab sie zmieni - przebuduj cala strone.
    return ValueListenableBuilder(
      builder: (context, selectedTab, child) {
        return Scaffold(
          backgroundColor: AppColor.background,
          appBar: AppBar(
            forceMaterialTransparency: true,
            shape: Border(bottom: BorderSide(color: AppColor.outline)),
            // Tytul jest brany dynamicznie z listy pages.
            title: Text(
              pages[selectedTab]['title'],
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColor.onBackground,
              ),
            ),
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
