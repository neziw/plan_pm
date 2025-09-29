// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get stage1Title => ' ';

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
      'Otrzymuj przypomnienia przed kadymi zajęciami, zeby nigdy ich nie przegapić.';

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
}
