import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../data/backrooms_data.dart';
import '../widgets/level_card.dart';
import '../widgets/entity_card.dart';
import '../widgets/section_header.dart';
import 'level_detail_page.dart';
import 'entity_detail_page.dart';
import 'noclip_page.dart';
import 'level_map_page.dart';
import 'glossary_page.dart';
import 'speed_terminal_page.dart';

/// 後室 App 首頁
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _levelsExpanded = true;
  bool _entitiesExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero 區塊
              _HeroBanner(),
              // 主要內容
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),
                    // 警示橫幅
                    _WarningBanner(),
                    const SizedBox(height: 24),
                    // === 快捷功能區 ===
                    _QuickActions(),
                    const SizedBox(height: 32),
                    // Level 百科（可收合）
                    _CollapsibleHeader(
                      title: '層級百科',
                      subtitle: '已確認的後室層級',
                      icon: Icons.layers_outlined,
                      count: BackroomsData.levels.length,
                      expanded: _levelsExpanded,
                      onToggle: () =>
                          setState(() => _levelsExpanded = !_levelsExpanded),
                    ),
                    AnimatedCrossFade(
                      firstChild: Column(
                        children: BackroomsData.levels
                            .map(
                              (level) => LevelCard(
                                level: level,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        LevelDetailPage(level: level),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      secondChild: const SizedBox.shrink(),
                      crossFadeState: _levelsExpanded
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 300),
                      sizeCurve: Curves.easeInOut,
                    ),
                    const SizedBox(height: 32),
                    // 實體圖鑑（可收合）
                    _CollapsibleHeader(
                      title: '實體圖鑑',
                      subtitle: '後室中已記錄的生物',
                      icon: Icons.visibility_off_outlined,
                      count: BackroomsData.entities.length,
                      expanded: _entitiesExpanded,
                      onToggle: () => setState(
                        () => _entitiesExpanded = !_entitiesExpanded,
                      ),
                    ),
                    AnimatedCrossFade(
                      firstChild: Column(
                        children: BackroomsData.entities
                            .map(
                              (entity) => EntityCard(
                                entity: entity,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EntityDetailPage(entity: entity),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      secondChild: const SizedBox.shrink(),
                      crossFadeState: _entitiesExpanded
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 300),
                      sizeCurve: Curves.easeInOut,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 首頁 Hero 橫幅（使用 Stack + Image.asset）
class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 背景圖片
        SizedBox(
          height: 300,
          width: double.infinity,
          child: Image.asset(
            'assets/images/hero.png',
            fit: BoxFit.cover,
            errorBuilder: (ctx, err, stack) => Container(
              color: AppColors.surface,
              child: Icon(
                Icons.image_not_supported,
                color: AppColors.textMuted,
                size: 40,
              ),
            ),
          ),
        ),
        // 暗色漸層遮罩
        Container(
          height: 300,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x331A1208), Color(0xFF1A1208)],
            ),
          ),
        ),
        // 頂部 AppBar 區域
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'BACKROOMS',
              style: GoogleFonts.creepster(
                color: AppColors.primary,
                fontSize: 26,
                letterSpacing: 4,
              ),
            ),
            actions: [
              Icon(Icons.menu_book_outlined, color: AppColors.primary),
              const SizedBox(width: 16),
            ],
          ),
        ),
        // 底部標題文字
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '後  室',
                style: GoogleFonts.creepster(
                  color: AppColors.textPrimary,
                  fontSize: 44,
                  letterSpacing: 6,
                  height: 1,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.circle, color: AppColors.dangerExtreme, size: 8),
                  const SizedBox(width: 6),
                  Text(
                    '倖存者資料庫  ·  SURVIVOR DATABASE',
                    style: GoogleFonts.spaceMono(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 警示橫幅元件
class _WarningBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.dangerExtreme.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.dangerExtreme.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppColors.dangerHigh,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '警告 WARNING',
                  style: GoogleFonts.spaceMono(
                    color: AppColors.dangerHigh,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '此資料庫由後室倖存者共同維護。如你正在閱讀此文件，代表你已進入後室。請保持冷靜。',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 快捷功能區
class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: '探索工具',
          subtitle: '倖存者必備功能',
          icon: Icons.explore_outlined,
        ),
        Row(
          children: [
            // 隨機切入
            Expanded(
              child: _ActionCard(
                icon: Icons.blur_on,
                label: '隨機切入',
                sublabel: 'NOCLIP',
                color: AppColors.dangerHigh,
                onTap: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (ctx, anim, anim2) => const NoclipPage(),
                    transitionsBuilder: (ctx, anim, anim2, child) {
                      return FadeTransition(opacity: anim, child: child);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // 層級地圖
            Expanded(
              child: _ActionCard(
                icon: Icons.account_tree_outlined,
                label: '連接圖',
                sublabel: 'LEVEL MAP',
                color: AppColors.primary,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LevelMapPage()),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // 術語表
            Expanded(
              child: _ActionCard(
                icon: Icons.menu_book_outlined,
                label: '術語表',
                sublabel: 'GLOSSARY',
                color: AppColors.dangerSafeLight,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GlossaryPage()),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // 速切終端（獨立大按鈕）
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SpeedTerminalPage()),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF3874F8).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF3874F8).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3874F8).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.terminal,
                    color: Color(0xFF3874F8),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '速切終端 C-49',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'SPEED NOCLIP TERMINAL · 定位 · 導航 · 計時',
                        style: GoogleFonts.spaceMono(
                          color: const Color(0xFF3874F8).withValues(alpha: 0.7),
                          fontSize: 8,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: const Color(0xFF3874F8),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 快捷功能卡片
class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              sublabel,
              style: GoogleFonts.spaceMono(
                color: color.withValues(alpha: 0.7),
                fontSize: 8,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 可收合的區塊標題
class _CollapsibleHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final int count;
  final bool expanded;
  final VoidCallback onToggle;

  const _CollapsibleHeader({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.count,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.spaceMono(
                  color: AppColors.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(width: 8),
              // 數量標籤
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: GoogleFonts.spaceMono(
                    color: AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
              const SizedBox(width: 8),
              // 展開/收合箭頭
              AnimatedRotation(
                turns: expanded ? 0 : -0.25,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: Icon(
                  Icons.expand_more,
                  color: AppColors.textMuted,
                  size: 22,
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 28),
              child: Text(
                expanded ? subtitle! : '點擊展開',
                style: TextStyle(color: AppColors.textMuted, fontSize: 11),
              ),
            ),
          ],
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
