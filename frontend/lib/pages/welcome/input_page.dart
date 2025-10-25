import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:plan_pm/global/colors.dart';
import 'package:plan_pm/global/student.dart';
import 'package:plan_pm/main.dart';
import 'package:plan_pm/pages/welcome/group_selection_page.dart';
import 'package:plan_pm/pages/welcome/widgets/button_switch.dart';
import 'package:plan_pm/pages/welcome/widgets/dropdown_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  String selectedFaculty = "";
  String selectedDegreeCourse = "";
  String selectedSpecialisation = "";
  TextEditingController facultyController = TextEditingController();
  TextEditingController degreeCourseController = TextEditingController();
  TextEditingController specialisationController = TextEditingController();
  int selectedYear = 0;
  int? selectedTerm;

  @override
  Widget build(BuildContext context) {
    final List<String> faculties = [
      "Wydział Nawigacyjny",
      "Wydział Mechaniczny",
      "Wydział Inzynieryjno-Ekonomiczny Transportu",
      "Wydział Informatyki i Telekomunikacji",
      "Wydział Mechatroniki i Elektrotechniki",
    ];

    final Map<String, List<String>> degreeCourse = {
      "Wydział Informatyki i Telekomunikacji": [
        "Informatyka",
        "Teleinformatyka",
      ],
      "Wydział Inzynieryjno-Ekonomiczny Transportu": [
        "Logistyka",
        "Transport",
        "Zarządzanie",
        "Zarządzanie i Inzynieria Produkcji",
      ],
      "Wydział Mechaniczny": [
        "Inżynieria Modelowania Przestrzennego",
        "Inżynieria przemysłowa i morskie elektrownie wiatrowe",
        "Mechanika i Budowa Maszyn",
      ],
      "Wydział Mechatroniki i Elektrotechniki": [
        "Automatyka i robotyka",
        "Mechatronika",
      ],
      "Wydział Nawigacyjny": [
        "Geodezja i Kartografia",
        "Geoinformatyka",
        "Nawigacja",
        "Oceanotechnika",
        "Oceanotechnika - Budowa Jachtów i Okrętów",
        "Żegluga Śródlądowa",
      ],
    };

    final Map<String, List<String>> specialisations = {
      "Informatyka": [
        "Programowanie",
        "Programowanie systemów informatycznych",
        "Programowanie systemów multimedialnych",
        "Sztuczna Inteligencja",
      ],
      "Teleinformatyka": ["Eksploatacja systemów łączności"],
      "Logistyka": [
        "Logistyka i Zarządzanie w Europejskim Systemie Transportowym",
        "Logistyka Łańcuchów Dostaw",
        "Logistyka Offshore",
        "Logistyka Przedsiębiorstw",
      ],
      "Transport": [
        "Eksploatacja Portów i Floty Morskiej",
        "Logistyka Transportu Zintegrowanego",
      ],
      "Zarządzanie": [
        "Organizacja i Zarządzanie w Gospodarce Morskiej",
        "Zarządzanie Zasobami Ludzkimi",
      ],
      "Zarządzanie i Inżynieria Produkcji": [
        "Utrzymanie Ruchu w Przemyśle 4.0",
        "Zarządzanie Innowacjami w Produkcji i Usługach",
        "Zarządzanie Jakością Produkcji i Usług",
        "Zarządzanie Zautomatyzowanymi Systemami Produkcyjnymi",
      ],
      "Inżynieria Modelowania Przestrzennego": ["Brak specjalizacji"],
      "Inżynieria przemysłowa i morskie elektrownie wiatrowe": [
        "Ekspolatacja siłowni wiatrowych",
      ],
      "Mechanika i Budowa Maszyn": [
        "Budowa i Eksploatacja Morskich Systemów Energetycznych",
        "Diagnostyka i Remonty Maszyn i Urządzeń Okrętowych",
        "Eksploatacja Siłowni Okrętowych",
      ],
      "Automatyka i robotyka": ["Brak specjalizacji"],
      "Mechatronika": ["Mechatronika i Elektrotechnika Przemysłowa"],
      "Geodezja i Kartografia": ["Geoinformatyka", "Hydrografia"],
      "Geoinformatyka": ["Brak specjalizacji"],
      "Nawigacja": [
        "Eksploatacja Jednostek Pływających Offshore",
        "Inżynieria Ruchu Morskiego",
        "Ratownictwo",
        "Transport Morski",
      ],
      "Oceanotechnika": [
        "Projektowanie i Budowa Jachtów",
        "Projektowanie i Budowa Statków",
      ],
      "Oceanotechnika - Budowa Jachtów i Okrętów": [
        "Projektowanie i Budowa Okrętów",
      ],
      "Żegluga Śródlądowa": ["Brak specjalizacji"],
    };

    // final Map<String, List<int?>> specialisationLength = {
    //   "Programowanie": [1, 1],
    //   "Programowanie systemów informatycznych": [1, null],
    //   "Programowanie systemów multimedialnych": [3, 3],
    //   "Sztuczna Inteligencja": [1, 1],
    //   "Logistyka i Zarządzanie w Europejskim Systemie Transportowym": [3, 4],
    //   "Eksploatacja systemów łączności": [3, null],
    //   "Logistyka Łańcuchów Dostaw": [null, 1],
    //   "Logistyka Offshore": [1, 1],
    //   "Logistyka Przedsiębiorstw": [3, 4],
    //   "Eksploatacja Portów i Floty Morskiej": [3, 4],
    //   "Logistyka Transportu Zintegrowanego": [3, null],
    //   "Zarządzanie Zasobami Ludzkimi": [null, null, 3],
    //   "Organizacja i Zarządzanie w Gospodarce Morskiej":[null, null, 0],
    //   "Zarządzanie Zautomatyzowanymi Systemami Produkcyjnymi": [null, 1],
    //   "Zarządzanie Jakością Produkcji i Usług": [3, 4],
    //   "Zarządzanie Innowacjami w Produkcji i Usługach": [3, 4],
    //   "Utrzymanie Ruchu w Przemyśle 4.0": [4, null]
    //   "Ekspolatacja siłowni wiatrowych": []

    // };

    return Scaffold(
      appBar: AppBar(
        shape: Border(bottom: BorderSide(color: Colors.black.withAlpha(20))),
        title: Text(
          "Ustawienia studiów",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          spacing: 10,
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.black.withAlpha(50)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const MyHomePage(title: "Plan PM"),
                      ),
                    );
                  },
                  child: Text("Pomiń", style: TextStyle(color: Colors.black)),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 50,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColor.light.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(16),
                    ),
                  ),
                  onPressed:
                      (selectedYear <= 2
                          ? selectedFaculty != "" &&
                                selectedDegreeCourse != "" &&
                                selectedYear != 0 &&
                                selectedTerm != null
                          : selectedFaculty != "" &&
                                selectedDegreeCourse != "" &&
                                selectedYear >= 2 &&
                                selectedSpecialisation != "" &&
                                selectedTerm != null)
                      ? () async {
                          Student.degreeCourse = selectedDegreeCourse != ""
                              ? selectedDegreeCourse
                              : null;
                          Student.faculty = selectedFaculty != ""
                              ? selectedFaculty
                              : null;
                          Student.specialisation = selectedSpecialisation != ""
                              ? selectedSpecialisation
                              : null;
                          Student.term = selectedTerm == 1
                              ? "Stacjonarne"
                              : "Niestacjonarne";
                          Student.year = selectedYear;

                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          await prefs.setString("course", Student.course ?? "");
                          await prefs.setString(
                            "faculty",
                            Student.faculty ?? "",
                          );
                          await prefs.setString(
                            "degree_course",
                            Student.degreeCourse ?? "",
                          );
                          await prefs.setString(
                            "specialisation",
                            Student.specialisation ?? "",
                          );
                          await prefs.setInt("year", selectedYear);
                          await prefs.setString(
                            "term",
                            selectedTerm == 1
                                ? "Stacjonarne"
                                : "Niestacjonarne",
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupSelectionPage(),
                            ),
                          );
                        }
                      : null,
                  child: Text("Wybór grupy"),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Text(
                  "Wybierz swój wydział, kierunek i tryb, aby spersonalizować plan zajęć",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black.withAlpha(150),
                  ),
                ),
                SizedBox(height: 10),
                FacultyDropDownMenu(
                  controller: facultyController,
                  label: "Wydział",
                  icon: LucideIcons.school,
                  color: Colors.blue,
                  hint: "Wybierz wydział",
                  itemList: faculties,
                  onChanged: (value) {
                    setState(() {
                      if (selectedFaculty != value) {
                        selectedFaculty = value!;
                        selectedDegreeCourse = "";
                        selectedSpecialisation = "";
                        degreeCourseController.text = "";
                        specialisationController.text = "";
                      }
                    });
                  },
                  selectedValue: selectedFaculty,
                ),
                SizedBox(height: 20),
                FacultyDropDownMenu(
                  controller: degreeCourseController,
                  enabled: selectedFaculty == "" ? false : true,
                  label: "Kierunek studiów",
                  icon: LucideIcons.bookOpen,
                  color: Colors.green,
                  hint: "Wybierz kierunek studiów",
                  itemList: selectedFaculty != ""
                      ? degreeCourse[selectedFaculty]!
                      : [""],
                  selectedValue: selectedDegreeCourse,
                  onChanged: (value) {
                    setState(() {
                      if (selectedDegreeCourse != value) {
                        selectedDegreeCourse = value!;
                        specialisationController.text = "";
                      }
                    });
                  },
                ),
                SizedBox(height: 20),
                ButtonSwitch(
                  onValueChanged: (year) {
                    setState(() {
                      selectedYear = year + 1;
                      selectedSpecialisation = "";
                      specialisationController.text = "";
                    });
                  },
                  buttonLabels: ["I", "II", "III", "IV"],
                  buttonAmount: 4,
                  icon: LucideIcons.graduationCap,
                  color: Colors.purple,
                  label: "Aktualny Rok",
                ),
                SizedBox(height: 10),
                selectedYear > 2
                    ? FacultyDropDownMenu(
                        controller: specialisationController,
                        enabled:
                            selectedFaculty == "" || selectedDegreeCourse == ""
                            ? false
                            : true,
                        label: "Specjalizacja",
                        icon: LucideIcons.glasses,
                        color: Colors.orange,
                        hint: "Wybierz specjalizacje",
                        itemList:
                            selectedFaculty != "" && selectedDegreeCourse != ""
                            ? specialisations[selectedDegreeCourse] ?? [""]
                            : [""],
                        selectedValue: selectedSpecialisation,
                        onChanged: (value) {
                          setState(() {
                            if (selectedSpecialisation != value) {
                              selectedSpecialisation = value!;
                            }
                          });
                        },
                      )
                    : SizedBox(),
                SizedBox(height: 10),
                ButtonSwitch(
                  onValueChanged: (term) {
                    setState(() {
                      selectedTerm = term + 1;
                    });
                  },
                  buttonLabels: ["Stacjonarne", "Zaoczne"],
                  buttonAmount: 2,
                  icon: LucideIcons.graduationCap,
                  color: Colors.red,
                  label: "Tryb studiów",
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
