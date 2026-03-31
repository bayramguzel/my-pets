import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:math';

import 'package:my_pets/l10n/app_localizations.dart';
import '../models/pet_models.dart';
import '../providers/pet_provider.dart';

class AddEditPetScreen extends StatefulWidget {
  final Pet? pet;

  const AddEditPetScreen({super.key, this.pet});

  @override
  State<AddEditPetScreen> createState() => _AddEditPetScreenState();
}

class _AddEditPetScreenState extends State<AddEditPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _veterinarianNameController = TextEditingController();
  final _veterinarianContactController = TextEditingController();
  final _notesController = TextEditingController();
  final _weightController = TextEditingController();
  final _microchipIdController = TextEditingController();
  final _insuranceController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _medicalHistoryController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _currentMedicationsController = TextEditingController();
  final _customTypeController = TextEditingController();

  String _selectedType = 'dog';
  String _selectedGender = 'unknown';
  String _selectedHealthStatus = 'good';
  DateTime? _birthDate;
  DateTime? _nextAppointment;
  String _photoUrl = 'https://via.placeholder.com/300x300.png?text=Pet+Photo';
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.pet != null) {
      _initializeWithPetData();
    }
  }

  void _initializeWithPetData() {
    final pet = widget.pet!;
    _nameController.text = pet.name;

    final List<String> predefinedTypes = [
      'dog',
      'cat',
      'bird',
      'rabbit',
      'hamster',
      'fish',
    ];

    if (predefinedTypes.contains(pet.type)) {
      _selectedType = pet.type;
    } else {
      _selectedType = 'other';
      _customTypeController.text = pet.type;
    }

    _breedController.text = pet.breed ?? '';
    _birthDate = pet.birthDate;
    _photoUrl = pet.photoUrl;
    _nationalIdController.text = pet.nationalId ?? '';
    _veterinarianNameController.text = pet.veterinarianName ?? '';
    _veterinarianContactController.text = pet.veterinarianContact ?? '';
    _notesController.text = pet.notes ?? '';
    _selectedGender = pet.gender ?? 'unknown';
    _weightController.text = pet.weight?.toString() ?? '';
    _microchipIdController.text = pet.microchipId ?? '';
    _insuranceController.text = pet.insurance ?? '';
    _emergencyContactController.text = pet.emergencyContact ?? '';
    _medicalHistoryController.text = pet.medicalHistory ?? '';
    _allergiesController.text = pet.allergies ?? '';
    _currentMedicationsController.text = pet.currentMedications ?? '';
    _nextAppointment = pet.nextAppointment;
    _selectedHealthStatus = pet.healthStatus;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.pet != null;

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? '${l10n.edit} ${l10n.petName}' : l10n.addPet),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: l10n.selectImage),
              Tab(text: l10n.basicInfo),
              Tab(text: l10n.healthInfo),
              Tab(text: l10n.veterinarian),
              Tab(text: l10n.additionalInfo),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: _savePet,
            icon: const Icon(Icons.check_circle_outline),
            label: Text(l10n.save),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: TabBarView(
            children: [
              ListView(
                padding: const EdgeInsets.all(16.0),
                children: [_buildPhotoSection(context)],
              ),
              ListView(
                padding: const EdgeInsets.all(16.0),
                children: [_buildBasicInfoSection(context)],
              ),
              ListView(
                padding: const EdgeInsets.all(16.0),
                children: [_buildHealthSection(context)],
              ),
              ListView(
                padding: const EdgeInsets.all(16.0),
                children: [_buildVeterinarianSection(context)],
              ),
              ListView(
                padding: const EdgeInsets.all(16.0),
                children: [_buildAdditionalInfoSection(context)],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _showImagePicker,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 132,
                    height: 132,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.2),
                          Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.05),
                        ],
                      ),
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: _imageFile != null
                          ? Image.file(_imageFile!, fit: BoxFit.cover)
                          : _photoUrl.contains('placeholder')
                          ? Icon(Icons.pets, size: 64, color: Colors.grey[600])
                          : _buildImageFromPath(_photoUrl),
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.selectImage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.basicInfo,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.petName,
                prefixIcon: const Icon(Icons.pets),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.pleaseEnterPetName;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedType,
              decoration: InputDecoration(
                labelText: l10n.petType,
                prefixIcon: const Icon(Icons.category),
              ),
              items: [
                DropdownMenuItem(value: 'dog', child: Text(l10n.dog)),
                DropdownMenuItem(value: 'cat', child: Text(l10n.cat)),
                DropdownMenuItem(value: 'bird', child: Text(l10n.bird)),
                DropdownMenuItem(value: 'rabbit', child: Text(l10n.rabbit)),
                DropdownMenuItem(value: 'hamster', child: Text(l10n.hamster)),
                DropdownMenuItem(value: 'fish', child: Text(l10n.fish)),
                DropdownMenuItem(value: 'other', child: Text(l10n.other)),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            if (_selectedType == 'other') ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _customTypeController,
                decoration: InputDecoration(
                  labelText: l10n.other,
                  hintText: l10n.other,
                  labelStyle: const TextStyle(color: Colors.red),
                  hintStyle: const TextStyle(color: Colors.redAccent),
                  prefixIcon: const Icon(Icons.edit_note, color: Colors.red),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                ),
                validator: (value) {
                  if (_selectedType == 'other' &&
                      (value == null || value.isEmpty)) {
                    return l10n
                        .pleaseEnterPetName; // Using existing validator for now
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _breedController,
              decoration: InputDecoration(
                labelText: l10n.breed,
                prefixIcon: const Icon(Icons.pets),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedGender,
              decoration: InputDecoration(
                labelText: l10n.gender,
                prefixIcon: const Icon(Icons.wc),
              ),
              items: [
                DropdownMenuItem(value: 'male', child: Text(l10n.male)),
                DropdownMenuItem(value: 'female', child: Text(l10n.female)),
                DropdownMenuItem(value: 'unknown', child: Text(l10n.unknown)),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.cake),
              title: Text(l10n.birthDate),
              subtitle: Text(
                _birthDate != null
                    ? DateFormat('dd/MM/yyyy').format(_birthDate!)
                    : l10n.selectDate,
              ),
              onTap: _selectBirthDate,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _weightController,
              decoration: InputDecoration(
                labelText: '${l10n.weight} (${l10n.kg})',
                prefixIcon: const Icon(Icons.monitor_weight),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.healthInfo,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedHealthStatus,
              decoration: InputDecoration(
                labelText: l10n.healthStatus,
                prefixIcon: const Icon(Icons.health_and_safety),
              ),
              items: [
                DropdownMenuItem(
                  value: 'excellent',
                  child: Text(l10n.excellent),
                ),
                DropdownMenuItem(value: 'good', child: Text(l10n.good)),
                DropdownMenuItem(value: 'fair', child: Text(l10n.fair)),
                DropdownMenuItem(value: 'poor', child: Text(l10n.poor)),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedHealthStatus = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _microchipIdController,
              decoration: InputDecoration(
                labelText: l10n.microchipId,
                prefixIcon: const Icon(Icons.memory),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _medicalHistoryController,
              decoration: InputDecoration(
                labelText: l10n.medicalHistory,
                prefixIcon: const Icon(Icons.medical_services),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _allergiesController,
              decoration: InputDecoration(
                labelText: l10n.allergies,
                prefixIcon: const Icon(Icons.warning),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _currentMedicationsController,
              decoration: InputDecoration(
                labelText: l10n.currentMedications,
                prefixIcon: const Icon(Icons.medication),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.event),
              title: Text(l10n.nextAppointment),
              subtitle: Text(
                _nextAppointment != null
                    ? DateFormat('dd/MM/yyyy HH:mm').format(_nextAppointment!)
                    : l10n.selectDate,
              ),
              onTap: _selectNextAppointment,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVeterinarianSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.veterinarianInfo,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _veterinarianNameController,
              decoration: InputDecoration(
                labelText: l10n.veterinarianName,
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _veterinarianContactController,
              decoration: InputDecoration(
                labelText: l10n.veterinarianContact,
                prefixIcon: const Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.additionalInfo,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nationalIdController,
              decoration: InputDecoration(
                labelText: l10n.nationalId,
                prefixIcon: const Icon(Icons.badge),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _insuranceController,
              decoration: InputDecoration(
                labelText: l10n.insurance,
                prefixIcon: const Icon(Icons.security),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emergencyContactController,
              decoration: InputDecoration(
                labelText: l10n.emergencyContact,
                prefixIcon: const Icon(Icons.emergency),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: l10n.notes,
                prefixIcon: const Icon(Icons.note),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePicker() {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(l10n.takePicture),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(l10n.chooseFromGallery),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _photoUrl = image.path;
      });
    }
  }

  Widget _buildImageFromPath(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(path, fit: BoxFit.cover);
    }
    return Image.file(File(path), fit: BoxFit.cover);
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  Future<void> _selectNextAppointment() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _nextAppointment ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_nextAppointment ?? DateTime.now()),
      );

      if (pickedTime != null) {
        setState(() {
          _nextAppointment = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _savePet() {
    if (_formKey.currentState!.validate()) {
      final petData = Provider.of<PetData>(context, listen: false);

      String finalType = _selectedType;
      if (_selectedType == 'other' && _customTypeController.text.isNotEmpty) {
        finalType = _customTypeController.text;
      }

      final pet = Pet(
        id: widget.pet?.id ?? 'pet_${Random().nextInt(100000)}',
        name: _nameController.text,
        type: finalType,
        breed: _breedController.text.isEmpty ? null : _breedController.text,
        birthDate: _birthDate,
        photoUrl: _photoUrl,
        nationalId: _nationalIdController.text.isEmpty
            ? null
            : _nationalIdController.text,
        veterinarianName: _veterinarianNameController.text.isEmpty
            ? null
            : _veterinarianNameController.text,
        veterinarianContact: _veterinarianContactController.text.isEmpty
            ? null
            : _veterinarianContactController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        gender: _selectedGender,
        weight: _weightController.text.isEmpty
            ? null
            : double.tryParse(_weightController.text),
        microchipId: _microchipIdController.text.isEmpty
            ? null
            : _microchipIdController.text,
        insurance: _insuranceController.text.isEmpty
            ? null
            : _insuranceController.text,
        emergencyContact: _emergencyContactController.text.isEmpty
            ? null
            : _emergencyContactController.text,
        medicalHistory: _medicalHistoryController.text.isEmpty
            ? null
            : _medicalHistoryController.text,
        allergies: _allergiesController.text.isEmpty
            ? null
            : _allergiesController.text,
        currentMedications: _currentMedicationsController.text.isEmpty
            ? null
            : _currentMedicationsController.text,
        nextAppointment: _nextAppointment,
        healthStatus: _selectedHealthStatus,
      );

      if (widget.pet != null) {
        petData.updatePet(pet);
      } else {
        petData.addPet(pet);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.saveSuccess)),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _nationalIdController.dispose();
    _veterinarianNameController.dispose();
    _veterinarianContactController.dispose();
    _notesController.dispose();
    _weightController.dispose();
    _microchipIdController.dispose();
    _insuranceController.dispose();
    _emergencyContactController.dispose();
    _medicalHistoryController.dispose();
    _allergiesController.dispose();
    _currentMedicationsController.dispose();
    _customTypeController.dispose();
    super.dispose();
  }
}
