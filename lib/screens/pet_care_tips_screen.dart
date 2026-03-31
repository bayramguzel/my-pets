import 'package:flutter/material.dart';
import 'package:my_pets/l10n/app_localizations.dart';

class PetCareTipsScreen extends StatefulWidget {
  const PetCareTipsScreen({super.key});

  @override
  State<PetCareTipsScreen> createState() => _PetCareTipsScreenState();
}

class _PetCareTipsScreenState extends State<PetCareTipsScreen> {
  String selectedPetType = 'general';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.petCareTips),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildPetTypeChip('general', l10n.general, Icons.pets),
                        _buildPetTypeChip('dog', l10n.dog, Icons.pets),
                        _buildPetTypeChip('cat', l10n.cat, Icons.pets),
                        _buildPetTypeChip(
                          'bird',
                          l10n.bird,
                          Icons.flutter_dash,
                        ),
                        _buildPetTypeChip(
                          'rabbit',
                          l10n.rabbit,
                          Icons.cruelty_free,
                        ),
                        _buildPetTypeChip('fish', l10n.fish, Icons.water),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: _getTipsForPetType(selectedPetType),
      ),
    );
  }

  Widget _buildPetTypeChip(String type, String label, IconData icon) {
    final isSelected = selectedPetType == type;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        onSelected: (selected) {
          setState(() {
            selectedPetType = type;
          });
        },
      ),
    );
  }

  List<Widget> _getTipsForPetType(String petType) {
    switch (petType) {
      case 'dog':
        return _getDogTips();
      case 'cat':
        return _getCatTips();
      case 'bird':
        return _getBirdTips();
      case 'rabbit':
        return _getRabbitTips();
      case 'fish':
        return _getFishTips();
      default:
        return _getGeneralTips();
    }
  }

  List<Widget> _getGeneralTips() {
    final l10n = AppLocalizations.of(context)!;
    return [
      _buildTipCard(context, l10n.dailyCare, Icons.schedule, Colors.blue, [
        l10n.generalDailyTip1,
        l10n.generalDailyTip2,
        l10n.generalDailyTip3,
        l10n.generalDailyTip4,
        l10n.generalDailyTip5,
      ]),
      const SizedBox(height: 16),
      _buildTipCard(
        context,
        l10n.healthControl,
        Icons.health_and_safety,
        Colors.green,
        [
          l10n.generalHealthTip1,
          l10n.generalHealthTip2,
          l10n.generalHealthTip3,
          l10n.generalHealthTip4,
          l10n.generalHealthTip5,
        ],
      ),
      const SizedBox(height: 16),
      _buildTipCard(context, l10n.nutrition, Icons.restaurant, Colors.orange, [
        l10n.generalNutritionTip1,
        l10n.generalNutritionTip2,
        l10n.generalNutritionTip3,
        l10n.generalNutritionTip4,
        l10n.generalNutritionTip5,
      ]),
      const SizedBox(height: 16),
      _buildTipCard(context, l10n.safety, Icons.security, Colors.red, [
        l10n.generalSafetyTip1,
        l10n.generalSafetyTip2,
        l10n.generalSafetyTip3,
        l10n.generalSafetyTip4,
        l10n.generalSafetyTip5,
      ]),
    ];
  }

  List<Widget> _getDogTips() {
    final l10n = AppLocalizations.of(context)!;
    return [
      _buildTipCard(context, l10n.dogDailyCare, Icons.pets, Colors.blue, [
        l10n.dogDailyTip1,
        l10n.dogDailyTip2,
        l10n.dogDailyTip3,
        l10n.dogDailyTip4,
        l10n.dogDailyTip5,
      ]),
      const SizedBox(height: 16),
      _buildTipCard(context, l10n.training, Icons.school, Colors.green, [
        l10n.dogTrainingTip1,
        l10n.dogTrainingTip2,
        l10n.dogTrainingTip3,
        l10n.dogTrainingTip4,
        l10n.dogTrainingTip5,
      ]),
      const SizedBox(height: 16),
      _buildTipCard(
        context,
        l10n.exercise,
        Icons.directions_run,
        Colors.orange,
        [
          l10n.dogExerciseTip1,
          l10n.dogExerciseTip2,
          l10n.dogExerciseTip3,
          l10n.dogExerciseTip4,
          l10n.dogExerciseTip5,
        ],
      ),
    ];
  }

  List<Widget> _getCatTips() {
    final l10n = AppLocalizations.of(context)!;
    return [
      _buildTipCard(context, l10n.catDailyCare, Icons.pets, Colors.purple, [
        l10n.catDailyTip1,
        l10n.catDailyTip2,
        l10n.catDailyTip3,
        l10n.catDailyTip4,
        l10n.catDailyTip5,
      ]),
      const SizedBox(height: 16),
      _buildTipCard(context, l10n.playAndActivity, Icons.toys, Colors.pink, [
        l10n.catPlayTip1,
        l10n.catPlayTip2,
        l10n.catPlayTip3,
        l10n.catPlayTip4,
        l10n.catPlayTip5,
      ]),
      const SizedBox(height: 16),
      _buildTipCard(context, l10n.catSpecialCare, Icons.favorite, Colors.red, [
        l10n.catSpecialTip1,
        l10n.catSpecialTip2,
        l10n.catSpecialTip3,
        l10n.catSpecialTip4,
        l10n.catSpecialTip5,
      ]),
    ];
  }

  List<Widget> _getBirdTips() {
    final l10n = AppLocalizations.of(context)!;
    return [
      _buildTipCard(context, l10n.birdCare, Icons.flutter_dash, Colors.teal, [
        l10n.birdCareTip1,
        l10n.birdCareTip2,
        l10n.birdCareTip3,
        l10n.birdCareTip4,
        l10n.birdCareTip5,
      ]),
      const SizedBox(height: 16),
      _buildTipCard(context, l10n.cageArrangement, Icons.home, Colors.indigo, [
        l10n.birdCageTip1,
        l10n.birdCageTip2,
        l10n.birdCageTip3,
        l10n.birdCageTip4,
        l10n.birdCageTip5,
      ]),
    ];
  }

  List<Widget> _getRabbitTips() {
    final l10n = AppLocalizations.of(context)!;
    return [
      _buildTipCard(
        context,
        l10n.rabbitCare,
        Icons.cruelty_free,
        Colors.green,
        [
          l10n.rabbitCareTip1,
          l10n.rabbitCareTip2,
          l10n.rabbitCareTip3,
          l10n.rabbitCareTip4,
          l10n.rabbitCareTip5,
        ],
      ),
      const SizedBox(height: 16),
      _buildTipCard(context, l10n.nutrition, Icons.grass, Colors.lightGreen, [
        l10n.rabbitNutritionTip1,
        l10n.rabbitNutritionTip2,
        l10n.rabbitNutritionTip3,
        l10n.rabbitNutritionTip4,
        l10n.rabbitNutritionTip5,
      ]),
    ];
  }

  List<Widget> _getFishTips() {
    final l10n = AppLocalizations.of(context)!;
    return [
      _buildTipCard(context, l10n.aquariumCare, Icons.water, Colors.blue, [
        l10n.fishCareTip1,
        l10n.fishCareTip2,
        l10n.fishCareTip3,
        l10n.fishCareTip4,
        l10n.fishCareTip5,
      ]),
      const SizedBox(height: 16),
      _buildTipCard(context, l10n.waterQuality, Icons.science, Colors.cyan, [
        l10n.fishWaterTip1,
        l10n.fishWaterTip2,
        l10n.fishWaterTip3,
        l10n.fishWaterTip4,
        l10n.fishWaterTip5,
      ]),
    ];
  }

  Widget _buildTipCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    List<String> tips,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...tips.map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        tip,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
