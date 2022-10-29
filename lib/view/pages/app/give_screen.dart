import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grace_nation/core/models/payment_model.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/core/services/payment.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/shared/widgets/alert_widget.dart';
import 'package:grace_nation/view/shared/widgets/custom_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GiveScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GiveScreenState();
  }
}

class _GiveScreenState extends State<GiveScreen> {
  final NumberFormat formatter = NumberFormat('#,##,000');
  final paymentApi = PaymentApi();
  bool isConfirming = false;

  PaymentType partnerType = PaymentType.offline;
  int? selectedAmount;
  String? selectedGivingType;
  String? memberId;

  bool amoutFieldTapped = false;

  void _handleGiving(BuildContext context) async {
    print('selected giving is $selectedGivingType');
    print('selected Amount is $selectedAmount');

    if (selectedGivingType == null || selectedAmount == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertWidget(
            title: 'Incomplete Details',
            description: selectedGivingType == null
                ? "Please return and select a giving type"
                : "Please return and enter the amount you wish to give",
          );
        },
      );
    } else {
      Provider.of<AppProvider>(context, listen: false)
          .setGivingType(selectedGivingType!);
      Provider.of<AppProvider>(context, listen: false).initPayment(
        PaymentInit(
          supportType: 2,
          frequency: 'monthly',
          paymentOption: 'transfer',
          amount: selectedAmount!.toDouble(),
          currency: 'NGN',
          startDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          endDate: DateFormat('yyyy-MM-dd')
              .format(DateTime.now().add(Duration(days: 31))),
        ),
      );
      partnerType == PaymentType.offline
          ? context.goNamed(offlineGivingRouteName)
          : context.goNamed(onlineGivingRouteName);
    }
  }

  Widget amountItem(int number) {
    return Padding(
        padding: EdgeInsets.only(right: 20),
        child: InkWell(
          onTap: () {
            setState(() {
              selectedAmount = number;
              amoutFieldTapped = false;
              print("selectedAmount is $selectedAmount");
              FocusManager.instance.primaryFocus!.unfocus();
            });
          },
          child: Material(
            elevation: selectedAmount == number ? 3 : 0,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 27.5,
              width: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selectedAmount == number
                    ? Theme.of(context).primaryColor
                    : white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '₦${formatter.format(number)}',
                style: GoogleFonts.roboto(
                  color: selectedAmount == number ? white : Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ));
  }

  Widget textField(String text) {
    return SizedBox(
      height: 40,
      child: TextField(
        obscureText: true,
        //controller: passwordController,

        decoration: InputDecoration(
          hintText: text,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: babyBlue),
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Theme.of(context).hoverColor,
        ),
      ),
    );
  }

  Widget dropdownField(String hintText, List<DropDownValueModel> list,
      [bool paymentType = false]) {
    return SizedBox(
      height: 40,
      child: DropDownTextField(
        listTextStyle: TextStyle(
          color: Colors.black,
        ),
        textFieldDecoration: InputDecoration(
          hintText: hintText,
          //     hintStyle: TextStyle(color: Colors),
          filled: true,
          fillColor: Theme.of(context).hoverColor,
          contentPadding: EdgeInsets.only(top: 6, left: 12),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: Color.fromRGBO(173, 173, 173, 0.3),
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: babyBlue,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        listSpace: 0,
        enableSearch: false,
        dropDownIconProperty: IconProperty(
          icon: Icons.keyboard_arrow_down_outlined,
          size: 30,
          color: Theme.of(context).primaryColorDark,
        ),
        clearIconProperty: IconProperty(
          color: Theme.of(context).primaryColorDark,
        ),
        dropDownList: list,
        dropDownItemCount: list.length,
        onChanged: ((value) {
          if (value == null || value == "") {
            return;
          } else {
            print(value);
            if (paymentType == false) {
              setState(() {
                selectedGivingType = value.value;
                print('selected giving type is .. $selectedGivingType');
              });
            } else {
              setState(() {
                value.toString() == 'DropDownValueModel(Online Payment, online)'
                    ? partnerType = PaymentType.online
                    : partnerType = PaymentType.offline;
              });
            }
            print('payment type is $partnerType');
          }
        }),
        validator: (String? value) {
          if (value == null) {
            return 'value must not be empty';
          }
        },
      ),
    );
  }

  Widget titleText(String text, [bool optional = false]) {
    return Row(
      children: [
        Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        optional
            ? Text(
                ' (optional - members only)',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
              )
            : Container()
      ],
    );
  }

  Widget setAmountText() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "₦",
                hintStyle: GoogleFonts.roboto(color: partnerHintText),
                filled: true,
                fillColor: Theme.of(context).hoverColor,
                contentPadding: EdgeInsets.only(top: 6, left: 12),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    style: BorderStyle.solid,
                    color: Color.fromRGBO(173, 173, 173, 0.3),
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    style: BorderStyle.solid,
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onTap: () {
                if (!amoutFieldTapped) {
                  setState(() {
                    selectedAmount = 0;
                    amoutFieldTapped = true;
                  });
                } else {}
              },
              onChanged: (value) {
                selectedAmount = int.parse(value);
                print("selectedAmount is.. $selectedAmount");
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: xPadding, //vertical: xPadding
          ),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 5,
                      ),
                      child: Text(
                        'Thank you for choosing to give to God through our ministry, kindly select the giving and if you are a registered member, please input your giving ID. ',
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              titleText('Select Giving Type'),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: dropdownField('Please Select', [
                      DropDownValueModel(
                          name: 'Offering and Seed',
                          value: "offering_and_seed"),
                      DropDownValueModel(name: 'Tithe', value: "tithe"),
                      DropDownValueModel(
                          name: 'TV Support', value: "tv_support"),
                      DropDownValueModel(
                          name: 'Building Support', value: "building_support"),
                      DropDownValueModel(name: 'Welfare', value: "welfare"),
                    ]),
                  ),
                ],
              ),
              SizedBox(height: 20),
              titleText('Select Amount'),
              SizedBox(height: 10),
              SizedBox(
                height: 36,
                child: ListView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    scrollDirection: Axis.horizontal,
                    children: [
                      amountItem(10000),
                      amountItem(20000),
                      amountItem(50000),
                      amountItem(100000),
                      amountItem(200000),
                      amountItem(500000),
                      amountItem(1000000)
                    ]),
              ),
              SizedBox(height: 5),
              titleText('or'),
              titleText('Set Amount'),
              SizedBox(height: 10),
              setAmountText(),
              SizedBox(height: 20),
              titleText('Select Payment Option'),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: dropdownField(
                        "Offline Payment",
                        [
                          DropDownValueModel(
                              name: 'Offline Payment', value: "offline"),
                          DropDownValueModel(
                              name: 'Online Payment', value: "online")
                        ],
                        true),
                  ),
                ],
              ),
              SizedBox(height: 20),
              titleText('Giving ID', true),
              SizedBox(height: 10),
              Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: "Please input giving id",
                              hintStyle: TextStyle(color: partnerHintText),
                              filled: true,
                              fillColor: Theme.of(context).hoverColor,
                              contentPadding: EdgeInsets.only(top: 6, left: 12),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  color: Color.fromRGBO(173, 173, 173, 0.3),
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  color: babyBlue,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  isConfirming
                      ? Positioned(
                          top: 10,
                          right: 15,
                          child: Container(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: babyBlue,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
              SizedBox(height: 30),
              CustomButton(
                  text: 'Continue',
                  onTap: () {
                    _handleGiving(context);
                  }),
              SizedBox(height: 45),
            ],
          ),
        ),
      ),
    );
  }
}
