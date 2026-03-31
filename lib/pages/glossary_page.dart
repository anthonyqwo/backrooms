import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../data/glossary_data.dart';

/// 後室術語表頁面
/// 可搜尋、按分類篩選的術語百科。
class GlossaryPage extends StatefulWidget {
  const GlossaryPage({super.key});

  @override
  State<GlossaryPage> createState() => _GlossaryPageState();
}

class _GlossaryPageState extends State<GlossaryPage> {
  String _searchQuery = '';
  String? _selectedCategory;
  final _searchController = TextEditingController();

  static const _categories = ['概念', '現象', '物品', '組織', '地點', '實體'];

  static const _categoryIcons = {
    '概念': Icons.lightbulb_outline,
    '現象': Icons.flash_on_outlined,
    '物品': Icons.inventory_2_outlined,
    '組織': Icons.groups_outlined,
    '地點': Icons.place_outlined,
    '實體': Icons.visibility_off_outlined,
  };
  
  static const _categoryColors = {
    '概念': Color(0xFF4FC3F7), // 淺藍
    '現象': Color(0xFFBA68C8), // 淺紫
    '物品': Color(0xFF81C784), // 淺綠
    '組織': Color(0xFFFFB74D), // 琥珀
    '地點': Color(0xFF4DB6AC), // 青綠
    '實體': Color(0xFFE57373), // 珊瑚紅
  };

  List<GlossaryEntry> get _filteredEntries {
    return GlossaryData.entries.where((entry) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          entry.term.contains(_searchQuery) ||
          entry.termEn.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          entry.definition.contains(_searchQuery);
      final matchesCategory =
          _selectedCategory == null || entry.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entries = _filteredEntries;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primary,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '後室術語表',
          style: GoogleFonts.creepster(
            color: AppColors.primary,
            fontSize: 22,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 搜尋列
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: '搜尋術語…',
                    hintStyle: const TextStyle(color: AppColors.textMuted),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: AppColors.textMuted,
                              size: 18,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (v) => setState(() => _searchQuery = v),
                ),
              ),
            ),
            // 分類篩選器
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: SizedBox(
                height: 34,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _CategoryChip(
                      label: '全部',
                      icon: Icons.apps,
                      selected: _selectedCategory == null,
                      onTap: () => setState(() => _selectedCategory = null),
                    ),
                    ..._categories.map(
                      (cat) => _CategoryChip(
                        label: cat,
                        icon: _categoryIcons[cat] ?? Icons.label_outline,
                        selected: _selectedCategory == cat,
                        onTap: () => setState(() {
                          _selectedCategory = _selectedCategory == cat
                              ? null
                              : cat;
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 結果數量
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    '${entries.length} 筆結果',
                    style: GoogleFonts.spaceMono(
                      color: AppColors.textMuted,
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // 術語列表
            Expanded(
              child: entries.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off,
                            color: AppColors.textMuted,
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '找不到相關術語',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                      itemCount: entries.length,
                      itemBuilder: (context, index) =>
                          _GlossaryCard(entry: entries[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 分類篩選按鈕
class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: selected ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.primary : AppColors.textSecondary,
                fontSize: 11,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 術語卡片（可展開）
class _GlossaryCard extends StatefulWidget {
  final GlossaryEntry entry;

  const _GlossaryCard({required this.entry});

  @override
  State<_GlossaryCard> createState() => _GlossaryCardState();
}

class _GlossaryCardState extends State<_GlossaryCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _expanded ? AppColors.surface : AppColors.cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _expanded
                ? AppColors.primary.withValues(alpha: 0.4)
                : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 標題行
            Row(
              children: [
                // 分類標籤
                if (entry.category != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: (_GlossaryPageState._categoryColors[entry.category] ?? AppColors.primary).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: (_GlossaryPageState._categoryColors[entry.category] ?? AppColors.primary).withValues(alpha: 0.5),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      entry.category!,
                      style: GoogleFonts.spaceMono(
                        color: _GlossaryPageState._categoryColors[entry.category] ?? AppColors.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                // 中文名
                Expanded(
                  child: Text(
                    entry.term,
                    style: GoogleFonts.notoSans(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // 展開圖示
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    Icons.expand_more,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                ),
              ],
            ),
            // 英文名
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                entry.termEn,
                style: GoogleFonts.spaceMono(
                  color: AppColors.textMuted,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
            ),
            // 定義（展開時顯示）
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  entry.definition,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.7,
                  ),
                ),
              ),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
          ],
        ),
      ),
    );
  }
}
