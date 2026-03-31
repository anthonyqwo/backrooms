import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../core/inventory_manager.dart';
import '../data/backrooms_data.dart';
import '../widgets/danger_badge.dart';
import '../widgets/fullscreen_image_viewer.dart';
import '../widgets/section_header.dart';

/// 物資詳情頁面
class ObjectDetailPage extends StatefulWidget {
  final BackroomsObject object;

  const ObjectDetailPage({super.key, required this.object});

  @override
  State<ObjectDetailPage> createState() => _ObjectDetailPageState();
}

class _ObjectDetailPageState extends State<ObjectDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroSection(object: widget.object),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: '物資描述',
                          icon: Icons.description_outlined,
                        ),
                        Text(
                          widget.object.fullDescription,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            height: 1.8,
                          ),
                        ),
                        const SizedBox(height: 28),
                        SectionHeader(
                          title: '用途與特點',
                          icon: Icons.auto_awesome_outlined,
                        ),
                        _PropertyList(items: widget.object.properties),
                        const SizedBox(height: 28),
                        SectionHeader(
                          title: '基本資料',
                          icon: Icons.info_outline,
                        ),
                        _InfoRow(
                          label: '物資等級',
                          value: widget.object.objectClass,
                          icon: Icons.label_important_outline,
                        ),
                        _InfoRow(
                          label: '英文名稱',
                          value: widget.object.nameEn,
                          icon: Icons.translate,
                        ),
                        _InfoRow(
                          label: '危險程度',
                          value: widget.object.dangerLevel.toUpperCase(),
                          icon: Icons.warning_amber_rounded,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // 底部「操作」按鈕
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _ActionDock(object: widget.object),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final BackroomsObject object;

  const _HeroSection({required this.object});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FullscreenImageViewer.open(
            context,
            object.imageUrl,
            heroTag: 'obj_img_${object.id}',
          ),
          child: SizedBox(
            height: 300,
            width: double.infinity,
            child: Hero(
              tag: 'obj_img_${object.id}',
              child: Image.asset(
                object.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) =>
                    Container(color: AppColors.surface),
              ),
            ),
          ),
        ),
        Container(
          height: 300,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x661A1208), Color(0xFF1A1208)],
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
        // 標題與危險徽章
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                object.nameEn.toUpperCase(),
                style: GoogleFonts.spaceMono(
                  color: AppColors.primary,
                  fontSize: 12,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                object.name,
                style: GoogleFonts.creepster(
                  color: AppColors.textPrimary,
                  fontSize: 40,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  DangerBadge(dangerLevel: object.dangerLevel),
                  const SizedBox(width: 8),
                  Text(
                    object.objectClass,
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
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

class _PropertyList extends StatelessWidget {
  final List<String> items;

  const _PropertyList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.check_circle_outline,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        height: 1.5,
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textMuted, size: 18),
          const SizedBox(width: 12),
          Text(
            '$label：',
            style: TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionDock extends StatefulWidget {
  final BackroomsObject object;

  const _ActionDock({required this.object});

  @override
  State<_ActionDock> createState() => _ActionDockState();
}

class _ActionDockState extends State<_ActionDock> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, AppColors.background.withValues(alpha: 0.9)],
        ),
      ),
      child: Center(
        child: ValueListenableBuilder<Map<String, int>>(
          valueListenable: InventoryManager.instance.inventory,
          builder: (context, inv, child) {
            final count = inv[widget.object.id] ?? 0;
            return ElevatedButton(
              onPressed: () {
                InventoryManager.instance.addItem(widget.object.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.primary,
                    content: Text(
                      '已將一份 ${widget.object.name} 加入生存包',
                      style: const TextStyle(color: Colors.white),
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
                shadowColor: AppColors.primary.withValues(alpha: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_shopping_cart, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    count > 0 ? '再次獲取 (目前持有: $count)' : '加入生存包',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
