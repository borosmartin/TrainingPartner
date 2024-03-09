import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/utils/date_time_util.dart';
import 'package:training_partner/core/utils/text_util.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer? _timer;
  int _restSeconds = 0;
  bool _isTimerRunning = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();

    _restSeconds = 60;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.tertiary,
      elevation: 0,
      shape: defaultCornerShape,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => _showRestTimePickerBottomSheet(context),
        borderRadius: defaultBorderRadius,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: _isTimerRunning || _isPaused
              ? Text(DateTimeUtil.secondsToDigitalFormat(_restSeconds), style: boldNormalWhite)
              : const Icon(Icons.timer_rounded, color: Colors.white),
        ),
      ),
    );
  }

  void _showRestTimePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setBottomSheetState) {
            return _getBottomSheetBody(setBottomSheetState);
          },
        );
      },
    );
  }

  Widget _getBottomSheetBody(StateSetter setBottomSheetState) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Card(
            elevation: 0,
            color: Colors.black26,
            child: SizedBox(height: 5, width: 80),
          ),
          const SizedBox(height: 20),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                elevation: 0,
                color: Colors.white,
                shape: defaultCornerShape,
                margin: const EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Iconsax.backward_15_seconds, size: 35),
                        onPressed: _restSeconds > 15 && !_isTimerRunning
                            ? () {
                                setBottomSheetState(() {
                                  _restSeconds -= 15;
                                  if (_restSeconds < 0) {
                                    _restSeconds = 0;
                                  }
                                });
                              }
                            : null,
                      ),
                      const SizedBox(width: 30),
                      Text(
                        DateTimeUtil.secondsToDigitalFormat(_restSeconds),
                        style: TextUtil.getCustomTextStyle(fontSize: 45, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                      const SizedBox(width: 30),
                      IconButton(
                        icon: const Icon(Iconsax.forward_15_seconds, size: 35),
                        onPressed: !_isTimerRunning
                            ? () {
                                setBottomSheetState(() {
                                  _restSeconds += 15;
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _isTimerRunning
                      ? IconButton(icon: const Icon(Iconsax.pause, size: 35), onPressed: () => _pauseTimer(setBottomSheetState))
                      : _restSeconds != 0
                          ? IconButton(icon: const Icon(Iconsax.play, size: 35), onPressed: () => _startTimer(setBottomSheetState))
                          : Container(),
                  if (_isTimerRunning || _isPaused || _restSeconds == 0)
                    IconButton(icon: const Icon(Icons.restore_rounded, size: 35), onPressed: () => _stopTimer(setBottomSheetState))
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _startTimer(StateSetter setBottomSheetState) {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    _restSeconds--;

    setState(() {
      _isTimerRunning = true;
      _isPaused = false;
    });

    setBottomSheetState(() {
      _isTimerRunning = true;
      _isPaused = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_restSeconds == 0) {
          timer.cancel();
          _isTimerRunning = false;
        } else {
          _restSeconds--;
        }
      });

      setBottomSheetState(() {
        if (_restSeconds == 0) {
          timer.cancel();
          _isTimerRunning = false;
        } else {
          _restSeconds--;
        }
      });
    });
  }

  void _stopTimer(StateSetter setBottomSheetState) {
    setState(() {
      if (_timer!.isActive) {
        _timer!.cancel();
      }

      _isPaused = false;
      _isTimerRunning = false;
      _restSeconds = 60;
    });

    setBottomSheetState(() {
      if (_timer!.isActive) {
        _timer!.cancel();
      }

      _isPaused = false;
      _isTimerRunning = false;
      _restSeconds = 60;
    });
  }

  void _pauseTimer(StateSetter setBottomSheetState) {
    setState(() {
      if (_timer!.isActive) {
        _timer!.cancel();
        _isTimerRunning = false;
        _isPaused = true;
      }
    });

    setBottomSheetState(() {
      if (_timer!.isActive) {
        _timer!.cancel();
        _isTimerRunning = false;
        _isPaused = true;
      }
    });
  }
}
