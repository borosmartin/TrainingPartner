import 'dart:async';

import 'package:flutter/material.dart';
import 'package:training_partner/core/constants/component_constants.dart';

class TimeCounterWidget extends StatefulWidget {
  const TimeCounterWidget({super.key});

  @override
  State<TimeCounterWidget> createState() => _TimeCounterWidgetState();
}

class _TimeCounterWidgetState extends State<TimeCounterWidget> {
  late Timer _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();

    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatTime(_seconds),
      style: boldLargeBlack,
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds ~/ 60) % 60;
    final remainingSeconds = seconds % 60;

    String hoursStr = (hours > 0) ? '${hours.toString().padLeft(2, '0')}:' : '';
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$hoursStr$minutesStr:$secondsStr';
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }
}
