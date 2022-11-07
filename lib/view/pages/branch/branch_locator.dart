import 'package:dropdown_search/dropdown_search.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_nation/core/models/country.dart';
import 'package:grace_nation/core/models/state.dart';
import 'package:grace_nation/core/providers/app_provider.dart';
import 'package:grace_nation/core/services/branch_locator.dart';
import 'package:grace_nation/utils/constants.dart';
import 'package:grace_nation/utils/styles.dart';
import 'package:grace_nation/view/shared/screens/drawer.dart';
import 'package:grace_nation/view/shared/widgets/appbar.dart';
import 'package:grace_nation/view/shared/widgets/custom_button.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class BranchLocatorScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BranchLocatorScreenState();
  }
}

class _BranchLocatorScreenState extends State<BranchLocatorScreen> {
  // Initial Selected Value
  Future? future;
  final locatorApi = BranchLocator();
  final TextEditingController areaController = TextEditingController();
  bool isLoading = false;
  Country? countryValue;
  States? stateValue;
  List<States>? states;
  List<Country>? countries;

  @override
  void initState() {
    future = _asyncmethodCall();
    super.initState();
  }

  Future _asyncmethodCall() async {
    countries = await locatorApi.getCountries();
    states = await locatorApi.getStates(countryId: 160);
  }

  Widget titleText(String text) {
    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        bottom: 10,
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget countryDropdown(
    String text,
    List<Country> list,
  ) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor,
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      child: DropdownSearch<Country>(
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            hintText: text,
            hintStyle: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .color!
                  .withOpacity(0.3),
            ),
            filled: true,
            fillColor: Theme.of(context).hoverColor,
            contentPadding: EdgeInsets.only(top: 6, left: 12),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                style: BorderStyle.none,
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
        dropdownButtonProps: DropdownButtonProps(
          icon: Icon(
            Icons.keyboard_arrow_down_outlined,
            size: 30,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        popupProps: PopupProps.menu(
          constraints: BoxConstraints(maxHeight: 250),
          menuProps: MenuProps(
            backgroundColor: Theme.of(context).hoverColor,
          ),
          searchFieldProps: TextFieldProps(
            showCursor: true,
            cursorHeight: 25,
            cursorColor: babyBlue,
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .color!
                    .withOpacity(0.3),
              ),
              filled: true,
              fillColor: Theme.of(context).hoverColor,
              contentPadding: EdgeInsets.only(top: 4, left: 6),
              border: InputBorder.none,
            ),
          ),
          showSearchBox: true,
        ),
        // Array list of items
        items: list.map<Country>((Country value) {
          return Country(id: value.id, name: value.name);
        }).toList(),

        onChanged: (Country? newValue) async {
          setState(() {
            isLoading = true;
          });
          final newStates = await locatorApi.getStates(countryId: newValue!.id);
          setState(() {
            print('$newValue');
            countryValue = newValue;
            print('$countryValue');
            stateValue = null;
            states = newStates;
            isLoading = false;
          });
        },
      ),
    );
  }

  Widget stateDropdown(
    String text,
    List<States> list,
  ) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).hoverColor,
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      child: DropdownSearch<States>(
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            hintText: text,
            hintStyle: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .color!
                  .withOpacity(0.3),
            ),
            filled: true,
            fillColor: Theme.of(context).hoverColor,
            contentPadding: EdgeInsets.only(top: 6, left: 12),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                style: BorderStyle.none,
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
        dropdownButtonProps: DropdownButtonProps(
          icon: Icon(
            Icons.keyboard_arrow_down_outlined,
            size: 30,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        popupProps: PopupProps.menu(
          constraints: BoxConstraints(maxHeight: 250),
          menuProps: MenuProps(
            backgroundColor: Theme.of(context).hoverColor,
          ),
          searchFieldProps: TextFieldProps(
            showCursor: true,
            cursorHeight: 25,
            cursorColor: babyBlue,
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .color!
                    .withOpacity(0.3),
              ),
              filled: true,
              fillColor: Theme.of(context).hoverColor,
              contentPadding: EdgeInsets.only(top: 4, left: 6),
              border: InputBorder.none,
            ),
          ),
          showSearchBox: true,
        ),
        // Array list of items
        items: list.map<States>((States value) {
          return States(id: value.id, name: value.name);
        }).toList(),

        onChanged: (States? newValue) async {
          if (newValue == null || newValue == "") {
            return;
          } else {
            setState(() {
              print('$newValue');
              stateValue = States(id: newValue.id, name: newValue.name);
              print('$stateValue');
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.goNamed(homeRouteName, params: {'tab': 'homepage'});
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBarWidget(
          actionScreen: false,
          appBar: AppBar(),
          title: 'Branch Locator',
        ),
        drawer: AppDrawer(),
        body: SafeArea(
          child: Stack(
            children: [
              FutureBuilder(
                future: future,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    debugPrint("ConnectionState.waiting");
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: babyBlue,
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Scaffold(
                      body: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Center(
                          child: Text('An error has occured'),
                        ),
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                   //   vertical: 24,
                      horizontal: 36,
                    ),
                    physics: BouncingScrollPhysics(),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                             SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/locator-destination.png',
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                          titleText('Select Country'),
                          countryDropdown('Please Select', countries ?? []),
                          titleText('Select State'),
                          stateDropdown('Please Select', states ?? []),
                          titleText('Nearest bus stop or Area'),
                          Container(
                              //height: 50,
                              padding: EdgeInsets.only(
                                left: 24,
                                right: 15,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).hoverColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                              ),
                              child: TextField(
                                cursorColor: babyBlue,
                                controller: areaController,
                                decoration: InputDecoration(
                                  hintText: "Please enter ",
                                  hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color!
                                        .withOpacity(0.3),
                                  ),
                                  filled: true,
                                  fillColor: Theme.of(context).hoverColor,
                                  contentPadding:
                                      EdgeInsets.only(top: 6, left: 1),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(style: BorderStyle.none),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(style: BorderStyle.none),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              )),
                          SizedBox(height: 30),
                          CustomButton(
                            text: 'Search',
                            onTap: () {
                              if (countryValue == null || stateValue == null)
                                return;
                              Provider.of<AppProvider>(context, listen: false)
                                  .setbranchValues(
                                      countryId: countryValue!.id,
                                      stateId: stateValue!.id,
                                      area: areaController.text);
                              context.goNamed(branchResultsRouteName);
                            },
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  );
                },
              ),
              isLoading
                  ? Container(
                      color: black.withOpacity(0.36),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: CircularProgressIndicator(color: babyBlue),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
