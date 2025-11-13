import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:plan_pm/global/colors.dart';
import 'package:plan_pm/global/notifiers.dart';
import 'package:plan_pm/global/student.dart';
import 'package:plan_pm/global/widgets/navigation_bar.dart';
import 'package:plan_pm/pages/home/home_page.dart';
import 'package:plan_pm/pages/lectures/lectures_page.dart';
import 'package:plan_pm/pages/menu/menu_page.dart';
import 'package:plan_pm/pages/news/news_page.dart';
import 'package:plan_pm/pages/welcome/input_page.dart';
import 'package:plan_pm/pages/welcome/welcome_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:plan_pm/l10n/app_localizations.dart';
import 'package:preload_page_view/preload_page_view.dart';
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

      // print(
      //   'Student(name: ${Student.name ?? ""}, surname: ${Student.surname ?? ""}, course: ${Student.course ?? ""}, faculty: ${Student.faculty ?? ""}, degreeCourse: ${Student.degreeCourse ?? ""}, specialisation: ${Student.specialisation ?? ""}, year: ${Student.year?.toString() ?? ""}, term: ${Student.term ?? ""}, selectedGroups: ${Student.selectedGroups ?? []})',
      // );

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
              themeMode: ThemeMode.system,
              title: 'Plan PM',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: "Inter",
                brightness: Brightness.light,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: ColorThemes.lightPrimary,
                  brightness: Brightness.light,
                ),
              ),
              darkTheme: ThemeData(
                fontFamily: "Inter",
                brightness: Brightness.dark,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: ColorThemes.darkPrimary,
                  brightness: Brightness.dark,
                ),
              ),

              builder: (context, child) {
                return Builder(
                  builder: (BuildContext innerContext) {
                    final brightness = Theme.of(innerContext).brightness;

                    AppColor.update(brightness);
                    return child!;
                  },
                );
              },

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

// To jest lista ze wszystkimi stronami i ich tytułami. W przyszłości będzie mozna dodać więcej parametrów.
List<Map<String, dynamic>> pages = [
  {"widget": const HomePage(), "title": "Strona główna"},
  {"widget": const LecturesPage(), "title": "Zajęcia"},
  {"widget": const NewsPage(), "title": "Nowości"},
];

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  late final PreloadPageController _preloadPageController;

  @override
  void initState() {
    super.initState();
    _preloadPageController = PreloadPageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _preloadPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MenuPage()),
              );
            },
            icon: Icon(
              LucideIcons.settings,
              color: AppColor.onBackgroundVariant,
            ),
          ),
        ],
        forceMaterialTransparency: true,
        shape: Border(bottom: BorderSide(color: AppColor.outline)),
        // Tytul jest brany dynamicznie z listy pages.
        title: Text(
          pages[_currentIndex]['title'],
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColor.onBackground,
          ),
        ),
      ),
      bottomNavigationBar: CustomNavigationBar(
        index: _currentIndex,
        onChange: (newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
          _preloadPageController.animateToPage(
            newIndex,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        },
      ),
      body: PreloadPageView.builder(
        itemCount: pages.length,
        itemBuilder: (context, index) => pages[index]["widget"],
        preloadPagesCount: 2,
        onPageChanged: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        controller: _preloadPageController,
      ),
    );
  }
}
