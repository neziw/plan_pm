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
  String get stage1Button => 'Welcome to Plan PM';

  @override
  String get stage2Title => 'View all your classes in a clear weekly schedule.';

  @override
  String get stage2Button => 'Next';

  @override
  String get stage3Title =>
      'Find your destination easily with detailed location information.';

  @override
  String get stage3Button => 'Next';

  @override
  String get stage4Title =>
      'Get reminders before each class so you never miss them.';

  @override
  String get stage4Button => 'Get Started';

  @override
  String get welcomePageSelectionText => 'Back to WelcomeScreen';

  @override
  String get inputPageSelectionText => 'Back to InputPage';

  @override
  String get inputPageLabel => 'Your Academic Data';

  @override
  String get facultyLabel => 'Faculty';

  @override
  String get facultyHintText => 'Select faculty';

  @override
  String get fieldLabel => 'Field of Study';

  @override
  String get fieldHintText => 'Select field of study';

  @override
  String get yearLabel => 'Current Year';

  @override
  String get specialisationLabel => 'Specialization';

  @override
  String get specialisationHintText => 'Select specialization';

  @override
  String get typeLabel => 'Mode of Study';

  @override
  String get campusButton => 'Full-time';

  @override
  String get extramuralButton => 'Part-time';

  @override
  String get continueButton => 'Continue';

  @override
  String get homePageLabel => 'Student data is: ';

  @override
  String get facultyText => 'Faculty';

  @override
  String get fieldText => 'Field';

  @override
  String get specialisationText => 'Specialization';

  @override
  String get yearText => 'Year';

  @override
  String get typeText => 'Mode of Study';

  @override
  String get dataNaN => 'No data';

  @override
  String get studySettings => 'Study settings';

  @override
  String get skipButton => 'Skip';

  @override
  String get fullTimeStudy => 'Full-time study';

  @override
  String get partTimeStudy => 'Part-time study';

  @override
  String get groupSelection => 'Group selection';

  @override
  String get groupSelectionHint =>
      'Based on your study settings, we have downloaded the available groups. Select one or more to follow multiple schedules.';

  @override
  String get groupLoading => 'Loading groups...';

  @override
  String get groupSettings => 'Study settings';

  @override
  String get save => 'Save';

  @override
  String get todayDataNaN => 'No data for today';

  @override
  String lecturesPageErrorMess(Object snapshotError) {
    return 'Error in FutureBuilder $snapshotError';
  }

  @override
  String lectureLength(Object lecturesLength) {
    return '$lecturesLength classes';
  }
}
