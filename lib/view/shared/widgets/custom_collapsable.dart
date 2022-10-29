import 'package:flutter/material.dart';

/// [CustomCollapsable] is collapsable widget which shows a [preview]
/// and a trailing with a [trailingText] by default. On tap the trailing or
/// its [trailingText], it animates to show the [child].

/// NOTE: [ExpansionTile] doesn't support layout changes, for example
/// moving trailing down or to hide the [preview] after expand the content.
/// [CustomCollapsable] is inspired on [ExpansionTile] with additional features.
class CustomCollapsable extends StatefulWidget {
  /// [Widget] shown when expanded
  final Widget child;

  /// [Widget] shown only when it is not expanded
  final Widget preview;

  /// [String] that goes on top of the trailing arrow
  final String? trailingText;

  /// Callback [ValueChanged] function fired after animation
  final ValueChanged<bool>? onExpansionChanged;

  const CustomCollapsable({
    Key? key,
    required this.preview,
    required this.child,
   this.trailingText,
    this.onExpansionChanged,
  });

  @override
  _CustomCollapsableState createState() => _CustomCollapsableState();
}

class _CustomCollapsableState extends State<CustomCollapsable>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween = CurveTween(
    curve: Curves.easeIn,
  );
  static final Animatable<double> _halfTween = Tween<double>(
    begin: 0.0,
    end: 0.5,
  );

  late AnimationController _controller;
  late Animation<double> _heightFactor;
  late Animation<double> _iconTurns;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));

    _heightFactor = _controller.drive(_easeInTween);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get isClosed => !_isExpanded && _controller.isDismissed;

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;

      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {});
        });
      }

      PageStorage.of(context)?.writeState(context, _isExpanded);
    });

    if (widget.onExpansionChanged != null) {
      widget.onExpansionChanged!(_isExpanded);
    }
  }

  Widget _buildTralling() {
    return GestureDetector(
      onTap: _handleTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 1.0),
        child: RotationTransition(
          turns: _iconTurns,
          child: const Icon(Icons.expand_more),
        ),
      ),
    );
  }

  Widget _buildChild(BuildContext context, Widget? child) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Preview widget is visible only when the parent is closed
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: isClosed ? widget.preview : const SizedBox(width: 1),
            ),
            _buildTralling()
          ],
        ),
        Wrap(children: [
          ClipRect(
            child: Align(
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChild,
      child: isClosed ? null : widget.child,
    );
  }
}
