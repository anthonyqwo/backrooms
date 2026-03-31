import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/backrooms_data.dart';
import '../pages/level_detail_page.dart';
import '../pages/inventory_page.dart';
import '../core/inventory_manager.dart';

/// 速切終端配色
class _TermColors {
  static const bg = Color(0xFF0A1628);
  static const panel = Color(0xFF0D1E3A);
  static const border = Color(0xFF1A3A6E);
  static const accent = Color(0xFF3874F8);

  static const green = Color(0xFF33FF55);
  static const red = Color(0xFFFF3433);
  static const textPrimary = Color(0xFFF8F8FF);
  static const textDim = Color(0xFF6B8AC4);
}

/// 速切終端頁面
/// 模擬後室世界觀中的 Object C-49「速切終端」裝置介面。
/// 功能：層級定位、導航路徑規劃、速切計時器、資料庫查詢。
class SpeedTerminalPage extends StatefulWidget {
  const SpeedTerminalPage({super.key});

  @override
  State<SpeedTerminalPage> createState() => _SpeedTerminalPageState();
}

class _SpeedTerminalPageState extends State<SpeedTerminalPage>
    with TickerProviderStateMixin {
  // 狀態
  int _currentTab = 0; // 0=定位, 1=導航, 2=計時, 3=資料庫
  Level? _currentLevel;
  Level? _targetLevel;
  final _random = Random();

  // 計時器
  Timer? _timer;
  int _elapsedMs = 0;
  bool _isRunning = false;

  // 開機動畫
  bool _bootComplete = false;
  late AnimationController _bootController;
  late Animation<double> _bootAnim;
  int _bootLine = 0;
  Timer? _bootTimer;

  // 收刮功能狀態
  bool _isScavenging = false;
  double _scavengeProgress = 0.0;
  final List<String> _scavengeLogs = [];
  BackroomsObject? _lastScavengeResult;
  late AnimationController _scavengeController;
  late Animation<double> _scavengeAnim;
  final ScrollController _scavengeScrollController = ScrollController();

  final _bootLines = [
    'SPEED_NOCLIP_TERMINAL v3.7.2',
    '正在連線至速切玩家中央伺服器...',
    '驗證身份... 訪客模式',
    '載入層級資料庫... 13 筆紀錄',
    '載入實體資料庫... 5 筆紀錄',
    '校正空間座標...',
    '終端就緒。',
  ];

  @override
  void initState() {
    super.initState();
    _currentLevel = BackroomsData.levels.first;

    _bootController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bootAnim = CurvedAnimation(parent: _bootController, curve: Curves.easeOut);

    _scavengeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _scavengeAnim =
        CurvedAnimation(parent: _scavengeController, curve: Curves.linear);

    _scavengeController.addListener(() {
      setState(() => _scavengeProgress = _scavengeController.value);
    });

    // 開機序列
    _bootTimer = Timer.periodic(const Duration(milliseconds: 350), (timer) {
      if (_bootLine >= _bootLines.length) {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() => _bootComplete = true);
            _bootController.forward();
          }
        });
        return;
      }
      setState(() => _bootLine++);
    });
  }

  @override
  void dispose() {
    _bootTimer?.cancel();
    _timer?.cancel();
    _bootController.dispose();
    _scavengeController.dispose();
    _scavengeScrollController.dispose();
    super.dispose();
  }

  // === 計時器功能 ===
  void _startTimer() {
    _elapsedMs = 0;
    _isRunning = true;
    _timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      setState(() => _elapsedMs += 10);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _elapsedMs = 0;
    });
  }

  String _formatTime(int ms) {
    final mins = (ms ~/ 60000).toString().padLeft(2, '0');
    final secs = ((ms % 60000) ~/ 1000).toString().padLeft(2, '0');
    final millis = ((ms % 1000) ~/ 10).toString().padLeft(2, '0');
    return '$mins:$secs.$millis';
  }

  // === 導航路徑計算 ===
  List<Level> _calculatePath(Level from, Level to) {
    // 簡易 BFS 路徑搜尋
    final levels = BackroomsData.levels;
    final graph = <int, Set<int>>{};

    for (final level in levels) {
      graph[level.id] ??= {};
      final allText = [...level.exitMethods, ...level.accessMethods].join(' ');
      final regex = RegExp(r'Level\s+(\d+)');
      for (final match in regex.allMatches(allText)) {
        final targetId = int.tryParse(match.group(1) ?? '');
        if (targetId != null && targetId != level.id) {
          graph[level.id]!.add(targetId);
          graph[targetId] ??= {};
          graph[targetId]!.add(level.id);
        }
      }
    }

    // BFS
    final visited = <int>{from.id};
    final queue = <List<int>>[
      [from.id],
    ];

    while (queue.isNotEmpty) {
      final path = queue.removeAt(0);
      final current = path.last;
      if (current == to.id) {
        return path.map((id) => levels.firstWhere((l) => l.id == id)).toList();
      }
      for (final neighbor in graph[current] ?? <int>{}) {
        if (!visited.contains(neighbor)) {
          visited.add(neighbor);
          queue.add([...path, neighbor]);
        }
      }
    }

    // 找不到路時直接返回起終點
    return [from, to];
  }

  // === 收刮邏輯 ===
  void _addScavengeLog(String text) {
    if (mounted) {
      setState(() {
        _scavengeLogs.add('[${DateTime.now().toString().split(' ').last.substring(0, 8)}] $text');
      });
      // 自動捲動到底部
      Future.delayed(const Duration(milliseconds: 50), () {
        if (_scavengeScrollController.hasClients) {
          _scavengeScrollController.animateTo(
            _scavengeScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  Future<void> _performScavenge() async {
    if (_isScavenging) return;

    setState(() {
      _isScavenging = true;
      _scavengeProgress = 0.0;
      _scavengeLogs.clear();
      _lastScavengeResult = null;
    });

    _addScavengeLog('初始化空間頻譜掃描器...');
    await Future.delayed(const Duration(milliseconds: 600));
    _addScavengeLog('正在偵測局部空間不穩定性...');
    
    // 開始計時 4 秒的探測動畫
    final scanFuture = _scavengeController.forward();

    // 在掃描期間非同步插入日誌（總計約耗時 3.5 秒）
    await Future.delayed(const Duration(milliseconds: 800));
    _addScavengeLog('掃描到異常微粒排列方式: ${_currentLevel?.name ?? "未知層級"}');
    await Future.delayed(const Duration(milliseconds: 1000));
    _addScavengeLog('正在解析高能反應信號源...');
    await Future.delayed(const Duration(milliseconds: 1000));
    _addScavengeLog('嘗試提取空間物資快照...');

    // 確保動畫完全結束
    await scanFuture;

    if (mounted) {
      setState(() {
        _isScavenging = false;
        _scavengeController.reset();

        // 隨機結果：70% 成功，30% 失敗
        if (_random.nextDouble() > 0.3) {
          final objects = BackroomsData.objects;
          _lastScavengeResult = objects[_random.nextInt(objects.length)];
          _addScavengeLog('>>> 掃描成功：尋獲物資 【${_lastScavengeResult!.name}】');
          _addScavengeLog('正在將物資數據化並傳輸至生存包...');
          InventoryManager.instance.addItem(_lastScavengeResult!.id);
        } else {
          _addScavengeLog('>>> 掃描結束：未偵測到有價值的物資。');
          _addScavengeLog('警告：該區域資源可能已枯竭。');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _TermColors.bg,
      body: SafeArea(
        child: _bootComplete ? _buildTerminal() : _buildBootScreen(),
      ),
    );
  }

  // === 開機畫面 ===
  Widget _buildBootScreen() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          // Logo
          Center(child: Text('⚡', style: const TextStyle(fontSize: 48))),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'SPEED NOCLIP TERMINAL',
              style: GoogleFonts.spaceMono(
                color: _TermColors.accent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
          ),
          const SizedBox(height: 40),
          // 開機日誌
          ...List.generate(
            _bootLine,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Text(
                    '> ',
                    style: GoogleFonts.spaceMono(
                      color: _TermColors.green,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    _bootLines[i],
                    style: GoogleFonts.spaceMono(
                      color: i == _bootLines.length - 1
                          ? _TermColors.green
                          : _TermColors.textDim,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 閃爍游標
          if (_bootLine < _bootLines.length) _BlinkingCursor(),
        ],
      ),
    );
  }

  // === 主終端介面 ===
  Widget _buildTerminal() {
    return FadeTransition(
      opacity: _bootAnim,
      child: Column(
        children: [
          // 頂部標題列
          _buildHeader(),
          // Tab 選擇器
          _buildTabBar(),
          // 內容區
          Expanded(
            child: IndexedStack(
              index: _currentTab,
              children: [
                _buildLocateTab(),
                _buildNavigateTab(),
                _buildTimerTab(),
                _buildDatabaseTab(),
                _buildScavengeTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: _TermColors.panel,
        border: Border(bottom: BorderSide(color: _TermColors.border, width: 1)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: _TermColors.accent,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Text('⚡', style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '速切終端 C-49',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.spaceMono(
                    color: _TermColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'SPEED NOCLIP TERMINAL',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.spaceMono(
                    color: _TermColors.textDim,
                    fontSize: 8,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _TermColors.green.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _TermColors.green.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _TermColors.green,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'ONLINE',
                  style: GoogleFonts.spaceMono(
                    color: _TermColors.green,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // 生存包入口
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InventoryPage()),
            ),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _TermColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _TermColors.accent.withValues(alpha: 0.4)),
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                color: _TermColors.accent,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    const tabs = [
      ('定位', Icons.my_location),
      ('導航', Icons.route),
      ('計時', Icons.timer_outlined),
      ('資料庫', Icons.storage),
      ('收刮', Icons.search),
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _TermColors.bg,
        border: Border(bottom: BorderSide(color: _TermColors.border, width: 1)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: tabs.asMap().entries.map((entry) {
                    final i = entry.key;
                    final label = entry.value.$1;
                    final icon = entry.value.$2;
                    final selected = _currentTab == i;

                    return GestureDetector(
                      onTap: () => setState(() => _currentTab = i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: selected
                              ? _TermColors.accent.withValues(alpha: 0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              icon,
                              size: 18,
                              color: selected ? _TermColors.accent : _TermColors.textDim,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              label,
                              style: GoogleFonts.spaceMono(
                                color: selected ? _TermColors.accent : _TermColors.textDim,
                                fontSize: 10,
                                fontWeight:
                                    selected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // === Tab 1: 定位 ===
  Widget _buildLocateTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('當前位置'),
          const SizedBox(height: 12),
          // 下拉選擇目前層級
          _buildLevelSelector(
            label: '選擇所在層級',
            value: _currentLevel,
            onChanged: (l) => setState(() => _currentLevel = l),
          ),
          const SizedBox(height: 20),
          if (_currentLevel != null) ...[
            // 定位資訊面板
            _infoPanel(
              children: [
                _infoRow('層級', 'Level ${_currentLevel!.id}'),
                _infoRow('名稱', _currentLevel!.name),
                _infoRow('生存難度', _currentLevel!.classLabel),
                _infoRow('空間範圍', _currentLevel!.sizeDesc),
              ],
            ),
            const SizedBox(height: 16),
            // 實體偵測
            _sectionTitle('實體偵測'),
            const SizedBox(height: 8),
            if (_currentLevel!.entities.isEmpty)
              _infoPanel(
                children: [
                  _infoRow('狀態', '未偵測到實體活動', valueColor: _TermColors.green),
                ],
              )
            else
              ..._currentLevel!.entities.map((e) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _TermColors.red.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _TermColors.red.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: _TermColors.red,
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          e,
                          style: GoogleFonts.spaceMono(
                            color: _TermColors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '距離 ${_random.nextInt(500) + 50}m',
                        style: GoogleFonts.spaceMono(
                          color: _TermColors.textDim,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ],
      ),
    );
  }

  // === Tab 2: 導航 ===
  Widget _buildNavigateTab() {
    final path = (_currentLevel != null && _targetLevel != null)
        ? _calculatePath(_currentLevel!, _targetLevel!)
        : <Level>[];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('路徑規劃'),
          const SizedBox(height: 12),
          _buildLevelSelector(
            label: '起點層級',
            value: _currentLevel,
            onChanged: (l) => setState(() => _currentLevel = l),
          ),
          const SizedBox(height: 10),
          Center(
            child: Icon(
              Icons.arrow_downward,
              color: _TermColors.accent,
              size: 20,
            ),
          ),
          const SizedBox(height: 10),
          _buildLevelSelector(
            label: '目標層級',
            value: _targetLevel,
            onChanged: (l) => setState(() => _targetLevel = l),
          ),
          const SizedBox(height: 20),
          if (path.isNotEmpty) ...[
            _sectionTitle('建議路線'),
            const SizedBox(height: 8),
            _infoPanel(
              children: [
                _infoRow('途經層級數', '${path.length}'),
                _infoRow(
                  '預估距離',
                  '${path.length * 1200 + _random.nextInt(800)}m',
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 路線節點
            ...List.generate(path.length, (i) {
              final level = path[i];
              final isFirst = i == 0;
              final isLast = i == path.length - 1;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 連線指示器
                  SizedBox(
                    width: 30,
                    child: Column(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isFirst
                                ? _TermColors.accent
                                : isLast
                                ? _TermColors.green
                                : _TermColors.textDim,
                            border: Border.all(
                              color: isFirst
                                  ? _TermColors.accent
                                  : isLast
                                  ? _TermColors.green
                                  : _TermColors.textDim,
                              width: 2,
                            ),
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 36,
                            color: _TermColors.border,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 層級資訊
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LevelDetailPage(level: level),
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _TermColors.panel,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: _TermColors.border),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Lv.${level.id}',
                              style: GoogleFonts.spaceMono(
                                color: isFirst
                                    ? _TermColors.accent
                                    : isLast
                                    ? _TermColors.green
                                    : _TermColors.textPrimary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                level.name,
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: GoogleFonts.spaceMono(
                                  color: _TermColors.textPrimary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (isFirst || isLast) const SizedBox(width: 6),
                            if (isFirst)
                              _badge('起點', _TermColors.accent)
                            else if (isLast)
                              _badge('終點', _TermColors.green),
                            Icon(
                              Icons.chevron_right,
                              color: _TermColors.textDim,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ],
      ),
    );
  }

  // === Tab 3: 計時器 ===
  Widget _buildTimerTab() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '速切計時器',
              style: GoogleFonts.spaceMono(
                color: _TermColors.textDim,
                fontSize: 12,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 24),
            // 計時顯示
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              decoration: BoxDecoration(
                color: _TermColors.panel,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isRunning
                      ? _TermColors.green.withValues(alpha: 0.5)
                      : _TermColors.border,
                  width: 2,
                ),
                boxShadow: _isRunning
                    ? [
                        BoxShadow(
                          color: _TermColors.green.withValues(alpha: 0.1),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Text(
                _formatTime(_elapsedMs),
                style: GoogleFonts.spaceMono(
                  color: _isRunning
                      ? _TermColors.green
                      : _TermColors.textPrimary,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // 控制按鈕
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _termButton(
                  label: _isRunning ? '停止' : '開始',
                  icon: _isRunning ? Icons.stop : Icons.play_arrow,
                  color: _isRunning ? _TermColors.red : _TermColors.green,
                  onTap: _isRunning ? _stopTimer : _startTimer,
                ),
                const SizedBox(width: 16),
                _termButton(
                  label: '重置',
                  icon: Icons.refresh,
                  color: _TermColors.textDim,
                  onTap: _resetTimer,
                ),
              ],
            ),
            const SizedBox(height: 32),
            // 提示
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _TermColors.accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _TermColors.accent.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: _TermColors.accent, size: 14),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '選擇起點與終點後，按下「開始」即可記錄你的速切成績。',
                      style: TextStyle(
                        color: _TermColors.textDim,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === Tab 4: 資料庫 ===
  Widget _buildDatabaseTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('層級資料庫'),
          const SizedBox(height: 8),
          ...BackroomsData.levels.map((level) {
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LevelDetailPage(level: level),
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _TermColors.panel,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _TermColors.border),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Text(
                        '${level.id}',
                        style: GoogleFonts.spaceMono(
                          color: _TermColors.accent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            level.name,
                            style: TextStyle(
                              color: _TermColors.textPrimary,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            level.subtitle,
                            style: GoogleFonts.spaceMono(
                              color: _TermColors.textDim,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _badge(level.classLabel, _dangerColor(level.dangerLevel)),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.chevron_right,
                      color: _TermColors.textDim,
                      size: 16,
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          _sectionTitle('實體資料庫'),
          const SizedBox(height: 8),
          ...BackroomsData.entities.map((entity) {
            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _TermColors.panel,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: _TermColors.border),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber,
                    color: _dangerColor(entity.dangerLevel),
                    size: 16,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entity.name,
                          style: TextStyle(
                            color: _TermColors.textPrimary,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          entity.nameEn,
                          style: GoogleFonts.spaceMono(
                            color: _TermColors.textDim,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    entity.category,
                    style: TextStyle(color: _TermColors.textDim, fontSize: 10),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // === Tab 5: 收刮 ===
  Widget _buildScavengeTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('空間物資探測'),
          const SizedBox(height: 16),
          // 掃描狀態顯示
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _TermColors.panel,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isScavenging ? _TermColors.accent : _TermColors.border,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isScavenging ? '正在探測中...' : '系統就緒',
                      style: GoogleFonts.spaceMono(
                        color: _isScavenging ? _TermColors.accent : _TermColors.textDim,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${(_scavengeProgress * 100).toInt()}%',
                      style: GoogleFonts.spaceMono(
                        color: _TermColors.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // 進度條
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _scavengeProgress,
                    backgroundColor: _TermColors.bg,
                    valueColor: const AlwaysStoppedAnimation(_TermColors.accent),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 收刮結果（獲取物品時顯示）
          if (_lastScavengeResult != null)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _TermColors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _TermColors.green.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      _lastScavengeResult!.imageUrl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '獲取物資：${_lastScavengeResult!.name}',
                          style: const TextStyle(
                            color: _TermColors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '已自動存入生存包',
                          style: TextStyle(color: _TermColors.textDim, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          // 終端日誌區
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 0),
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _TermColors.border),
              ),
              child: _scavengeLogs.isEmpty
                  ? Center(
                      child: Text(
                        '等待探測指令...',
                        style: GoogleFonts.spaceMono(
                          color: _TermColors.textDim,
                          fontSize: 12,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scavengeScrollController,
                      itemCount: _scavengeLogs.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            _scavengeLogs[index],
                            style: GoogleFonts.spaceMono(
                              color: _TermColors.textDim,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(height: 16),
          // 按鈕
          SizedBox(
            width: double.infinity,
            child: _termButton(
              label: _isScavenging ? '掃描中...' : '開始空間收刮',
              icon: _isScavenging ? Icons.radar : Icons.search,
              color: _isScavenging ? _TermColors.textDim : _TermColors.accent,
              onTap: _isScavenging ? () {} : _performScavenge,
            ),
          ),
        ],
      ),
    );
  }

  // === 工具元件 ===
  Widget _buildLevelSelector({
    required String label,
    required Level? value,
    required ValueChanged<Level?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _TermColors.panel,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _TermColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Level>(
          value: value,
          isExpanded: true,
          hint: Text(
            label,
            style: TextStyle(color: _TermColors.textDim, fontSize: 13),
          ),
          dropdownColor: _TermColors.panel,
          icon: Icon(Icons.expand_more, color: _TermColors.accent, size: 20),
          items: BackroomsData.levels.map((level) {
            return DropdownMenuItem<Level>(
              value: level,
              child: Text(
                'Level ${level.id} — ${level.name}',
                style: GoogleFonts.spaceMono(
                  color: _TermColors.textPrimary,
                  fontSize: 12,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Row(
      children: [
        Container(width: 3, height: 14, color: _TermColors.accent),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.spaceMono(
            color: _TermColors.accent,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _infoPanel({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _TermColors.panel,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _TermColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.spaceMono(
              color: _TermColors.textDim,
              fontSize: 11,
            ),
          ),
          const SizedBox(width: 12),
          const Spacer(),
          Flexible(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.spaceMono(
                color: valueColor ?? _TermColors.textPrimary,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: GoogleFonts.spaceMono(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _termButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.spaceMono(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _dangerColor(String level) {
    switch (level) {
      case 'class0':
        return const Color(0xFFF7E375);
      case 'class1':
        return const Color(0xFFFFC90E);
      case 'class2':
        return const Color(0xFFF59C00);
      case 'class3':
        return const Color(0xFFF95A00);
      case 'class4':
        return _TermColors.red;
      case 'class5':
        return const Color(0xFFAF0606);
      case 'deadzone':
        return const Color(0xFFFF4444);
      case 'habitable':
        return _TermColors.green;
      case 'pending':
        return const Color(0xFFB6B6B6);
      default:
        return _TermColors.textDim;
    }
  }
}

/// 閃爍游標
class _BlinkingCursor extends StatefulWidget {
  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _controller.value,
          child: Text(
            '█',
            style: GoogleFonts.spaceMono(
              color: _TermColors.green,
              fontSize: 12,
            ),
          ),
        );
      },
    );
  }
}
