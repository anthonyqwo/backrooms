import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_colors.dart';
import '../data/backrooms_data.dart';
import '../pages/level_detail_page.dart';

/// 隨機切入（Noclip）動畫頁面
/// 模擬「切入後室」的效果，隨機跳轉到一個層級。
class NoclipPage extends StatefulWidget {
  const NoclipPage({super.key});

  @override
  State<NoclipPage> createState() => _NoclipPageState();
}

class _NoclipPageState extends State<NoclipPage> with TickerProviderStateMixin {
  late AnimationController _glitchController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  final _random = Random();
  int _phase = 0; // 0=初始, 1=故障, 2=黑屏文字, 3=跳轉
  String _statusText = '';
  final List<String> _glitchTexts = [
    '正在偵測閾限空間……',
    'R̶E̸A̵L̷I̸T̶Y̷ ̵E̷R̸R̸O̸R̷',
    '維度邊界不穩定',
    '警告：座標偏移',
    '你的腳下開始變得不穩……',
    'N̶O̸C̷L̵I̷P̸ ̵D̶E̵T̴E̶C̷T̵E̸D̵',
    '切入程序已啟動',
  ];
  Level? _targetLevel;
  Timer? _textTimer;
  int _textIndex = 0;

  @override
  void initState() {
    super.initState();
    _glitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

    // 選擇目標層級
    final levels = BackroomsData.levels;
    _targetLevel = levels[_random.nextInt(levels.length)];

    // 開始切入序列
    _startNoclipSequence();
  }

  void _startNoclipSequence() {
    // Phase 1: 故障文字序列（2.5 秒）
    setState(() => _phase = 1);
    _textTimer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if (_textIndex >= _glitchTexts.length) {
        timer.cancel();
        _enterBlackScreen();
        return;
      }
      setState(() {
        _statusText = _glitchTexts[_textIndex];
        _textIndex++;
      });
    });
  }

  void _enterBlackScreen() {
    // Phase 2: 黑屏 + 目標層級揭示
    setState(() => _phase = 2);
    _fadeController.forward();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      // Phase 3: 跳轉
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (ctx, anim, anim2) =>
              LevelDetailPage(level: _targetLevel!),
          transitionsBuilder: (ctx, anim, anim2, child) {
            return FadeTransition(opacity: anim, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _textTimer?.cancel();
    _glitchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Phase 1: 故障效果
          if (_phase == 1) _buildGlitchPhase(),
          // Phase 2: 黑屏揭示
          if (_phase == 2) _buildRevealPhase(),
        ],
      ),
    );
  }

  Widget _buildGlitchPhase() {
    return AnimatedBuilder(
      animation: _glitchController,
      builder: (context, child) {
        final dx = (_random.nextDouble() - 0.5) * 8;
        final dy = (_random.nextDouble() - 0.5) * 8;
        return Stack(
          children: [
            // 閃爍背景
            Positioned.fill(
              child: Opacity(
                opacity: _random.nextDouble() * 0.15,
                child: Container(color: Colors.white),
              ),
            ),
            // 掃描線效果
            ...List.generate(20, (i) {
              final y =
                  _random.nextDouble() * MediaQuery.of(context).size.height;
              return Positioned(
                top: y,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: _random.nextDouble() * 0.3,
                  child: Container(
                    height: 1 + _random.nextDouble() * 3,
                    color: Colors.white,
                  ),
                ),
              );
            }),
            // 中央文字
            Center(
              child: Transform.translate(
                offset: Offset(dx, dy),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 警告圖示
                    Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.dangerHigh.withValues(
                        alpha: 0.6 + _random.nextDouble() * 0.4,
                      ),
                      size: 48,
                    ),
                    const SizedBox(height: 20),
                    // 狀態文字
                    Text(
                      _statusText,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.spaceMono(
                        color: Color.lerp(
                          AppColors.dangerHigh,
                          Colors.white,
                          _random.nextDouble() * 0.5,
                        ),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // 進度指示
                    SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        value: _textIndex / _glitchTexts.length,
                        backgroundColor: Colors.white10,
                        color: AppColors.dangerHigh,
                        minHeight: 3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRevealPhase() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '你切入了',
              style: GoogleFonts.notoSans(
                color: AppColors.textMuted,
                fontSize: 14,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'LEVEL ${_targetLevel!.id}',
              style: GoogleFonts.spaceMono(
                color: AppColors.primary,
                fontSize: 42,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _targetLevel!.name,
              style: GoogleFonts.creepster(
                color: AppColors.textPrimary,
                fontSize: 28,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
