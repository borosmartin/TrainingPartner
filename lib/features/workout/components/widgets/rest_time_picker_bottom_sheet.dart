import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:training_partner/core/constants/component_constants.dart';
import 'package:training_partner/core/utils/date_time_util.dart';
import 'package:training_partner/core/utils/text_util.dart';

class RestTimePickerBottomSheet extends StatefulWidget {
  final void Function(int) onRestTimeChanged;

  const RestTimePickerBottomSheet({super.key, required this.onRestTimeChanged});

  @override
  State<RestTimePickerBottomSheet> createState() => _RestTimePickerBottomSheetState();
}

class _RestTimePickerBottomSheetState extends State<RestTimePickerBottomSheet> {
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
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setBottomSheetState) {
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
              _getBodyContent(setBottomSheetState),
            ],
          ),
        );
      },
    );
  }

  Widget _getBodyContent(StateSetter setBottomSheetState) {
    return Column(
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
    );
  }

  void _startTimer(StateSetter setBottomSheetState) {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }

    _restSeconds--;

    setBottomSheetState(() {
      _isTimerRunning = true;
      _isPaused = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    setBottomSheetState(() {
      if (_timer!.isActive) {
        _timer!.cancel();
        _isTimerRunning = false;
        _isPaused = true;
      }
    });
  }
}
