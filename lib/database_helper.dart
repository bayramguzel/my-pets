import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/pet_models.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pets.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE pets(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        breed TEXT,
        birth_date TEXT,
        photo_url TEXT,
        national_id TEXT,
        veterinarian_name TEXT,
        veterinarian_contact TEXT,
        notes TEXT,
        gender TEXT,
        weight REAL,
        microchip_id TEXT,
        insurance TEXT,
        emergency_contact TEXT,
        medical_history TEXT,
        allergies TEXT,
        current_medications TEXT,
        next_appointment TEXT,
        health_status TEXT DEFAULT 'good',
        color TEXT,
        adoption_date TEXT,
        training_level TEXT,
        favorite_food TEXT,
        favorite_toy TEXT,
        height REAL,
        blood_type TEXT,
        last_vet_visit TEXT,
        diet_type TEXT,
        daily_exercise_minutes INTEGER,
        personality TEXT,
        activity_level TEXT,
        is_spayed_or_neutered INTEGER,
        dietary_requirements TEXT,
        favorite_toys TEXT,
        behavioral_notes TEXT,
        passport_number TEXT,
        owner_name TEXT,
        owner_contact TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE activities(
        id TEXT PRIMARY KEY,
        pet_id TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY (pet_id) REFERENCES pets (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE vaccinations(
        id TEXT PRIMARY KEY,
        pet_id TEXT NOT NULL,
        name TEXT NOT NULL,
        date TEXT NOT NULL,
        next_due_date TEXT,
        veterinarian TEXT,
        notes TEXT,
        FOREIGN KEY (pet_id) REFERENCES pets (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE reminders(
        id TEXT PRIMARY KEY,
        pet_id TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        reminder_date TEXT NOT NULL,
        is_active INTEGER DEFAULT 1,
        type TEXT,
        FOREIGN KEY (pet_id) REFERENCES pets (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE expenses(
        id TEXT PRIMARY KEY,
        pet_id TEXT NOT NULL,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        description TEXT,
        FOREIGN KEY (pet_id) REFERENCES pets (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Version 2 upgrades were handled by recreation as this is a new app phase
    }
    if (oldVersion < 3) {
      final List<String> newColumns = [
        'color TEXT',
        'adoption_date TEXT',
        'training_level TEXT',
        'favorite_food TEXT',
        'favorite_toy TEXT',
        'height REAL',
        'blood_type TEXT',
        'last_vet_visit TEXT',
        'diet_type TEXT',
        'daily_exercise_minutes INTEGER',
        'personality TEXT',
        'activity_level TEXT',
        'is_spayed_or_neutered INTEGER',
        'dietary_requirements TEXT',
        'favorite_toys TEXT',
        'behavioral_notes TEXT',
        'passport_number TEXT',
        'owner_name TEXT',
        'owner_contact TEXT',
      ];

      for (var column in newColumns) {
        try {
          await db.execute('ALTER TABLE pets ADD COLUMN $column');
        } catch (e) {
          debugPrint('Error adding column $column: $e');
        }
      }
    }
  }

  // Pet CRUD operations
  Future<void> insertPet(Pet pet) async {
    final db = await database;
    await db.insert('pets', {
      'id': pet.id,
      'name': pet.name,
      'type': pet.type,
      'breed': pet.breed,
      'birth_date': pet.birthDate?.toIso8601String(),
      'photo_url': pet.photoUrl,
      'national_id': pet.nationalId,
      'veterinarian_name': pet.veterinarianName,
      'veterinarian_contact': pet.veterinarianContact,
      'notes': pet.notes,
      'gender': pet.gender,
      'weight': pet.weight,
      'microchip_id': pet.microchipId,
      'insurance': pet.insurance,
      'emergency_contact': pet.emergencyContact,
      'medical_history': pet.medicalHistory,
      'allergies': pet.allergies,
      'current_medications': pet.currentMedications,
      'next_appointment': pet.nextAppointment?.toIso8601String(),
      'health_status': pet.healthStatus,
      'color': pet.color,
      'adoption_date': pet.adoptionDate?.toIso8601String(),
      'training_level': pet.trainingLevel,
      'favorite_food': pet.favoriteFood,
      'favorite_toy': pet.favoriteToy,
      'height': pet.height,
      'blood_type': pet.bloodType,
      'last_vet_visit': pet.lastVetVisit?.toIso8601String(),
      'diet_type': pet.dietType,
      'daily_exercise_minutes': pet.dailyExerciseMinutes,
      'personality': pet.personality,
      'activity_level': pet.activityLevel,
      'is_spayed_or_neutered': pet.isSpayedOrNeutered == true ? 1 : 0,
      'dietary_requirements': pet.dietaryRequirements,
      'favorite_toys': pet.favoriteToys,
      'behavioral_notes': pet.behavioralNotes,
      'passport_number': pet.passportNumber,
      'owner_name': pet.ownerName,
      'owner_contact': pet.ownerContact,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Pet>> getAllPets() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('pets');

    return List.generate(maps.length, (i) {
      return Pet(
        id: maps[i]['id'],
        name: maps[i]['name'],
        type: maps[i]['type'],
        breed: maps[i]['breed'],
        birthDate: maps[i]['birth_date'] != null
            ? DateTime.parse(maps[i]['birth_date'])
            : null,
        photoUrl:
            maps[i]['photo_url'] ??
            'https://via.placeholder.com/300x300.png?text=Pet+Photo',
        nationalId: maps[i]['national_id'],
        veterinarianName: maps[i]['veterinarian_name'],
        veterinarianContact: maps[i]['veterinarian_contact'],
        notes: maps[i]['notes'],
        gender: maps[i]['gender'],
        weight: maps[i]['weight']?.toDouble(),
        microchipId: maps[i]['microchip_id'],
        insurance: maps[i]['insurance'],
        emergencyContact: maps[i]['emergency_contact'],
        medicalHistory: maps[i]['medical_history'],
        allergies: maps[i]['allergies'],
        currentMedications: maps[i]['current_medications'],
        nextAppointment: maps[i]['next_appointment'] != null
            ? DateTime.parse(maps[i]['next_appointment'])
            : null,
        healthStatus: maps[i]['health_status'] ?? 'good',
        color: maps[i]['color'],
        adoptionDate: maps[i]['adoption_date'] != null
            ? DateTime.parse(maps[i]['adoption_date'])
            : null,
        trainingLevel: maps[i]['training_level'],
        favoriteFood: maps[i]['favorite_food'],
        favoriteToy: maps[i]['favorite_toy'],
        height: maps[i]['height']?.toDouble(),
        bloodType: maps[i]['blood_type'],
        lastVetVisit: maps[i]['last_vet_visit'] != null
            ? DateTime.parse(maps[i]['last_vet_visit'])
            : null,
        dietType: maps[i]['diet_type'],
        dailyExerciseMinutes: maps[i]['daily_exercise_minutes'],
        personality: maps[i]['personality'],
        activityLevel: maps[i]['activity_level'],
        isSpayedOrNeutered: maps[i]['is_spayed_or_neutered'] == 1,
        dietaryRequirements: maps[i]['dietary_requirements'],
        favoriteToys: maps[i]['favorite_toys'],
        behavioralNotes: maps[i]['behavioral_notes'],
        passportNumber: maps[i]['passport_number'],
        ownerName: maps[i]['owner_name'],
        ownerContact: maps[i]['owner_contact'],
      );
    });
  }

  Future<void> updatePet(Pet pet) async {
    final db = await database;
    await db.update(
      'pets',
      {
        'name': pet.name,
        'type': pet.type,
        'breed': pet.breed,
        'birth_date': pet.birthDate?.toIso8601String(),
        'photo_url': pet.photoUrl,
        'national_id': pet.nationalId,
        'veterinarian_name': pet.veterinarianName,
        'veterinarian_contact': pet.veterinarianContact,
        'notes': pet.notes,
        'gender': pet.gender,
        'weight': pet.weight,
        'microchip_id': pet.microchipId,
        'insurance': pet.insurance,
        'emergency_contact': pet.emergencyContact,
        'medical_history': pet.medicalHistory,
        'allergies': pet.allergies,
        'current_medications': pet.currentMedications,
        'next_appointment': pet.nextAppointment?.toIso8601String(),
        'health_status': pet.healthStatus,
        'color': pet.color,
        'adoption_date': pet.adoptionDate?.toIso8601String(),
        'training_level': pet.trainingLevel,
        'favorite_food': pet.favoriteFood,
        'favorite_toy': pet.favoriteToy,
        'height': pet.height,
        'blood_type': pet.bloodType,
        'last_vet_visit': pet.lastVetVisit?.toIso8601String(),
        'diet_type': pet.dietType,
        'daily_exercise_minutes': pet.dailyExerciseMinutes,
        'personality': pet.personality,
        'activity_level': pet.activityLevel,
        'is_spayed_or_neutered': pet.isSpayedOrNeutered == true ? 1 : 0,
        'dietary_requirements': pet.dietaryRequirements,
        'favorite_toys': pet.favoriteToys,
        'behavioral_notes': pet.behavioralNotes,
        'passport_number': pet.passportNumber,
        'owner_name': pet.ownerName,
        'owner_contact': pet.ownerContact,
      },
      where: 'id = ?',
      whereArgs: [pet.id],
    );
  }

  Future<void> deletePet(String id) async {
    final db = await database;
    await db.delete('pets', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllData() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('reminders');
      await txn.delete('expenses');
      await txn.delete('vaccinations');
      await txn.delete('activities');
      await txn.delete('pets');
    });
  }

  // Activity CRUD operations
  Future<void> insertActivity(PetActivity activity) async {
    final db = await database;
    await db.insert('activities', {
      'id': activity.id,
      'pet_id': activity.petId,
      'title': activity.description,
      'description': activity.description,
      'category': activity.category,
      'date': activity.date.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<PetActivity>> getActivitiesForPet(String petId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'activities',
      where: 'pet_id = ?',
      whereArgs: [petId],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return PetActivity(
        id: maps[i]['id'],
        petId: maps[i]['pet_id'],
        description: maps[i]['description'],
        category: maps[i]['category'],
        date: DateTime.parse(maps[i]['date']),
      );
    });
  }

  Future<void> deleteActivity(String id) async {
    final db = await database;
    await db.delete('activities', where: 'id = ?', whereArgs: [id]);
  }

  // Vaccination CRUD operations
  Future<void> insertVaccination(Vaccination vaccination) async {
    final db = await database;
    await db.insert('vaccinations', {
      'id': vaccination.id,
      'pet_id': vaccination.petId,
      'name': vaccination.vaccineName,
      'date': vaccination.vaccineDate.toIso8601String(),
      'next_due_date': vaccination.nextDueDate?.toIso8601String(),
      'veterinarian': vaccination.veterinarian,
      'notes': vaccination.notes,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Vaccination>> getVaccinationsForPet(String petId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'vaccinations',
      where: 'pet_id = ?',
      whereArgs: [petId],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return Vaccination(
        id: maps[i]['id'],
        petId: maps[i]['pet_id'],
        vaccineName: maps[i]['name'],
        vaccineDate: DateTime.parse(maps[i]['date']),
        nextDueDate: maps[i]['next_due_date'] != null
            ? DateTime.parse(maps[i]['next_due_date'])
            : null,
        veterinarian: maps[i]['veterinarian'],
        notes: maps[i]['notes'],
      );
    });
  }

  // Reminder CRUD operations
  Future<void> insertReminder(HealthReminder reminder) async {
    final db = await database;
    await db.insert('reminders', {
      'id': reminder.id,
      'pet_id': reminder.petId,
      'title': reminder.title,
      'description': reminder.title, // Use title as description
      'reminder_date': reminder.reminderDate.toIso8601String(),
      'is_active': reminder.isActive ? 1 : 0,
      'type': reminder.repeatType,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<HealthReminder>> getAllReminders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'reminders',
      orderBy: 'reminder_date ASC',
    );

    return List.generate(maps.length, (i) {
      return HealthReminder(
        id: maps[i]['id'],
        petId: maps[i]['pet_id'],
        title: maps[i]['title'],
        reminderDate: DateTime.parse(maps[i]['reminder_date']),
        reminderTime: const TimeOfDay(hour: 9, minute: 0), // Default time
        repeatType: maps[i]['type'] ?? 'never',
        isActive: maps[i]['is_active'] == 1,
      );
    });
  }

  // Expense CRUD operations
  Future<void> insertExpense(Expense expense) async {
    final db = await database;
    await db.insert('expenses', {
      'id': expense.id,
      'pet_id': expense.petId,
      'amount': expense.amount,
      'category': expense.category,
      'date': expense.date.toIso8601String(),
      'description': expense.description,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Expense>> getExpensesForPet(String petId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'pet_id = ?',
      whereArgs: [petId],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return Expense(
        id: maps[i]['id'],
        petId: maps[i]['pet_id'],
        amount: maps[i]['amount'],
        category: maps[i]['category'],
        date: DateTime.parse(maps[i]['date']),
        description: maps[i]['description'],
      );
    });
  }

  Future<List<Expense>> getAllExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return Expense(
        id: maps[i]['id'],
        petId: maps[i]['pet_id'],
        amount: maps[i]['amount'],
        category: maps[i]['category'],
        date: DateTime.parse(maps[i]['date']),
        description: maps[i]['description'],
      );
    });
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
