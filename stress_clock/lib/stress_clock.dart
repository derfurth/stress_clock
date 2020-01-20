// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

import 'clock_face.dart';

/// A basic digital clock.
///
/// You can do better than this!
class StressClock extends StatefulWidget {
  const StressClock(this.model);

  final ClockModel model;

  @override
  _StressClockState createState() => _StressClockState();
}

class _StressClockState extends State<StressClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(StressClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _dateTime = _dateTime.subtract(Duration(hours: 6));
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).brightness == Brightness.light
        ? ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.white,
            accentColor: Colors.red,
          )
        : ThemeData(
            brightness: Brightness.dark,
            primaryColor: Colors.black,
            accentColor: Colors.yellow,
          );

    return Theme(
        data: theme,
        child: ClockFace(
          dateTime: _dateTime,
          is24HourFormat: widget.model.is24HourFormat,
        ));
  }
}
