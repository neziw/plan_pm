// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get stage1Title => '';

  @override
  String get stage1Button => 'Witaj w Plan PM';

  @override
  String get stage2Title =>
      'Zobacz wszystkie zajęcia w przejrzystym planie tygodniowym.';

  @override
  String get stage2Button => 'Dalej';

  @override
  String get stage3Title =>
      'Znajdź swoje sale łatwo dzięki szczegółowym informacjom o lokalizacji.';

  @override
  String get stage3Button => 'Dalej';

  @override
  String get stage4Title =>
      'Otrzymuj przypomnienia przed każdym zajęciami, żeby nigdy ich nie przegapić.';

  @override
  String get stage4Button => 'Rozpocznij';

  @override
  String get welcomePageSelectionText => 'Powrót do WelcomeScreen';

  @override
  String get inputPageSelectionText => 'Powrót do InputPage';

  @override
  String get inputPageLabel => 'Twoje Dane Akademickie';

  @override
  String get facultyLabel => 'Wydział';

  @override
  String get facultyHintText => 'Wybierz wydział';

  @override
  String get fieldLabel => 'Kierunek studiów';

  @override
  String get fieldHintText => 'Wybierz kierunek studiów';

  @override
  String get yearLabel => 'Aktualny Rok';

  @override
  String get specialisationLabel => 'Specjalizacja';

  @override
  String get specialisationHintText => 'Wybierz specjalizacje';

  @override
  String get typeLabel => 'Tryb studiów';

  @override
  String get campusButton => 'Stacjonarne';

  @override
  String get extramuralButton => 'Zaoczne';

  @override
  String get continueButton => 'Kontynuuj';

  @override
  String get homePageLabel => 'Dane studenta to: ';

  @override
  String get facultyText => 'Wydział';

  @override
  String get fieldText => 'Kierunek';

  @override
  String get specialisationText => 'Specjalizacja';

  @override
  String get yearText => 'Rok';

  @override
  String get typeText => 'Tryb studiów';

  @override
  String get dataNaN => 'Brak danych';

  @override
  String get studySettings => 'Ustawienia studiów';

  @override
  String get skipButton => 'Pomiń';

  @override
  String get fullTimeStudy => 'Stacjonarne';

  @override
  String get partTimeStudy => 'Niestacjonarne';

  @override
  String get groupSelection => 'Wybór grupy';

  @override
  String get groupSelectionHint =>
      'Wybierz swój wydział, kierunek i tryb, aby spersonalizować plan zajęć';

  @override
  String get groupLoading => 'Ładowanie grup...';

  @override
  String get groupSettings => 'Ustawienia studiów';

  @override
  String get groupSelectionHintAfterLoad =>
      'Na podstawie Twoich ustawień studiów pobraliśmy dostępne grupy. Wybierz jedną lub wiele, aby śledzić kilka planów.';

  @override
  String get save => 'Zapisz';

  @override
  String get todayDataNaN => 'Brak zajęć na dziś';

  @override
  String pageErrorMess(Object snapshotError) {
    return 'Błąd w FutureBuilder $snapshotError';
  }

  @override
  String lectureLength(num lecturesLength) {
    return '$lecturesLength zajęcia';
  }

  @override
  String get recentLecture => 'Twoje najblizsze zajęcia';

  @override
  String get lectureLoading => 'Ładowanie planu';

  @override
  String get todayLecturesNaN => 'Brak zajęć na dziś';

  @override
  String get lectureWigetHint =>
      'Jesteś na bieżąco! Skorzystaj z wolnego czasu lub przejrzyj swój harmonogram.';

  @override
  String get daysShortMon => 'Pon';

  @override
  String get daysShortTue => 'Wt';

  @override
  String get daysShortWed => 'Śr';

  @override
  String get daysShortThu => 'Czw';

  @override
  String get daysShortFri => 'Pt';

  @override
  String get daysMon => 'poniedziałek';

  @override
  String get daysTue => 'wtorek';

  @override
  String get daysWed => 'środa';

  @override
  String get daysThu => 'czwartek';

  @override
  String get daysFri => 'piątek';

  @override
  String get selectedGroupsHeader => 'Wybrane grupy';

  @override
  String get changeGroupsButton => 'Zmień grupy';

  @override
  String get selectedGroupsLabel => 'Wybrane grupy';

  @override
  String get noDataAvailable => 'Brak danych';

  @override
  String get academicInfoHeader => 'Informacje akademickie';

  @override
  String get editButton => 'Edytuj';

  @override
  String studyYear(int year) {
    final intl.NumberFormat yearNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String yearString = yearNumberFormat.format(year);

    String _temp0 = intl.Intl.pluralLogic(
      year,
      locale: localeName,
      other: '$yearString roku',
      many: '$yearString lat',
      few: '$yearString lata',
      one: '1 rok',
    );
    return '$_temp0';
  }

  @override
  String get studyModeLabel => 'Tryb studiów';

  @override
  String get groupTypeAuditorium => 'Audytorium';

  @override
  String get groupTypeClasses => 'Ćwiczenia';

  @override
  String get groupTypeLabs => 'Laboratoria';

  @override
  String get groupTypeOther => 'Inne';

  @override
  String get pageTitleHome => 'Strona główna';

  @override
  String get pageTitleLectures => 'Zajęcia';

  @override
  String get pageTitleMenu => 'Menu';

  @override
  String get debugHeader => 'Debug';

  @override
  String get returnToLabel => 'Powrót do';

  @override
  String get welcomeScreenButton => 'Welcome screen';

  @override
  String get inputPageButton => 'Input page';
}
