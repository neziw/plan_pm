import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl'),
    Locale('uk'),
  ];

  /// No description provided for @stage1Title.
  ///
  /// In pl, this message translates to:
  /// **' '**
  String get stage1Title;

  /// No description provided for @stage1Button.
  ///
  /// In pl, this message translates to:
  /// **'Witaj w Plan PM'**
  String get stage1Button;

  /// No description provided for @stage2Title.
  ///
  /// In pl, this message translates to:
  /// **'Zobacz wszystkie zajęcia w przejrzystym planie tygodniowym.'**
  String get stage2Title;

  /// No description provided for @stage2Button.
  ///
  /// In pl, this message translates to:
  /// **'Dalej'**
  String get stage2Button;

  /// No description provided for @stage3Title.
  ///
  /// In pl, this message translates to:
  /// **'Znajdź swoje sale łatwo dzięki szczegółowym informacjom o lokalizacji.'**
  String get stage3Title;

  /// No description provided for @stage3Button.
  ///
  /// In pl, this message translates to:
  /// **'Dalej'**
  String get stage3Button;

  /// No description provided for @stage4Title.
  ///
  /// In pl, this message translates to:
  /// **'Otrzymuj przypomnienia przed kadymi zajęciami, żeby nigdy ich nie przegapić.'**
  String get stage4Title;

  /// No description provided for @stage4Button.
  ///
  /// In pl, this message translates to:
  /// **'Rozpocznij'**
  String get stage4Button;

  /// No description provided for @welcomePageSelectionText.
  ///
  /// In pl, this message translates to:
  /// **'Powrót do WelcomeScreen'**
  String get welcomePageSelectionText;

  /// No description provided for @inputPageSelectionText.
  ///
  /// In pl, this message translates to:
  /// **'Powrót do InputPage'**
  String get inputPageSelectionText;

  /// No description provided for @inputPageLabel.
  ///
  /// In pl, this message translates to:
  /// **'Twoje Dane Akademickie'**
  String get inputPageLabel;

  /// No description provided for @facultyLabel.
  ///
  /// In pl, this message translates to:
  /// **'Wydział'**
  String get facultyLabel;

  /// No description provided for @facultyHintText.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz wydział'**
  String get facultyHintText;

  /// No description provided for @fieldLabel.
  ///
  /// In pl, this message translates to:
  /// **'Kierunek studiów'**
  String get fieldLabel;

  /// No description provided for @fieldHintText.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz kierunek studiów'**
  String get fieldHintText;

  /// No description provided for @yearLabel.
  ///
  /// In pl, this message translates to:
  /// **'Aktualny Rok'**
  String get yearLabel;

  /// No description provided for @specialisationLabel.
  ///
  /// In pl, this message translates to:
  /// **'Specjalizacja'**
  String get specialisationLabel;

  /// No description provided for @specialisationHintText.
  ///
  /// In pl, this message translates to:
  /// **'Wybierz specjalizacje'**
  String get specialisationHintText;

  /// No description provided for @typeLabel.
  ///
  /// In pl, this message translates to:
  /// **'Tryb studiów'**
  String get typeLabel;

  /// No description provided for @campusButton.
  ///
  /// In pl, this message translates to:
  /// **'Stacjonarne'**
  String get campusButton;

  /// No description provided for @extramuralButton.
  ///
  /// In pl, this message translates to:
  /// **'Zaoczne'**
  String get extramuralButton;

  /// No description provided for @continueButton.
  ///
  /// In pl, this message translates to:
  /// **'Kontynuuj'**
  String get continueButton;

  /// No description provided for @homePageLabel.
  ///
  /// In pl, this message translates to:
  /// **'Dane studenta to: '**
  String get homePageLabel;

  /// No description provided for @facultyText.
  ///
  /// In pl, this message translates to:
  /// **'Wydział'**
  String get facultyText;

  /// No description provided for @fieldText.
  ///
  /// In pl, this message translates to:
  /// **'Kierunek'**
  String get fieldText;

  /// No description provided for @specialisationText.
  ///
  /// In pl, this message translates to:
  /// **'Specjalizacja'**
  String get specialisationText;

  /// No description provided for @yearText.
  ///
  /// In pl, this message translates to:
  /// **'Rok'**
  String get yearText;

  /// No description provided for @typeText.
  ///
  /// In pl, this message translates to:
  /// **'Tryb studiów'**
  String get typeText;

  /// No description provided for @dataNaN.
  ///
  /// In pl, this message translates to:
  /// **'Brak danych'**
  String get dataNaN;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pl', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
