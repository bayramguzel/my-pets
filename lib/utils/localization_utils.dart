import 'package:flutter/material.dart';
import 'package:my_pets/l10n/app_localizations.dart';

String getPetTypeTranslation(BuildContext context, String type) {
  final l10n = AppLocalizations.of(context)!;
  switch (type.toLowerCase()) {
    case 'dog':
      return l10n.dog;
    case 'cat':
      return l10n.cat;
    case 'bird':
      return l10n.bird;
    case 'rabbit':
      return l10n.rabbit;
    case 'hamster':
      return l10n.hamster;
    case 'fish':
      return l10n.fish;
    case 'other':
      return l10n.other;
    default:
      // Return the custom type name if it's not predefined
      return type;
  }
}

String getLocalizedTitle(BuildContext context, String titleKey) {
  final l10n = AppLocalizations.of(context)!;
  final Map<String, String> titles = {
    'healthyFeedingTips': l10n.healthyFeedingTips,
    'catHappinessTips': l10n.catHappinessTips,
    'birdTrainingBasics': l10n.birdTrainingBasics,
    'smallPetHabitat': l10n.smallPetHabitat,
    'commonDiseaseSymptoms': l10n.commonDiseaseSymptoms,
    'travelingWithPets': l10n.travelingWithPets,
    'firstAidForPets': l10n.firstAidForPets,
    'choosingRightPet': l10n.choosingRightPet,
    'dentalCareForPets': l10n.dentalCareForPets,
    'socializingYourPuppy': l10n.socializingYourPuppy,
    'litterBoxProblems': l10n.litterBoxProblems,
    'fishAquariumSetup': l10n.fishAquariumSetup,
    'rabbitDiet': l10n.rabbitDiet,
    'introducingNewPet': l10n.introducingNewPet,
    'winterCareTips': l10n.winterCareTips,
    'summerSafety': l10n.summerSafety,
    'understandingBodyLanguage': l10n.understandingBodyLanguage,
    'diyPetToys': l10n.diyPetToys,
    'seniorPetCare': l10n.seniorPetCare,
    'parasitePrevention': l10n.parasitePrevention,
    'groomingYourPetAtHome': l10n.groomingYourPetAtHome,
    // New articles
    'hamsterCareBasics': l10n.hamsterCareBasics,
    'hamsterDiet': l10n.hamsterDiet,
    'turtleCareGuide': l10n.turtleCareGuide,
    'puppyCareGuide': l10n.puppyCareGuide,
    'kittenCareGuide': l10n.kittenCareGuide,
    'petNutritionGuide': l10n.petNutritionGuide,
    'toxicFoodsForPets': l10n.toxicFoodsForPets,
    'dogExerciseGuide': l10n.dogExerciseGuide,
    'catPlaytimeIdeas': l10n.catPlaytimeIdeas,
    'dogBehaviorProblems': l10n.dogBehaviorProblems,
    'catBehaviorProblems': l10n.catBehaviorProblems,
    'petAllergies': l10n.petAllergies,
    'petWeightManagement': l10n.petWeightManagement,
    'spayNeuterBenefits': l10n.spayNeuterBenefits,
    'springPetCare': l10n.springPetCare,
    'autumnPetCare': l10n.autumnPetCare,
    'petFriendlyHome': l10n.petFriendlyHome,
    'movingWithPets': l10n.movingWithPets,
    'petsAndBabies': l10n.petsAndBabies,
    'basicDogCommands': l10n.basicDogCommands,
    'houseTraining': l10n.houseTraining,
    'birdDietGuide': l10n.birdDietGuide,
    'birdHealthSigns': l10n.birdHealthSigns,
    'fishTankMaintenance': l10n.fishTankMaintenance,
    'fishDiseasePrevention': l10n.fishDiseasePrevention,
    'rabbitHousing': l10n.rabbitHousing,
    'rabbitHealthGuide': l10n.rabbitHealthGuide,
    'petEmergencyKit': l10n.petEmergencyKit,
    'emergencySigns': l10n.emergencySigns,
  };
  return titles[titleKey] ?? titleKey;
}

String getLocalizedCategory(BuildContext context, String categoryKey) {
  final l10n = AppLocalizations.of(context)!;
  switch (categoryKey) {
    case 'dogCare':
      return l10n.dog;
    case 'catCare':
      return l10n.cat;
    case 'birdCare':
      return l10n.bird;
    case 'fishCare':
      return l10n.fish;
    case 'rabbitCare':
      return l10n.rabbit;
    case 'hamsterCare':
      return l10n.hamster;
    case 'exoticCare':
      return l10n.turtle;
    case 'generalCare':
      return l10n.other;
    case 'health':
      return l10n.medical;
    case 'lifestyle':
      return l10n.lifestyle;
    case 'behavior':
      return l10n.behavior;
    default:
      return categoryKey;
  }
}

String getLocalizedContent(BuildContext context, String? contentKey) {
  if (contentKey == null || contentKey.isEmpty) return '';
  final l10n = AppLocalizations.of(context)!;
  final Map<String, String> contents = {
    'healthyFeedingContent': l10n.healthyFeedingContent,
    'catHappinessContent': l10n.catHappinessContent,
    'birdTrainingContent': l10n.birdTrainingContent,
    'smallPetHabitatContent': l10n.smallPetHabitatContent,
    'commonDiseaseSymptomsContent': l10n.commonDiseaseSymptomsContent,
    'travelingWithPetsContent': l10n.travelingWithPetsContent,
    'firstAidForPetsContent': l10n.firstAidForPetsContent,
    'choosingRightPetContent': l10n.choosingRightPetContent,
    'dentalCareForPetsContent': l10n.dentalCareForPetsContent,
    'socializingYourPuppyContent': l10n.socializingYourPuppyContent,
    'litterBoxProblemsContent': l10n.litterBoxProblemsContent,
    'fishAquariumSetupContent': l10n.fishAquariumSetupContent,
    'rabbitDietContent': l10n.rabbitDietContent,
    'introducingNewPetContent': l10n.introducingNewPetContent,
    'winterCareTipsContent': l10n.winterCareTipsContent,
    'summerSafetyContent': l10n.summerSafetyContent,
    'understandingBodyLanguageContent': l10n.understandingBodyLanguageContent,
    'diyPetToysContent': l10n.diyPetToysContent,
    'seniorPetCareContent': l10n.seniorPetCareContent,
    'parasitePreventionContent': l10n.parasitePreventionContent,
    'groomingYourPetAtHomeContent': l10n.groomingYourPetAtHomeContent,
    // New articles
    'hamsterCareBasicsContent': l10n.hamsterCareBasicsContent,
    'hamsterDietContent': l10n.hamsterDietContent,
    'turtleCareGuideContent': l10n.turtleCareGuideContent,
    'puppyCareGuideContent': l10n.puppyCareGuideContent,
    'kittenCareGuideContent': l10n.kittenCareGuideContent,
    'petNutritionGuideContent': l10n.petNutritionGuideContent,
    'toxicFoodsForPetsContent': l10n.toxicFoodsForPetsContent,
    'dogExerciseGuideContent': l10n.dogExerciseGuideContent,
    'catPlaytimeIdeasContent': l10n.catPlaytimeIdeasContent,
    'dogBehaviorProblemsContent': l10n.dogBehaviorProblemsContent,
    'catBehaviorProblemsContent': l10n.catBehaviorProblemsContent,
    'petAllergiesContent': l10n.petAllergiesContent,
    'petWeightManagementContent': l10n.petWeightManagementContent,
    'spayNeuterBenefitsContent': l10n.spayNeuterBenefitsContent,
    'springPetCareContent': l10n.springPetCareContent,
    'autumnPetCareContent': l10n.autumnPetCareContent,
    'petFriendlyHomeContent': l10n.petFriendlyHomeContent,
    'movingWithPetsContent': l10n.movingWithPetsContent,
    'petsAndBabiesContent': l10n.petsAndBabiesContent,
    'basicDogCommandsContent': l10n.basicDogCommandsContent,
    'houseTrainingContent': l10n.houseTrainingContent,
    'birdDietGuideContent': l10n.birdDietGuideContent,
    'birdHealthSignsContent': l10n.birdHealthSignsContent,
    'fishTankMaintenanceContent': l10n.fishTankMaintenanceContent,
    'fishDiseasePreventionContent': l10n.fishDiseasePreventionContent,
    'rabbitHousingContent': l10n.rabbitHousingContent,
    'rabbitHealthGuideContent': l10n.rabbitHealthGuideContent,
    'petEmergencyKitContent': l10n.petEmergencyKitContent,
    'emergencySignsContent': l10n.emergencySignsContent,
    'demoPetBuddyNotes': l10n.demoPetBuddyNotes,
    'demoPetWhiskersNotes': l10n.demoPetWhiskersNotes,
    'demoActivity1Desc': l10n.demoActivity1Desc,
    'demoActivity2Desc': l10n.demoActivity2Desc,
    'demoExpense1Desc': l10n.demoExpense1Desc,
    'demoVaccineRabies': l10n.demoVaccineRabies,
  };
  return contents[contentKey] ?? contentKey;
}

String getLocalizedFullContent(BuildContext context, String contentKey) {
  final l10n = AppLocalizations.of(context)!;
  final Map<String, String> contents = {
    'healthyFeedingContent': l10n.healthyFeedingFullContent,
    'catHappinessContent': l10n.catHappinessFullContent,
    'birdTrainingContent': l10n.birdTrainingFullContent,
    'smallPetHabitatContent': l10n.smallPetHabitatFullContent,
    'commonDiseaseSymptomsContent': l10n.commonDiseaseSymptomsFullContent,
    'travelingWithPetsContent': l10n.travelingWithPetsFullContent,
    'firstAidForPetsContent': l10n.firstAidForPetsFullContent,
    'choosingRightPetContent': l10n.choosingRightPetFullContent,
    'dentalCareForPetsContent': l10n.dentalCareForPetsFullContent,
    'socializingYourPuppyContent': l10n.socializingYourPuppyFullContent,
    'litterBoxProblemsContent': l10n.litterBoxProblemsFullContent,
    'fishAquariumSetupContent': l10n.fishAquariumFullContent,
    'rabbitDietContent': l10n.rabbitDietFullContent,
    'introducingNewPetContent': l10n.introducingNewPetFullContent,
    'winterCareTipsContent': l10n.winterCareTipsFullContent,
    'summerSafetyContent': l10n.summerSafetyFullContent,
    'understandingBodyLanguageContent':
        l10n.understandingBodyLanguageFullContent,
    'diyPetToysContent': l10n.diyPetToysFullContent,
    'seniorPetCareContent': l10n.seniorPetCareFullContent,
    'parasitePreventionContent': l10n.parasitePreventionFullContent,
    'groomingYourPetAtHomeContent': l10n.groomingYourPetAtHomeFullContent,
    // New articles
    'hamsterCareBasicsContent': l10n.hamsterCareBasicsFullContent,
    'hamsterDietContent': l10n.hamsterDietFullContent,
    'turtleCareGuideContent': l10n.turtleCareGuideFullContent,
    'puppyCareGuideContent': l10n.puppyCareGuideFullContent,
    'kittenCareGuideContent': l10n.kittenCareGuideFullContent,
    'petNutritionGuideContent': l10n.petNutritionGuideFullContent,
    'toxicFoodsForPetsContent': l10n.toxicFoodsForPetsFullContent,
    'dogExerciseGuideContent': l10n.dogExerciseGuideFullContent,
    'catPlaytimeIdeasContent': l10n.catPlaytimeIdeasFullContent,
    'dogBehaviorProblemsContent': l10n.dogBehaviorProblemsFullContent,
    'catBehaviorProblemsContent': l10n.catBehaviorProblemsFullContent,
    'petAllergiesContent': l10n.petAllergiesFullContent,
    'petWeightManagementContent': l10n.petWeightManagementFullContent,
    'spayNeuterBenefitsContent': l10n.spayNeuterBenefitsFullContent,
    'springPetCareContent': l10n.springPetCareFullContent,
    'autumnPetCareContent': l10n.autumnPetCareFullContent,
    'petFriendlyHomeContent': l10n.petFriendlyHomeFullContent,
    'movingWithPetsContent': l10n.movingWithPetsFullContent,
    'petsAndBabiesContent': l10n.petsAndBabiesFullContent,
    'basicDogCommandsContent': l10n.basicDogCommandsFullContent,
    'houseTrainingContent': l10n.houseTrainingFullContent,
    'birdDietGuideContent': l10n.birdDietGuideFullContent,
    'birdHealthSignsContent': l10n.birdHealthSignsFullContent,
    'fishTankMaintenanceContent': l10n.fishTankMaintenanceFullContent,
    'fishDiseasePreventionContent': l10n.fishDiseasePreventionFullContent,
    'rabbitHousingContent': l10n.rabbitHousingFullContent,
    'rabbitHealthGuideContent': l10n.rabbitHealthGuideFullContent,
    'petEmergencyKitContent': l10n.petEmergencyKitFullContent,
    'emergencySignsContent': l10n.emergencySignsFullContent,
  };
  return contents[contentKey] ?? contentKey;
}

String getLocalizedAmountLabel(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return l10n.amountLabel;
}

String getLocalizedCostOptional(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return l10n.costOptional;
}
