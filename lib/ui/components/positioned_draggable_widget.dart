import 'package:flutter/widgets.dart';

// Stolen from https://stackoverflow.com/a/58682175
class PositionedDraggableWidget extends StatefulWidget {
  final double top;
  final double left;
  final Widget child;
  final VoidCallback? onSecondaryTap;

  PositionedDraggableWidget(
      {Key? key,
      required this.top,
      required this.left,
      required this.child,
      this.onSecondaryTap})
      : super(key: key);

  @override
  _PositionedDraggableWidgetState createState() =>
      _PositionedDraggableWidgetState();
}

class _PositionedDraggableWidgetState extends State<PositionedDraggableWidget> {
  GlobalKey _key = GlobalKey();
  late double top, left;
  late double xOff, yOff;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback(_afterLayout);
    top = widget.top;
    left = widget.left;
    super.initState();
  }

  void _getRenderOffsets() {
    final RenderBox renderBoxWidget =
        _key.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBoxWidget.localToGlobal(Offset.zero);

    yOff = offset.dy - this.top;
    xOff = offset.dx - this.left;
  }

  void _afterLayout(_) {
    _getRenderOffsets();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        key: _key,
        top: top,
        left: left,
        child: GestureDetector(
          onSecondaryTap: widget.onSecondaryTap,
          child: Draggable(
            child: widget.child,
            feedback: widget.child,
            childWhenDragging: Container(),
            onDragEnd: (drag) {
              setState(() {
                top = drag.offset.dy - yOff;
                left = drag.offset.dx - xOff;
              });
            },
          ),
        ));
  }
}
