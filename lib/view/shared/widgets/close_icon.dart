import 'package:flutter/material.dart';
import 'package:grace_nation/utils/styles.dart';

class CloseIcon extends StatelessWidget {
  final Function onTap;
  const CloseIcon({Key? key, required this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
      alignment: Alignment.center,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          onTap();
        },
        icon: Icon(
          Icons.close_rounded,
          size: 18,
          color: white,
        ),
      ),
    );
  }
}
