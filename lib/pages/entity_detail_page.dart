import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../data/backrooms_data.dart';
import '../widgets/danger_badge.dart';
import '../widgets/fullscreen_image_viewer.dart';
import '../widgets/section_header.dart';
import '../widgets/level_link_text.dart';

/// 實體詳情頁面
class EntityDetailPage extends StatelessWidget {
  final Entity entity;

  const EntityDetailPage({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _EntityHeroSection(entity: entity),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 類別與危險等級
                    Row(
                      children: [
                        Icon(
                          Icons.category_outlined,
                          color: AppColors.primary,
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          entity.category,
                          style: GoogleFonts.spaceMono(
                            color: AppColors.primary,
                            fontSize: 11,
                            letterSpacing: 1,
                          ),
                        ),
                        const Spacer(),
                        DangerBadge(
                          dangerLevel: entity.dangerLevel,
                          isEntity: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SectionHeader(title: '實體描述', icon: Icons.subject),
                    LevelLinkText(
                      entity.fullDescription,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        height: 1.8,
                      ),
                    ),
                    const SizedBox(height: 28),
                    SectionHeader(
                      title: '出沒層級',
                      icon: Icons.location_on_outlined,
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: entity.foundInLevels
                          .map(
                            (lvl) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.layers_outlined,
                                    color: AppColors.primary,
                                    size: 13,
                                  ),
                                  const SizedBox(width: 5),
                                  LevelLinkText(
                                    lvl,
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
                    ),
                    const SizedBox(height: 28),
                    SectionHeader(title: '倖存者守則', icon: Icons.shield_outlined),
                    ...entity.survivorTips.asMap().entries.map(
                      (e) => _SurvivorTip(index: e.key + 1, tip: e.value),
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

/// 實體英雄區塊
class _EntityHeroSection extends StatelessWidget {
  final Entity entity;

  const _EntityHeroSection({required this.entity});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FullscreenImageViewer.open(
            context,
            entity.imageUrl,
            heroTag: 'entity_image_${entity.nameEn}',
          ),
          child: SizedBox(
            height: 280,
            width: double.infinity,
            child: Hero(
              tag: 'entity_image_${entity.nameEn}',
              child: Image.asset(
                entity.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  color: AppColors.surface,
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.visibility_off,
                      color: AppColors.textMuted,
                      size: 60,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        IgnorePointer(
          child: Container(
            height: 280,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x881A1208), Color(0xFF1A1208)],
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
                entity.imageUrl,
                heroTag: 'entity_image_${entity.nameEn}',
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
        // 底部資訊
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entity.nameEn.toUpperCase(),
                style: GoogleFonts.spaceMono(
                  color: AppColors.primary,
                  fontSize: 11,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                entity.name,
                style: GoogleFonts.creepster(
                  color: AppColors.textPrimary,
                  fontSize: 36,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 倖存者守則項目
class _SurvivorTip extends StatelessWidget {
  final int index;
  final String tip;

  const _SurvivorTip({required this.index, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                '$index',
                style: GoogleFonts.spaceMono(
                  color: AppColors.textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: LevelLinkText(
              tip,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
