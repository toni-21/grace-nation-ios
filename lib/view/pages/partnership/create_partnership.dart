import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grace_nation/core/models/payment_model.dart';
import 'package:grace_nation/core/models/support_type.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/core/services/partnership.dart';
import 'package:grace_nation/view/pages/partnership/temporary_congrats.dart';
import 'package:grace_nation/view/shared/widgets/alert_widget.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/view/shared/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class CreatePartnership extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreatePartnershipState();
  }
}

class _CreatePartnershipState extends State<CreatePartnership> {
  final NumberFormat formatter = NumberFormat("#,##0", "en_US");
  final _dateController = TextEditingController();
  final _amountController = TextEditingController();
  final ptApi = PartnershipApi();
  PaymentType partnerType = PaymentType.offline;
  //SELECTED VALUES
  int selectedDuration = 0;
  String? startDate;
  DateTime? startDateTime;
  String? endDate;
  int selectedAmount = 0;
  String selectedCurrency = "NGN";
  String selectedFrequency = "monthly";
  int? selectedSupportType;
  String selectedPaymentOption = "online";
  List<bool> selecteds = [false, false, false, false, false];
  bool offlinePaying = false;
  Future? future;

  List<int> ngnAmounts = [10000, 20000, 50000, 100000, 200000, 500000, 1000000];
  List<int> usdAmounts = [10, 20, 50, 100, 200, 500, 1000];
  List<DropDownValueModel> supportList = [];

  @override
  void initState() {
    future = _asyncmethodCall();
    super.initState();
  }

  Future _asyncmethodCall() async {
    List<SupportType> supportTypes = await ptApi.getSupportTypes();
    for (int i = 0; i < supportTypes.length; i++) {
      SupportType type = supportTypes[i];
      DropDownValueModel model =
          DropDownValueModel(name: type.displayName, value: type.id);
      supportList.add(model);
    }
    print("DONE with support types");
    setState(() {});
  }

  void _validate(BuildContext context) async {
    print('selected Amount is $selectedAmount');
    print('selected currency is $selectedCurrency');
    print('selected frequency is $selectedFrequency');
    print('selected support is $selectedSupportType');
    print('selected pay option is $selectedPaymentOption');
    print('selected start is $startDate');
    print('selected end is $endDate');
    if (selectedSupportType == null || startDate == null || endDate == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertWidget(
              title: 'Incomplete Details',
              description: "Please return and complete all the details");
        },
      );
    } else {
      Provider.of<AppProvider>(context, listen: false).initPayment(
        PaymentInit(
          supportType: selectedSupportType!,
          frequency: selectedFrequency,
          paymentOption: selectedPaymentOption,
          amount: selectedAmount.toDouble(),
          currency: selectedCurrency,
          startDate: startDate!,
          endDate: endDate!,
        ),
      );
      selectedPaymentOption == 'online'
          ? context.goNamed(onlinePartnershipRouteName)
          : context.goNamed(offlinePartnershipRouteName);
    }
  }

  Widget amountItem(int number, String sign) {
    return Padding(
        padding: EdgeInsets.only(right: 20),
        child: InkWell(
          onTap: () {
            setState(() {
              selectedAmount = number;
              print("amount is $selectedAmount");
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

  Widget durationItem(int text, [bool oneTime = false]) {
    // final calcDuration = selectedFrequency == "monthly" ?
    int duration = oneTime ? 1 : text;
    final now = startDateTime ?? DateTime.now();
    //print(selectedFrequency);
    final then = selectedFrequency == "monthly"
        ? DateTime(now.year, (now.month + duration), now.day)
        : selectedFrequency == "yearly"
            ? DateTime((now.year + duration), now.month, now.day)
            : DateTime(now.year, (now.month + (3 * duration)), now.day);
    //  : DateTime(now.year, now.month, now.day + (7 * duration));WEEKLY IMPLEMENTATION

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDuration = oneTime ? 1 : text;
          startDate = DateFormat('yyyy-MM-dd').format(now);
          endDate = DateFormat('yyyy-MM-dd').format(then);
          print('startDate is $startDate');
          print('endDate is $endDate');
        });
      },
      child: Container(
        height: 36,
        width: 50,
        margin: EdgeInsets.only(right: 4, left: 4, bottom: 18),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: oneTime
              ? selectedDuration == 1
                  ? Theme.of(context).primaryColor
                  : white
              : selectedDuration == text
                  ? Theme.of(context).primaryColor
                  : white,
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
          boxShadow: [
            BoxShadow(
                color: darkGray.withOpacity(0.85),
                blurRadius: 7,
                spreadRadius: -5,
                offset: const Offset(0, 5)),
          ],
        ),
        child: Text(
          oneTime ? 'X' : text.toString(),
          style: TextStyle(
            color: oneTime
                ? selectedDuration == 1
                    ? white
                    : Colors.black
                : selectedDuration == text
                    ? white
                    : Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 17.5,
          ),
        ),
      ),
    );
  }

  Widget dropdownField(
      String hintText, List<DropDownValueModel> list, CreateFormType type) {
    return SizedBox(
      //  height: 40,
      child: DropDownTextField(
        listPadding: ListPadding(bottom: 10, top: 10),
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
        listTextStyle: TextStyle(color: Colors.black),
        enableSearch: false,
        dropDownIconProperty: IconProperty(
          icon: Icons.keyboard_arrow_down_outlined,
          size: 30,
          color: deepBlue,
        ),
        clearIconProperty: IconProperty(color: deepBlue),
        dropDownList: list,
        dropDownItemCount: list.length,
        onChanged: ((value) {
          if (value == null || value == "") {
            if (type == CreateFormType.currency) {
              setState(() {
                selectedCurrency = "NGN";
              });
            }
            return;
          } else {
            print('${value.name}');
            switch (type) {
              case CreateFormType.currency:
                setState(() {
                  selectedCurrency = value.value;
                });
                break;
              case CreateFormType.frequency:
                selectedFrequency = value.value;
                break;
              case CreateFormType.paymenttype:
                selectedPaymentOption = value.value;
                if (selectedPaymentOption == 'offline') {
                  setState(() {
                    offlinePaying = true;
                  });
                } else {
                  setState(() {
                    offlinePaying = false;
                  });
                }
                break;
              case CreateFormType.supporttype:
                selectedSupportType = value.value;
                break;
            }
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

  Widget titleText(String text) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 10,
              //  right: 2,
            ),
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ),
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
                hintText: selectedCurrency == "NGN" ? "₦" : "\$",
                hintStyle: GoogleFonts.roboto(
                  color: partnerHintText,
                ),
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
              onChanged: (value) {
                if (value.length > 0)
                  setState(() {
                    selectedAmount = int.parse(value);
                    print("amount is $selectedAmount");
                  });
              },
              onTap: () {
                // setState(() {
                //   selectedAmount = 0;
                // });
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
      appBar: AppBarWidget(
        actionScreen: true,
        title: 'Create Partnership',
        appBar: AppBar(),
      ),
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
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 10,
                        left: 12,
                      ),
                      child: Text(
                        'Select Frequency',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: dropdownField(
                        'NGN',
                        [
                          DropDownValueModel(name: 'NGN', value: "NGN"),
                          DropDownValueModel(name: 'USD', value: "USD"),
                        ],
                        CreateFormType.currency),
                  ),
                  SizedBox(width: 22),
                  Expanded(
                    child: dropdownField(
                        'Monthly',
                        [
                          DropDownValueModel(name: 'Monthly', value: "monthly"),
                          DropDownValueModel(
                              name: 'Quarterly', value: "quarterly"),
                          DropDownValueModel(name: 'Yearly', value: "yearly"),
                        ],
                        CreateFormType.frequency),
                  ),
                ],
              ),
              SizedBox(height: 20),
              titleText('Select Support Type'),
              Row(
                children: [
                  Expanded(
                    child: dropdownField('Please Select', supportList,
                        CreateFormType.supporttype),
                  ),
                ],
              ),
              SizedBox(height: 20),
              titleText('Select Amount'),
              //      SizedBox(height: 20),

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
                    }),
              ),

              SizedBox(height: 5),
              titleText('or'),
              //   SizedBox(height: 20),
              titleText('Set Amount'),

              setAmountText(),
              SizedBox(height: 20),
              titleText('Select Payment Option'),
              Row(
                children: [
                  Expanded(
                    child: dropdownField(
                        "Online Payment",
                        [
                          DropDownValueModel(
                              name: 'Offline Payment', value: "offline"),
                          DropDownValueModel(
                              name: 'Online Payment', value: "online")
                        ],
                        CreateFormType.paymenttype),
                  ),
                ],
              ),
              offlinePaying
                  ? Container()
                  : Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 20, top: 9, right: 20),
                            child: Text(
                              '*Please note that you will be required to make your first payment to complete online payment',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        )
                      ],
                    ),
              SizedBox(height: 20),

              !offlinePaying ? Container() : titleText('Select Start Date'),

              !offlinePaying
                  ? Container()
                  : Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: !offlinePaying
                                ? () {
                                    _dateController.text = "";
                                  }
                                : () async {
                                    final DateTime? picked =
                                        await showDatePicker(
                                            context: context,
                                            initialDate:
                                                startDateTime ?? DateTime.now(),
                                            firstDate: DateTime(2015, 8),
                                            lastDate: DateTime(2101));
                                    if (picked != null) {
                                      setState(() {
                                        startDateTime = picked;
                                        startDate = DateFormat('yyyy-MM-dd')
                                            .format(picked);
                                        print('startDate is $startDate');
                                        _dateController.text = startDate!;
                                      });
                                    }
                                  },
                            child: SizedBox(
                              height: 40,
                              child: TextFormField(
                                controller: _dateController,
                                decoration: InputDecoration(
                                  enabled: false,
                                  hintText: 'Please Select Date',
                                  hintStyle: TextStyle(color: partnerHintText),
                                  filled: true,
                                  fillColor: Theme.of(context).hoverColor,
                                  suffixIcon: Icon(Icons.calendar_month,
                                      color: deepBlue),
                                  contentPadding:
                                      EdgeInsets.only(top: 6, left: 12),
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
                                validator: (String? value) {
                                  if (value == null) {
                                    return 'value must not be empty';
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              SizedBox(height: 20),
              titleText('Giving Duration'),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 10,
                        right: 10,
                        left: 10,
                      ),
                      child: Text(
                        'Please select how long you want this giving to be active. E.g; You selected monthly above and want to give for 8months, so select 8 here. If it is a one off, please select X',
                        style: TextStyle(
                          fontSize: 12,
                          color: partnerHintText,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Flexible(child:
              GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,

                ///       scrollDirection: Axis.horizontal,
                crossAxisCount: 6,
                childAspectRatio: 1,
                children: [
                  durationItem(1, true),
                  durationItem(2),
                  durationItem(3),
                  durationItem(4),
                  durationItem(5),
                  durationItem(6),
                  durationItem(7),
                  durationItem(8),
                  durationItem(9),
                  durationItem(10),
                  durationItem(11),
                  durationItem(12),
                ],
              ),
              //    ),
              SizedBox(height: 20),
              CustomButton(
                  text: 'Continue',
                  onTap: () {
                    _validate(context);
                    //  context.goNamed(congratsRouteName);
                  }),
              SizedBox(height: 45),
            ],
          ),
        ),
      ),
    );
  }
}
