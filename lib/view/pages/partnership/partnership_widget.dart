import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grace_nation/core/models/partnership.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:intl/intl.dart';

class PartnershipWidget extends StatefulWidget {
  final Partnership partnership;
  const PartnershipWidget({Key? key, required this.partnership})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _PartnerShipWidgetState();
  }
}

class _PartnerShipWidgetState extends State<PartnershipWidget> {
  double calcProgress = 0;
  final NumberFormat formatter = NumberFormat("#,##0", "en_US");

  //int totalPayment = partnership.amount * partnership.frequency

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 5), () {
      setState(() {
        calcProgress = ((widget.partnership.transactions!.length *
                        widget.partnership.amount)
                    .truncate() /
                widget.partnership.totalPayable) *
            MediaQuery.of(context).size.width /
            1.125;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int numberofTransations = widget.partnership.transactions!.length;
    int currentPayment =
        (numberofTransations * widget.partnership.amount).truncate();

    String freq = widget.partnership.frequency == 'monthly'
        ? 'mth'
        : widget.partnership.frequency;
    String image = currentPayment == widget.partnership.totalPayable
        ? 'assets/images/partner-crown-gold.svg'
        : 'assets/images/partner-crown-ash.svg';

    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                widget.partnership.supportCategory,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              Expanded(
                child: Text(
                  '₦${formatter.format(widget.partnership.amount.truncate())}/$freq',
                  //'# 1,000,000/Year',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.roboto(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 200,
                child: Text(
                  widget.partnership.supportType,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Spacer(),
              Text('${widget.partnership.paymentType} Payments',
                  //'Online Payments',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  )),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 12, bottom: 5),
                  height: 36,
                  //width: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.circular(18.5),
                  ),
                  child: Stack(children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 750),
                      width: calcProgress, // MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.circular(18.5),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      top: MediaQuery.of(context).size.height / 75,
                      child: Text("₦${formatter.format(currentPayment)}",
                          //'#100,000',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            //color: white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                    Positioned(
                        right: 12, top: 6, child: SvgPicture.asset(image))
                  ]),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                // 'End Date: 31st Dec 2022',
                'End Date: ${widget.partnership.endDate}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Text(
                  '₦${formatter.format(widget.partnership.totalPayable.truncate())}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    color: babyBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          )
        ],
      ),
    );
  }
}
