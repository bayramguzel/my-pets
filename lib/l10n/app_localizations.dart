import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

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
    Locale('de'),
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'My Pets'**
  String get appTitle;

  /// No description provided for @errorSelectingImage.
  ///
  /// In en, this message translates to:
  /// **'Error selecting image: {error}'**
  String errorSelectingImage(Object error);

  /// No description provided for @popularPetTypes.
  ///
  /// In en, this message translates to:
  /// **'Popular Pet Types:'**
  String get popularPetTypes;

  /// No description provided for @draftFound.
  ///
  /// In en, this message translates to:
  /// **'Draft Found'**
  String get draftFound;

  /// No description provided for @draftResumeQuestion.
  ///
  /// In en, this message translates to:
  /// **'You have an incomplete registration. Would you like to continue?'**
  String get draftResumeQuestion;

  /// No description provided for @noDelete.
  ///
  /// In en, this message translates to:
  /// **'No, Delete'**
  String get noDelete;

  /// No description provided for @yesResume.
  ///
  /// In en, this message translates to:
  /// **'Yes, Continue'**
  String get yesResume;

  /// No description provided for @viewModeList.
  ///
  /// In en, this message translates to:
  /// **'List View'**
  String get viewModeList;

  /// No description provided for @viewModeGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid View'**
  String get viewModeGrid;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @noPetsYet.
  ///
  /// In en, this message translates to:
  /// **'No Pets Yet'**
  String get noPetsYet;

  /// No description provided for @noPetsDescription.
  ///
  /// In en, this message translates to:
  /// **'Add your pet friends to easily track their health, nutrition and care records.'**
  String get noPetsDescription;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @petSimulation.
  ///
  /// In en, this message translates to:
  /// **'Pet Simulation'**
  String get petSimulation;

  /// No description provided for @simulationDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'These values are simulation results for informational purposes. Consult your veterinarian for definitive advice.'**
  String get simulationDisclaimer;

  /// No description provided for @humanAge.
  ///
  /// In en, this message translates to:
  /// **'Human Age'**
  String get humanAge;

  /// No description provided for @dailyCalories.
  ///
  /// In en, this message translates to:
  /// **'Daily Calories'**
  String get dailyCalories;

  /// No description provided for @waterRequirement.
  ///
  /// In en, this message translates to:
  /// **'Water Requirement'**
  String get waterRequirement;

  /// No description provided for @myPets.
  ///
  /// In en, this message translates to:
  /// **'My Pets'**
  String get myPets;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @addPet.
  ///
  /// In en, this message translates to:
  /// **'Add Pet Friend'**
  String get addPet;

  /// No description provided for @petName.
  ///
  /// In en, this message translates to:
  /// **'Pet Name'**
  String get petName;

  /// No description provided for @petType.
  ///
  /// In en, this message translates to:
  /// **'Pet Type'**
  String get petType;

  /// No description provided for @breed.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get breed;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birthDate;

  /// No description provided for @nationalId.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalId;

  /// No description provided for @veterinarianName.
  ///
  /// In en, this message translates to:
  /// **'Veterinarian Name'**
  String get veterinarianName;

  /// No description provided for @veterinarianContact.
  ///
  /// In en, this message translates to:
  /// **'Veterinarian Contact'**
  String get veterinarianContact;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @activities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get activities;

  /// No description provided for @addActivity.
  ///
  /// In en, this message translates to:
  /// **'Add Activity'**
  String get addActivity;

  /// No description provided for @activityDate.
  ///
  /// In en, this message translates to:
  /// **'Activity Date'**
  String get activityDate;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @veterinaryVisit.
  ///
  /// In en, this message translates to:
  /// **'Veterinary Visit'**
  String get veterinaryVisit;

  /// No description provided for @feeding.
  ///
  /// In en, this message translates to:
  /// **'Feeding'**
  String get feeding;

  /// No description provided for @vaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination'**
  String get vaccination;

  /// No description provided for @grooming.
  ///
  /// In en, this message translates to:
  /// **'Grooming'**
  String get grooming;

  /// No description provided for @walk.
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get walk;

  /// No description provided for @cageCleaning.
  ///
  /// In en, this message translates to:
  /// **'Cage Cleaning'**
  String get cageCleaning;

  /// No description provided for @training.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get training;

  /// No description provided for @medication.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get medication;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @changeAppTheme.
  ///
  /// In en, this message translates to:
  /// **'Change app theme'**
  String get changeAppTheme;

  /// No description provided for @appTheme.
  ///
  /// In en, this message translates to:
  /// **'App Theme'**
  String get appTheme;

  /// No description provided for @selectColorScheme.
  ///
  /// In en, this message translates to:
  /// **'Select color scheme'**
  String get selectColorScheme;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @toggleNotifications.
  ///
  /// In en, this message translates to:
  /// **'Turn app notifications on/off'**
  String get toggleNotifications;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @toggleSound.
  ///
  /// In en, this message translates to:
  /// **'Turn app sounds on/off'**
  String get toggleSound;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @deviceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Device Language (Auto)'**
  String get deviceLanguage;

  /// No description provided for @selectAppLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select app language'**
  String get selectAppLanguage;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appInfo.
  ///
  /// In en, this message translates to:
  /// **'App information'**
  String get appInfo;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'This app helps you manage your pets\' records and activities.'**
  String get appDescription;

  /// No description provided for @defaultTheme.
  ///
  /// In en, this message translates to:
  /// **'Default Theme'**
  String get defaultTheme;

  /// No description provided for @orangeTheme.
  ///
  /// In en, this message translates to:
  /// **'Orange Theme'**
  String get orangeTheme;

  /// No description provided for @greenTheme.
  ///
  /// In en, this message translates to:
  /// **'Green Theme'**
  String get greenTheme;

  /// No description provided for @purpleTheme.
  ///
  /// In en, this message translates to:
  /// **'Purple Theme'**
  String get purpleTheme;

  /// No description provided for @red.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get red;

  /// No description provided for @pink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get pink;

  /// No description provided for @teal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get teal;

  /// No description provided for @yellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get yellow;

  /// No description provided for @cyan.
  ///
  /// In en, this message translates to:
  /// **'Cyan'**
  String get cyan;

  /// No description provided for @brown.
  ///
  /// In en, this message translates to:
  /// **'Brown'**
  String get brown;

  /// Title for the pet care tips screen
  ///
  /// In en, this message translates to:
  /// **'Pet Care Tips'**
  String get petCareTips;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @healthControl.
  ///
  /// In en, this message translates to:
  /// **'Health Control'**
  String get healthControl;

  /// No description provided for @safety.
  ///
  /// In en, this message translates to:
  /// **'Safety'**
  String get safety;

  /// No description provided for @dailyCare.
  ///
  /// In en, this message translates to:
  /// **'Daily Care'**
  String get dailyCare;

  /// No description provided for @generalCare.
  ///
  /// In en, this message translates to:
  /// **'General Care'**
  String get generalCare;

  /// No description provided for @dogCare.
  ///
  /// In en, this message translates to:
  /// **'Dog Care'**
  String get dogCare;

  /// No description provided for @catCare.
  ///
  /// In en, this message translates to:
  /// **'Cat Care'**
  String get catCare;

  /// No description provided for @birdCare.
  ///
  /// In en, this message translates to:
  /// **'Bird Care'**
  String get birdCare;

  /// No description provided for @rabbitCare.
  ///
  /// In en, this message translates to:
  /// **'Rabbit Care'**
  String get rabbitCare;

  /// No description provided for @fishCare.
  ///
  /// In en, this message translates to:
  /// **'Fish Care'**
  String get fishCare;

  /// No description provided for @hamsterCare.
  ///
  /// In en, this message translates to:
  /// **'Hamster Care'**
  String get hamsterCare;

  /// No description provided for @exoticCare.
  ///
  /// In en, this message translates to:
  /// **'Exotic Pets'**
  String get exoticCare;

  /// No description provided for @winterCareTips.
  ///
  /// In en, this message translates to:
  /// **'Winter Care Tips'**
  String get winterCareTips;

  /// No description provided for @summerSafety.
  ///
  /// In en, this message translates to:
  /// **'Summer Safety'**
  String get summerSafety;

  /// No description provided for @houseTraining.
  ///
  /// In en, this message translates to:
  /// **'House Training'**
  String get houseTraining;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @addInfo.
  ///
  /// In en, this message translates to:
  /// **'Add Info'**
  String get addInfo;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @totalPets.
  ///
  /// In en, this message translates to:
  /// **'Total Pets'**
  String get totalPets;

  /// No description provided for @activitiesThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Activities This Month'**
  String get activitiesThisMonth;

  /// No description provided for @expenseSummary.
  ///
  /// In en, this message translates to:
  /// **'Expense Summary'**
  String get expenseSummary;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @upcomingReminders7Days.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Reminders (7 Days)'**
  String get upcomingReminders7Days;

  /// No description provided for @noUpcomingReminders.
  ///
  /// In en, this message translates to:
  /// **'No upcoming reminders.'**
  String get noUpcomingReminders;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @themeSettings.
  ///
  /// In en, this message translates to:
  /// **'Theme Settings'**
  String get themeSettings;

  /// No description provided for @generalSettings.
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get generalSettings;

  /// No description provided for @aboutTheApp.
  ///
  /// In en, this message translates to:
  /// **'About The App'**
  String get aboutTheApp;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @healthStatus.
  ///
  /// In en, this message translates to:
  /// **'Health Status'**
  String get healthStatus;

  /// No description provided for @excellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellent;

  /// No description provided for @good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get good;

  /// No description provided for @fair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get fair;

  /// No description provided for @poor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get poor;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @totalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Total Expenses'**
  String get totalExpenses;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @medical.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get medical;

  /// No description provided for @toys.
  ///
  /// In en, this message translates to:
  /// **'Toys'**
  String get toys;

  /// No description provided for @accessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get accessories;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// No description provided for @notificationsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled.'**
  String get notificationsEnabled;

  /// No description provided for @notificationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications disabled.'**
  String get notificationsDisabled;

  /// No description provided for @languageSettingsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Language settings coming soon!'**
  String get languageSettingsComingSoon;

  /// No description provided for @petManagementApp.
  ///
  /// In en, this message translates to:
  /// **'Pet Management App'**
  String get petManagementApp;

  /// No description provided for @noContentToExplore.
  ///
  /// In en, this message translates to:
  /// **'No content to explore found.'**
  String get noContentToExplore;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @veterinarianInfo.
  ///
  /// In en, this message translates to:
  /// **'Veterinarian Information'**
  String get veterinarianInfo;

  /// No description provided for @pleaseEnterPetName.
  ///
  /// In en, this message translates to:
  /// **'Please enter pet name'**
  String get pleaseEnterPetName;

  /// No description provided for @pleaseEnterVaccineName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a vaccine name'**
  String get pleaseEnterVaccineName;

  /// No description provided for @pleaseEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter an amount'**
  String get pleaseEnterAmount;

  /// No description provided for @pleaseEnterDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter a description'**
  String get pleaseEnterDescription;

  /// No description provided for @pleaseSelectPet.
  ///
  /// In en, this message translates to:
  /// **'Please select a pet'**
  String get pleaseSelectPet;

  /// No description provided for @pleaseEnterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get pleaseEnterValidNumber;

  /// No description provided for @deletePetConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}? This action cannot be undone.'**
  String deletePetConfirmation(String name);

  /// No description provided for @saveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get saveSuccess;

  /// No description provided for @deleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Deleted successfully'**
  String get deleteSuccess;

  /// No description provided for @costOptional.
  ///
  /// In en, this message translates to:
  /// **'Cost (Optional)'**
  String get costOptional;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount (\$)'**
  String get amountLabel;

  /// No description provided for @demoPetBuddyNotes.
  ///
  /// In en, this message translates to:
  /// **'Energetic and loves playing. No food allergies.'**
  String get demoPetBuddyNotes;

  /// No description provided for @demoPetWhiskersNotes.
  ///
  /// In en, this message translates to:
  /// **'Calm, usually sleeps. Sensitive to dairy products.'**
  String get demoPetWhiskersNotes;

  /// No description provided for @demoActivity1Desc.
  ///
  /// In en, this message translates to:
  /// **'Annual checkup, everything is fine.'**
  String get demoActivity1Desc;

  /// No description provided for @demoActivity2Desc.
  ///
  /// In en, this message translates to:
  /// **'Switched to new food. 2 scoops each meal.'**
  String get demoActivity2Desc;

  /// No description provided for @demoExpense1Desc.
  ///
  /// In en, this message translates to:
  /// **'Veterinary checkup'**
  String get demoExpense1Desc;

  /// No description provided for @demoVaccineRabies.
  ///
  /// In en, this message translates to:
  /// **'Rabies Vaccination'**
  String get demoVaccineRabies;

  /// No description provided for @tip1.
  ///
  /// In en, this message translates to:
  /// **'Ensure fresh water is always available.'**
  String get tip1;

  /// No description provided for @tip2.
  ///
  /// In en, this message translates to:
  /// **'Regular vet checkups keep pets healthy.'**
  String get tip2;

  /// No description provided for @tip3.
  ///
  /// In en, this message translates to:
  /// **'Daily exercise reduces stress and boredom.'**
  String get tip3;

  /// No description provided for @tip4.
  ///
  /// In en, this message translates to:
  /// **'Grooming helps detect skin issues early.'**
  String get tip4;

  /// No description provided for @tip5.
  ///
  /// In en, this message translates to:
  /// **'Rotate toys to keep your pet stimulated.'**
  String get tip5;

  /// No description provided for @tip6.
  ///
  /// In en, this message translates to:
  /// **'Balanced diet supports long-term health.'**
  String get tip6;

  /// No description provided for @tip7.
  ///
  /// In en, this message translates to:
  /// **'Social interaction improves behavior.'**
  String get tip7;

  /// No description provided for @tip8.
  ///
  /// In en, this message translates to:
  /// **'Monitor weight to prevent obesity.'**
  String get tip8;

  /// No description provided for @tip9.
  ///
  /// In en, this message translates to:
  /// **'Dental care is essential for overall health.'**
  String get tip9;

  /// No description provided for @tip10.
  ///
  /// In en, this message translates to:
  /// **'Positive reinforcement builds trust.'**
  String get tip10;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Exported to {path}'**
  String exportSuccess(Object path);

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailed(Object error);

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get readMore;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get months;

  /// No description provided for @noActivitiesFound.
  ///
  /// In en, this message translates to:
  /// **'No activities found.'**
  String get noActivitiesFound;

  /// No description provided for @noVaccinationsFound.
  ///
  /// In en, this message translates to:
  /// **'No vaccinations found.'**
  String get noVaccinationsFound;

  /// No description provided for @noRemindersFound.
  ///
  /// In en, this message translates to:
  /// **'No reminders found.'**
  String get noRemindersFound;

  /// No description provided for @noExpensesFound.
  ///
  /// In en, this message translates to:
  /// **'No expenses found.'**
  String get noExpensesFound;

  /// No description provided for @editActivity.
  ///
  /// In en, this message translates to:
  /// **'Edit Activity'**
  String get editActivity;

  /// No description provided for @editVaccination.
  ///
  /// In en, this message translates to:
  /// **'Edit Vaccination'**
  String get editVaccination;

  /// No description provided for @editReminder.
  ///
  /// In en, this message translates to:
  /// **'Edit Reminder'**
  String get editReminder;

  /// No description provided for @editExpense.
  ///
  /// In en, this message translates to:
  /// **'Edit Expense'**
  String get editExpense;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @enterDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter description'**
  String get enterDescription;

  /// No description provided for @petDetails.
  ///
  /// In en, this message translates to:
  /// **'Pet Details'**
  String get petDetails;

  /// No description provided for @basicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInfo;

  /// No description provided for @healthInfo.
  ///
  /// In en, this message translates to:
  /// **'Health Information'**
  String get healthInfo;

  /// No description provided for @behaviorAndTraining.
  ///
  /// In en, this message translates to:
  /// **'Behavior & Training'**
  String get behaviorAndTraining;

  /// No description provided for @dietAndCare.
  ///
  /// In en, this message translates to:
  /// **'Diet & Care'**
  String get dietAndCare;

  /// No description provided for @ownerInfo.
  ///
  /// In en, this message translates to:
  /// **'Owner Information'**
  String get ownerInfo;

  /// No description provided for @petActivities.
  ///
  /// In en, this message translates to:
  /// **'Pet Activities'**
  String get petActivities;

  /// No description provided for @filterByCategory.
  ///
  /// In en, this message translates to:
  /// **'Filter by Category'**
  String get filterByCategory;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// No description provided for @takePicture.
  ///
  /// In en, this message translates to:
  /// **'Take Picture'**
  String get takePicture;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @selectImage.
  ///
  /// In en, this message translates to:
  /// **'Select Image'**
  String get selectImage;

  /// No description provided for @dog.
  ///
  /// In en, this message translates to:
  /// **'Dog'**
  String get dog;

  /// No description provided for @cat.
  ///
  /// In en, this message translates to:
  /// **'Cat'**
  String get cat;

  /// No description provided for @bird.
  ///
  /// In en, this message translates to:
  /// **'Bird'**
  String get bird;

  /// No description provided for @rabbit.
  ///
  /// In en, this message translates to:
  /// **'Rabbit'**
  String get rabbit;

  /// No description provided for @hamster.
  ///
  /// In en, this message translates to:
  /// **'Hamster'**
  String get hamster;

  /// No description provided for @fish.
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get fish;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @kg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kg;

  /// No description provided for @microchipId.
  ///
  /// In en, this message translates to:
  /// **'Microchip ID'**
  String get microchipId;

  /// No description provided for @insurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get insurance;

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContact;

  /// No description provided for @medicalHistory.
  ///
  /// In en, this message translates to:
  /// **'Medical History'**
  String get medicalHistory;

  /// No description provided for @allergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get allergies;

  /// No description provided for @currentMedications.
  ///
  /// In en, this message translates to:
  /// **'Current Medications'**
  String get currentMedications;

  /// No description provided for @nextAppointment.
  ///
  /// In en, this message translates to:
  /// **'Next Appointment'**
  String get nextAppointment;

  /// No description provided for @vaccinationRecord.
  ///
  /// In en, this message translates to:
  /// **'Vaccination Record'**
  String get vaccinationRecord;

  /// No description provided for @addVaccination.
  ///
  /// In en, this message translates to:
  /// **'Add Vaccination'**
  String get addVaccination;

  /// No description provided for @vaccineName.
  ///
  /// In en, this message translates to:
  /// **'Vaccine Name'**
  String get vaccineName;

  /// No description provided for @vaccineDate.
  ///
  /// In en, this message translates to:
  /// **'Vaccine Date'**
  String get vaccineDate;

  /// No description provided for @nextDueDate.
  ///
  /// In en, this message translates to:
  /// **'Next Due Date'**
  String get nextDueDate;

  /// No description provided for @veterinarian.
  ///
  /// In en, this message translates to:
  /// **'Veterinarian'**
  String get veterinarian;

  /// No description provided for @batchNumber.
  ///
  /// In en, this message translates to:
  /// **'Batch Number'**
  String get batchNumber;

  /// No description provided for @healthReminders.
  ///
  /// In en, this message translates to:
  /// **'Health Reminders'**
  String get healthReminders;

  /// No description provided for @addReminder.
  ///
  /// In en, this message translates to:
  /// **'Add Reminder'**
  String get addReminder;

  /// No description provided for @reminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder Title'**
  String get reminderTitle;

  /// No description provided for @reminderDate.
  ///
  /// In en, this message translates to:
  /// **'Reminder Date'**
  String get reminderDate;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder Time'**
  String get reminderTime;

  /// No description provided for @repeatReminder.
  ///
  /// In en, this message translates to:
  /// **'Repeat Reminder'**
  String get repeatReminder;

  /// No description provided for @expenseAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get expenseAmount;

  /// No description provided for @expenseCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get expenseCategory;

  /// No description provided for @expenseDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get expenseDate;

  /// No description provided for @expenseDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get expenseDescription;

  /// No description provided for @monthlyExpenses.
  ///
  /// In en, this message translates to:
  /// **'Monthly Expenses'**
  String get monthlyExpenses;

  /// No description provided for @yearlyExpenses.
  ///
  /// In en, this message translates to:
  /// **'Yearly Expenses'**
  String get yearlyExpenses;

  /// No description provided for @qrCode.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qrCode;

  /// No description provided for @scanQRMsg.
  ///
  /// In en, this message translates to:
  /// **'Scan this QR code to access {name}\'s information.'**
  String scanQRMsg(Object name);

  /// No description provided for @copyInfo.
  ///
  /// In en, this message translates to:
  /// **'Copy Information'**
  String get copyInfo;

  /// No description provided for @emergencyInfo.
  ///
  /// In en, this message translates to:
  /// **'Emergency Information'**
  String get emergencyInfo;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @activityChart.
  ///
  /// In en, this message translates to:
  /// **'Activity Chart'**
  String get activityChart;

  /// No description provided for @expenseChart.
  ///
  /// In en, this message translates to:
  /// **'Expense Chart'**
  String get expenseChart;

  /// No description provided for @lastCheckup.
  ///
  /// In en, this message translates to:
  /// **'Last Checkup'**
  String get lastCheckup;

  /// No description provided for @nextCheckup.
  ///
  /// In en, this message translates to:
  /// **'Next Checkup'**
  String get nextCheckup;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @importData.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importData;

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @healthyFeedingTips.
  ///
  /// In en, this message translates to:
  /// **'Healthy Feeding Tips'**
  String get healthyFeedingTips;

  /// No description provided for @catHappinessTips.
  ///
  /// In en, this message translates to:
  /// **'Cat Happiness Tips'**
  String get catHappinessTips;

  /// No description provided for @birdTrainingBasics.
  ///
  /// In en, this message translates to:
  /// **'Bird Training Basics'**
  String get birdTrainingBasics;

  /// No description provided for @smallPetHabitat.
  ///
  /// In en, this message translates to:
  /// **'Small Pet Habitat'**
  String get smallPetHabitat;

  /// No description provided for @commonDiseaseSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Common Disease Symptoms'**
  String get commonDiseaseSymptoms;

  /// No description provided for @travelingWithPets.
  ///
  /// In en, this message translates to:
  /// **'Traveling with Pets'**
  String get travelingWithPets;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @lifestyle.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle'**
  String get lifestyle;

  /// No description provided for @healthyFeedingContent.
  ///
  /// In en, this message translates to:
  /// **'Providing a balanced and nutritious diet is critical for your dog\'s health. Choose quality food appropriate for their age, weight, and activity level. Feed 2-3 meals daily and always keep fresh water available. Avoid human foods, especially chocolate, grapes, and onions.'**
  String get healthyFeedingContent;

  /// No description provided for @catHappinessContent.
  ///
  /// In en, this message translates to:
  /// **'A happy cat needs play, scratching, and personal space. Play for at least 15 minutes daily. Create window sunbathing spots. Provide scratching posts and high platforms. Keep the litter box clean and create a calm environment.'**
  String get catHappinessContent;

  /// No description provided for @birdTrainingContent.
  ///
  /// In en, this message translates to:
  /// **'Patience and consistency are crucial when training your bird. Use positive reinforcement methods. Have short training sessions daily at the same time. Start with simple commands: step up, come when called. Use favorite treats as rewards. Watch for stress signs.'**
  String get birdTrainingContent;

  /// No description provided for @smallPetHabitatContent.
  ///
  /// In en, this message translates to:
  /// **'Create an appropriately sized, clean, and safe living space for small pets. Ensure proper ventilation, natural light, and appropriate temperature. Add play and exercise areas. Provide hiding spots and nesting materials. Clean the cage at least weekly.'**
  String get smallPetHabitatContent;

  /// No description provided for @commonDiseaseSymptomsContent.
  ///
  /// In en, this message translates to:
  /// **'Be alert if your pet shows loss of appetite, lethargy, vomiting, diarrhea, or behavior changes. Frequent urination, changes in drinking habits, or breathing difficulties are important signs. If you notice any of these symptoms, consult your vet immediately.'**
  String get commonDiseaseSymptomsContent;

  /// No description provided for @travelingWithPetsContent.
  ///
  /// In en, this message translates to:
  /// **'When traveling with your pet, first get a health certificate from your vet. Get them used to the carrier at home before traveling. Take regular breaks on long journeys. Keep adequate water and food. Keep ID and microchip information updated. Check pet policies at your destination beforehand.'**
  String get travelingWithPetsContent;

  /// No description provided for @orange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get orange;

  /// No description provided for @green.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get green;

  /// No description provided for @purple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get purple;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @healthReminder.
  ///
  /// In en, this message translates to:
  /// **'Health Reminder'**
  String get healthReminder;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @pet.
  ///
  /// In en, this message translates to:
  /// **'Pet'**
  String get pet;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @cost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get cost;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @pleaseEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get pleaseEnterTitle;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @blue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get blue;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// No description provided for @upcomingVaccinations.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Vaccinations'**
  String get upcomingVaccinations;

  /// No description provided for @pendingReminders.
  ///
  /// In en, this message translates to:
  /// **'Pending Reminders'**
  String get pendingReminders;

  /// No description provided for @monthlyExpenseTotal.
  ///
  /// In en, this message translates to:
  /// **'This Month\'s Expenses'**
  String get monthlyExpenseTotal;

  /// No description provided for @lastActivity.
  ///
  /// In en, this message translates to:
  /// **'Last Activity'**
  String get lastActivity;

  /// No description provided for @noActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get noActivity;

  /// No description provided for @noReminders.
  ///
  /// In en, this message translates to:
  /// **'No reminders'**
  String get noReminders;

  /// No description provided for @noVaccinations.
  ///
  /// In en, this message translates to:
  /// **'No upcoming vaccinations'**
  String get noVaccinations;

  /// No description provided for @dailyTip.
  ///
  /// In en, this message translates to:
  /// **'Daily Tip'**
  String get dailyTip;

  /// No description provided for @exportCSV.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCSV;

  /// No description provided for @searchBreed.
  ///
  /// In en, this message translates to:
  /// **'Search Breed'**
  String get searchBreed;

  /// No description provided for @breeds.
  ///
  /// In en, this message translates to:
  /// **'Breeds'**
  String get breeds;

  /// No description provided for @noBreedFound.
  ///
  /// In en, this message translates to:
  /// **'No breed found'**
  String get noBreedFound;

  /// No description provided for @firstAidForPets.
  ///
  /// In en, this message translates to:
  /// **'First Aid for Pets'**
  String get firstAidForPets;

  /// No description provided for @firstAidForPetsContent.
  ///
  /// In en, this message translates to:
  /// **'Don\'t panic in emergencies. Keep your vet\'s phone number ready. For injuries, apply pressure with clean cloth. If poisoning is suspected, go to the vet immediately and bring the packaging if possible. Prepare a basic first aid kit: gauze, bandages, antiseptic, tweezers.'**
  String get firstAidForPetsContent;

  /// No description provided for @choosingRightPet.
  ///
  /// In en, this message translates to:
  /// **'Choosing the Right Pet'**
  String get choosingRightPet;

  /// No description provided for @choosingRightPetContent.
  ///
  /// In en, this message translates to:
  /// **'Choose a pet that fits your lifestyle. Consider your living space, daily routine, and budget. Each animal type has different needs. Dogs need daily walks, cats need independent space, birds need social interaction. Be prepared for long-term responsibility.'**
  String get choosingRightPetContent;

  /// No description provided for @dentalCareForPets.
  ///
  /// In en, this message translates to:
  /// **'Dental Care for Pets'**
  String get dentalCareForPets;

  /// No description provided for @dentalCareForPetsContent.
  ///
  /// In en, this message translates to:
  /// **'Dental health is critical for overall health. Brush dog and cat teeth 2-3 times weekly. Use pet dental products, never human toothpaste. Get regular vet checks for dental decay. Use treats and toys that support dental health.'**
  String get dentalCareForPetsContent;

  /// No description provided for @socializingYourPuppy.
  ///
  /// In en, this message translates to:
  /// **'Socializing Your Puppy'**
  String get socializingYourPuppy;

  /// No description provided for @socializingYourPuppyContent.
  ///
  /// In en, this message translates to:
  /// **'The first 3-4 months are critical for socialization. Introduce different people, animals, and environments. Create positive experiences. Get them used to daily elements like children, bikes, cars. Attend puppy training classes. Avoid frightening experiences.'**
  String get socializingYourPuppyContent;

  /// No description provided for @litterBoxProblems.
  ///
  /// In en, this message translates to:
  /// **'Litter Box Problems'**
  String get litterBoxProblems;

  /// No description provided for @litterBoxProblemsContent.
  ///
  /// In en, this message translates to:
  /// **'If your cat won\'t use the litter box, first get a vet check. Clean daily, completely change litter weekly. Place in a quiet, accessible location. For multiple cats, have one box per cat plus one. Try different litter types.'**
  String get litterBoxProblemsContent;

  /// No description provided for @fishAquariumSetup.
  ///
  /// In en, this message translates to:
  /// **'Aquarium Setup'**
  String get fishAquariumSetup;

  /// No description provided for @fishAquariumSetupContent.
  ///
  /// In en, this message translates to:
  /// **'Choose an appropriately sized aquarium for your fish species. Wait 4-6 weeks to start the water cycle. Use a quality filter system. Regularly check water temperature, pH, and ammonia levels. Do 25% water changes weekly. Avoid overfeeding.'**
  String get fishAquariumSetupContent;

  /// No description provided for @rabbitDiet.
  ///
  /// In en, this message translates to:
  /// **'Rabbit Diet'**
  String get rabbitDiet;

  /// No description provided for @rabbitDietContent.
  ///
  /// In en, this message translates to:
  /// **'80% of a rabbit\'s diet should be quality hay. Give fresh leafy vegetables daily: lettuce, parsley, celery. Keep pellets limited. Give fruits only as treats, in small amounts. Always provide fresh water. Don\'t make sudden diet changes.'**
  String get rabbitDietContent;

  /// No description provided for @introducingNewPet.
  ///
  /// In en, this message translates to:
  /// **'Introducing a New Pet'**
  String get introducingNewPet;

  /// No description provided for @introducingNewPetContent.
  ///
  /// In en, this message translates to:
  /// **'Introduce a new pet slowly and carefully. Keep them in separate rooms for the first few days. Get them used to each other\'s scents. Have short, supervised meetings. Give equal attention to both. Reward positive behaviors. Don\'t rush, this can take weeks.'**
  String get introducingNewPetContent;

  /// No description provided for @winterCareTipsContent.
  ///
  /// In en, this message translates to:
  /// **'Provide extra protection in winter months. Limit prolonged outdoor time. Use clothing for small and short-haired pets. Use paw protectors, protect from salt and chemicals. Keep indoor air humid. Keep sleeping areas warm.'**
  String get winterCareTipsContent;

  /// No description provided for @summerSafetyContent.
  ///
  /// In en, this message translates to:
  /// **'Protect your pet in hot weather. Never leave in a car. Provide shaded and cool areas. Keep plenty of water available. Avoid exercise during hot hours. Watch for asphalt burns. Maintain regular grooming, but don\'t shave completely - fur protects from sun.'**
  String get summerSafetyContent;

  /// No description provided for @understandingBodyLanguage.
  ///
  /// In en, this message translates to:
  /// **'Understanding Body Language'**
  String get understandingBodyLanguage;

  /// No description provided for @understandingBodyLanguageContent.
  ///
  /// In en, this message translates to:
  /// **'Learn to read your pet\'s body language. Tail, ears, and posture give important clues. In dogs, lying down shows submission, cat meowing is a request for communication. Recognize stress signs: restlessness, excessive licking, aggression. Each animal is individual, learn their own signals.'**
  String get understandingBodyLanguageContent;

  /// No description provided for @diyPetToys.
  ///
  /// In en, this message translates to:
  /// **'DIY Pet Toys'**
  String get diyPetToys;

  /// No description provided for @diyPetToysContent.
  ///
  /// In en, this message translates to:
  /// **'You can make simple and safe toys at home. Make braided ropes from old t-shirts. Create cat houses from cardboard boxes. Use PET bottles for food-finding games. Always check for toxicity and choking hazards. Don\'t leave unsupervised.'**
  String get diyPetToysContent;

  /// No description provided for @seniorPetCare.
  ///
  /// In en, this message translates to:
  /// **'Senior Pet Care'**
  String get seniorPetCare;

  /// No description provided for @seniorPetCareContent.
  ///
  /// In en, this message translates to:
  /// **'Senior pets require extra care. Increase vet checks to 2-3 times yearly. Use soft beds for joint health. Adjust diet according to age and health status. Reduce exercise but don\'t stop it. Watch for vision and hearing loss. Show more love and patience.'**
  String get seniorPetCareContent;

  /// No description provided for @parasitePrevention.
  ///
  /// In en, this message translates to:
  /// **'Parasite Prevention'**
  String get parasitePrevention;

  /// No description provided for @parasitePreventionContent.
  ///
  /// In en, this message translates to:
  /// **'Regular parasite protection is very important. Use flea, tick, and internal parasite medications recommended by your vet. Don\'t neglect seasonal protection. Clean feces immediately. Keep living areas clean. Quarantine new pets. Get stool examinations at least once yearly.'**
  String get parasitePreventionContent;

  /// No description provided for @groomingYourPetAtHome.
  ///
  /// In en, this message translates to:
  /// **'Grooming Your Pet at Home'**
  String get groomingYourPetAtHome;

  /// No description provided for @groomingYourPetAtHomeContent.
  ///
  /// In en, this message translates to:
  /// **'Regular grooming is important for health and bonding. Use a brush suitable for fur type. Brush 2-3 times weekly. Bathe when needed, but don\'t overdo it. Trim nails regularly. Don\'t forget ear and dental cleaning. Use treats to create positive experiences.'**
  String get groomingYourPetAtHomeContent;

  /// No description provided for @behavior.
  ///
  /// In en, this message translates to:
  /// **'Behavior'**
  String get behavior;

  /// No description provided for @turtle.
  ///
  /// In en, this message translates to:
  /// **'Turtle'**
  String get turtle;

  /// No description provided for @hamsterCareBasics.
  ///
  /// In en, this message translates to:
  /// **'Hamster Care Basics'**
  String get hamsterCareBasics;

  /// No description provided for @hamsterCareBasicsContent.
  ///
  /// In en, this message translates to:
  /// **'A hamster\'s cage should be spacious with proper ventilation. Provide fresh water and food daily. Line the cage with safe bedding.'**
  String get hamsterCareBasicsContent;

  /// No description provided for @hamsterCareBasicsFullContent.
  ///
  /// In en, this message translates to:
  /// **'Creating a healthy environment for your hamster is extremely important. The cage should be at least 60x40 cm and have proper ventilation. Add hiding spots, an exercise wheel, and toys. Line with safe bedding, avoid scented products. Provide fresh water and quality hamster food daily. Clean weekly. Hamsters are nocturnal, so don\'t disturb them during the day. Check teeth regularly, provide wooden toys.'**
  String get hamsterCareBasicsFullContent;

  /// No description provided for @hamsterDiet.
  ///
  /// In en, this message translates to:
  /// **'Hamster Diet'**
  String get hamsterDiet;

  /// No description provided for @hamsterDietContent.
  ///
  /// In en, this message translates to:
  /// **'A hamster\'s main food should be quality hamster pellets. Supplement with fresh vegetables and occasional fruits as treats.'**
  String get hamsterDietContent;

  /// No description provided for @hamsterDietFullContent.
  ///
  /// In en, this message translates to:
  /// **'Hamsters are omnivores and need a balanced diet. Quality hamster pellets should make up the main diet. Give fresh vegetables daily: carrots, cucumbers, broccoli. Use fruits as treats, in small amounts. Offer protein with boiled egg or mealworms occasionally. Always keep fresh water available. Don\'t make sudden diet changes, transition slowly. Avoid sugary foods. Monitor weight regularly and adjust portions.'**
  String get hamsterDietFullContent;

  /// No description provided for @turtleCareGuide.
  ///
  /// In en, this message translates to:
  /// **'Turtle Care Guide'**
  String get turtleCareGuide;

  /// No description provided for @turtleCareGuideContent.
  ///
  /// In en, this message translates to:
  /// **'Turtles need an environment with proper water and dry areas. UV lighting and proper temperature are essential.'**
  String get turtleCareGuideContent;

  /// No description provided for @turtleCareGuideFullContent.
  ///
  /// In en, this message translates to:
  /// **'Turtle care requires specialized knowledge. Create an appropriately sized aquarium with both dry and water areas. Water temperature should be 24-28°C. UV-B lighting is essential for healthy shell development. Feed with quality turtle food and occasional vegetables. Change water regularly and use a filter system. Provide calcium supplements. Do regular vet checks. Prepare for long lifespans - turtles can live 20-50 years.'**
  String get turtleCareGuideFullContent;

  /// No description provided for @puppyCareGuide.
  ///
  /// In en, this message translates to:
  /// **'Puppy Care Guide'**
  String get puppyCareGuide;

  /// No description provided for @puppyCareGuideContent.
  ///
  /// In en, this message translates to:
  /// **'The first few months are critical for puppies. Feeding, training, and socialization should be planned carefully.'**
  String get puppyCareGuideContent;

  /// No description provided for @puppyCareGuideFullContent.
  ///
  /// In en, this message translates to:
  /// **'Your puppy\'s first year is very important. In the first few months, complete the vaccination schedule. Feed quality puppy food 3-4 times daily. Begin toilet training immediately. Start socialization early - expose to different people, animals, and environments. Basic obedience training can begin around 8 weeks. Provide adequate sleep and rest time. Regular vet check-ups. Secure your home with puppy-proofing. Show love and patience.'**
  String get puppyCareGuideFullContent;

  /// No description provided for @kittenCareGuide.
  ///
  /// In en, this message translates to:
  /// **'Kitten Care Guide'**
  String get kittenCareGuide;

  /// No description provided for @kittenCareGuideContent.
  ///
  /// In en, this message translates to:
  /// **'Kittens need special nutrition, safe play areas, and regular vet visits in their first months.'**
  String get kittenCareGuideContent;

  /// No description provided for @kittenCareGuideFullContent.
  ///
  /// In en, this message translates to:
  /// **'Your kitten\'s first months are critical. Feed kitten-specific food 3-4 times daily until 6 months, then reduce to twice daily. Keep the litter box clean and easily accessible. Complete vaccinations and parasite treatments on schedule. Provide safe toys and scratching posts. Create high resting spots. Monitor socialization, introduce different people and sounds. Regular vet visits for health checks. Secure your home for kitten safety.'**
  String get kittenCareGuideFullContent;

  /// No description provided for @petNutritionGuide.
  ///
  /// In en, this message translates to:
  /// **'Pet Nutrition Guide'**
  String get petNutritionGuide;

  /// No description provided for @petNutritionGuideContent.
  ///
  /// In en, this message translates to:
  /// **'Proper nutrition is the cornerstone of pet health. Each species has different nutritional needs.'**
  String get petNutritionGuideContent;

  /// No description provided for @petNutritionGuideFullContent.
  ///
  /// In en, this message translates to:
  /// **'Proper nutrition is the foundation of your pet\'s health. Dogs and cats need protein-based diets. Choose age and size-appropriate food. Avoid human foods. Provide fresh water always. Don\'t overfeed - obesity is a common problem. Follow feeding schedules. Read labels carefully. Consult your vet for special dietary needs. Make diet changes gradually over 7-10 days. Monitor weight and body condition regularly.'**
  String get petNutritionGuideFullContent;

  /// No description provided for @toxicFoodsForPets.
  ///
  /// In en, this message translates to:
  /// **'Toxic Foods for Pets'**
  String get toxicFoodsForPets;

  /// No description provided for @toxicFoodsForPetsContent.
  ///
  /// In en, this message translates to:
  /// **'Some human foods can be deadly for pets. Learn and avoid these dangerous foods.'**
  String get toxicFoodsForPetsContent;

  /// No description provided for @toxicFoodsForPetsFullContent.
  ///
  /// In en, this message translates to:
  /// **'Many common foods are dangerous for pets. For dogs and cats: chocolate, grapes, raisins, onions, garlic, xylitol, alcohol, caffeine, macadamia nuts, avocado are toxic. Cooked bones can splinter. Raw meat may contain bacteria. Some plants are also poisonous: lilies (cats), azaleas, tulips, oleander. If poisoning is suspected, contact your vet immediately. Keep toxic foods and plants out of reach.'**
  String get toxicFoodsForPetsFullContent;

  /// No description provided for @dogExerciseGuide.
  ///
  /// In en, this message translates to:
  /// **'Dog Exercise Guide'**
  String get dogExerciseGuide;

  /// No description provided for @dogExerciseGuideContent.
  ///
  /// In en, this message translates to:
  /// **'Regular exercise is essential for your dog\'s physical and mental health. The amount varies by breed and age.'**
  String get dogExerciseGuideContent;

  /// No description provided for @dogExerciseGuideFullContent.
  ///
  /// In en, this message translates to:
  /// **'Exercise is crucial for your dog\'s health and happiness. Most dogs need 30-60 minutes daily. High-energy breeds may need 1-2 hours. Include walks, running, fetch, and swimming. Mental exercise is also important - puzzle toys, training games. Puppies have special exercise needs - avoid over-exercising to protect developing joints. Senior dogs need gentler exercise. Adjust for weather conditions. Regular exercise prevents obesity and behavioral problems.'**
  String get dogExerciseGuideFullContent;

  /// No description provided for @catPlaytimeIdeas.
  ///
  /// In en, this message translates to:
  /// **'Cat Playtime Ideas'**
  String get catPlaytimeIdeas;

  /// No description provided for @catPlaytimeIdeasContent.
  ///
  /// In en, this message translates to:
  /// **'Play is essential for cats\' physical and mental well-being. Interactive play mimics hunting behavior.'**
  String get catPlaytimeIdeasContent;

  /// No description provided for @catPlaytimeIdeasFullContent.
  ///
  /// In en, this message translates to:
  /// **'Playtime is essential for cats of all ages. Aim for at least 15-20 minutes of interactive play daily. Use feather wands, laser pointers (never shine in eyes), and toy mice. Rotate toys to maintain interest. Puzzle feeders stimulate mental activity. Create climbing opportunities and window perches for bird watching. Catnip toys can enhance play. Multiple short play sessions are better than one long one. Play before feeding mimics the hunt-eat-groom-sleep cycle.'**
  String get catPlaytimeIdeasFullContent;

  /// No description provided for @dogBehaviorProblems.
  ///
  /// In en, this message translates to:
  /// **'Dog Behavior Problems'**
  String get dogBehaviorProblems;

  /// No description provided for @dogBehaviorProblemsContent.
  ///
  /// In en, this message translates to:
  /// **'Barking, digging, and chewing are common behavioral issues that can be addressed with proper training.'**
  String get dogBehaviorProblemsContent;

  /// No description provided for @dogBehaviorProblemsFullContent.
  ///
  /// In en, this message translates to:
  /// **'Understanding why dogs misbehave helps solve problems. Excessive barking often indicates boredom, anxiety, or territorial behavior. Provide adequate exercise and mental stimulation. Chewing can be redirected to appropriate toys. Digging may indicate boredom or hunting instincts - create a designated digging area. Separation anxiety requires gradual desensitization. Aggression needs professional help. Use positive reinforcement, never punishment. Consistency is key. Consider professional training for serious issues.'**
  String get dogBehaviorProblemsFullContent;

  /// No description provided for @catBehaviorProblems.
  ///
  /// In en, this message translates to:
  /// **'Cat Behavior Problems'**
  String get catBehaviorProblems;

  /// No description provided for @catBehaviorProblemsContent.
  ///
  /// In en, this message translates to:
  /// **'Scratching furniture, spraying, and aggression are common cat issues that can be managed effectively.'**
  String get catBehaviorProblemsContent;

  /// No description provided for @catBehaviorProblemsFullContent.
  ///
  /// In en, this message translates to:
  /// **'Understanding cat behavior helps address issues. Scratching is natural - provide scratching posts and pads. Spraying may indicate stress, territorial issues, or medical problems - consult vet first. Aggression can stem from fear, play, or redirected frustration. Provide hiding spots and vertical space. Litter box avoidance often has medical causes. Use pheromone diffusers for stress. Never physically punish cats. Create a enriched environment. Multiple cats need multiple resources.'**
  String get catBehaviorProblemsFullContent;

  /// No description provided for @petAllergies.
  ///
  /// In en, this message translates to:
  /// **'Pet Allergies'**
  String get petAllergies;

  /// No description provided for @petAllergiesContent.
  ///
  /// In en, this message translates to:
  /// **'Pets can suffer from food, environmental, and contact allergies. Recognizing symptoms early is important.'**
  String get petAllergiesContent;

  /// No description provided for @petAllergiesFullContent.
  ///
  /// In en, this message translates to:
  /// **'Allergies are common in pets. Symptoms include itching, redness, ear infections, digestive issues, and paw licking. Food allergies may require elimination diets. Environmental allergies (pollen, dust mites) are seasonal or year-round. Contact allergies from cleaning products or bedding materials. Flea allergy dermatitis is very common. Diagnosis may require vet tests. Treatment includes avoidance, medications, and special diets. Regular bathing can help. Some pets benefit from allergy shots.'**
  String get petAllergiesFullContent;

  /// No description provided for @petWeightManagement.
  ///
  /// In en, this message translates to:
  /// **'Pet Weight Management'**
  String get petWeightManagement;

  /// No description provided for @petWeightManagementContent.
  ///
  /// In en, this message translates to:
  /// **'Obesity is a common problem in pets that leads to serious health issues. Proper diet and exercise are key.'**
  String get petWeightManagementContent;

  /// No description provided for @petWeightManagementFullContent.
  ///
  /// In en, this message translates to:
  /// **'Pet obesity is a growing concern. Overweight pets face diabetes, joint problems, heart disease, and shorter lifespans. Assess body condition - you should feel ribs easily. Measure food portions accurately. Avoid excessive treats - keep under 10% of daily calories. Increase exercise gradually. Consider weight management foods. Regular weigh-ins track progress. The whole family must follow the plan. Slow weight loss is healthier. Consult your vet for a weight loss program.'**
  String get petWeightManagementFullContent;

  /// No description provided for @spayNeuterBenefits.
  ///
  /// In en, this message translates to:
  /// **'Spay/Neuter Benefits'**
  String get spayNeuterBenefits;

  /// No description provided for @spayNeuterBenefitsContent.
  ///
  /// In en, this message translates to:
  /// **'Spaying and neutering provide health benefits and help control pet population.'**
  String get spayNeuterBenefitsContent;

  /// No description provided for @spayNeuterBenefitsFullContent.
  ///
  /// In en, this message translates to:
  /// **'Spaying and neutering offer many benefits. Health benefits: reduced risk of certain cancers, no uterine infections, prevents testicular cancer. Behavioral benefits: less roaming, reduced aggression, no heat cycles. Population control: prevents unwanted litters. Best timing varies by species and size - discuss with your vet. Recovery typically takes 10-14 days. Follow post-operative care instructions carefully. Some weight gain may occur - adjust diet accordingly.'**
  String get spayNeuterBenefitsFullContent;

  /// No description provided for @springPetCare.
  ///
  /// In en, this message translates to:
  /// **'Spring Pet Care'**
  String get springPetCare;

  /// No description provided for @springPetCareContent.
  ///
  /// In en, this message translates to:
  /// **'Spring brings new challenges for pet care including allergies, parasites, and outdoor hazards.'**
  String get springPetCareContent;

  /// No description provided for @springPetCareFullContent.
  ///
  /// In en, this message translates to:
  /// **'Spring requires special pet care attention. Start flea and tick prevention. Watch for allergy symptoms - itching, sneezing. Check gardens for toxic plants. Remove antifreeze and winter chemicals. Update ID tags and microchip info for more outdoor time. Gradually increase outdoor exercise. Watch for encounters with wildlife. Be cautious with open windows for cats. Spring cleaning products can be toxic - keep pets away. Fresh start with grooming and vet checkups.'**
  String get springPetCareFullContent;

  /// No description provided for @autumnPetCare.
  ///
  /// In en, this message translates to:
  /// **'Autumn Pet Care'**
  String get autumnPetCare;

  /// No description provided for @autumnPetCareContent.
  ///
  /// In en, this message translates to:
  /// **'Fall brings seasonal changes that require adjustments in pet care routines.'**
  String get autumnPetCareContent;

  /// No description provided for @autumnPetCareFullContent.
  ///
  /// In en, this message translates to:
  /// **'Autumn brings unique challenges for pets. Watch for mushrooms and falling nuts that can be toxic. School supplies like glue and markers are hazardous. Rodent poisons become common - keep pets away. Shorter days mean more indoor time - increase mental stimulation. Continue flea and tick prevention. Molting season requires more grooming. Adjust food portions for activity level changes. Check heating systems before use. Keep holiday decorations safe.'**
  String get autumnPetCareFullContent;

  /// No description provided for @petFriendlyHome.
  ///
  /// In en, this message translates to:
  /// **'Creating a Pet-Friendly Home'**
  String get petFriendlyHome;

  /// No description provided for @petFriendlyHomeContent.
  ///
  /// In en, this message translates to:
  /// **'Make your home safe and comfortable for your pets by removing hazards and creating dedicated spaces.'**
  String get petFriendlyHomeContent;

  /// No description provided for @petFriendlyHomeFullContent.
  ///
  /// In en, this message translates to:
  /// **'Creating a pet-friendly home ensures safety and comfort. Secure toxic substances: cleaning products, medications, plants. Cover electrical cords. Install baby gates if needed. Secure trash cans. Remove small choking hazards. Create comfortable rest areas. Provide scratching posts for cats. Ensure water access. Consider pet-safe flooring. Create outdoor safety with secure fencing. Store foods safely. Use pet-safe cleaning products. Regular safety audits as pets grow or age.'**
  String get petFriendlyHomeFullContent;

  /// No description provided for @movingWithPets.
  ///
  /// In en, this message translates to:
  /// **'Moving with Pets'**
  String get movingWithPets;

  /// No description provided for @movingWithPetsContent.
  ///
  /// In en, this message translates to:
  /// **'Moving can be stressful for pets. Proper planning helps minimize anxiety and ensures safety.'**
  String get movingWithPetsContent;

  /// No description provided for @movingWithPetsFullContent.
  ///
  /// In en, this message translates to:
  /// **'Moving requires careful planning for pets. Before moving: update microchip and ID tags, get copies of medical records, research new area vets. During packing: maintain routines, keep pets away from moving chaos. Moving day: keep pets in a quiet room or with a friend. Transport: use secure carriers, have water and supplies ready. New home: set up a safe room first with familiar items. Gradually introduce to new spaces. Re-establish routines quickly. Watch for stress signs.'**
  String get movingWithPetsFullContent;

  /// No description provided for @petsAndBabies.
  ///
  /// In en, this message translates to:
  /// **'Pets and Babies'**
  String get petsAndBabies;

  /// No description provided for @petsAndBabiesContent.
  ///
  /// In en, this message translates to:
  /// **'Introducing a new baby to your pet requires preparation and careful management.'**
  String get petsAndBabiesContent;

  /// No description provided for @petsAndBabiesFullContent.
  ///
  /// In en, this message translates to:
  /// **'Preparing pets for a new baby takes time. Before baby arrives: gradually adjust routines, set up baby equipment for pet to investigate, use recordings of baby sounds. Create pet-free zones. Brush up on obedience training. After baby arrives: have someone bring home baby\'s scent first. Introduce gradually with pet on leash. Never leave baby and pet alone together. Maintain pet\'s routine as much as possible. Reward calm behavior around baby. Watch for stress signs.'**
  String get petsAndBabiesFullContent;

  /// No description provided for @basicDogCommands.
  ///
  /// In en, this message translates to:
  /// **'Basic Dog Commands'**
  String get basicDogCommands;

  /// No description provided for @basicDogCommandsContent.
  ///
  /// In en, this message translates to:
  /// **'Teaching basic commands creates a well-behaved dog and strengthens your bond.'**
  String get basicDogCommandsContent;

  /// No description provided for @basicDogCommandsFullContent.
  ///
  /// In en, this message translates to:
  /// **'Basic obedience training is essential. Start with sit: hold treat above nose, move back. Down: from sit, lower treat to ground. Stay: gradually increase distance and duration. Come: use excited voice, big rewards. Leave it: protects from dangers. Heel: for leash walking. Use positive reinforcement - treats, praise, play. Keep sessions short (5-10 minutes). Practice in different locations. Be consistent with commands. End sessions positively. Consider professional training classes.'**
  String get basicDogCommandsFullContent;

  /// No description provided for @houseTrainingContent.
  ///
  /// In en, this message translates to:
  /// **'Consistent house training establishes good bathroom habits for puppies and newly adopted pets.'**
  String get houseTrainingContent;

  /// No description provided for @houseTrainingFullContent.
  ///
  /// In en, this message translates to:
  /// **'Successful house training requires consistency and patience. Take puppies out frequently: after waking, eating, playing, and every 2-3 hours. Choose a designated bathroom spot. Use a cue word during elimination. Reward immediately after. Supervise indoors or use crate training. Clean accidents with enzyme cleaners. Never punish accidents - interrupt and redirect outside. Watch for signs: sniffing, circling. Adult dogs need similar patience. Success takes weeks to months. Maintain schedule even after success.'**
  String get houseTrainingFullContent;

  /// No description provided for @birdDietGuide.
  ///
  /// In en, this message translates to:
  /// **'Bird Diet Guide'**
  String get birdDietGuide;

  /// No description provided for @birdDietGuideContent.
  ///
  /// In en, this message translates to:
  /// **'Proper nutrition is essential for bird health. Seeds alone are not a complete diet.'**
  String get birdDietGuideContent;

  /// No description provided for @birdDietGuideFullContent.
  ///
  /// In en, this message translates to:
  /// **'Bird nutrition varies by species. Most birds need a base of quality pellets (60-70% of diet), supplemented with fresh vegetables and fruits. Seeds should be limited (10-20%) as they\'re high in fat. Leafy greens: kale, spinach, chard. Safe fruits: apple, berries, melon (no avocado). Some birds need protein: cooked egg, beans. Always provide fresh water. Toxic foods: avocado, chocolate, caffeine, alcohol, onions. Change food daily. Consider species-specific requirements.'**
  String get birdDietGuideFullContent;

  /// No description provided for @birdHealthSigns.
  ///
  /// In en, this message translates to:
  /// **'Bird Health Signs'**
  String get birdHealthSigns;

  /// No description provided for @birdHealthSignsContent.
  ///
  /// In en, this message translates to:
  /// **'Birds hide illness well. Knowing the signs of health problems can save their lives.'**
  String get birdHealthSignsContent;

  /// No description provided for @birdHealthSignsFullContent.
  ///
  /// In en, this message translates to:
  /// **'Birds instinctively hide illness, so subtle changes matter. Warning signs: fluffed feathers, sitting on cage floor, changes in droppings, tail bobbing, discharge from eyes or nostrils, changes in appetite, less vocalization, feather picking, weight loss. Healthy birds are alert, active, have clean feathers, clear eyes, and regular eating patterns. Any behavior change warrants vet attention. Find an avian-specialized vet before emergencies. Regular checkups recommended yearly.'**
  String get birdHealthSignsFullContent;

  /// No description provided for @fishTankMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Fish Tank Maintenance'**
  String get fishTankMaintenance;

  /// No description provided for @fishTankMaintenanceContent.
  ///
  /// In en, this message translates to:
  /// **'Regular tank maintenance keeps your fish healthy and your aquarium beautiful.'**
  String get fishTankMaintenanceContent;

  /// No description provided for @fishTankMaintenanceFullContent.
  ///
  /// In en, this message translates to:
  /// **'Consistent maintenance is key to a healthy aquarium. Weekly: test water parameters (ammonia, nitrite, nitrate, pH), 10-20% water change, clean algae from glass, check equipment. Monthly: clean filter media (never replace all at once), vacuum gravel, trim plants. Never change more than 25% water at once. Use water conditioner for tap water. Monitor temperature daily. Feed appropriate amounts - excess food pollutes water. Watch for fish behavior changes indicating problems.'**
  String get fishTankMaintenanceFullContent;

  /// No description provided for @fishDiseasePrevention.
  ///
  /// In en, this message translates to:
  /// **'Fish Disease Prevention'**
  String get fishDiseasePrevention;

  /// No description provided for @fishDiseasePreventionContent.
  ///
  /// In en, this message translates to:
  /// **'Prevention is better than treatment for fish diseases. Good water quality is the foundation.'**
  String get fishDiseasePreventionContent;

  /// No description provided for @fishDiseasePreventionFullContent.
  ///
  /// In en, this message translates to:
  /// **'Prevention is the best approach to fish health. Maintain excellent water quality through regular testing and changes. Quarantine new fish for 2-4 weeks before adding to main tank. Avoid overstocking. Don\'t overfeed. Choose compatible species. Common diseases: ich (white spots), fin rot, fungal infections. Watch for: clamped fins, loss of color, spots, abnormal swimming, loss of appetite. Have basic medications on hand. Research species-specific diseases. Find a fish-experienced vet.'**
  String get fishDiseasePreventionFullContent;

  /// No description provided for @rabbitHousing.
  ///
  /// In en, this message translates to:
  /// **'Rabbit Housing'**
  String get rabbitHousing;

  /// No description provided for @rabbitHousingContent.
  ///
  /// In en, this message translates to:
  /// **'Rabbits need spacious, safe housing that allows for natural behaviors.'**
  String get rabbitHousingContent;

  /// No description provided for @rabbitHousingFullContent.
  ///
  /// In en, this message translates to:
  /// **'Rabbit housing should be at least 4 times the rabbit\'s size. Include: hiding area, litter box, food and water containers, toys. Indoor housing is safer. Outdoor hutches need weather protection and predator-proofing. Rabbits need daily exercise time outside their enclosure - minimum 3 hours. Rabbit-proof exercise areas by protecting wires and plants. Flooring should be solid (not wire). Bedding: hay, paper, or fleece. Avoid cedar and pine shavings. Clean daily and deep clean weekly.'**
  String get rabbitHousingFullContent;

  /// No description provided for @rabbitHealthGuide.
  ///
  /// In en, this message translates to:
  /// **'Rabbit Health Guide'**
  String get rabbitHealthGuide;

  /// No description provided for @rabbitHealthGuideContent.
  ///
  /// In en, this message translates to:
  /// **'Rabbits have specific health needs including dental care and digestive health monitoring.'**
  String get rabbitHealthGuideContent;

  /// No description provided for @rabbitHealthGuideFullContent.
  ///
  /// In en, this message translates to:
  /// **'Rabbit health requires specialized knowledge. Teeth grow continuously - provide unlimited hay for dental wear. Watch for drooling or eating difficulties. GI stasis is an emergency - watch for decreased appetite, small or no droppings, lethargy. Spaying/neutering prevents cancer and behavioral issues. Check nails regularly and trim as needed. Watch for mites and fleas. Myxomatosis and VHD vaccinations where available. Find a rabbit-savvy vet. Annual checkups recommended. Handle gently - rabbits have fragile spines.'**
  String get rabbitHealthGuideFullContent;

  /// No description provided for @petEmergencyKit.
  ///
  /// In en, this message translates to:
  /// **'Pet Emergency Kit'**
  String get petEmergencyKit;

  /// No description provided for @petEmergencyKitContent.
  ///
  /// In en, this message translates to:
  /// **'Every pet owner should have an emergency kit ready for disasters and health emergencies.'**
  String get petEmergencyKitContent;

  /// No description provided for @petEmergencyKitFullContent.
  ///
  /// In en, this message translates to:
  /// **'Be prepared for emergencies with a pet kit. Include: 3-day supply of food and water, medications, first aid supplies (bandages, gauze, tape, antiseptic), copies of medical records and ID, recent photos, carrier or leash, blanket, litter and disposal bags, toys for comfort. Know your vet\'s emergency contact and nearest 24-hour clinic. Have a pet first aid guide. Consider pet insurance. Practice evacuation with pets. Keep kit accessible and updated. Include comfort items to reduce stress.'**
  String get petEmergencyKitFullContent;

  /// No description provided for @emergencySigns.
  ///
  /// In en, this message translates to:
  /// **'Emergency Signs in Pets'**
  String get emergencySigns;

  /// No description provided for @emergencySignsContent.
  ///
  /// In en, this message translates to:
  /// **'Knowing emergency signs can save your pet\'s life. Some situations require immediate veterinary care.'**
  String get emergencySignsContent;

  /// No description provided for @emergencySignsFullContent.
  ///
  /// In en, this message translates to:
  /// **'Some situations are emergencies requiring immediate vet care. Signs: difficulty breathing, collapse, severe bleeding, trauma, seizures lasting over 3 minutes, suspected poisoning, inability to urinate, bloated abdomen (especially dogs), prolonged vomiting or diarrhea, heat stroke, pale gums, eye injuries, broken bones. Don\'t wait - time matters. Know your closest emergency vet. Keep poison control numbers handy. Stay calm, keep pet warm, minimize movement. Have carrier ready for transport.'**
  String get emergencySignsFullContent;

  /// No description provided for @healthyFeedingFullContent.
  ///
  /// In en, this message translates to:
  /// **'Providing a balanced and nutritious diet is critical for your dog\'s health. Choose quality food appropriate for their age, weight, and activity level. Puppies, adults, and senior dogs have different nutritional needs. Measure food portions accurately to prevent obesity. Feed 2-3 meals daily at consistent times. Always keep fresh water available. Avoid table scraps and human foods, especially toxic ones like chocolate, grapes, onions, and xylitol. Consider breed-specific nutritional requirements. Consult your vet for special dietary needs or allergies. Monitor weight and body condition regularly, adjusting portions as needed.'**
  String get healthyFeedingFullContent;

  /// No description provided for @catHappinessFullContent.
  ///
  /// In en, this message translates to:
  /// **'A happy cat needs mental stimulation, physical activity, and personal space. Provide at least 15-20 minutes of interactive play daily using feather wands, laser pointers, or toy mice. Create window sunbathing spots for bird watching. Install scratching posts in multiple locations. Offer vertical spaces like cat trees and shelves. Keep the litter box clean - scoop daily and change litter regularly. Create calm retreats away from household activity. Multiple cats need multiple resources. Consider puzzle feeders for mental stimulation. Establish routines for feeding and play. Respect your cat\'s need for alone time.'**
  String get catHappinessFullContent;

  /// No description provided for @birdTrainingFullContent.
  ///
  /// In en, this message translates to:
  /// **'Patience and consistency are crucial when training your bird. Use positive reinforcement methods exclusively - never punishment. Keep training sessions short (5-10 minutes) and at the same time daily. Start with basic commands: step up onto your hand, come when called. Use favorite treats as rewards but keep overall portion in check. Learn your bird\'s body language to recognize stress or fatigue. Create a quiet, distraction-free training environment. Repeat commands consistently. Talk to your bird regularly to build vocabulary. Some species learn tricks easily, others need more time. Celebrate small victories.'**
  String get birdTrainingFullContent;

  /// No description provided for @smallPetHabitatFullContent.
  ///
  /// In en, this message translates to:
  /// **'Creating the right habitat for small pets is essential for their well-being. Choose an appropriately sized enclosure - bigger is always better. Ensure proper ventilation while avoiding drafts. Provide appropriate bedding: paper-based for hamsters, hay for guinea pigs and rabbits. Include hiding spots for security and nesting materials. Add exercise equipment like wheels (solid surface, not wire) for hamsters. Create exploration areas with tunnels and platforms. Maintain appropriate temperature for the species. Keep away from direct sunlight and heat sources. Clean the habitat weekly at minimum. Provide fresh water and species-appropriate food daily.'**
  String get smallPetHabitatFullContent;

  /// No description provided for @commonDiseaseSymptomsFullContent.
  ///
  /// In en, this message translates to:
  /// **'Recognizing disease symptoms early can save your pet\'s life. Watch for: loss of appetite lasting more than 24 hours, lethargy or unusual tiredness, vomiting or diarrhea (especially if persistent or bloody), changes in water consumption, difficulty urinating or defecating, coughing or difficulty breathing, limping or difficulty moving, behavioral changes like hiding or aggression, changes in coat quality, discharge from eyes, nose, or ears, unexplained weight loss or gain. If you notice any of these symptoms, consult your veterinarian promptly. Keep a record of symptoms including timing and frequency to help with diagnosis.'**
  String get commonDiseaseSymptomsFullContent;

  /// No description provided for @travelingWithPetsFullContent.
  ///
  /// In en, this message translates to:
  /// **'Successful travel with pets requires careful planning. Start with a vet visit for health certificates and updated vaccinations. Get your pet accustomed to their carrier weeks before travel. For car travel: take regular breaks every 2-3 hours, never leave pets in parked cars, secure carriers safely. For air travel: check airline pet policies, book direct flights when possible, choose appropriate carrier dimensions. Pack essentials: food, water, bowls, medications, waste bags, favorite toy, recent photos, medical records, ID tags with contact info. Research pet-friendly accommodations. Some pets may benefit from anti-anxiety aids - consult your vet.'**
  String get travelingWithPetsFullContent;

  /// No description provided for @firstAidForPetsFullContent.
  ///
  /// In en, this message translates to:
  /// **'Every pet owner should be prepared for emergencies. Create a first aid kit containing: gauze rolls and pads, adhesive tape, antiseptic wipes, tweezers, scissors, digital thermometer, clean towels, hydrogen peroxide (for inducing vomiting if directed by vet), antibiotic ointment, emergency blanket. For bleeding: apply direct pressure with clean cloth. For choking: check mouth carefully, perform gentle Heimlich if needed. For poisoning: call vet or poison control immediately, bring packaging if possible. For heatstroke: cool gradually with tepid water, not ice. Know CPR basics for pets. Keep emergency vet numbers accessible.'**
  String get firstAidForPetsFullContent;

  /// No description provided for @choosingRightPetFullContent.
  ///
  /// In en, this message translates to:
  /// **'Choosing the right pet is a long-term decision affecting your life for years. Consider your living situation: apartment vs. house, rental restrictions, yard space. Evaluate your lifestyle: work schedule, travel frequency, activity level. Think about costs: food, veterinary care, grooming, equipment, pet insurance. Different pets have different needs: dogs require daily walks and attention; cats are more independent but need play and care; birds need social interaction and can be loud; small mammals like rabbits need space and specific care; fish require proper aquarium maintenance. Research specific breeds within species. Consider adopting from shelters. Meet potential pets before deciding.'**
  String get choosingRightPetFullContent;

  /// No description provided for @dentalCareForPetsFullContent.
  ///
  /// In en, this message translates to:
  /// **'Dental health directly impacts overall health in pets. By age 3, most dogs and cats have some dental disease. Brush teeth 2-3 times weekly using pet-specific toothpaste (never human toothpaste - fluoride is toxic). Start dental care young to build acceptance. Use enzymatic dental chews and toys designed for dental health. Schedule professional cleanings as recommended by your vet. Warning signs of dental problems: bad breath, difficulty eating, drooling, pawing at mouth, loose or discolored teeth, bleeding gums, facial swelling. Untreated dental disease can lead to heart, kidney, and liver problems. Small breeds often need more frequent dental care.'**
  String get dentalCareForPetsFullContent;

  /// No description provided for @socializingYourPuppyFullContent.
  ///
  /// In en, this message translates to:
  /// **'The critical socialization period is 3-16 weeks of age. During this time, expose puppies to: different types of people (various ages, appearances, uniforms), other vaccinated dogs and animals, various environments (urban, parks, pet-friendly stores), different surfaces (grass, gravel, metal grates), sounds (traffic, appliances, music), handling (paws, ears, mouth for vet visits). Make all experiences positive using treats and praise. Never force interactions. Attend puppy socialization classes for supervised introductions. Continue socialization throughout life. Poor socialization leads to fear and aggression. Balance exposure with protecting from diseases before vaccination completion.'**
  String get socializingYourPuppyFullContent;

  /// No description provided for @litterBoxProblemsFullContent.
  ///
  /// In en, this message translates to:
  /// **'Litter box avoidance is a common problem with solutions. First, rule out medical issues - UTIs, kidney disease, and arthritis can cause problems. The basic rule: one box per cat plus one extra. Clean boxes daily, change litter completely weekly. Place boxes in quiet, accessible locations - not near food or noisy appliances. Avoid covered boxes for some cats who feel trapped. Box should be 1.5 times cat\'s length. Try different litter types - some cats prefer unscented, fine-grained litter. Don\'t use strong-smelling cleaners. For multi-cat households, ensure boxes are in different locations. Clean accidents with enzyme cleaners to remove scent completely.'**
  String get litterBoxProblemsFullContent;

  /// No description provided for @fishAquariumFullContent.
  ///
  /// In en, this message translates to:
  /// **'Setting up a successful aquarium requires patience. Choose tank size appropriate for your fish species - bigger tanks are more stable. Wait 4-6 weeks for nitrogen cycle to establish before adding fish. Use quality filtration rated for your tank size. Test water weekly for ammonia, nitrite, nitrate, and pH. Maintain appropriate temperature for your species. Do 20-25% water changes weekly, treating new water with conditioner. Avoid overfeeding - feed only what fish consume in 2-3 minutes. Add fish gradually, not all at once. Research compatibility before mixing species. Provide appropriate décor and hiding spots. Consider live plants for natural filtration.'**
  String get fishAquariumFullContent;

  /// No description provided for @rabbitDietFullContent.
  ///
  /// In en, this message translates to:
  /// **'Proper nutrition keeps rabbits healthy. 80% of diet should be unlimited timothy hay - essential for dental wear and digestion. Offer fresh leafy greens daily: romaine lettuce, cilantro, parsley, dandelion greens. Limit high-calcium greens like kale. Quality pellets should be timothy-based, plain without seeds or treats - about 1/4 cup per 5 lbs body weight. Fresh fruits only as occasional treats - apple, berries, banana - no more than 1 tablespoon per 2 lbs. Avoid iceberg lettuce, beans, bread, cereals, chocolate. Fresh water always available - consider a bottle and bowl. Introduce new foods gradually to avoid GI upset.'**
  String get rabbitDietFullContent;

  /// No description provided for @introducingNewPetFullContent.
  ///
  /// In en, this message translates to:
  /// **'Successfully introducing a new pet takes patience. Before arrival: prepare separate living space with own food, water, litter/bedding, and toys. First days: keep new pet isolated to decompress and get vet check. Scent exchange: swap bedding between pets so they become familiar with each other\'s smell. Visual introduction: use baby gates or cracked doors for supervised viewing. Short meetings: keep initial interactions brief and positive, with treats for calm behavior. Watch body language for signs of stress or aggression. Never force interactions. Increase meeting duration gradually. The process can take days to months. Equal attention prevents jealousy.'**
  String get introducingNewPetFullContent;

  /// No description provided for @winterCareTipsFullContent.
  ///
  /// In en, this message translates to:
  /// **'Winter brings special challenges for pet care. Limit outdoor time in freezing temperatures, especially for small, senior, or short-haired pets. Consider pet-safe sweaters or jackets for short-coated dogs. Protect paws from salt and chemical de-icers - wipe paws after walks or use pet booties. Check for antifreeze spills which are sweet-tasting but deadly. Provide warm, draft-free sleeping areas elevated from cold floors. Indoor heating can dry skin - consider a humidifier and omega fatty acid supplements for coat health. Keep cats indoors - outdoor cats may seek warmth in car engines. Increase food slightly for outdoor pets burning more calories.'**
  String get winterCareTipsFullContent;

  /// No description provided for @summerSafetyFullContent.
  ///
  /// In en, this message translates to:
  /// **'Hot weather poses serious risks for pets. Never leave pets in parked cars - temperatures can become fatal within minutes even with windows cracked. Provide constant access to fresh water and shade. Walk dogs during cooler morning and evening hours. Check pavement temperature with your hand - if it\'s too hot for you, it\'s too hot for paw pads. Watch for heat stroke signs: excessive panting, drooling, weakness, vomiting, collapse. Keep pets with light skin or thin coats protected from sunburn. Maintain regular grooming but don\'t shave double-coated breeds - their coat provides insulation. Be aware of increased snake and insect activity. Avoid toxic lawn treatments.'**
  String get summerSafetyFullContent;

  /// No description provided for @understandingBodyLanguageFullContent.
  ///
  /// In en, this message translates to:
  /// **'Understanding your pet\'s body language improves your relationship and prevents problems. Dogs: wagging tail doesn\'t always mean happy - position and speed matter; ears back and low body indicates fear; direct stare can be aggressive. Cats: slow blinks show affection; ears flat means fear or aggression; exposed belly isn\'t always an invitation to touch. Tail position tells a lot: high and relaxed is confident, low or tucked shows fear. Recognize stress signals: yawning, lip licking, turning away. Birds fluff feathers when content but also when ill. Each pet has individual quirks - learn your pet\'s personal signals. Changes in behavior often indicate health issues.'**
  String get understandingBodyLanguageFullContent;

  /// No description provided for @diyPetToysFullContent.
  ///
  /// In en, this message translates to:
  /// **'Creating homemade toys saves money and provides enrichment. For dogs: braid old t-shirts into tug ropes, fill Kong with frozen peanut butter, make treat puzzles from muffin tins and tennis balls. For cats: create wands from sticks and feathers, make crinkle toys from paper in socks, construct boxes-within-boxes mazes. For small animals: toilet paper tubes stuffed with hay, cardboard box hideaways, paper bag tunnels. Always use pet-safe materials - no toxic dyes, small parts, or strings that can be swallowed. Supervise play with homemade toys. Check regularly for damage and discard worn toys. Rotate toys to maintain interest.'**
  String get diyPetToysFullContent;

  /// No description provided for @seniorPetCareFullContent.
  ///
  /// In en, this message translates to:
  /// **'Senior pets need adjusted care for their golden years. Increase vet visits to twice yearly for early problem detection. Switch to senior-formulated food to maintain healthy weight and support joints. Provide orthopedic beds for comfort. Adjust exercise - regular but gentler activities. Create easier access with ramps or steps to furniture. Monitor for cognitive changes: confusion, restlessness at night, house training regression. Watch for signs of arthritis: reluctance to jump, stiffness after rest. Regular dental care becomes even more important. Be patient with slower responses. Some seniors benefit from joint supplements - ask your vet. Maintain mental stimulation with appropriate activities.'**
  String get seniorPetCareFullContent;

  /// No description provided for @parasitePreventionFullContent.
  ///
  /// In en, this message translates to:
  /// **'Year-round parasite prevention protects pet and family health. Fleas cause itching, allergies, and transmit tapeworms - use monthly preventatives. Ticks carry Lyme disease and other serious illnesses - check pets after outdoor activities. Heartworm is transmitted by mosquitoes and is potentially fatal - monthly preventatives are essential. Intestinal parasites (roundworms, hookworms, tapeworms) require regular deworming. Get fecal exams at least annually. Clean up feces promptly to prevent spread. Keep living areas clean. Treat all pets in household simultaneously. Consult your vet for the best prevention program for your area and pet\'s lifestyle. Some parasites can infect humans - practice good hygiene.'**
  String get parasitePreventionFullContent;

  /// No description provided for @groomingYourPetAtHomeFullContent.
  ///
  /// In en, this message translates to:
  /// **'Regular grooming maintains health and strengthens your bond. Brush according to coat type: short coats weekly, long coats daily to prevent mats. Use appropriate brushes: slicker brushes for tangles, bristle brushes for finishing. Bathe as needed - overbathing strips natural oils. Use pet-specific shampoos. Trim nails every 2-4 weeks - have styptic powder ready for accidents. Clean ears weekly with vet-approved solution - never insert cotton swabs. Check teeth and gums regularly. Look for lumps, bumps, or skin changes during grooming. Start grooming routines early for easier handling. Use treats and positive reinforcement. Consider professional grooming for complex cuts or if pet is too anxious.'**
  String get groomingYourPetAtHomeFullContent;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @isSpayedNeutered.
  ///
  /// In en, this message translates to:
  /// **'Spayed/Neutered'**
  String get isSpayedNeutered;

  /// No description provided for @adoptionDate.
  ///
  /// In en, this message translates to:
  /// **'Adoption Date'**
  String get adoptionDate;

  /// No description provided for @trainingLevel.
  ///
  /// In en, this message translates to:
  /// **'Training Level'**
  String get trainingLevel;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @favoriteFood.
  ///
  /// In en, this message translates to:
  /// **'Favorite Food'**
  String get favoriteFood;

  /// No description provided for @favoriteToy.
  ///
  /// In en, this message translates to:
  /// **'Favorite Toy'**
  String get favoriteToy;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @cm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get cm;

  /// No description provided for @bloodType.
  ///
  /// In en, this message translates to:
  /// **'Blood Type'**
  String get bloodType;

  /// No description provided for @lastVetVisit.
  ///
  /// In en, this message translates to:
  /// **'Last Vet Visit'**
  String get lastVetVisit;

  /// No description provided for @dietType.
  ///
  /// In en, this message translates to:
  /// **'Diet Type'**
  String get dietType;

  /// No description provided for @regularDiet.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get regularDiet;

  /// No description provided for @vegetarianDiet.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get vegetarianDiet;

  /// No description provided for @rawDiet.
  ///
  /// In en, this message translates to:
  /// **'Raw'**
  String get rawDiet;

  /// No description provided for @prescriptionDiet.
  ///
  /// In en, this message translates to:
  /// **'Prescription'**
  String get prescriptionDiet;

  /// No description provided for @dailyExerciseMinutes.
  ///
  /// In en, this message translates to:
  /// **'Daily Exercise (Minutes)'**
  String get dailyExerciseMinutes;

  /// No description provided for @personality.
  ///
  /// In en, this message translates to:
  /// **'Personality'**
  String get personality;

  /// No description provided for @calm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get calm;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @playful.
  ///
  /// In en, this message translates to:
  /// **'Playful'**
  String get playful;

  /// No description provided for @shy.
  ///
  /// In en, this message translates to:
  /// **'Shy'**
  String get shy;

  /// No description provided for @friendly.
  ///
  /// In en, this message translates to:
  /// **'Friendly'**
  String get friendly;

  /// No description provided for @independent.
  ///
  /// In en, this message translates to:
  /// **'Independent'**
  String get independent;

  /// No description provided for @activityLevel.
  ///
  /// In en, this message translates to:
  /// **'Activity Level'**
  String get activityLevel;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @moderate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @dietaryRequirements.
  ///
  /// In en, this message translates to:
  /// **'Dietary Requirements'**
  String get dietaryRequirements;

  /// No description provided for @favoriteToys.
  ///
  /// In en, this message translates to:
  /// **'Favorite Toys'**
  String get favoriteToys;

  /// No description provided for @behavioralNotes.
  ///
  /// In en, this message translates to:
  /// **'Behavioral Notes'**
  String get behavioralNotes;

  /// No description provided for @passportNumber.
  ///
  /// In en, this message translates to:
  /// **'Passport Number'**
  String get passportNumber;

  /// No description provided for @ownerName.
  ///
  /// In en, this message translates to:
  /// **'Owner Name'**
  String get ownerName;

  /// No description provided for @ownerContact.
  ///
  /// In en, this message translates to:
  /// **'Owner Contact'**
  String get ownerContact;

  /// No description provided for @additionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalInfo;

  /// No description provided for @spayedOrNeutered.
  ///
  /// In en, this message translates to:
  /// **'Spayed/Neutered'**
  String get spayedOrNeutered;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @deleteAllData.
  ///
  /// In en, this message translates to:
  /// **'Delete All Data'**
  String get deleteAllData;

  /// No description provided for @deleteAllDataConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete ALL data? This action cannot be undone.'**
  String get deleteAllDataConfirm;

  /// No description provided for @deleteAllDataWarning.
  ///
  /// In en, this message translates to:
  /// **'This will delete all pets, activities, health records, and expenses.'**
  String get deleteAllDataWarning;

  /// No description provided for @additionalInfoCard.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get additionalInfoCard;

  /// No description provided for @noVaccinationRecord.
  ///
  /// In en, this message translates to:
  /// **'No vaccination record found.'**
  String get noVaccinationRecord;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @nextLabel.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextLabel;

  /// No description provided for @currencySymbol.
  ///
  /// In en, this message translates to:
  /// **'\$'**
  String get currencySymbol;

  /// No description provided for @excellentStatus.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get excellentStatus;

  /// No description provided for @goodStatus.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get goodStatus;

  /// No description provided for @fairStatus.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get fairStatus;

  /// No description provided for @poorStatus.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get poorStatus;

  /// No description provided for @foodCategory.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get foodCategory;

  /// No description provided for @medicalCategory.
  ///
  /// In en, this message translates to:
  /// **'Medical'**
  String get medicalCategory;

  /// No description provided for @toysCategory.
  ///
  /// In en, this message translates to:
  /// **'Toys'**
  String get toysCategory;

  /// No description provided for @accessoriesCategory.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get accessoriesCategory;

  /// No description provided for @dogDailyCare.
  ///
  /// In en, this message translates to:
  /// **'Dog Daily Care'**
  String get dogDailyCare;

  /// No description provided for @catDailyCare.
  ///
  /// In en, this message translates to:
  /// **'Cat Daily Care'**
  String get catDailyCare;

  /// No description provided for @playAndActivity.
  ///
  /// In en, this message translates to:
  /// **'Play and Activity'**
  String get playAndActivity;

  /// No description provided for @catSpecialCare.
  ///
  /// In en, this message translates to:
  /// **'Cat Special Care'**
  String get catSpecialCare;

  /// No description provided for @cageArrangement.
  ///
  /// In en, this message translates to:
  /// **'Cage Arrangement'**
  String get cageArrangement;

  /// No description provided for @aquariumCare.
  ///
  /// In en, this message translates to:
  /// **'Aquarium Care'**
  String get aquariumCare;

  /// No description provided for @waterQuality.
  ///
  /// In en, this message translates to:
  /// **'Water Quality'**
  String get waterQuality;

  /// No description provided for @nutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutrition;

  /// No description provided for @exercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get exercise;

  /// No description provided for @generalDailyTip1.
  ///
  /// In en, this message translates to:
  /// **'Establish regular feeding times'**
  String get generalDailyTip1;

  /// No description provided for @generalDailyTip2.
  ///
  /// In en, this message translates to:
  /// **'Ensure clean water is always accessible'**
  String get generalDailyTip2;

  /// No description provided for @generalDailyTip3.
  ///
  /// In en, this message translates to:
  /// **'Set aside daily exercise and play time'**
  String get generalDailyTip3;

  /// No description provided for @generalDailyTip4.
  ///
  /// In en, this message translates to:
  /// **'Do not neglect grooming'**
  String get generalDailyTip4;

  /// No description provided for @generalDailyTip5.
  ///
  /// In en, this message translates to:
  /// **'Focus on dental hygiene'**
  String get generalDailyTip5;

  /// No description provided for @generalHealthTip1.
  ///
  /// In en, this message translates to:
  /// **'Vet check-up at least twice a year'**
  String get generalHealthTip1;

  /// No description provided for @generalHealthTip2.
  ///
  /// In en, this message translates to:
  /// **'Follow the vaccination schedule'**
  String get generalHealthTip2;

  /// No description provided for @generalHealthTip3.
  ///
  /// In en, this message translates to:
  /// **'Do not neglect parasite protection'**
  String get generalHealthTip3;

  /// No description provided for @generalHealthTip4.
  ///
  /// In en, this message translates to:
  /// **'Observe behavioral changes'**
  String get generalHealthTip4;

  /// No description provided for @generalHealthTip5.
  ///
  /// In en, this message translates to:
  /// **'Monitor weight'**
  String get generalHealthTip5;

  /// No description provided for @generalNutritionTip1.
  ///
  /// In en, this message translates to:
  /// **'Choose quality food suitable for their age'**
  String get generalNutritionTip1;

  /// No description provided for @generalNutritionTip2.
  ///
  /// In en, this message translates to:
  /// **'Practice portion control'**
  String get generalNutritionTip2;

  /// No description provided for @generalNutritionTip3.
  ///
  /// In en, this message translates to:
  /// **'Do not give human food'**
  String get generalNutritionTip3;

  /// No description provided for @generalNutritionTip4.
  ///
  /// In en, this message translates to:
  /// **'Always have fresh water available'**
  String get generalNutritionTip4;

  /// No description provided for @generalNutritionTip5.
  ///
  /// In en, this message translates to:
  /// **'Do not make sudden food changes'**
  String get generalNutritionTip5;

  /// No description provided for @generalSafetyTip1.
  ///
  /// In en, this message translates to:
  /// **'Keep dangerous household substances away'**
  String get generalSafetyTip1;

  /// No description provided for @generalSafetyTip2.
  ///
  /// In en, this message translates to:
  /// **'Have a microchip implanted'**
  String get generalSafetyTip2;

  /// No description provided for @generalSafetyTip3.
  ///
  /// In en, this message translates to:
  /// **'Keep identification information updated'**
  String get generalSafetyTip3;

  /// No description provided for @generalSafetyTip4.
  ///
  /// In en, this message translates to:
  /// **'Choose safe toys'**
  String get generalSafetyTip4;

  /// No description provided for @generalSafetyTip5.
  ///
  /// In en, this message translates to:
  /// **'Have emergency vet information ready'**
  String get generalSafetyTip5;

  /// No description provided for @dogDailyTip1.
  ///
  /// In en, this message translates to:
  /// **'Feeding 2-3 times a day'**
  String get dogDailyTip1;

  /// No description provided for @dogDailyTip2.
  ///
  /// In en, this message translates to:
  /// **'At least 30 minutes of daily walking'**
  String get dogDailyTip2;

  /// No description provided for @dogDailyTip3.
  ///
  /// In en, this message translates to:
  /// **'Brushing 2-3 times a week'**
  String get dogDailyTip3;

  /// No description provided for @dogDailyTip4.
  ///
  /// In en, this message translates to:
  /// **'Tooth brushing (2-3 times a week)'**
  String get dogDailyTip4;

  /// No description provided for @dogDailyTip5.
  ///
  /// In en, this message translates to:
  /// **'Ear cleaning (once a week)'**
  String get dogDailyTip5;

  /// No description provided for @dogTrainingTip1.
  ///
  /// In en, this message translates to:
  /// **'Teach basic commands (sit, stay, come)'**
  String get dogTrainingTip1;

  /// No description provided for @dogTrainingTip2.
  ///
  /// In en, this message translates to:
  /// **'Use positive reinforcement'**
  String get dogTrainingTip2;

  /// No description provided for @dogTrainingTip3.
  ///
  /// In en, this message translates to:
  /// **'Provide socialization training'**
  String get dogTrainingTip3;

  /// No description provided for @dogTrainingTip4.
  ///
  /// In en, this message translates to:
  /// **'Practice leash training'**
  String get dogTrainingTip4;

  /// No description provided for @dogTrainingTip5.
  ///
  /// In en, this message translates to:
  /// **'Be patient and consistent'**
  String get dogTrainingTip5;

  /// No description provided for @dogExerciseTip1.
  ///
  /// In en, this message translates to:
  /// **'Exercise suitable for age and breed'**
  String get dogExerciseTip1;

  /// No description provided for @dogExerciseTip2.
  ///
  /// In en, this message translates to:
  /// **'Set aside time for play'**
  String get dogExerciseTip2;

  /// No description provided for @dogExerciseTip3.
  ///
  /// In en, this message translates to:
  /// **'Provide mental stimulation'**
  String get dogExerciseTip3;

  /// No description provided for @dogExerciseTip4.
  ///
  /// In en, this message translates to:
  /// **'Try different routes'**
  String get dogExerciseTip4;

  /// No description provided for @dogExerciseTip5.
  ///
  /// In en, this message translates to:
  /// **'Pay attention to weather conditions'**
  String get dogExerciseTip5;

  /// No description provided for @catDailyTip1.
  ///
  /// In en, this message translates to:
  /// **'Feeding 2-3 times a day'**
  String get catDailyTip1;

  /// No description provided for @catDailyTip2.
  ///
  /// In en, this message translates to:
  /// **'Daily grooming'**
  String get catDailyTip2;

  /// No description provided for @catDailyTip3.
  ///
  /// In en, this message translates to:
  /// **'Litter box cleaning'**
  String get catDailyTip3;

  /// No description provided for @catDailyTip4.
  ///
  /// In en, this message translates to:
  /// **'Dental care'**
  String get catDailyTip4;

  /// No description provided for @catDailyTip5.
  ///
  /// In en, this message translates to:
  /// **'Nail trimming'**
  String get catDailyTip5;

  /// No description provided for @catPlayTip1.
  ///
  /// In en, this message translates to:
  /// **'Use interactive toys'**
  String get catPlayTip1;

  /// No description provided for @catPlayTip2.
  ///
  /// In en, this message translates to:
  /// **'Provide a scratching post'**
  String get catPlayTip2;

  /// No description provided for @catPlayTip3.
  ///
  /// In en, this message translates to:
  /// **'Create high places'**
  String get catPlayTip3;

  /// No description provided for @catPlayTip4.
  ///
  /// In en, this message translates to:
  /// **'Hidden food games'**
  String get catPlayTip4;

  /// No description provided for @catPlayTip5.
  ///
  /// In en, this message translates to:
  /// **'Regular play sessions'**
  String get catPlayTip5;

  /// No description provided for @catSpecialTip1.
  ///
  /// In en, this message translates to:
  /// **'Monitor for stress signs'**
  String get catSpecialTip1;

  /// No description provided for @catSpecialTip2.
  ///
  /// In en, this message translates to:
  /// **'Provide a calm environment'**
  String get catSpecialTip2;

  /// No description provided for @catSpecialTip3.
  ///
  /// In en, this message translates to:
  /// **'Do not break routines'**
  String get catSpecialTip3;

  /// No description provided for @catSpecialTip4.
  ///
  /// In en, this message translates to:
  /// **'Create safe areas'**
  String get catSpecialTip4;

  /// No description provided for @catSpecialTip5.
  ///
  /// In en, this message translates to:
  /// **'Do not make too many changes'**
  String get catSpecialTip5;

  /// No description provided for @birdCareTip1.
  ///
  /// In en, this message translates to:
  /// **'Daily cage cleaning'**
  String get birdCareTip1;

  /// No description provided for @birdCareTip2.
  ///
  /// In en, this message translates to:
  /// **'Give various grains and fruits'**
  String get birdCareTip2;

  /// No description provided for @birdCareTip3.
  ///
  /// In en, this message translates to:
  /// **'Change fresh water daily'**
  String get birdCareTip3;

  /// No description provided for @birdCareTip4.
  ///
  /// In en, this message translates to:
  /// **'Provide safe flight area'**
  String get birdCareTip4;

  /// No description provided for @birdCareTip5.
  ///
  /// In en, this message translates to:
  /// **'Establish social interaction'**
  String get birdCareTip5;

  /// No description provided for @birdCageTip1.
  ///
  /// In en, this message translates to:
  /// **'Cages of adequate size'**
  String get birdCageTip1;

  /// No description provided for @birdCageTip2.
  ///
  /// In en, this message translates to:
  /// **'Perches of different thicknesses'**
  String get birdCageTip2;

  /// No description provided for @birdCageTip3.
  ///
  /// In en, this message translates to:
  /// **'Toys and enrichment'**
  String get birdCageTip3;

  /// No description provided for @birdCageTip4.
  ///
  /// In en, this message translates to:
  /// **'Provide natural light'**
  String get birdCageTip4;

  /// No description provided for @birdCageTip5.
  ///
  /// In en, this message translates to:
  /// **'Protect from drafts'**
  String get birdCageTip5;

  /// No description provided for @rabbitCareTip1.
  ///
  /// In en, this message translates to:
  /// **'High fiber diet'**
  String get rabbitCareTip1;

  /// No description provided for @rabbitCareTip2.
  ///
  /// In en, this message translates to:
  /// **'Daily hay box cleaning'**
  String get rabbitCareTip2;

  /// No description provided for @rabbitCareTip3.
  ///
  /// In en, this message translates to:
  /// **'Free movement area'**
  String get rabbitCareTip3;

  /// No description provided for @rabbitCareTip4.
  ///
  /// In en, this message translates to:
  /// **'Trim nails regularly'**
  String get rabbitCareTip4;

  /// No description provided for @rabbitCareTip5.
  ///
  /// In en, this message translates to:
  /// **'Pay attention to dental care'**
  String get rabbitCareTip5;

  /// No description provided for @rabbitNutritionTip1.
  ///
  /// In en, this message translates to:
  /// **'Quality hay (primary food)'**
  String get rabbitNutritionTip1;

  /// No description provided for @rabbitNutritionTip2.
  ///
  /// In en, this message translates to:
  /// **'Fresh leafy vegetables'**
  String get rabbitNutritionTip2;

  /// No description provided for @rabbitNutritionTip3.
  ///
  /// In en, this message translates to:
  /// **'Limited amount of pellets'**
  String get rabbitNutritionTip3;

  /// No description provided for @rabbitNutritionTip4.
  ///
  /// In en, this message translates to:
  /// **'Fruits as treats'**
  String get rabbitNutritionTip4;

  /// No description provided for @rabbitNutritionTip5.
  ///
  /// In en, this message translates to:
  /// **'Always clean water'**
  String get rabbitNutritionTip5;

  /// No description provided for @fishCareTip1.
  ///
  /// In en, this message translates to:
  /// **'Monitor water temperature'**
  String get fishCareTip1;

  /// No description provided for @fishCareTip2.
  ///
  /// In en, this message translates to:
  /// **'Weekly partial water change'**
  String get fishCareTip2;

  /// No description provided for @fishCareTip3.
  ///
  /// In en, this message translates to:
  /// **'Clean the filter regularly'**
  String get fishCareTip3;

  /// No description provided for @fishCareTip4.
  ///
  /// In en, this message translates to:
  /// **'Measure pH levels'**
  String get fishCareTip4;

  /// No description provided for @fishCareTip5.
  ///
  /// In en, this message translates to:
  /// **'Avoid overfeeding'**
  String get fishCareTip5;

  /// No description provided for @fishWaterTip1.
  ///
  /// In en, this message translates to:
  /// **'Monitor ammonia levels'**
  String get fishWaterTip1;

  /// No description provided for @fishWaterTip2.
  ///
  /// In en, this message translates to:
  /// **'Nitrite and nitrate measurement'**
  String get fishWaterTip2;

  /// No description provided for @fishWaterTip3.
  ///
  /// In en, this message translates to:
  /// **'Do not neglect water changes'**
  String get fishWaterTip3;

  /// No description provided for @fishWaterTip4.
  ///
  /// In en, this message translates to:
  /// **'Neutralize chlorine'**
  String get fishWaterTip4;

  /// No description provided for @fishWaterTip5.
  ///
  /// In en, this message translates to:
  /// **'Avoid temperature changes'**
  String get fishWaterTip5;

  /// No description provided for @nutritionTab.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutritionTab;

  /// No description provided for @feedingProfile.
  ///
  /// In en, this message translates to:
  /// **'Feeding Profile'**
  String get feedingProfile;

  /// No description provided for @feedingSchedule.
  ///
  /// In en, this message translates to:
  /// **'Feeding Schedule'**
  String get feedingSchedule;

  /// No description provided for @editFeedingProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Feeding Profile'**
  String get editFeedingProfile;

  /// No description provided for @foodBrand.
  ///
  /// In en, this message translates to:
  /// **'Food Brand'**
  String get foodBrand;

  /// No description provided for @mealsPerDay.
  ///
  /// In en, this message translates to:
  /// **'Meals Per Day'**
  String get mealsPerDay;

  /// No description provided for @mealTimes.
  ///
  /// In en, this message translates to:
  /// **'Meal Times'**
  String get mealTimes;

  /// No description provided for @portionSize.
  ///
  /// In en, this message translates to:
  /// **'Portion Size'**
  String get portionSize;

  /// No description provided for @portionUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get portionUnit;

  /// No description provided for @favoriteFoods.
  ///
  /// In en, this message translates to:
  /// **'Favorite Foods'**
  String get favoriteFoods;

  /// No description provided for @dailyWaterMl.
  ///
  /// In en, this message translates to:
  /// **'Daily Water (ml)'**
  String get dailyWaterMl;

  /// No description provided for @ml.
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get ml;

  /// No description provided for @gram.
  ///
  /// In en, this message translates to:
  /// **'gram'**
  String get gram;

  /// No description provided for @scoop.
  ///
  /// In en, this message translates to:
  /// **'scoop'**
  String get scoop;

  /// No description provided for @addFavoriteFood.
  ///
  /// In en, this message translates to:
  /// **'Add Food'**
  String get addFavoriteFood;

  /// No description provided for @feedingLog.
  ///
  /// In en, this message translates to:
  /// **'Feeding Log'**
  String get feedingLog;

  /// No description provided for @addFeedingLog.
  ///
  /// In en, this message translates to:
  /// **'Add Feeding Entry'**
  String get addFeedingLog;

  /// No description provided for @editFeedingLog.
  ///
  /// In en, this message translates to:
  /// **'Edit Feeding Entry'**
  String get editFeedingLog;

  /// No description provided for @mealType.
  ///
  /// In en, this message translates to:
  /// **'Meal Type'**
  String get mealType;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @lunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get lunch;

  /// No description provided for @dinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get dinner;

  /// No description provided for @snack.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get snack;

  /// No description provided for @foodName.
  ///
  /// In en, this message translates to:
  /// **'Food Name'**
  String get foodName;

  /// No description provided for @portionGiven.
  ///
  /// In en, this message translates to:
  /// **'Portion Given'**
  String get portionGiven;

  /// No description provided for @eaten.
  ///
  /// In en, this message translates to:
  /// **'Eaten'**
  String get eaten;

  /// No description provided for @noFeedingLogFound.
  ///
  /// In en, this message translates to:
  /// **'No feeding entries found.'**
  String get noFeedingLogFound;

  /// No description provided for @noFeedingProfile.
  ///
  /// In en, this message translates to:
  /// **'No feeding profile set yet.'**
  String get noFeedingProfile;

  /// No description provided for @addFeedingProfile.
  ///
  /// In en, this message translates to:
  /// **'Set Feeding Profile'**
  String get addFeedingProfile;

  /// No description provided for @mealTimesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 08:00, 13:00, 19:00'**
  String get mealTimesHint;

  /// No description provided for @deleteFeedingLog.
  ///
  /// In en, this message translates to:
  /// **'Delete entry'**
  String get deleteFeedingLog;

  /// No description provided for @feedingStats.
  ///
  /// In en, this message translates to:
  /// **'Daily Nutrition Overview'**
  String get feedingStats;

  /// No description provided for @pleaseEnterFoodName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a food name'**
  String get pleaseEnterFoodName;

  /// No description provided for @pleaseEnterMealsPerDay.
  ///
  /// In en, this message translates to:
  /// **'Please enter meals per day'**
  String get pleaseEnterMealsPerDay;

  /// No description provided for @foodPreferences.
  ///
  /// In en, this message translates to:
  /// **'Food Preferences'**
  String get foodPreferences;

  /// No description provided for @addFoodPreference.
  ///
  /// In en, this message translates to:
  /// **'Add Food Preference'**
  String get addFoodPreference;

  /// No description provided for @editFoodPreference.
  ///
  /// In en, this message translates to:
  /// **'Edit Food Preference'**
  String get editFoodPreference;

  /// No description provided for @noFoodPreferences.
  ///
  /// In en, this message translates to:
  /// **'No food preferences added yet.'**
  String get noFoodPreferences;

  /// No description provided for @foodCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get foodCategoryLabel;

  /// No description provided for @ratingLabel.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get ratingLabel;

  /// No description provided for @ratingLoves.
  ///
  /// In en, this message translates to:
  /// **'Loves it'**
  String get ratingLoves;

  /// No description provided for @ratingLikes.
  ///
  /// In en, this message translates to:
  /// **'Likes it'**
  String get ratingLikes;

  /// No description provided for @ratingNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get ratingNeutral;

  /// No description provided for @ratingDislikes.
  ///
  /// In en, this message translates to:
  /// **'Dislikes it'**
  String get ratingDislikes;

  /// No description provided for @ratingAllergic.
  ///
  /// In en, this message translates to:
  /// **'Allergic / Forbidden'**
  String get ratingAllergic;

  /// No description provided for @catDryFood.
  ///
  /// In en, this message translates to:
  /// **'Dry Food'**
  String get catDryFood;

  /// No description provided for @catWetFood.
  ///
  /// In en, this message translates to:
  /// **'Wet Food'**
  String get catWetFood;

  /// No description provided for @catTreat.
  ///
  /// In en, this message translates to:
  /// **'Treat'**
  String get catTreat;

  /// No description provided for @catHomemade.
  ///
  /// In en, this message translates to:
  /// **'Homemade'**
  String get catHomemade;

  /// No description provided for @catSupplement.
  ///
  /// In en, this message translates to:
  /// **'Supplement'**
  String get catSupplement;

  /// No description provided for @deleteFoodPreference.
  ///
  /// In en, this message translates to:
  /// **'Delete preference'**
  String get deleteFoodPreference;

  /// No description provided for @dislikedFoods.
  ///
  /// In en, this message translates to:
  /// **'Disliked Foods'**
  String get dislikedFoods;

  /// No description provided for @addDislikedFood.
  ///
  /// In en, this message translates to:
  /// **'Add Disliked Food'**
  String get addDislikedFood;

  /// No description provided for @pleaseEnterPreferenceName.
  ///
  /// In en, this message translates to:
  /// **'Please enter food name'**
  String get pleaseEnterPreferenceName;
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
      <String>['de', 'en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
