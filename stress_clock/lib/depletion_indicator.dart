import 'package:flutter/material.dart';

/// A linear depletion indicator, the opposite of a progress bar.
///
/// Aligned to the right when text flows left to right.
class DepletionIndicator extends StatelessWidget {
  /// Brightness transition duration.
  final Duration transitionDuration;

  /// When [value] reaches 1.0, there is nothing left.
  final double value;

  /// Display label.
  final String label;

  /// Optional accessibility label.
  final String semanticLabel;

  const DepletionIndicator({
    Key key,
    @required this.value,
    @required this.label,
    @required this.transitionDuration,
    this.semanticLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).primaryColor;
    final barColor = Theme.of(context).accentColor;

    return Flexible(
      child: Semantics(
        label: semanticLabel ?? 'percentage of $label remaining',
        value: '${(value * 100).round()}%',
        child: Align(
          alignment: AlignmentDirectional.centerEnd,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              final shadow = constraints.maxHeight / 40;
              final spread = shadow / 4;
              final blur = shadow * 2;

              /// Bar.
              return FractionallySizedBox(
                widthFactor: value,
                heightFactor: .6,
                child: AnimatedContainer(
                  duration: transitionDuration,
                  decoration: BoxDecoration(
                    color: barColor,
                    boxShadow: [
                      BoxShadow(
                        color: barColor.withOpacity(.3),
                        blurRadius: blur,
                        spreadRadius: spread,
                        offset: Offset(
                          TextDirection.ltr == Directionality.of(context)
                              ? shadow
                              : -shadow,
                          shadow,
                        ),
                      ),
                    ],
                  ),
                  child: ClipRect(
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        /// Text
                        OverflowBox(
                          maxWidth: maxWidth,
                          alignment: AlignmentDirectional.centerEnd,
                          child: FractionallySizedBox(
                            heightFactor: .8,
                            child: FittedBox(
                              alignment: AlignmentDirectional.centerEnd,
                              child: AnimatedDefaultTextStyle(
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                duration: transitionDuration,
                                child: Text(
                                  '$label ',
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// Fade effect
                        AnimatedContainer(
                          duration: transitionDuration,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                barColor,
                                barColor.withOpacity(.0)
                              ],
                              begin: AlignmentDirectional.centerStart,
                              end: AlignmentDirectional.centerEnd,
                              //stops: [.0, .5],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
