import 'package:flutter/material.dart';
import 'dart:math';

class Pet {
  final String id;
  String name;
  String type;
  String? breed;
  DateTime? birthDate;
  String photoUrl;
  String? nationalId;
  String? veterinarianName;
  String? veterinarianContact;
  String? notes;
  String? gender;
  double? weight;
  String? microchipId;
  String? insurance;
  String? emergencyContact;
  String? medicalHistory;
  String? allergies;
  String? currentMedications;
  DateTime? nextAppointment;
  String healthStatus;
  // New & Aesthetic fields
  String? color;
  DateTime? adoptionDate;
  String? trainingLevel; // beginner, intermediate, advanced
  String? favoriteFood;
  String? favoriteToy;
  double? height; // cm
  String? bloodType;
  DateTime? lastVetVisit;
  String? dietType; // regular, prescription, raw, homemade
  int? dailyExerciseMinutes;
  String? personality; // playful, calm, aggressive, shy, friendly
  String? activityLevel;
  bool? isSpayedOrNeutered;
  String? dietaryRequirements;
  String? favoriteToys;
  String? behavioralNotes;
  String? passportNumber;
  String? ownerName;
  String? ownerContact;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    this.breed,
    this.birthDate,
    this.photoUrl = 'https://via.placeholder.com/300x300.png?text=Pet+Photo',
    this.nationalId,
    this.veterinarianName,
    this.veterinarianContact,
    this.notes,
    this.gender,
    this.weight,
    this.microchipId,
    this.insurance,
    this.emergencyContact,
    this.medicalHistory,
    this.allergies,
    this.currentMedications,
    this.nextAppointment,
    this.healthStatus = 'good',
    this.color,
    this.adoptionDate,
    this.trainingLevel,
    this.favoriteFood,
    this.favoriteToy,
    this.height,
    this.bloodType,
    this.lastVetVisit,
    this.dietType,
    this.dailyExerciseMinutes,
    this.personality,
    this.activityLevel,
    this.isSpayedOrNeutered,
    this.dietaryRequirements,
    this.favoriteToys,
    this.behavioralNotes,
    this.passportNumber,
    this.ownerName,
    this.ownerContact,
  });

  int get ageInYears {
    if (birthDate == null) return 0;
    final DateTime now = DateTime.now();
    int age = now.year - birthDate!.year;
    if (now.month < birthDate!.month ||
        (now.month == birthDate!.month && now.day < birthDate!.day)) {
      age--;
    }
    return max(0, age);
  }

  // --- Simulation Helpers ---

  String get humanAge {
    if (birthDate == null) return '0';
    int years = ageInYears;
    int hAge = 0;

    switch (type.toLowerCase()) {
      case 'dog':
        if (years == 0) {
          hAge = (ageInMonths * 1.25).toInt();
        } else if (years == 1) {
          hAge = 15;
        } else if (years == 2) {
          hAge = 24;
        } else {
          hAge = 24 + (years - 2) * 4;
        }
        break;
      case 'cat':
        if (years == 0) {
          hAge = (ageInMonths * 1.25).toInt();
        } else if (years == 1) {
          hAge = 15;
        } else if (years == 2) {
          hAge = 24;
        } else {
          hAge = 24 + (years - 2) * 4;
        }
        break;
      case 'bird':
        hAge = years * 5;
        break;
      case 'rabbit':
        if (years == 0) {
          hAge = ageInMonths * 2;
        } else {
          hAge = 21 + (years - 1) * 6;
        }
        break;
      default:
        hAge = years * 7;
    }
    return hAge.toString();
  }

  String get dailyCalories {
    if (weight == null || weight == 0) return '0';
    // RER (Resting Energy Requirement) = 70 * (weight in kg ^ 0.75)
    double rer = (70 * pow(weight!, 0.75)).toDouble();
    double factor = 1.6; // Average active adult
    if (activityLevel == 'low') factor = 1.2;
    if (activityLevel == 'high') factor = 2.0;

    return (rer * factor).toStringAsFixed(0);
  }

  String get waterRequirement {
    if (weight == null || weight == 0) return '0';
    // Average 50-60ml per kg
    return (weight! * 55).toStringAsFixed(0);
  }

  int get ageInMonths {
    if (birthDate == null) return 0;
    final DateTime now = DateTime.now();
    int months =
        (now.year - birthDate!.year) * 12 + now.month - birthDate!.month;
    if (now.day < birthDate!.day) {
      months--;
    }
    return max(0, months);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'breed': breed,
      'birthDate': birthDate?.toIso8601String(),
      'photoUrl': photoUrl,
      'nationalId': nationalId,
      'veterinarianName': veterinarianName,
      'veterinarianContact': veterinarianContact,
      'notes': notes,
      'gender': gender,
      'weight': weight,
      'microchipId': microchipId,
      'insurance': insurance,
      'emergencyContact': emergencyContact,
      'medicalHistory': medicalHistory,
      'allergies': allergies,
      'currentMedications': currentMedications,
      'nextAppointment': nextAppointment?.toIso8601String(),
      'healthStatus': healthStatus,
      'color': color,
      'adoptionDate': adoptionDate?.toIso8601String(),
      'trainingLevel': trainingLevel,
      'favoriteFood': favoriteFood,
      'favoriteToy': favoriteToy,
      'height': height,
      'bloodType': bloodType,
      'lastVetVisit': lastVetVisit?.toIso8601String(),
      'dietType': dietType,
      'dailyExerciseMinutes': dailyExerciseMinutes,
      'personality': personality,
      'activityLevel': activityLevel,
      'isSpayedOrNeutered': isSpayedOrNeutered,
      'dietaryRequirements': dietaryRequirements,
      'favoriteToys': favoriteToys,
      'behavioralNotes': behavioralNotes,
      'passportNumber': passportNumber,
      'ownerName': ownerName,
      'ownerContact': ownerContact,
    };
  }

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      breed: json['breed'],
      birthDate: json['birthDate'] != null
          ? DateTime.parse(json['birthDate'])
          : null,
      photoUrl:
          json['photoUrl'] ??
          'https://via.placeholder.com/300x300.png?text=Pet+Photo',
      nationalId: json['nationalId'],
      veterinarianName: json['veterinarianName'],
      veterinarianContact: json['veterinarianContact'],
      notes: json['notes'],
      gender: json['gender'],
      weight: json['weight']?.toDouble(),
      microchipId: json['microchipId'],
      insurance: json['insurance'],
      emergencyContact: json['emergencyContact'],
      medicalHistory: json['medicalHistory'],
      allergies: json['allergies'],
      currentMedications: json['currentMedications'],
      nextAppointment: json['nextAppointment'] != null
          ? DateTime.parse(json['nextAppointment'])
          : null,
      healthStatus: json['healthStatus'] ?? 'good',
      color: json['color'],
      adoptionDate: json['adoptionDate'] != null
          ? DateTime.parse(json['adoptionDate'])
          : null,
      trainingLevel: json['trainingLevel'],
      favoriteFood: json['favoriteFood'],
      favoriteToy: json['favoriteToy'],
      height: json['height']?.toDouble(),
      bloodType: json['bloodType'],
      lastVetVisit: json['lastVetVisit'] != null
          ? DateTime.parse(json['lastVetVisit'])
          : null,
      dietType: json['dietType'],
      dailyExerciseMinutes: json['dailyExerciseMinutes'],
      personality: json['personality'],
      activityLevel: json['activityLevel'],
      isSpayedOrNeutered: json['isSpayedOrNeutered'],
      dietaryRequirements: json['dietaryRequirements'],
      favoriteToys: json['favoriteToys'],
      behavioralNotes: json['behavioralNotes'],
      passportNumber: json['passportNumber'],
      ownerName: json['ownerName'],
      ownerContact: json['ownerContact'],
    );
  }
}

class PetActivity {
  final String id;
  final String petId;
  DateTime date;
  String category;
  String description;
  double? cost;

  PetActivity({
    required this.id,
    required this.petId,
    required this.date,
    required this.category,
    required this.description,
    this.cost,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'date': date.toIso8601String(),
      'category': category,
      'description': description,
      'cost': cost,
    };
  }

  factory PetActivity.fromJson(Map<String, dynamic> json) {
    return PetActivity(
      id: json['id'],
      petId: json['petId'],
      date: DateTime.parse(json['date']),
      category: json['category'],
      description: json['description'],
      cost: json['cost']?.toDouble(),
    );
  }
}

class Vaccination {
  final String id;
  final String petId;
  String vaccineName;
  DateTime vaccineDate;
  DateTime? nextDueDate;
  String? veterinarian;
  String? batchNumber;
  String? notes;

  Vaccination({
    required this.id,
    required this.petId,
    required this.vaccineName,
    required this.vaccineDate,
    this.nextDueDate,
    this.veterinarian,
    this.batchNumber,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'vaccineName': vaccineName,
      'vaccineDate': vaccineDate.toIso8601String(),
      'nextDueDate': nextDueDate?.toIso8601String(),
      'veterinarian': veterinarian,
      'batchNumber': batchNumber,
      'notes': notes,
    };
  }

  factory Vaccination.fromJson(Map<String, dynamic> json) {
    return Vaccination(
      id: json['id'],
      petId: json['petId'],
      vaccineName: json['vaccineName'],
      vaccineDate: DateTime.parse(json['vaccineDate']),
      nextDueDate: json['nextDueDate'] != null
          ? DateTime.parse(json['nextDueDate'])
          : null,
      veterinarian: json['veterinarian'],
      batchNumber: json['batchNumber'],
      notes: json['notes'],
    );
  }
}

class HealthReminder {
  final String id;
  final String petId;
  String title;
  DateTime reminderDate;
  TimeOfDay reminderTime;
  String repeatType;
  bool isActive;

  HealthReminder({
    required this.id,
    required this.petId,
    required this.title,
    required this.reminderDate,
    required this.reminderTime,
    this.repeatType = 'never',
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'title': title,
      'reminderDate': reminderDate.toIso8601String(),
      'reminderTime': '${reminderTime.hour}:${reminderTime.minute}',
      'repeatType': repeatType,
      'isActive': isActive,
    };
  }

  factory HealthReminder.fromJson(Map<String, dynamic> json) {
    final timeParts = json['reminderTime'].split(':');
    return HealthReminder(
      id: json['id'],
      petId: json['petId'],
      title: json['title'],
      reminderDate: DateTime.parse(json['reminderDate']),
      reminderTime: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      repeatType: json['repeatType'] ?? 'never',
      isActive: json['isActive'] ?? true,
    );
  }
}

// ─── Nutrition / Feeding models ──────────────────────────────────────────────

/// Feeding profile for a pet (one per pet, upserted).
class FeedingSchedule {
  String petId;
  String? foodBrand;
  int mealsPerDay;
  List<String> mealTimes; // e.g. ["08:00", "13:00", "19:00"]
  double? portionSizeGram;
  String portionUnit; // gram | ml | scoop
  List<String> favoriteFoods;
  List<String> dislikedFoods;
  int? dailyWaterMl;
  String? notes;

  FeedingSchedule({
    required this.petId,
    this.foodBrand,
    this.mealsPerDay = 2,
    List<String>? mealTimes,
    this.portionSizeGram,
    this.portionUnit = 'gram',
    List<String>? favoriteFoods,
    List<String>? dislikedFoods,
    this.dailyWaterMl,
    this.notes,
  }) : mealTimes = mealTimes ?? [],
       favoriteFoods = favoriteFoods ?? [],
       dislikedFoods = dislikedFoods ?? [];

  Map<String, dynamic> toJson() => {
    'petId': petId,
    'foodBrand': foodBrand,
    'mealsPerDay': mealsPerDay,
    'mealTimes': mealTimes,
    'portionSizeGram': portionSizeGram,
    'portionUnit': portionUnit,
    'favoriteFoods': favoriteFoods,
    'dislikedFoods': dislikedFoods,
    'dailyWaterMl': dailyWaterMl,
    'notes': notes,
  };

  factory FeedingSchedule.fromJson(Map<String, dynamic> json) =>
      FeedingSchedule(
        petId: json['petId'],
        foodBrand: json['foodBrand'],
        mealsPerDay: json['mealsPerDay'] ?? 2,
        mealTimes:
            (json['mealTimes'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        portionSizeGram: json['portionSizeGram']?.toDouble(),
        portionUnit: json['portionUnit'] ?? 'gram',
        favoriteFoods:
            (json['favoriteFoods'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        dislikedFoods:
            (json['dislikedFoods'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        dailyWaterMl: json['dailyWaterMl'],
        notes: json['notes'],
      );
}

/// One feeding log entry.
class FeedingLog {
  final String id;
  final String petId;
  DateTime date;
  String mealType; // breakfast | lunch | dinner | snack
  String foodName;
  double? portionGiven;
  String portionUnit; // gram | ml | scoop
  bool isEaten;
  String? notes;

  FeedingLog({
    required this.id,
    required this.petId,
    required this.date,
    required this.mealType,
    required this.foodName,
    this.portionGiven,
    this.portionUnit = 'gram',
    this.isEaten = true,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'petId': petId,
    'date': date.toIso8601String(),
    'mealType': mealType,
    'foodName': foodName,
    'portionGiven': portionGiven,
    'portionUnit': portionUnit,
    'isEaten': isEaten,
    'notes': notes,
  };

  factory FeedingLog.fromJson(Map<String, dynamic> json) => FeedingLog(
    id: json['id'],
    petId: json['petId'],
    date: DateTime.parse(json['date']),
    mealType: json['mealType'],
    foodName: json['foodName'],
    portionGiven: json['portionGiven']?.toDouble(),
    portionUnit: json['portionUnit'] ?? 'gram',
    isEaten: json['isEaten'] ?? true,
    notes: json['notes'],
  );
}

// ─── Food Preference model ───────────────────────────────────────────────────

/// Detailed food preference/rating for a specific food item.
class FoodPreference {
  final String id;
  final String petId;
  String foodName;
  String category; // dryFood | wetFood | treat | homemade | supplement | other
  String rating; // loves | likes | neutral | dislikes | allergic
  String? notes;
  DateTime createdAt;

  FoodPreference({
    required this.id,
    required this.petId,
    required this.foodName,
    this.category = 'other',
    this.rating = 'likes',
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'petId': petId,
    'foodName': foodName,
    'category': category,
    'rating': rating,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
  };

  factory FoodPreference.fromJson(Map<String, dynamic> json) => FoodPreference(
    id: json['id'],
    petId: json['petId'],
    foodName: json['foodName'],
    category: json['category'] ?? 'other',
    rating: json['rating'] ?? 'likes',
    notes: json['notes'],
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now(),
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class Expense {
  final String id;
  final String petId;
  double amount;
  String category;
  DateTime date;
  String description;

  Expense({
    required this.id,
    required this.petId,
    required this.amount,
    required this.category,
    required this.date,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'petId': petId,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      petId: json['petId'],
      amount: json['amount'].toDouble(),
      category: json['category'],
      date: DateTime.parse(json['date']),
      description: json['description'],
    );
  }
}
