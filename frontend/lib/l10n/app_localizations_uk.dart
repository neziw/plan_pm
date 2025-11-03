// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get stage1Title => ' ';

  @override
  String get stage1Button => 'Ласкаво просимо до Plan PM';

  @override
  String get stage2Title =>
      'Переглядайте всі свої заняття у чіткому тижневому розкладі.';

  @override
  String get stage2Button => 'Далі';

  @override
  String get stage3Title =>
      'Легко знаходьте аудиторії завдяки детальній інформації про місцезнаходження.';

  @override
  String get stage3Button => 'Далі';

  @override
  String get stage4Title =>
      'Отримуйте нагадування перед кожним заняттям, щоб ніколи не пропустити.';

  @override
  String get stage4Button => 'Почати';

  @override
  String get welcomePageSelectionText => 'Повернутися до WelcomeScreen';

  @override
  String get inputPageSelectionText => 'Повернутися до InputPage';

  @override
  String get inputPageLabel => 'Ваші академічні дані';

  @override
  String get facultyLabel => 'Факультет';

  @override
  String get facultyHintText => 'Оберіть факультет';

  @override
  String get fieldLabel => 'Напрям навчання';

  @override
  String get fieldHintText => 'Оберіть напрям навчання';

  @override
  String get yearLabel => 'Курс';

  @override
  String get specialisationLabel => 'Спеціалізація';

  @override
  String get specialisationHintText => 'Оберіть спеціалізацію';

  @override
  String get typeLabel => 'Форма навчання';

  @override
  String get campusButton => 'Денна';

  @override
  String get extramuralButton => 'Заочна';

  @override
  String get continueButton => 'Продовжити';

  @override
  String get homePageLabel => 'Дані студента: ';

  @override
  String get facultyText => 'Факультет';

  @override
  String get fieldText => 'Напрям';

  @override
  String get specialisationText => 'Спеціалізація';

  @override
  String get yearText => 'Курс';

  @override
  String get typeText => 'Форма навчання';

  @override
  String get dataNaN => 'Немає даних';

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
      'Na podstawie Twoich ustawień studiów pobraliśmy dostępne grupy. Wybierz jedną lub wiele, aby śledzić kilka planów.';

  @override
  String get groupLoading => 'Ładowanie grup...';

  @override
  String get groupSettings => 'Ustawienia studiów';

  @override
  String get save => 'Zapisz';

  @override
  String get todayDataNaN => 'No data for today';

  @override
  String lecturesPageErrorMess(Object snapshotError) {
    return 'Błąd w FutureBuilder $snapshotError';
  }

  @override
  String lectureLength(Object lecturesLength) {
    return '$lecturesLength zajęcia';
  }
}
