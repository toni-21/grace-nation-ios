import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/shared/widgets/custom_button.dart';

class PartnershipCongrats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).hoverColor,
        body: SafeArea(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: 210,
                width: 210,
                decoration:
                    BoxDecoration(color: babyBlue, shape: BoxShape.circle),
                child: Container(
                  alignment: Alignment.center,
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                      color: Theme.of(context).hoverColor,
                      shape: BoxShape.circle),
                  child: Container(
                    child: SvgPicture.asset('assets/images/congrats-check.svg'),
                  ),
                ),
              ),
              SizedBox(height: 84),
              Text(
                'Congatulations!!!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  //  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Partnership Goal Created',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  //  color: Colors.black.withOpacity(0.5),
                ),
              ),
              SizedBox(height: 50),
              CustomButton(
                  text: 'Go back Home',
                  onTap: () {
                    context.goNamed(partnershipPageRouteName);
                  })
            ],
          )),
        ));
  }
}
