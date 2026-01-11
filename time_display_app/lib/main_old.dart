import 'package:flutter/material.dart';
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
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
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
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      _period,
                      style: TextStyle(
                        fontSize: 32,
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

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  List<Map<String, dynamic>> _alarms = [];

  @override
  void initState() {
    super.initState();
    _loadAlarms();
  }

  Future<void> _loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsJson = prefs.getString('alarms');
    if (alarmsJson != null) {
      setState(() {
        _alarms = List<Map<String, dynamic>>.from(
          json.decode(alarmsJson).map((item) => Map<String, dynamic>.from(item))
        );
      });
    }
  }

  Future<void> _saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('alarms', json.encode(_alarms));
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
          'label': 'Alarm',
        });
      });
      await _saveAlarms();
    }
  }

  Future<void> _toggleAlarm(int index) async {
    setState(() {
      _alarms[index]['enabled'] = !_alarms[index]['enabled'];
    });
    await _saveAlarms();
  }

  Future<void> _deleteAlarm(int index) async {
    setState(() {
      _alarms.removeAt(index);
    });
    await _saveAlarms();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarms'),
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
                  'No alarms set',
                  style: TextStyle(
                    fontSize: 18,
                    color: isDark ? Colors.white60 : Colors.black54,
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

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  final List<String> _laps = [];

  void _startStopwatch() {
    setState(() {
      _stopwatch.start();
      _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        setState(() {});
      });
    });
  }

  void _stopStopwatch() {
    setState(() {
      _stopwatch.stop();
      _timer?.cancel();
    });
  }

  void _resetStopwatch() {
    setState(() {
      _stopwatch.reset();
      _laps.clear();
      _timer?.cancel();
    });
  }

  void _addLap() {
    if (_stopwatch.isRunning) {
      setState(() {
        _laps.insert(0, _formatTime(_stopwatch.elapsedMilliseconds));
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
        title: const Text('Stopwatch'),
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
                _formatTime(_stopwatch.elapsedMilliseconds),
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w200,
                  color: isDark ? Colors.white : Colors.deepPurple.shade900,
                ),
              ),
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_stopwatch.isRunning && _stopwatch.elapsedMilliseconds == 0)
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
                'Laps',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _laps.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        'Lap ${_laps.length - index}',
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

  Future<void> _pickDuration() async {
    final result = await showDialog<Duration>(
      context: context,
      builder: (context) => const DurationPickerDialog(),
    );

    if (result != null) {
      setState(() {
        _selectedDuration = result;
        _remainingDuration = result;
      });
    }
  }

  void _startTimer() {
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
      } else {
        setState(() {
          _remainingDuration -= const Duration(seconds: 1);
        });
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingDuration = _selectedDuration;
    });
  }

  void _showTimerCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Timer Complete!'),
        content: const Text('Your timer has finished.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
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
        title: const Text('Timer'),
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
                    'Set a timer',
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
                  const SizedBox(height: 60),
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
                              onPressed: _startTimer,
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
              const SizedBox(height: 60),
            if (_selectedDuration == Duration.zero)
              ElevatedButton.icon(
                onPressed: _pickDuration,
                icon: const Icon(Icons.add),
                label: const Text('Add Timer'),
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
      title: const Text('Set Timer'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimePicker('Hours', _hours, (value) => setState(() => _hours = value), 23),
              _buildTimePicker('Minutes', _minutes, (value) => setState(() => _minutes = value), 59),
              _buildTimePicker('Seconds', _seconds, (value) => setState(() => _seconds = value), 59),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
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
          child: const Text('Start'),
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
