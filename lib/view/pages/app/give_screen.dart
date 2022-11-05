import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grace_nation/core/models/giving_model.dart';
import 'package:grace_nation/core/models/payment_model.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/core/services/giving_payment.dart';
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
  final NumberFormat formatter = NumberFormat("#,##0", "en_US");
  final paymentApi = PaymentApi();
  final givingApi = GivingPayment();
  bool isConfirming = false;
  List<DropDownValueModel> givingTypeList = [];
  PaymentType partnerType = PaymentType.offline;
  int? selectedAmount;
  String selectedCurrency = "NGN";
  List<DropDownValueModel> currencyList = [
    DropDownValueModel(name: 'NGN', value: "NGN"),
    DropDownValueModel(name: 'USD', value: "USD"),
  ];
  final _amountController = TextEditingController();
  int? selectedGivingTypeId;
  String? memberId;
  Future? future;
  bool amoutFieldTapped = false;

  List<int> ngnAmounts = [10000, 20000, 50000, 100000, 200000, 500000, 1000000];
  List<int> usdAmounts = [10, 20, 50, 100, 200, 500, 1000];

  @override
  void initState() {
    future = _asyncmethodCall();
    super.initState();
  }

  Future _asyncmethodCall() async {
    List<GivingType> givingTypes = await givingApi.fetchGivingTypes();
    print("giving type list length is ... ${givingTypes.length}");
    for (int i = 0; i < givingTypes.length; i++) {
      print("addded a giving type");
      GivingType type = givingTypes[i];
      DropDownValueModel model =
          DropDownValueModel(name: type.name, value: type.id);
      givingTypeList.add(model);
    }
    print("DONE with support types");
    setState(() {});
  }

  void _handleGiving(BuildContext context) async {
    print('selected giving is $selectedGivingTypeId');
    print('selected Amount is $selectedAmount');

    if (selectedGivingTypeId == null || selectedAmount == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertWidget(
            title: 'Incomplete Details',
            description: selectedGivingTypeId == null
                ? "Please return and select a giving type"
                : "Please return and enter the amount you wish to give",
          );
        },
      );
    } else {
      Provider.of<AppProvider>(context, listen: false)
          .setGivingTypeId(selectedGivingTypeId!);
      Provider.of<AppProvider>(context, listen: false).givingInitPayment(
          GivingInit(
              amount: selectedAmount!.toDouble(),
              currency: selectedCurrency,
              givingTypeId: selectedGivingTypeId!));
      partnerType == PaymentType.offline
          ? context.goNamed(offlineGivingRouteName)
          : context.goNamed(onlineGivingRouteName);
    }
  }

  Widget amountItem(int number, String sign) {
    return Padding(
        padding: EdgeInsets.only(right: 20),
        child: InkWell(
          onTap: () {
            setState(() {
              selectedAmount = number;
              amoutFieldTapped = false;
              print("selectedAmount is $selectedAmount");
              _amountController.text = number.toString();
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
                '$sign${formatter.format(number)}',
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
          hintStyle:
              TextStyle(color: Theme.of(context).hintColor.withOpacity(0.75)),
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
            setState(() {
              selectedGivingTypeId = 0;
            });
            return;
          } else {
            print(value);
            if (paymentType == false) {
              setState(() {
                selectedGivingTypeId = value.value;
                print('selected giving type is .. $selectedGivingTypeId');
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
              controller: _amountController,
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
                        'Thank you for choosing to give to God through our ministry, kindly select the giving option and if you are a registered member, please input your giving ID. ',
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

              //
              Row(children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Text(
                      'Select Currency',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                SizedBox(width: 22),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Text(
                      'Select Giving Type',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ]),

              //

              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 40,
                      child: DropDownTextField(
                        listPadding: ListPadding(bottom: 10, top: 10),
                        textFieldDecoration: InputDecoration(
                          hintText: 'NGN',
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .hintColor
                                  .withOpacity(0.75)),
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
                        listTextStyle: TextStyle(color: Colors.black),
                        dropDownIconProperty: IconProperty(
                          icon: Icons.keyboard_arrow_down_outlined,
                          size: 30,
                          color: deepBlue,
                        ),
                        clearIconProperty: IconProperty(color: deepBlue),
                        dropDownList: currencyList,
                        dropDownItemCount: currencyList.length,
                        onChanged: ((value) {
                          if (value == null || value == "") {
                            setState(() {
                              selectedCurrency = "NGN";
                            });
                            print("value is is ${value.toString()}");
                            return;
                          } else {
                            print('${value.name}');

                            setState(() {
                              selectedCurrency = value.value;
                            });
                          }
                        }),
                        validator: (String? value) {
                          if (value == null) {
                            return 'value must not be empty';
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 22),
                  Expanded(
                    flex: 4,
                    child: dropdownField(
                      'Offering',
                      givingTypeList,
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 10),
              // titleText('Select Giving Type'),
              // SizedBox(height: 10),
              // Row(
              //   children: [
              //     Expanded(
              //       child: dropdownField(
              //         'Please Select',
              //         givingTypeList,
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: 20),
              titleText('Select Amount'),
              SizedBox(height: 10),
              SizedBox(
                  height: 36,
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      scrollDirection: Axis.horizontal,
                      itemCount: ngnAmounts.length,
                      itemBuilder: (BuildContext context, int index) {
                        int amt = selectedCurrency == "NGN"
                            ? ngnAmounts[index]
                            : usdAmounts[index];
                        String ngn = selectedCurrency == "NGN" ? "₦" : "\$";

                        return amountItem(amt, ngn);
                      })),
              SizedBox(height: 5),
              titleText('or'),
              SizedBox(height: 7.5),
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
                            keyboardType: TextInputType.visiblePassword,
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
