import 'package:flutter/material.dart';

class CustomFAB extends StatelessWidget {
  final GestureTapCallback onTap;
  const CustomFAB({Key? key, required this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(0, 143, 172, 1),
                Color.fromRGBO(0, 169, 203, 1)
              ],
            )),
        height: 55,
        width: 55,
        child: Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 36,
        ),
      ),
    );
  }
}
