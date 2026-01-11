import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

FlutterLocalNotificationsPlugin notifications = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  const initSettings = InitializationSettings(
    android: androidSettings, 
    iOS: iosSettings,
  );
  
  await notifications.initialize(initSettings);
  
  // 启动闹钟检查服务
  AlarmService().initialize();
  
  runApp(const TimeDisplayApp());
}

class TimeDisplayApp extends StatelessWidget {
  const TimeDisplayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '智能时钟',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const MainScreen(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'CN'),
        Locale('en', 'US'),
      ],
      locale: const Locale('zh', 'CN'),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ClockScreen(),
    const AlarmScreen(),
    const StopwatchScreen(),
    const TimerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.access_time),
            label: '时钟',
          ),
          NavigationDestination(
            icon: Icon(Icons.alarm),
            label: '闹钟',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer),
            label: '秒表',
          ),
          NavigationDestination(
            icon: Icon(Icons.hourglass_empty),
            label: '计时器',
          ),
        ],
      ),
    );
  }
}

// 时钟屏幕
class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  late String _currentTime;
  late String _currentDate;
  late String _period;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime = _formatTime(now);
      _currentDate = _formatDate(now);
      _period = now.hour >= 12 ? '下午' : '上午';
    });
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12;
    final displayHour = hour == 0 ? 12 : hour;
    return '${displayHour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime dateTime) {
    const months = [
      '1月', '2月', '3月', '4月', '5月', '6月',
      '7月', '8月', '9月', '10月', '11月', '12月'
    ];
    const weekdays = [
      '星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'
    ];
    
    return '${dateTime.year}年${months[dateTime.month - 1]}${dateTime.day}日 ${weekdays[dateTime.weekday - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
            ? [const Color(0xFF1a1a2e), const Color(0xFF16213e)]
            : [const Color(0xFF667eea), const Color(0xFF764ba2)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isDark
                      ? [Colors.purple.shade400, Colors.blue.shade400]
                      : [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.purple.withOpacity(0.3) : Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.access_time_rounded,
                  size: 120,
                  color: isDark ? Colors.white : Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentTime,
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.w300,
                      color: isDark ? Colors.white : Colors.white,
                      letterSpacing: 8,
                      shadows: [
                        Shadow(
                          color: isDark ? Colors.purple.withOpacity(0.5) : Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 8),
                    child: Text(
                      _period,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w200,
                        color: isDark ? Colors.white70 : Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _currentDate,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: isDark ? Colors.white : Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 闹钟服务
class AlarmService {
  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  AlarmService._internal();

  List<Map<String, dynamic>> _alarms = [];
  bool _initialized = false;
  Timer? _checkTimer;

  void initialize() {
    if (!_initialized) {
      _loadAlarms();
      _startAlarmCheck();
      _initialized = true;
    }
  }

  Future<void> _loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsJson = prefs.getString('alarms');
    if (alarmsJson != null) {
      _alarms = List<Map<String, dynamic>>.from(
        json.decode(alarmsJson).map((item) => Map<String, dynamic>.from(item))
      );
    }
  }

  Future<void> _saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('alarms', json.encode(_alarms));
  }

  Future<void> addAlarm(String time, bool enabled) async {
    _alarms.add({
      'time': time,
      'enabled': enabled,
      'label': '闹钟',
      'notified': false,
    });
    await _saveAlarms();
  }

  Future<void> toggleAlarm(int index) async {
    _alarms[index]['enabled'] = !_alarms[index]['enabled'];
    _alarms[index]['notified'] = false;
    await _saveAlarms();
  }

  Future<void> deleteAlarm(int index) async {
    _alarms.removeAt(index);
    await _saveAlarms();
  }

  List<Map<String, dynamic>> getAlarms() {
    return List.from(_alarms);
  }

  void _startAlarmCheck() {
    _checkTimer?.cancel();
    _checkTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkAlarms();
    });
  }

  Future<void> _checkAlarms() async {
    final now = DateTime.now();
    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final currentSecond = now.second;

    for (var i = 0; i < _alarms.length; i++) {
      final alarm = _alarms[i];
      final alarmTime = alarm['time'] as String;
      
      // 检查是否到了闹钟时间，并且还没有通知过
      if (alarm['enabled'] == true && 
          alarmTime == currentTime && 
          !alarm['notified'] && 
          currentSecond == 0) {
        
        await _showNotification(alarmTime);
        alarm['notified'] = true;
        await _saveAlarms();
      } 
      // 如果时间改变了，重置通知状态
      else if (alarmTime != currentTime) {
        if (alarm['notified'] == true) {
          alarm['notified'] = false;
          await _saveAlarms();
        }
      }
    }
  }

  Future<void> _showNotification(String time) async {
    const androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      '闹钟提醒',
      channelDescription: '闹钟提醒通知渠道',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );
    
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      '⏰ 闹钟提醒',
      '您设置的 $time 闹钟时间到了！',
      notificationDetails,
    );
  }
}

// 闹钟屏幕
class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final AlarmService _alarmService = AlarmService();
  List<Map<String, dynamic>> _alarms = [];

  @override
  void initState() {
    super.initState();
    _loadAlarms();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadAlarms() async {
    setState(() {
      _alarms = _alarmService.getAlarms();
    });
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Theme.of(context).brightness,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _alarms.add({
          'time': '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}',
          'enabled': true,
          'label': '闹钟',
          'notified': false,
        });
      });
      
      await _alarmService.addAlarm(
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}',
        true
      );
    }
  }

  Future<void> _toggleAlarm(int index) async {
    await _alarmService.toggleAlarm(index);
    setState(() {
      _alarms = _alarmService.getAlarms();
    });
  }

  Future<void> _deleteAlarm(int index) async {
    await _alarmService.deleteAlarm(index);
    setState(() {
      _alarms = _alarmService.getAlarms();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('闹钟'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _alarms.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.alarm_off,
                  size: 80,
                  color: isDark ? Colors.white24 : Colors.black26,
                ),
                const SizedBox(height: 16),
                Text(
                  '暂无闹钟',
                  style: TextStyle(
                    fontSize: 18,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '点击右下角添加闹钟',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _alarms.length,
            itemBuilder: (context, index) {
              final alarm = _alarms[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Switch(
                    value: alarm['enabled'],
                    onChanged: (_) => _toggleAlarm(index),
                    activeColor: Colors.deepPurple,
                  ),
                  title: Text(
                    alarm['time'],
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                      color: alarm['enabled'] ? null : Colors.grey,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _deleteAlarm(index),
                  ),
                ),
              );
            },
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickTime,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// 秒表屏幕
class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  final List<String> _laps = [];
  static const String _stopwatchKey = 'stopwatch_data';
  int _savedElapsed = 0; // 保存的经过时间（毫秒）
  DateTime? _lastStartTime; // 最后开始时间

  @override
  void initState() {
    super.initState();
    _loadStopwatchData();
  }

  Future<void> _loadStopwatchData() async {
    final prefs = await SharedPreferences.getInstance();
    final stopwatchJson = prefs.getString(_stopwatchKey);
    if (stopwatchJson != null) {
      final data = json.decode(stopwatchJson);
      setState(() {
        _savedElapsed = data['elapsed'] ?? 0;
        _laps.clear();
        if (data['laps'] != null) {
          _laps.addAll(List<String>.from(data['laps']));
        }
        
        // 如果秒表正在运行，恢复计时状态
        if (data['running'] == true && _savedElapsed > 0) {
          _lastStartTime = DateTime.now();
          _stopwatch = Stopwatch()..start();
          _startUITimer();
        }
      });
    }
  }

  Future<void> _saveStopwatchData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'elapsed': _getCurrentElapsed(),
      'laps': _laps,
      'running': _stopwatch.isRunning,
    };
    await prefs.setString(_stopwatchKey, json.encode(data));
  }

  // 获取当前总经过时间
  int _getCurrentElapsed() {
    if (!_stopwatch.isRunning) {
      return _savedElapsed;
    }
    
    if (_lastStartTime != null) {
      return _savedElapsed + DateTime.now().difference(_lastStartTime!).inMilliseconds;
    }
    return _stopwatch.elapsedMilliseconds;
  }

  void _startStopwatch() {
    setState(() {
      if (_stopwatch.isRunning) return;
      
      _lastStartTime = DateTime.now();
      _stopwatch.start();
      _startUITimer();
      _saveStopwatchData();
    });
  }

  void _startUITimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {});
      // 每5秒保存一次状态
      if (_stopwatch.elapsedMilliseconds % 5000 < 10) {
        _saveStopwatchData();
      }
    });
  }

  void _stopStopwatch() {
    setState(() {
      _savedElapsed = _getCurrentElapsed();
      _stopwatch.stop();
      _timer?.cancel();
      _lastStartTime = null;
      _saveStopwatchData();
    });
  }

  void _resetStopwatch() {
    setState(() {
      _savedElapsed = 0;
      _stopwatch.reset();
      _laps.clear();
      _timer?.cancel();
      _lastStartTime = null;
    });
    _saveStopwatchData();
  }

  void _addLap() {
    if (_stopwatch.isRunning || _savedElapsed > 0) {
      setState(() {
        _laps.insert(0, _formatTime(_displayElapsed));
        _saveStopwatchData();
      });
    }
  }

  String _formatTime(int milliseconds) {
    final hours = milliseconds ~/ (1000 * 60 * 60);
    final minutes = (milliseconds ~/ (1000 * 60)) % 60;
    final seconds = (milliseconds ~/ 1000) % 60;
    final ms = (milliseconds % 1000) ~/ 10;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${ms.toString().padLeft(2, '0')}';
    }
  }

  // 获取显示的时间
  int get _displayElapsed {
    if (!_stopwatch.isRunning) {
      return _savedElapsed;
    }
    return _getCurrentElapsed();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('秒表'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isDark
                    ? [Colors.purple.shade400, Colors.blue.shade400]
                    : [Colors.deepPurple.shade100, Colors.blue.shade100],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Text(
                _formatTime(_displayElapsed),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w200,
                  color: isDark ? Colors.white : Colors.deepPurple.shade900,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_stopwatch.isRunning && _savedElapsed == 0)
                  ElevatedButton(
                    onPressed: _startStopwatch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.play_arrow, size: 32),
                  )
                else if (_stopwatch.isRunning)
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _addLap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: const CircleBorder(),
                        ),
                        child: const Icon(Icons.flag, size: 24),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _stopStopwatch,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: const CircleBorder(),
                        ),
                        child: const Icon(Icons.pause, size: 32),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _resetStopwatch,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: const CircleBorder(),
                        ),
                        child: const Icon(Icons.refresh, size: 24),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _startStopwatch,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: const CircleBorder(),
                        ),
                        child: const Icon(Icons.play_arrow, size: 32),
                      ),
                    ],
                  ),
              ],
            ),
            if (_laps.isNotEmpty) ...[
              const SizedBox(height: 40),
              const Text(
                '计次',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _laps.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        '计次 ${_laps.length - index}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        _laps[index],
                        style: const TextStyle(fontSize: 18, fontFamily: 'monospace'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// 计时器屏幕
class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Duration _selectedDuration = Duration.zero;
  Duration _remainingDuration = Duration.zero;
  Timer? _timer;
  bool _isRunning = false;
  static const String _timerKey = 'timer_data';

  @override
  void initState() {
    super.initState();
    _loadTimerData();
  }

  Future<void> _loadTimerData() async {
    final prefs = await SharedPreferences.getInstance();
    final timerJson = prefs.getString(_timerKey);
    if (timerJson != null) {
      final data = json.decode(timerJson);
      if (data['selected'] != null && data['remaining'] != null) {
        final lastSavedTime = data['lastSavedTime'] as int?;
        final now = DateTime.now().millisecondsSinceEpoch;
        
        setState(() {
          _selectedDuration = Duration(seconds: data['selected']);
          _isRunning = data['running'] ?? false;
          
          if (_isRunning && _remainingDuration.inSeconds > 0) {
            // 计算从上次保存到现在经过的时间
            if (lastSavedTime != null) {
              final elapsedSeconds = (now - lastSavedTime) ~/ 1000;
              _remainingDuration = Duration(seconds: data['remaining']) - Duration(seconds: elapsedSeconds);
              
              // 如果时间已经过了，重置为0
              if (_remainingDuration.inSeconds <= 0) {
                _remainingDuration = Duration.zero;
                _isRunning = false;
              } else {
                // 重新启动计时器
                _startTimer(false);
              }
            } else {
              _remainingDuration = Duration(seconds: data['remaining']);
              if (_remainingDuration.inSeconds > 0) {
                _startTimer(false);
              }
            }
          } else {
            _remainingDuration = Duration(seconds: data['remaining']);
          }
        });
      }
    }
  }

  Future<void> _saveTimerData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'selected': _selectedDuration.inSeconds,
      'remaining': _remainingDuration.inSeconds,
      'running': _isRunning,
      'lastSavedTime': DateTime.now().millisecondsSinceEpoch,
    };
    await prefs.setString(_timerKey, json.encode(data));
  }

  Future<void> _pickDuration() async {
    final result = await showDialog<Duration>(
      context: context,
      builder: (context) => const DurationPickerDialog(),
    );

    if (result != null && result.inSeconds > 0) {
      setState(() {
        _selectedDuration = result;
        _remainingDuration = result;
      });
      await _saveTimerData();
    }
  }

  void _startTimer(bool saveData) {
    setState(() {
      _isRunning = true;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingDuration.inSeconds <= 0) {
        _timer?.cancel();
        setState(() {
          _isRunning = false;
          _remainingDuration = Duration.zero;
        });
        _showTimerCompleteDialog();
        _saveTimerData();
      } else {
        setState(() {
          _remainingDuration -= const Duration(seconds: 1);
        });
        if (saveData) {
          _saveTimerData();
        }
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
    _saveTimerData();
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingDuration = _selectedDuration;
    });
    _saveTimerData();
  }

  void _showTimerCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('计时完成！'),
        content: const Text('您设置的计时器已结束。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('计时器'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_selectedDuration == Duration.zero)
              Column(
                children: [
                  Icon(
                    Icons.hourglass_empty,
                    size: 80,
                    color: isDark ? Colors.white24 : Colors.black26,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '设置计时器',
                    style: TextStyle(
                      fontSize: 18,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isDark
                          ? [Colors.purple.shade400, Colors.blue.shade400]
                          : [Colors.deepPurple.shade100, Colors.blue.shade100],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _formatDuration(_remainingDuration),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w200,
                          color: isDark ? Colors.white : Colors.deepPurple.shade900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!_isRunning && _remainingDuration.inSeconds > 0)
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: _resetTimer,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                shape: const CircleBorder(),
                              ),
                              child: const Icon(Icons.refresh, size: 24),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () => _startTimer(true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                shape: const CircleBorder(),
                              ),
                              child: const Icon(Icons.play_arrow, size: 32),
                            ),
                          ],
                        )
                      else if (_isRunning)
                        ElevatedButton(
                          onPressed: _pauseTimer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: const CircleBorder(),
                          ),
                          child: const Icon(Icons.pause, size: 32),
                        )
                      else
                        ElevatedButton(
                          onPressed: _pickDuration,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: const CircleBorder(),
                          ),
                          child: const Icon(Icons.add, size: 32),
                        ),
                    ],
                  ),
                ],
              ),
            if (_selectedDuration == Duration.zero)
              const SizedBox(height: 40),
            if (_selectedDuration == Duration.zero)
              ElevatedButton.icon(
                onPressed: _pickDuration,
                icon: const Icon(Icons.add),
                label: const Text('添加计时器'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// 时间选择对话框
class DurationPickerDialog extends StatefulWidget {
  const DurationPickerDialog({super.key});

  @override
  State<DurationPickerDialog> createState() => _DurationPickerDialogState();
}

class _DurationPickerDialogState extends State<DurationPickerDialog> {
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('设置计时器'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimePicker('小时', _hours, (value) => setState(() => _hours = value), 23),
              _buildTimePicker('分钟', _minutes, (value) => setState(() => _minutes = value), 59),
              _buildTimePicker('秒', _seconds, (value) => setState(() => _seconds = value), 59),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () {
            final duration = Duration(
              hours: _hours,
              minutes: _minutes,
              seconds: _seconds,
            );
            Navigator.pop(context, duration);
          },
          child: const Text('开始'),
        ),
      ],
    );
  }

  Widget _buildTimePicker(String label, int value, Function(int) onChanged, int maxValue) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepPurple),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListWheelScrollView.useDelegate(
            itemExtent: 40,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: onChanged,
            controller: FixedExtentScrollController(initialItem: value),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: maxValue + 1,
              builder: (context, index) {
                return Center(
                  child: Text(
                    index.toString().padLeft(2, '0'),
                    style: const TextStyle(fontSize: 24),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}