import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cronómetro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.compact,
      ),
      debugShowCheckedModeBanner: false,
      home: const WatchScreen(),
    );
  }
}

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WatchShape(
      builder: (context, shape, child) {
        return AmbientMode(
          builder: (context, mode, child) {
            return TimerScreen(
                mode: mode); // Pasar el modo al constructor de TimerScreen
          },
        );
      },
    );
  }
}

class TimerScreen extends StatefulWidget {
  final WearMode mode;

  const TimerScreen({required this.mode, super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer;
  late int _count;
  late String _strCount;
  late bool _isRunning;

  @override
  void initState() {
    _count = 0;
    _strCount = "00:00.00";
    _isRunning = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = widget.mode == WearMode.active
        ? const Color.fromARGB(255, 255, 255, 255)
        : Color.fromARGB(255, 0, 0, 0)!;
    return Scaffold(
      backgroundColor: widget.mode == WearMode.active
          ? Color.fromARGB(255, 17, 5, 98)
          : Color.fromARGB(255, 247, 233, 255)!,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Cronómetro",
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: textColor),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10.0),
            Center(
              child: Text(
                _strCount,
                style: TextStyle(
                  fontSize: 24.0,
                  color: widget.mode == WearMode.active
                      ? Color.fromARGB(255, 255, 255, 0)
                      : Color.fromARGB(255, 0, 0, 0)!,
                  fontFamily: 'Courier',
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            if (widget.mode == WearMode.active) _buildWidgetButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            if (_isRunning) {
              _stopTimer();
            } else {
              _startTimer();
            }
          },
          child: Icon(
            _isRunning ? Icons.pause : Icons.play_arrow,
            color: const Color.fromARGB(255, 255, 255, 255),
            size: 40.0,
          ),
        ),
        const SizedBox(width: 10.0),
        GestureDetector(
          onTap: _resetTimer,
          child: Icon(
            Icons.stop,
            color: const Color.fromARGB(255, 255, 255, 255),
            size: 40.0,
          ),
        ),
      ],
    );
  }

  void _startTimer() {
    _isRunning = true;
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        _count += 1;
        int minutes = _count ~/ 6000;
        int seconds = (_count ~/ 100) % 60;
        int milliseconds = _count % 100;
        _strCount =
            "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${milliseconds.toString().padLeft(2, '0')}";
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer.cancel();
    setState(() {
      _count = 0;
      _strCount = "00:00.00";
      _isRunning = false;
    });
  }
}
