import 'package:flutter/material.dart';
import 'package:grace_nation/utils/styles.dart';

class PageWidget extends StatelessWidget {
  final String mainText;
  final String subText;
  final String image;
  final String buttonText;
  final Function onTap;
  const PageWidget({
    Key? key,
    required this.mainText,
    required this.subText,
    required this.image,
    required this.onTap,
    required this.buttonText,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            mainText,
            style: TextStyle(
              color: white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              subText,
              style: TextStyle(
                color: miniTextWhite,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 90),
          SizedBox(
            height: 48,
            width: 345,
            child: ElevatedButton(
              onPressed: () {
                onTap();
              },
              child: Text(
                buttonText,
                style: TextStyle(
                  color: white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: babyBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
