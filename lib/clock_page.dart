import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_browser.dart';
import 'package:kindle_clock/clock_config.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  late DateFormat _secondsTimeFormat;
  late DateFormat _minutesTimeFormat;
  late DateFormat _dateFormat;
  final _config = ClockConfig();

  get _timeFormat =>
      _config.isSecondsMode ? _secondsTimeFormat : _minutesTimeFormat;

  int _currentTime = 0;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _calibrationTimer();
  }

  @override
  Widget build(BuildContext context) {
    final timeContent = _currentTime == 0
        ? ""
        : _timeFormat.format(DateTime.fromMillisecondsSinceEpoch(_currentTime));
    final dateContent = _currentTime == 0
        ? ""
        : _dateFormat.format(DateTime.fromMillisecondsSinceEpoch(_currentTime));
    return Scaffold(
      body: RotatedBox(
        quarterTurns: _config.quarterTurns,
        child: Stack(
          children: [
            Center(
              child: Text(
                timeContent,
                style: Theme.of(context).textTheme.headline1?.copyWith(
                      fontFamily: 'RobotoMono',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  dateContent,
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _config.rotate();
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.all(24),
                  child: Icon(
                    Icons.rotate_right,
                    color: Colors.black,
                    size: 48,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color:
                            _config.isSecondsMode ? Colors.black : Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'Seconds',
                            style:
                                Theme.of(context).textTheme.headline5?.copyWith(
                                      color: _config.isSecondsMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _config.secondsMode();
                          });
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color:
                            _config.isSecondsMode ? Colors.white : Colors.black,
                        border: Border.all(color: Colors.black),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'Minutes',
                            style:
                                Theme.of(context).textTheme.headline5?.copyWith(
                                      color: _config.isSecondsMode
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _config.minutesMode();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  void _calibrationTimer() {
    final time = DateTime.now().millisecondsSinceEpoch;
    if (time % 1000 != 0) {
      final delay = 1000 - (time % 1000);
      Future.delayed(Duration(milliseconds: delay), () async {
        Intl.systemLocale = await findSystemLocale();
        _dateFormat = DateFormat.MMMMEEEEd();
        _secondsTimeFormat = DateFormat.Hms();
        _minutesTimeFormat = DateFormat.Hm();
        setState(() {
          _currentTime = time + delay;
        });
        Timer.periodic(const Duration(seconds: 1), (timer) {
          _timer ??= timer;
          setState(() {
            _currentTime += 1000;
          });
        });
      });
    }
  }
}
