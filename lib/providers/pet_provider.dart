import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pet_models.dart';

enum AppColorScheme {
  defaultTheme,
  orangeTheme,
  greenTheme,
  purpleTheme,
  redTheme,
  pinkTheme,
  tealTheme,
  yellowTheme,
  cyanTheme,
  brownTheme,
}

class PetData extends ChangeNotifier {
  final List<Pet> _pets = [];
  final List<PetActivity> _activities = [];
  final List<Vaccination> _vaccinations = [];
  final List<HealthReminder> _reminders = [];
  final List<Expense> _expenses = [];
  final List<FeedingSchedule> _feedingSchedules = [];
  final List<FeedingLog> _feedingLogs = [];
  final List<FoodPreference> _foodPreferences = [];
  String _viewMode = 'list'; // 'list' or 'grid'
  bool _usingSampleData = false;

  String get viewMode => _viewMode;

  void setViewMode(String mode) {
    _viewMode = mode;
    notifyListeners();
  }

  PetData() {
    _loadFromStorage();
  }

  void _loadSampleData() {
    _usingSampleData = true;
    _pets.addAll([
      Pet(
        id: 'pet_1',
        name: 'Buddy',
        type: 'dog',
        breed: 'Golden Retriever',
        birthDate: DateTime(2020, 5, 10),
        photoUrl: 'assets/images/dog.png',
        nationalId: 'TRPET12345',
        veterinarianName: 'Dr. Ayşe Demir',
        veterinarianContact: '0555 123 4567',
        notes: 'demoPetBuddyNotes',
        gender: 'male',
        weight: 25.5,
        microchipId: 'MC123456789',
        healthStatus: 'excellent',
      ),
      Pet(
        id: 'pet_2',
        name: 'Whiskers',
        type: 'cat',
        breed: 'Siyam',
        birthDate: DateTime(2022, 1, 15),
        photoUrl: 'assets/images/cat.png',
        nationalId: 'TRCAT67890',
        veterinarianName: 'Dr. Can Kara',
        veterinarianContact: '0544 987 6543',
        notes: 'demoPetWhiskersNotes',
        gender: 'female',
        weight: 4.2,
        healthStatus: 'good',
      ),
    ]);

    _activities.addAll([
      PetActivity(
        id: 'act_1',
        petId: 'pet_1',
        date: DateTime.now().subtract(const Duration(days: 30)),
        category: 'veterinaryVisit',
        description: 'demoActivity1Desc',
        cost: 150.0,
      ),
      PetActivity(
        id: 'act_2',
        petId: 'pet_1',
        date: DateTime.now().subtract(const Duration(days: 15)),
        category: 'feeding',
        description: 'demoActivity2Desc',
        cost: 85.0,
      ),
    ]);

    _vaccinations.addAll([
      Vaccination(
        id: 'vac_1',
        petId: 'pet_1',
        vaccineName: 'demoVaccineRabies',
        vaccineDate: DateTime.now().subtract(const Duration(days: 365)),
        nextDueDate: DateTime.now().add(const Duration(days: 30)),
        veterinarian: 'Dr. Ayşe Demir',
      ),
    ]);

    _expenses.addAll([
      Expense(
        id: 'exp_1',
        petId: 'pet_1',
        amount: 150.0,
        category: 'medical',
        date: DateTime.now().subtract(const Duration(days: 30)),
        description: 'demoExpense1Desc',
      ),
    ]);
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final petsJson = prefs.getString('pets');
      if (petsJson != null) {
        final List<dynamic> petsList = jsonDecode(petsJson);
        _pets.clear();
        _pets.addAll(petsList.map((json) => Pet.fromJson(json)).toList());
        _usingSampleData = false;
      } else if (_pets.isEmpty) {
        _loadSampleData();
      }

      final activitiesJson = prefs.getString('activities');
      if (activitiesJson != null) {
        final List<dynamic> activitiesList = jsonDecode(activitiesJson);
        _activities.clear();
        _activities.addAll(
          activitiesList.map((json) => PetActivity.fromJson(json)).toList(),
        );
      }

      final vaccinationsJson = prefs.getString('vaccinations');
      if (vaccinationsJson != null) {
        final List<dynamic> vaccinationsList = jsonDecode(vaccinationsJson);
        _vaccinations.clear();
        _vaccinations.addAll(
          vaccinationsList.map((json) => Vaccination.fromJson(json)).toList(),
        );
      }

      final remindersJson = prefs.getString('reminders');
      if (remindersJson != null) {
        final List<dynamic> remindersList = jsonDecode(remindersJson);
        _reminders.clear();
        _reminders.addAll(
          remindersList.map((json) => HealthReminder.fromJson(json)).toList(),
        );
      }

      final expensesJson = prefs.getString('expenses');
      if (expensesJson != null) {
        final List<dynamic> expensesList = jsonDecode(expensesJson);
        _expenses.clear();
        _expenses.addAll(
          expensesList.map((json) => Expense.fromJson(json)).toList(),
        );
      }

      final feedingSchedulesJson = prefs.getString('feedingSchedules');
      if (feedingSchedulesJson != null) {
        final List<dynamic> list = jsonDecode(feedingSchedulesJson);
        _feedingSchedules.clear();
        _feedingSchedules.addAll(
          list.map((json) => FeedingSchedule.fromJson(json)).toList(),
        );
      }

      final feedingLogsJson = prefs.getString('feedingLogs');
      if (feedingLogsJson != null) {
        final List<dynamic> list = jsonDecode(feedingLogsJson);
        _feedingLogs.clear();
        _feedingLogs.addAll(
          list.map((json) => FeedingLog.fromJson(json)).toList(),
        );
      }

      final foodPreferencesJson = prefs.getString('foodPreferences');
      if (foodPreferencesJson != null) {
        final List<dynamic> list = jsonDecode(foodPreferencesJson);
        _foodPreferences.clear();
        _foodPreferences.addAll(
          list.map((json) => FoodPreference.fromJson(json)).toList(),
        );
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading data from storage: $e');
    }
  }

  // --- Added getters & helpers for insights/export ---
  List<Pet> get pets => List.unmodifiable(_pets);

  void reorderPets(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Pet item = _pets.removeAt(oldIndex);
    _pets.insert(newIndex, item);
    _saveToStorage();
    notifyListeners();
  }

  List<PetActivity> get activities => List.unmodifiable(_activities);
  List<Vaccination> get vaccinations => List.unmodifiable(_vaccinations);
  List<HealthReminder> get reminders => List.unmodifiable(_reminders);
  List<Expense> get expenses => List.unmodifiable(_expenses);
  List<FeedingSchedule> get feedingSchedules =>
      List.unmodifiable(_feedingSchedules);
  List<FeedingLog> get feedingLogs => List.unmodifiable(_feedingLogs);
  List<FoodPreference> get foodPreferences =>
      List.unmodifiable(_foodPreferences);

  Pet? getPetById(String id) {
    try {
      return _pets.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        'pets',
        jsonEncode(_pets.map((pet) => pet.toJson()).toList()),
      );
      await prefs.setString(
        'activities',
        jsonEncode(_activities.map((activity) => activity.toJson()).toList()),
      );
      await prefs.setString(
        'vaccinations',
        jsonEncode(
          _vaccinations.map((vaccination) => vaccination.toJson()).toList(),
        ),
      );
      await prefs.setString(
        'reminders',
        jsonEncode(_reminders.map((reminder) => reminder.toJson()).toList()),
      );
      await prefs.setString(
        'expenses',
        jsonEncode(_expenses.map((expense) => expense.toJson()).toList()),
      );
      await prefs.setString(
        'feedingSchedules',
        jsonEncode(_feedingSchedules.map((fs) => fs.toJson()).toList()),
      );
      await prefs.setString(
        'feedingLogs',
        jsonEncode(_feedingLogs.map((fl) => fl.toJson()).toList()),
      );
      await prefs.setString(
        'foodPreferences',
        jsonEncode(_foodPreferences.map((fp) => fp.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('Error saving data to storage: $e');
    }
  }

  // Pet methods
  void addPet(Pet pet) {
    if (_usingSampleData) {
      _pets.clear();
      _usingSampleData = false;
    }
    _pets.add(pet);
    _saveToStorage();
    notifyListeners();
  }

  void updatePet(Pet updatedPet) {
    final int index = _pets.indexWhere((Pet pet) => pet.id == updatedPet.id);
    if (index != -1) {
      _pets[index] = updatedPet;
      _saveToStorage();
      notifyListeners();
    }
  }

  void deletePet(String petId) {
    _pets.removeWhere((Pet pet) => pet.id == petId);
    _activities.removeWhere((PetActivity activity) => activity.petId == petId);
    _vaccinations.removeWhere(
      (Vaccination vaccination) => vaccination.petId == petId,
    );
    _reminders.removeWhere(
      (HealthReminder reminder) => reminder.petId == petId,
    );
    _expenses.removeWhere((Expense expense) => expense.petId == petId);
    _feedingSchedules.removeWhere((fs) => fs.petId == petId);
    _feedingLogs.removeWhere((fl) => fl.petId == petId);
    _foodPreferences.removeWhere((fp) => fp.petId == petId);
    _saveToStorage();
    notifyListeners();
  }

  Future<void> clearAll() async {
    _pets.clear();
    _activities.clear();
    _vaccinations.clear();
    _reminders.clear();
    _expenses.clear();
    _feedingSchedules.clear();
    _feedingLogs.clear();
    _foodPreferences.clear();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }

  // Activity methods
  void addActivity(PetActivity activity) {
    _activities.add(activity);
    _saveToStorage();
    notifyListeners();
  }

  void updateActivity(PetActivity updatedActivity) {
    final int index = _activities.indexWhere(
      (PetActivity activity) => activity.id == updatedActivity.id,
    );
    if (index != -1) {
      _activities[index] = updatedActivity;
      _saveToStorage();
      notifyListeners();
    }
  }

  void deleteActivity(String activityId) {
    _activities.removeWhere(
      (PetActivity activity) => activity.id == activityId,
    );
    _saveToStorage();
    notifyListeners();
  }

  List<PetActivity> getActivitiesForPet(String petId, String? category) {
    List<PetActivity> filteredActivities = _activities
        .where((PetActivity activity) => activity.petId == petId)
        .toList();
    if (category != null && category != 'allCategories') {
      filteredActivities = filteredActivities
          .where((PetActivity activity) => activity.category == category)
          .toList();
    }
    filteredActivities.sort(
      (PetActivity a, PetActivity b) => b.date.compareTo(a.date),
    );
    return filteredActivities;
  }

  // Vaccination methods
  void addVaccination(Vaccination vaccination) {
    _vaccinations.add(vaccination);
    _saveToStorage();
    notifyListeners();
  }

  void updateVaccination(Vaccination updatedVaccination) {
    final int index = _vaccinations.indexWhere(
      (Vaccination vaccination) => vaccination.id == updatedVaccination.id,
    );
    if (index != -1) {
      _vaccinations[index] = updatedVaccination;
      _saveToStorage();
      notifyListeners();
    }
  }

  void deleteVaccination(String vaccinationId) {
    _vaccinations.removeWhere(
      (Vaccination vaccination) => vaccination.id == vaccinationId,
    );
    _saveToStorage();
    notifyListeners();
  }

  List<Vaccination> getVaccinationsForPet(String petId) {
    return _vaccinations
        .where((Vaccination vaccination) => vaccination.petId == petId)
        .toList()
      ..sort(
        (Vaccination a, Vaccination b) =>
            b.vaccineDate.compareTo(a.vaccineDate),
      );
  }

  // Reminder methods
  void addReminder(HealthReminder reminder) {
    _reminders.add(reminder);
    _saveToStorage();
    notifyListeners();
  }

  void updateReminder(HealthReminder updatedReminder) {
    final int index = _reminders.indexWhere(
      (HealthReminder reminder) => reminder.id == updatedReminder.id,
    );
    if (index != -1) {
      _reminders[index] = updatedReminder;
      _saveToStorage();
      notifyListeners();
    }
  }

  void deleteReminder(String reminderId) {
    _reminders.removeWhere(
      (HealthReminder reminder) => reminder.id == reminderId,
    );
    _saveToStorage();
    notifyListeners();
  }

  List<HealthReminder> getRemindersForPet(String petId) {
    return _reminders
        .where((HealthReminder reminder) => reminder.petId == petId)
        .toList()
      ..sort(
        (HealthReminder a, HealthReminder b) =>
            a.reminderDate.compareTo(b.reminderDate),
      );
  }

  // Expense methods
  void addExpense(Expense expense) {
    _expenses.add(expense);
    _saveToStorage();
    notifyListeners();
  }

  void updateExpense(Expense updatedExpense) {
    final int index = _expenses.indexWhere(
      (Expense expense) => expense.id == updatedExpense.id,
    );
    if (index != -1) {
      _expenses[index] = updatedExpense;
      _saveToStorage();
      notifyListeners();
    }
  }

  void deleteExpense(String expenseId) {
    _expenses.removeWhere((Expense expense) => expense.id == expenseId);
    _saveToStorage();
    notifyListeners();
  }

  List<Expense> getExpensesForPet(String petId) {
    return _expenses.where((Expense expense) => expense.petId == petId).toList()
      ..sort((Expense a, Expense b) => b.date.compareTo(a.date));
  }

  double getTotalExpensesForPet(String petId) {
    return _expenses
        .where((Expense expense) => expense.petId == petId)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  double getMonthlyExpensesForPet(String petId, DateTime month) {
    return _expenses
        .where(
          (Expense expense) =>
              expense.petId == petId &&
              expense.date.year == month.year &&
              expense.date.month == month.month,
        )
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  // ── Feeding Schedule methods ─────────────────────────────────────────────
  FeedingSchedule? getFeedingScheduleForPet(String petId) {
    try {
      return _feedingSchedules.firstWhere((fs) => fs.petId == petId);
    } catch (_) {
      return null;
    }
  }

  void upsertFeedingSchedule(FeedingSchedule schedule) {
    final idx = _feedingSchedules.indexWhere(
      (fs) => fs.petId == schedule.petId,
    );
    if (idx != -1) {
      _feedingSchedules[idx] = schedule;
    } else {
      _feedingSchedules.add(schedule);
    }
    _saveToStorage();
    notifyListeners();
  }

  // ── Feeding Log methods ─────────────────────────────────────────────────
  List<FeedingLog> getFeedingLogsForPet(String petId) {
    return _feedingLogs.where((fl) => fl.petId == petId).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  void addFeedingLog(FeedingLog log) {
    _feedingLogs.add(log);
    _saveToStorage();
    notifyListeners();
  }

  void updateFeedingLog(FeedingLog updated) {
    final idx = _feedingLogs.indexWhere((fl) => fl.id == updated.id);
    if (idx != -1) {
      _feedingLogs[idx] = updated;
      _saveToStorage();
      notifyListeners();
    }
  }

  void deleteFeedingLog(String logId) {
    _feedingLogs.removeWhere((fl) => fl.id == logId);
    _saveToStorage();
    notifyListeners();
  }

  // ── Food Preference methods ───────────────────────────────────────
  List<FoodPreference> getFoodPreferencesForPet(String petId) {
    return _foodPreferences.where((fp) => fp.petId == petId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  void addFoodPreference(FoodPreference preference) {
    _foodPreferences.add(preference);
    _saveToStorage();
    notifyListeners();
  }

  void updateFoodPreference(FoodPreference updated) {
    final idx = _foodPreferences.indexWhere((fp) => fp.id == updated.id);
    if (idx != -1) {
      _foodPreferences[idx] = updated;
      _saveToStorage();
      notifyListeners();
    }
  }

  void deleteFoodPreference(String id) {
    _foodPreferences.removeWhere((fp) => fp.id == id);
    _saveToStorage();
    notifyListeners();
  }
}

class AppSettings extends ChangeNotifier {
  bool _isDarkMode;
  bool _notificationsEnabled;
  bool _soundEnabled;
  AppColorScheme _selectedColorScheme;
  String _selectedLanguage;

  AppSettings()
    : _isDarkMode = false,
      _notificationsEnabled = true,
      _soundEnabled = false,
      _selectedColorScheme = AppColorScheme.defaultTheme,
      _selectedLanguage = 'system' {
    _loadFromStorage();
  }

  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get soundEnabled => _soundEnabled;
  AppColorScheme get selectedColorScheme => _selectedColorScheme;
  String get selectedLanguage => _selectedLanguage;

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _soundEnabled = prefs.getBool('soundEnabled') ?? false;
      _selectedColorScheme =
          AppColorScheme.values[prefs.getInt('selectedColorScheme') ?? 0];
      _selectedLanguage = prefs.getString('selectedLanguage') ?? 'system';
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', _isDarkMode);
      await prefs.setBool('notificationsEnabled', _notificationsEnabled);
      await prefs.setBool('soundEnabled', _soundEnabled);
      await prefs.setInt('selectedColorScheme', _selectedColorScheme.index);
      await prefs.setString('selectedLanguage', _selectedLanguage);
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  void toggleDarkMode(bool value) {
    if (_isDarkMode != value) {
      _isDarkMode = value;
      _saveToStorage();
      notifyListeners();
    }
  }

  void toggleNotifications(bool value) {
    if (_notificationsEnabled != value) {
      _notificationsEnabled = value;
      _saveToStorage();
      notifyListeners();
    }
  }

  void toggleSound(bool value) {
    if (_soundEnabled != value) {
      _soundEnabled = value;
      _saveToStorage();
      notifyListeners();
    }
  }

  void setSelectedColorScheme(AppColorScheme colorScheme) {
    if (_selectedColorScheme != colorScheme) {
      _selectedColorScheme = colorScheme;
      _saveToStorage();
      notifyListeners();
    }
  }

  void setSelectedLanguage(String language) {
    if (_selectedLanguage != language) {
      _selectedLanguage = language;
      _saveToStorage();
      notifyListeners();
    }
  }
}

class ExploreArticle {
  final String id;
  final String titleKey;
  final String categoryKey;
  final String imageUrl;
  final String contentKey;

  ExploreArticle({
    required this.id,
    required this.titleKey,
    required this.categoryKey,
    required this.imageUrl,
    required this.contentKey,
  });
}

class ExploreData extends ChangeNotifier {
  final List<ExploreArticle> _articles = [
    ExploreArticle(
      id: 'exp_1',
      titleKey: 'healthyFeedingTips',
      categoryKey: 'dogCare',
      imageUrl:
          'https://images.unsplash.com/photo-1587300003388-59208cc962cb?w=400&h=200&fit=crop',
      contentKey: 'healthyFeedingContent',
    ),
    ExploreArticle(
      id: 'exp_2',
      titleKey: 'catHappinessTips',
      categoryKey: 'catCare',
      imageUrl:
          'https://images.unsplash.com/photo-1574158622682-e40e69881006?w=400&h=200&fit=crop',
      contentKey: 'catHappinessContent',
    ),
    ExploreArticle(
      id: 'exp_3',
      titleKey: 'birdTrainingBasics',
      categoryKey: 'birdCare',
      imageUrl:
          'https://images.unsplash.com/photo-1552728089-57bdde30beb3?w=400&h=200&fit=crop',
      contentKey: 'birdTrainingContent',
    ),
    ExploreArticle(
      id: 'exp_4',
      titleKey: 'smallPetHabitat',
      categoryKey: 'generalCare',
      imageUrl:
          'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?w=400&h=200&fit=crop',
      contentKey: 'smallPetHabitatContent',
    ),
    ExploreArticle(
      id: 'exp_5',
      titleKey: 'commonDiseaseSymptoms',
      categoryKey: 'health',
      imageUrl:
          'https://images.unsplash.com/photo-1530041539828-114de669390e?w=400&h=200&fit=crop',
      contentKey: 'commonDiseaseSymptomsContent',
    ),
    ExploreArticle(
      id: 'exp_6',
      titleKey: 'travelingWithPets',
      categoryKey: 'lifestyle',
      imageUrl:
          'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=400&h=200&fit=crop',
      contentKey: 'travelingWithPetsContent',
    ),
    ExploreArticle(
      id: 'exp_7',
      titleKey: 'firstAidForPets',
      categoryKey: 'health',
      imageUrl:
          'https://images.unsplash.com/photo-1628009368231-7bb7cfcb0def?w=400&h=200&fit=crop',
      contentKey: 'firstAidForPetsContent',
    ),
    ExploreArticle(
      id: 'exp_8',
      titleKey: 'choosingRightPet',
      categoryKey: 'lifestyle',
      imageUrl:
          'https://images.unsplash.com/photo-1450778869180-41d0601e046e?w=400&h=200&fit=crop',
      contentKey: 'choosingRightPetContent',
    ),
    ExploreArticle(
      id: 'exp_9',
      titleKey: 'dentalCareForPets',
      categoryKey: 'health',
      imageUrl:
          'https://images.unsplash.com/photo-1601758174114-e711c0cbaa69?w=400&h=200&fit=crop',
      contentKey: 'dentalCareForPetsContent',
    ),
    ExploreArticle(
      id: 'exp_10',
      titleKey: 'socializingYourPuppy',
      categoryKey: 'dogCare',
      imageUrl:
          'https://images.unsplash.com/photo-1517849845537-4d257902454a?w=400&h=200&fit=crop',
      contentKey: 'socializingYourPuppyContent',
    ),
    ExploreArticle(
      id: 'exp_11',
      titleKey: 'litterBoxProblems',
      categoryKey: 'catCare',
      imageUrl:
          'https://images.unsplash.com/photo-1513360371669-4adf3dd7dff8?w=400&h=200&fit=crop',
      contentKey: 'litterBoxProblemsContent',
    ),
    ExploreArticle(
      id: 'exp_12',
      titleKey: 'fishAquariumSetup',
      categoryKey: 'fishCare',
      imageUrl:
          'https://images.unsplash.com/photo-1520990269656-26d97974ebca?w=400&h=200&fit=crop',
      contentKey: 'fishAquariumSetupContent',
    ),
    ExploreArticle(
      id: 'exp_13',
      titleKey: 'rabbitDiet',
      categoryKey: 'rabbitCare',
      imageUrl:
          'https://images.unsplash.com/photo-1535241749838-299277b6305f?w=400&h=200&fit=crop',
      contentKey: 'rabbitDietContent',
    ),
    ExploreArticle(
      id: 'exp_14',
      titleKey: 'introducingNewPet',
      categoryKey: 'lifestyle',
      imageUrl:
          'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=400&h=200&fit=crop',
      contentKey: 'introducingNewPetContent',
    ),
    ExploreArticle(
      id: 'exp_15',
      titleKey: 'winterCareTips',
      categoryKey: 'generalCare',
      imageUrl:
          'https://images.unsplash.com/photo-1542435503-956c469947f6?w=400&h=200&fit=crop',
      contentKey: 'winterCareTipsContent',
    ),
    ExploreArticle(
      id: 'exp_16',
      titleKey: 'summerSafety',
      categoryKey: 'generalCare',
      imageUrl:
          'https://images.unsplash.com/photo-1601758125946-6ec2ef64daf8?w=400&h=200&fit=crop',
      contentKey: 'summerSafetyContent',
    ),
    ExploreArticle(
      id: 'exp_17',
      titleKey: 'understandingBodyLanguage',
      categoryKey: 'behavior',
      imageUrl:
          'https://images.unsplash.com/photo-1544568100-847a948585b9?w=400&h=200&fit=crop',
      contentKey: 'understandingBodyLanguageContent',
    ),
    ExploreArticle(
      id: 'exp_18',
      titleKey: 'diyPetToys',
      categoryKey: 'lifestyle',
      imageUrl:
          'https://images.unsplash.com/photo-1541364983171-a8ba01e95cfc?w=400&h=200&fit=crop',
      contentKey: 'diyPetToysContent',
    ),
    ExploreArticle(
      id: 'exp_19',
      titleKey: 'seniorPetCare',
      categoryKey: 'health',
      imageUrl:
          'https://images.unsplash.com/photo-1558788353-f76d92427f16?w=400&h=200&fit=crop',
      contentKey: 'seniorPetCareContent',
    ),
    ExploreArticle(
      id: 'exp_20',
      titleKey: 'parasitePrevention',
      categoryKey: 'health',
      imageUrl:
          'https://images.unsplash.com/photo-1507682044626-a4b4b3900f5f?w=400&h=200&fit=crop',
      contentKey: 'parasitePreventionContent',
    ),
    ExploreArticle(
      id: 'exp_21',
      titleKey: 'groomingYourPetAtHome',
      categoryKey: 'generalCare',
      imageUrl:
          'https://images.unsplash.com/photo-1515131430684-83dcf38f0ef5?w=400&h=200&fit=crop',
      contentKey: 'groomingYourPetAtHomeContent',
    ),
    // Hamster Bakımı
    ExploreArticle(
      id: 'exp_22',
      titleKey: 'hamsterCareBasics',
      categoryKey: 'hamsterCare',
      imageUrl:
          'https://images.unsplash.com/photo-1425082661705-1834bfd09dca?w=400&h=200&fit=crop',
      contentKey: 'hamsterCareBasicsContent',
    ),
    ExploreArticle(
      id: 'exp_23',
      titleKey: 'hamsterDiet',
      categoryKey: 'hamsterCare',
      imageUrl:
          'https://images.unsplash.com/photo-1548767797-d8c844163c4c?w=400&h=200&fit=crop',
      contentKey: 'hamsterDietContent',
    ),
    // Kaplumbağa Bakımı
    ExploreArticle(
      id: 'exp_24',
      titleKey: 'turtleCareGuide',
      categoryKey: 'exoticCare',
      imageUrl:
          'https://images.unsplash.com/photo-1437622368342-7a3d73a34c8f?w=400&h=200&fit=crop',
      contentKey: 'turtleCareGuideContent',
    ),
    // Yavru Bakımı
    ExploreArticle(
      id: 'exp_25',
      titleKey: 'puppyCareGuide',
      categoryKey: 'dogCare',
      imageUrl:
          'https://images.unsplash.com/photo-1601979031925-424e53b6caaa?w=400&h=200&fit=crop',
      contentKey: 'puppyCareGuideContent',
    ),
    ExploreArticle(
      id: 'exp_26',
      titleKey: 'kittenCareGuide',
      categoryKey: 'catCare',
      imageUrl:
          'https://images.unsplash.com/photo-1574144611937-0df059b5ef3e?w=400&h=200&fit=crop',
      contentKey: 'kittenCareGuideContent',
    ),
    ExploreArticle(
      id: 'exp_27',
      titleKey: 'petNutritionGuide',
      categoryKey: 'health',
      imageUrl:
          'https://images.unsplash.com/photo-1589923188900-85dae523321c?w=400&h=200&fit=crop',
      contentKey: 'petNutritionGuideContent',
    ),
    ExploreArticle(
      id: 'exp_28',
      titleKey: 'toxicFoodsForPets',
      categoryKey: 'health',
      imageUrl:
          'https://images.unsplash.com/photo-1596492784531-6e6eb5ea9993?w=400&h=200&fit=crop',
      contentKey: 'toxicFoodsForPetsContent',
    ),
    ExploreArticle(
      id: 'exp_29',
      titleKey: 'dogExerciseGuide',
      categoryKey: 'dogCare',
      imageUrl:
          'https://images.unsplash.com/photo-1534361960057-19889db9621e?w=400&h=200&fit=crop',
      contentKey: 'dogExerciseGuideContent',
    ),
    ExploreArticle(
      id: 'exp_30',
      titleKey: 'catPlaytimeIdeas',
      categoryKey: 'catCare',
      imageUrl:
          'https://images.unsplash.com/photo-1548546738-8502ce9a3544?w=400&h=200&fit=crop',
      contentKey: 'catPlaytimeIdeasContent',
    ),
    ExploreArticle(
      id: 'exp_31',
      titleKey: 'dogBehaviorProblems',
      categoryKey: 'behavior',
      imageUrl:
          'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?w=400&h=200&fit=crop',
      contentKey: 'dogBehaviorProblemsContent',
    ),
    ExploreArticle(
      id: 'exp_32',
      titleKey: 'catBehaviorProblems',
      categoryKey: 'behavior',
      imageUrl:
          'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=400&h=200&fit=crop',
      contentKey: 'catBehaviorProblemsContent',
    ),
    ExploreArticle(
      id: 'exp_33',
      titleKey: 'petAllergies',
      categoryKey: 'health',
      imageUrl:
          'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=400&h=200&fit=crop',
      contentKey: 'petAllergiesContent',
    ),
    ExploreArticle(
      id: 'exp_34',
      titleKey: 'petWeightManagement',
      categoryKey: 'health',
      imageUrl:
          'https://images.unsplash.com/photo-1558947530-cbcf6e9aeeae?w=400&h=200&fit=crop',
      contentKey: 'petWeightManagementContent',
    ),
    ExploreArticle(
      id: 'exp_35',
      titleKey: 'spayNeuterBenefits',
      categoryKey: 'health',
      imageUrl:
          'https://images.unsplash.com/photo-1576086213369-97a306d36557?w=400&h=200&fit=crop',
      contentKey: 'spayNeuterBenefitsContent',
    ),
    ExploreArticle(
      id: 'exp_36',
      titleKey: 'springPetCare',
      categoryKey: 'generalCare',
      imageUrl:
          'https://images.unsplash.com/photo-1522441815192-d9f04eb0614c?w=400&h=200&fit=crop',
      contentKey: 'springPetCareContent',
    ),
    ExploreArticle(
      id: 'exp_37',
      titleKey: 'autumnPetCare',
      categoryKey: 'generalCare',
      imageUrl:
          'https://images.unsplash.com/photo-1507608830360-bb5835389f86?w=400&h=200&fit=crop',
      contentKey: 'autumnPetCareContent',
    ),
    ExploreArticle(
      id: 'exp_38',
      titleKey: 'petFriendlyHome',
      categoryKey: 'lifestyle',
      imageUrl:
          'https://images.unsplash.com/photo-1516734212186-a967f81ad0d7?w=400&h=200&fit=crop',
      contentKey: 'petFriendlyHomeContent',
    ),
    ExploreArticle(
      id: 'exp_39',
      titleKey: 'movingWithPets',
      categoryKey: 'lifestyle',
      imageUrl:
          'https://images.unsplash.com/photo-1520038410233-7141be7e6f97?w=400&h=200&fit=crop',
      contentKey: 'movingWithPetsContent',
    ),
    ExploreArticle(
      id: 'exp_40',
      titleKey: 'petsAndBabies',
      categoryKey: 'lifestyle',
      imageUrl:
          'https://images.unsplash.com/photo-1537151608828-ea2b11777ee8?w=400&h=200&fit=crop',
      contentKey: 'petsAndBabiesContent',
    ),
    ExploreArticle(
      id: 'exp_41',
      titleKey: 'basicDogCommands',
      categoryKey: 'dogCare',
      imageUrl:
          'https://images.unsplash.com/photo-1598133894008-61f7fdb8cc3a?w=400&h=200&fit=crop',
      contentKey: 'basicDogCommandsContent',
    ),
    ExploreArticle(
      id: 'exp_42',
      titleKey: 'houseTraining',
      categoryKey: 'dogCare',
      imageUrl:
          'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?w=400&h=200&fit=crop',
      contentKey: 'houseTrainingContent',
    ),
    ExploreArticle(
      id: 'exp_43',
      titleKey: 'birdDietGuide',
      categoryKey: 'birdCare',
      imageUrl:
          'https://images.unsplash.com/photo-1522858547137-f1dcec554f55?w=400&h=200&fit=crop',
      contentKey: 'birdDietGuideContent',
    ),
    ExploreArticle(
      id: 'exp_44',
      titleKey: 'birdHealthSigns',
      categoryKey: 'birdCare',
      imageUrl:
          'https://images.unsplash.com/photo-1444464666168-49d633b867ad?w=400&h=200&fit=crop',
      contentKey: 'birdHealthSignsContent',
    ),
    ExploreArticle(
      id: 'exp_45',
      titleKey: 'fishTankMaintenance',
      categoryKey: 'fishCare',
      imageUrl:
          'https://images.unsplash.com/photo-1544551763-47a189531981?w=400&h=200&fit=crop',
      contentKey: 'fishTankMaintenanceContent',
    ),
    ExploreArticle(
      id: 'exp_46',
      titleKey: 'fishDiseasePrevention',
      categoryKey: 'fishCare',
      imageUrl:
          'https://images.unsplash.com/photo-1524704654690-b56c05c78a00?w=400&h=200&fit=crop',
      contentKey: 'fishDiseasePreventionContent',
    ),
    ExploreArticle(
      id: 'exp_47',
      titleKey: 'rabbitHousing',
      categoryKey: 'rabbitCare',
      imageUrl:
          'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?w=400&h=200&fit=crop',
      contentKey: 'rabbitHousingContent',
    ),
    ExploreArticle(
      id: 'exp_48',
      titleKey: 'rabbitHealthGuide',
      categoryKey: 'rabbitCare',
      imageUrl:
          'https://images.unsplash.com/photo-1559214369-a6b1d7919865?w=400&h=200&fit=crop',
      contentKey: 'rabbitHealthGuideContent',
    ),
    ExploreArticle(
      id: 'exp_49',
      titleKey: 'petEmergencyKit',
      categoryKey: 'health',
      imageUrl:
          'https://images.unsplash.com/photo-1584036561566-baf8f5f1b144?w=400&h=200&fit=crop',
      contentKey: 'petEmergencyKitContent',
    ),
    ExploreArticle(
      id: 'exp_50',
      titleKey: 'emergencySigns',
      categoryKey: 'health',
      imageUrl:
          'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=400&h=200&fit=crop',
      contentKey: 'emergencySignsContent',
    ),
  ];

  List<ExploreArticle> get articles =>
      List<ExploreArticle>.unmodifiable(_articles);
}
