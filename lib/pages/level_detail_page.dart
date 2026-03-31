import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../data/backrooms_data.dart';
import '../widgets/danger_badge.dart';
import '../widgets/fullscreen_image_viewer.dart';
import '../widgets/section_header.dart';
import '../widgets/info_item.dart';
import '../widgets/level_link_text.dart';

/// Level 詳情頁面
class LevelDetailPage extends StatelessWidget {
  final Level level;

  const LevelDetailPage({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroSection(level: level),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MetaRow(level: level),
                    const SizedBox(height: 24),
                    SectionHeader(
                      title: '層級描述',
                      icon: Icons.description_outlined,
                    ),
                    LevelLinkText(
                      level.fullDescription,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.8,
                      ),
                    ),
                    const SizedBox(height: 28),
                    SectionHeader(title: '基本資料', icon: Icons.info_outline),
                    InfoItem(
                      label: '層級編號',
                      value: 'Level ${level.id}',
                      icon: Icons.tag,
                    ),
                    InfoItem(
                      label: '英文名',
                      value: level.subtitle,
                      icon: Icons.translate,
                    ),
                    InfoItem(
                      label: '估計大小',
                      value: level.sizeDesc,
                      icon: Icons.straighten,
                    ),
                    InfoItem(
                      label: '生存難度',
                      value: level.classLabel,
                      icon: Icons.shield_outlined,
                    ),
                    InfoItem(
                      label: '難度標籤',
                      value: level.classTags,
                      icon: Icons.label_outline,
                    ),
                    const SizedBox(height: 28),
                    SectionHeader(
                      title: '已知實體',
                      icon: Icons.visibility_off_outlined,
                    ),
                    _TagList(
                      items: level.entities,
                      color: AppColors.dangerExtreme,
                    ),
                    const SizedBox(height: 28),
                    SectionHeader(title: '進入方式', icon: Icons.login),
                    _BulletList(items: level.accessMethods),
                    const SizedBox(height: 28),
                    SectionHeader(title: '逃離方式', icon: Icons.logout),
                    _BulletList(items: level.exitMethods),
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

/// 英雄區塊（圖片 + 返回按鈕 + 標題）
class _HeroSection extends StatelessWidget {
  final Level level;

  const _HeroSection({required this.level});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 背景圖（可點擊放大）
        GestureDetector(
          onTap: () => FullscreenImageViewer.open(
            context,
            level.imageUrl,
            heroTag: 'level_image_${level.id}',
          ),
          child: SizedBox(
            height: 260,
            width: double.infinity,
            child: Hero(
              tag: 'level_image_${level.id}',
              child: Image.asset(
                level.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context2, error2, stack) =>
                    Container(color: AppColors.surface),
              ),
            ),
          ),
        ),
        // 暗色漸層
        IgnorePointer(
          child: Container(
            height: 260,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x771A1208), Color(0xFF1A1208)],
              ),
            ),
          ),
        ),
        // 放大提示圖示
        Positioned(
          top: 12,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () => FullscreenImageViewer.open(
                context,
                level.imageUrl,
                heroTag: 'level_image_${level.id}',
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.zoom_in, color: AppColors.textMuted, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      '點擊查看大圖',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // 返回按鈕
        Positioned(
          top: 12,
          left: 12,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.primary,
                size: 18,
              ),
            ),
          ),
        ),
        // 回首頁按鈕
        Positioned(
          top: 12,
          right: 12,
          child: GestureDetector(
            onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.home_outlined,
                color: AppColors.primary,
                size: 18,
              ),
            ),
          ),
        ),
        // 底部標題
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LEVEL ${level.id}  ·  ${level.nameEn}',
                style: GoogleFonts.spaceMono(
                  color: AppColors.primary,
                  fontSize: 11,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                level.name,
                style: GoogleFonts.creepster(
                  color: AppColors.textPrimary,
                  fontSize: 36,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DangerBadge(dangerLevel: level.dangerLevel),
                  const SizedBox(height: 4),
                  Text(
                    level.classTags,
                    style: TextStyle(color: AppColors.textMuted, fontSize: 10),
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

/// Level meta 數據行
class _MetaRow extends StatelessWidget {
  final Level level;

  const _MetaRow({required this.level});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MetaChip(icon: Icons.straighten, label: '大小', value: level.sizeDesc),
        const SizedBox(width: 12),
        _MetaChip(
          icon: Icons.visibility_off,
          label: '實體數',
          value: '${level.entities.length} 種',
        ),
        const SizedBox(width: 12),
        _MetaChip(
          icon: Icons.login,
          label: '入口',
          value: '${level.accessMethods.length} 個',
        ),
      ],
    );
  }
}

/// Meta 資訊小方塊
class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 18),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.spaceMono(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(color: AppColors.textMuted, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

/// 標籤列表（Wrap 排列）
class _TagList extends StatelessWidget {
  final List<String> items;
  final Color color;

  const _TagList({required this.items, required this.color});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (item) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: color.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.remove_red_eye_outlined, color: color, size: 12),
                  const SizedBox(width: 4),
                  Text(
                    item,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

/// 項目符號列表
class _BulletList extends StatelessWidget {
  final List<String> items;

  const _BulletList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: LevelLinkText(
                      item,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
