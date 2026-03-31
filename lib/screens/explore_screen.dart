import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:my_pets/l10n/app_localizations.dart';
import 'package:my_pets/utils/localization_utils.dart';
import '../providers/pet_provider.dart';
import '../widgets/banner_ad_widget.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _selectedCategory = 'all';
  String _searchQuery = '';
  final ScrollController _categoryScrollController = ScrollController();
  bool _showRightArrow = true;

  @override
  void initState() {
    super.initState();
    _categoryScrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_categoryScrollController.position.pixels >=
        _categoryScrollController.position.maxScrollExtent - 20) {
      if (_showRightArrow) setState(() => _showRightArrow = false);
    } else {
      if (!_showRightArrow) setState(() => _showRightArrow = true);
    }
  }

  @override
  void dispose() {
    _categoryScrollController.dispose();
    super.dispose();
  }

  Color _getCategoryColor(String categoryKey) {
    switch (categoryKey) {
      case 'dogCare':
        return Colors.brown;
      case 'catCare':
        return Colors.purple;
      case 'birdCare':
        return Colors.teal;
      case 'fishCare':
        return Colors.blue;
      case 'rabbitCare':
        return Colors.green;
      case 'hamsterCare':
        return Colors.orange;
      case 'exoticCare':
        return Colors.deepOrange;
      case 'health':
        return Colors.red;
      case 'lifestyle':
        return Colors.amber;
      case 'behavior':
        return Colors.indigo;
      case 'generalCare':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.explore),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(115),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: l10n.search,
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  SizedBox(
                    height: 55,
                    child: ListView(
                      controller: _categoryScrollController,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        _buildCategoryChip('all', l10n.all, '📚'),
                        _buildCategoryChip('dogCare', l10n.dogCare, '🐕'),
                        _buildCategoryChip('catCare', l10n.catCare, '🐈'),
                        _buildCategoryChip('birdCare', l10n.birdCare, '🦜'),
                        _buildCategoryChip('fishCare', l10n.fishCare, '🐠'),
                        _buildCategoryChip('rabbitCare', l10n.rabbitCare, '🐰'),
                        _buildCategoryChip(
                          'hamsterCare',
                          l10n.hamsterCare,
                          '🐹',
                        ),
                        _buildCategoryChip('exoticCare', l10n.exoticCare, '🐢'),
                        _buildCategoryChip('health', l10n.health, '⚕️'),
                        _buildCategoryChip('lifestyle', l10n.lifestyle, '🏡'),
                        _buildCategoryChip('behavior', l10n.behavior, '🧠'),
                        _buildCategoryChip(
                          'generalCare',
                          l10n.generalCare,
                          '🐾',
                        ),
                      ],
                    ),
                  ),
                  if (_showRightArrow)
                    IgnorePointer(
                      child: Container(
                        width: 40,
                        height: 55,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Theme.of(
                                context,
                              ).colorScheme.surface.withOpacity(0),
                              Theme.of(context).colorScheme.surface,
                            ],
                          ),
                        ),
                        child: const Icon(Icons.chevron_right, size: 20),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
      body: Consumer<ExploreData>(
        builder:
            (BuildContext context, ExploreData exploreData, Widget? child) {
              if (exploreData.articles.isEmpty) {
                return Center(child: Text(l10n.noContentToExplore));
              }

              // Filter articles
              var filteredArticles = exploreData.articles.where((article) {
                bool categoryMatch =
                    _selectedCategory == 'all' ||
                    article.categoryKey == _selectedCategory;

                // Search in localized title and content
                String localizedTitle = getLocalizedTitle(
                  context,
                  article.titleKey,
                ).toLowerCase();
                String localizedContent = getLocalizedContent(
                  context,
                  article.contentKey,
                ).toLowerCase();

                bool searchMatch =
                    _searchQuery.isEmpty ||
                    localizedTitle.contains(_searchQuery) ||
                    localizedContent.contains(_searchQuery);

                return categoryMatch && searchMatch;
              }).toList();

              if (filteredArticles.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noResultsFound,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                );
              }

              // Build list with banner ads inserted
              List<Widget> listItems = [];

              // Add top banner
              listItems.add(
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: BannerAdWidget(adSize: AdSize.fullBanner),
                ),
              );

              for (int i = 0; i < filteredArticles.length; i++) {
                listItems.add(ExploreArticleCard(article: filteredArticles[i]));

                // Add banner every 3 articles
                if ((i + 1) % 3 == 0 && i != filteredArticles.length - 1) {
                  listItems.add(
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: BannerAdWidget(adSize: AdSize.fullBanner),
                    ),
                  );
                }
              }

              return ListView(
                padding: const EdgeInsets.all(8.0),
                children: listItems,
              );
            },
      ),
    );
  }

  Widget _buildCategoryChip(String category, String label, String emoji) {
    final isSelected = _selectedCategory == category;
    final color = _getCategoryColor(category);

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        avatar: Text(emoji),
        selectedColor: color.withOpacity(0.2),
        checkmarkColor: color,
        labelStyle: TextStyle(
          color: isSelected ? color : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
      ),
    );
  }
}

class ExploreArticleCard extends StatelessWidget {
  final ExploreArticle article;

  const ExploreArticleCard({super.key, required this.article});

  Widget _buildPlaceholder(Color categoryColor, String emoji) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            categoryColor.withValues(alpha: 0.3),
            categoryColor.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            scaleEmoji(emoji, size: 60),
            const SizedBox(height: 8),
            Icon(
              Icons.image_not_supported_outlined,
              color: categoryColor.withValues(alpha: 0.5),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget scaleEmoji(String emoji, {required double size}) {
    return Text(emoji, style: TextStyle(fontSize: size));
  }

  Color _getCategoryColor(String categoryKey) {
    switch (categoryKey) {
      case 'dogCare':
        return Colors.brown;
      case 'catCare':
        return Colors.purple;
      case 'birdCare':
        return Colors.teal;
      case 'fishCare':
        return Colors.blue;
      case 'rabbitCare':
        return Colors.green;
      case 'hamsterCare':
        return Colors.orange;
      case 'exoticCare':
        return Colors.deepOrange;
      case 'health':
        return Colors.red;
      case 'lifestyle':
        return Colors.amber;
      case 'behavior':
        return Colors.indigo;
      case 'generalCare':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  String _getCategoryEmoji(String categoryKey) {
    switch (categoryKey) {
      case 'dogCare':
        return '🐕';
      case 'catCare':
        return '🐈';
      case 'birdCare':
        return '🦜';
      case 'fishCare':
        return '🐠';
      case 'rabbitCare':
        return '🐰';
      case 'hamsterCare':
        return '🐹';
      case 'exoticCare':
        return '🐢';
      case 'health':
        return '⚕️';
      case 'lifestyle':
        return '🏡';
      case 'behavior':
        return '🧠';
      case 'generalCare':
        return '🐾';
      default:
        return '📚';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categoryColor = _getCategoryColor(article.categoryKey);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  ExploreArticleDetailScreen(article: article),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16.0),
                  ),
                  child:
                      article.imageUrl.isEmpty ||
                          article.imageUrl.contains('placeholder')
                      ? _buildPlaceholder(
                          categoryColor,
                          _getCategoryEmoji(article.categoryKey),
                        )
                      : Image.network(
                          article.imageUrl,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 180,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              _buildPlaceholder(
                                categoryColor,
                                _getCategoryEmoji(article.categoryKey),
                              ),
                        ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: categoryColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getCategoryEmoji(article.categoryKey),
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          getLocalizedCategory(context, article.categoryKey),
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getLocalizedTitle(context, article.titleKey),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    getLocalizedContent(context, article.contentKey),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  ExploreArticleDetailScreen(article: article),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward, size: 18),
                        label: Text(l10n.readMore),
                        style: TextButton.styleFrom(
                          foregroundColor: categoryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExploreArticleDetailScreen extends StatelessWidget {
  final ExploreArticle article;

  const ExploreArticleDetailScreen({super.key, required this.article});

  Widget _buildPlaceholder(Color categoryColor, String emoji) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            categoryColor.withValues(alpha: 0.3),
            categoryColor.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(child: Text(emoji, style: const TextStyle(fontSize: 100))),
    );
  }

  Color _getCategoryColor(String categoryKey) {
    switch (categoryKey) {
      case 'dogCare':
        return Colors.brown;
      case 'catCare':
        return Colors.purple;
      case 'birdCare':
        return Colors.teal;
      case 'fishCare':
        return Colors.blue;
      case 'rabbitCare':
        return Colors.green;
      case 'hamsterCare':
        return Colors.orange;
      case 'exoticCare':
        return Colors.deepOrange;
      case 'health':
        return Colors.red;
      case 'lifestyle':
        return Colors.amber;
      case 'behavior':
        return Colors.indigo;
      case 'generalCare':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  String _getCategoryEmoji(String categoryKey) {
    switch (categoryKey) {
      case 'dogCare':
        return '🐕';
      case 'catCare':
        return '🐈';
      case 'birdCare':
        return '🦜';
      case 'fishCare':
        return '🐠';
      case 'rabbitCare':
        return '🐰';
      case 'hamsterCare':
        return '🐹';
      case 'exoticCare':
        return '🐢';
      case 'health':
        return '⚕️';
      case 'lifestyle':
        return '🏡';
      case 'behavior':
        return '🧠';
      case 'generalCare':
        return '🐾';
      default:
        return '📚';
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(article.categoryKey);
    final emoji = _getCategoryEmoji(article.categoryKey);

    return Scaffold(
      appBar: AppBar(title: Text(getLocalizedTitle(context, article.titleKey))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child:
                  article.imageUrl.isEmpty ||
                      article.imageUrl.contains('placeholder')
                  ? _buildPlaceholder(categoryColor, emoji)
                  : Image.network(
                      article.imageUrl,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholder(categoryColor, emoji),
                    ),
            ),
            const SizedBox(height: 20.0),
            Text(
              getLocalizedCategory(context, article.categoryKey),
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              getLocalizedTitle(context, article.titleKey),
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Text(
              getLocalizedFullContent(context, article.contentKey),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
