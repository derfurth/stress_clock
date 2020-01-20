import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'depletion_indicator.dart';

/// A clock face displaying the depletion of
/// - current month
/// - current day
/// - current hour
/// - current minute
///
/// Uses a fluid layout to adapt to a wide variety of device sizes.
class ClockFace extends StatelessWidget {
  /// Brightness transition duration.
  final transitionDuration = const Duration(seconds: 2);

  final DateTime dateTime;

  final bool is24HourFormat;

  const ClockFace({
    Key key,
    @required this.dateTime,
    this.is24HourFormat = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final daysThisMonth = DateTime(dateTime.year, dateTime.month + 1, 0).day;

    final month = (daysThisMonth - dateTime.day) / daysThisMonth;
    final day = (24 - dateTime.hour) / 24;
    final hour = (60 - dateTime.minute) / 60;
    final minute = (60 - dateTime.second) / 60;

    return AnimatedContainer(
      duration: transitionDuration,
      color: Theme.of(context).primaryColor,
      child: Center(
        child: AspectRatio(
          aspectRatio: 1.0,
          child: FractionallySizedBox(
            heightFactor: .9,
            child: Column(
              children: <Widget>[
                DepletionIndicator(
                  value: month,
                  label: DateFormat('MMMM').format(dateTime),
                  transitionDuration: transitionDuration,
                ),
                DepletionIndicator(
                  value: day,
                  label: DateFormat('EEEE').format(dateTime),
                  transitionDuration: transitionDuration,
                ),
                DepletionIndicator(
                  value: hour,
                  label:
                      DateFormat(is24HourFormat ? 'HH' : 'hh').format(dateTime),
                  semanticLabel: 'percentage of current hour remaining',
                  transitionDuration: transitionDuration,
                ),
                DepletionIndicator(
                  value: minute,
                  label: DateFormat('mm').format(dateTime),
                  semanticLabel: 'percentage of current minute remaining',
                  transitionDuration: transitionDuration,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
