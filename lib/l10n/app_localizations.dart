import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @iotDashboard.
  ///
  /// In en, this message translates to:
  /// **'Weather Monitor'**
  String get iotDashboard;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @coolingSystemActivated.
  ///
  /// In en, this message translates to:
  /// **'High Temperature Alert'**
  String get coolingSystemActivated;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal Conditions'**
  String get normal;

  /// No description provided for @sensorHistory.
  ///
  /// In en, this message translates to:
  /// **'Sensor History'**
  String get sensorHistory;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No saved readings yet'**
  String get noHistory;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewHistory;

  /// No description provided for @selectCity.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get selectCity;

  /// No description provided for @weatherData.
  ///
  /// In en, this message translates to:
  /// **'Weather Data'**
  String get weatherData;

  /// No description provided for @windSpeed.
  ///
  /// In en, this message translates to:
  /// **'Wind Speed'**
  String get windSpeed;

  /// No description provided for @temperatureTrend.
  ///
  /// In en, this message translates to:
  /// **'Temperature Trend'**
  String get temperatureTrend;

  /// No description provided for @averageTemperature.
  ///
  /// In en, this message translates to:
  /// **'Average Temperature'**
  String get averageTemperature;

  /// No description provided for @dataPoints.
  ///
  /// In en, this message translates to:
  /// **'Data Points'**
  String get dataPoints;

  /// No description provided for @highTemperature.
  ///
  /// In en, this message translates to:
  /// **'High Temperature'**
  String get highTemperature;

  /// No description provided for @temperatureExceeded.
  ///
  /// In en, this message translates to:
  /// **'Temperature threshold exceeded'**
  String get temperatureExceeded;

  /// No description provided for @allConditionsNormal.
  ///
  /// In en, this message translates to:
  /// **'All conditions are normal'**
  String get allConditionsNormal;

  /// No description provided for @searchCities.
  ///
  /// In en, this message translates to:
  /// **'Search cities...'**
  String get searchCities;

  /// No description provided for @noCitiesFound.
  ///
  /// In en, this message translates to:
  /// **'No cities found'**
  String get noCitiesFound;

  /// No description provided for @selectLocationMap.
  ///
  /// In en, this message translates to:
  /// **'Select Location on Map'**
  String get selectLocationMap;

  /// No description provided for @realTimeData.
  ///
  /// In en, this message translates to:
  /// **'Real-time Data'**
  String get realTimeData;

  /// No description provided for @errorApiKeyNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'API key not configured. Please set your OpenWeatherMap API key.'**
  String get errorApiKeyNotConfigured;

  /// No description provided for @errorInvalidApiKey.
  ///
  /// In en, this message translates to:
  /// **'Invalid API key. Please check your OpenWeatherMap configuration.'**
  String get errorInvalidApiKey;

  /// No description provided for @errorCityNotFound.
  ///
  /// In en, this message translates to:
  /// **'Location not found. Please try a different location.'**
  String get errorCityNotFound;

  /// No description provided for @errorRateLimitExceeded.
  ///
  /// In en, this message translates to:
  /// **'API rate limit exceeded. Please try again later.'**
  String get errorRateLimitExceeded;

  /// No description provided for @errorNetworkConnection.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your internet connection.'**
  String get errorNetworkConnection;

  /// No description provided for @errorRequestTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timeout. Please check your connection.'**
  String get errorRequestTimeout;

  /// No description provided for @errorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get errorUnexpected;

  /// No description provided for @errorFailedFetchWeather.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch weather data'**
  String get errorFailedFetchWeather;

  /// No description provided for @errorFailedFetchAfterRetries.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch weather after multiple attempts'**
  String get errorFailedFetchAfterRetries;

  /// No description provided for @retryingAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Retrying automatically...'**
  String get retryingAutomatically;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;
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
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
