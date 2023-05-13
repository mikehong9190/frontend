import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:textfield_search/textfield_search.dart';
import '../model/responses.dart';

Widget TextFieldWidget(
  label,
  controller,
  isPassword,
  isValid,
  isEnabled,
) {
  // final String label;
  // TextFieldWidget ({super.key,required this.label,});
  return Column(
    children: [
      SizedBox(
        width: double.infinity,
        child: Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Text(label,
                textAlign: TextAlign.left,
                style: const TextStyle(fontWeight: FontWeight.w500))),
      ),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
          height: 50,
          width: double.infinity,
          child: TextField(
            enabled: isEnabled,
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              suffixIcon: isPassword
                  ? Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween, // added line
                      mainAxisSize: MainAxisSize.min,
                      children: [
                          isValid
                              ? SvgPicture.asset("assets/svg/check.svg")
                              : Container(),
                          IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset("assets/svg/Eye.svg"))
                        ])
                  : Container(
                      width: 0,
                    ),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Colors.black)),
              enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Colors.black)),
              hintText: !isPassword ? label : "**********",
            ),
          )),
    ],
  );
}

Widget SearchTextFieldWidget(
    label, controller, isPassword, isValid, getDistricts, clickOnSuggestion) {
  // final String label;
  // TextFieldWidget ({super.key,required this.label,});
  return Column(
    children: [
      SizedBox(
        height: 30,
        width: double.infinity,
        child: Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Text(label,
                textAlign: TextAlign.left,
                style: const TextStyle(fontWeight: FontWeight.w500))),
      ),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
          height: 50,
          width: double.infinity,
          child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  // hintText: 'Enter a search term',
                ),
                controller: controller,
              ),
              suggestionsCallback: getDistricts,
              itemBuilder: (context, SingleDistrictResponse? suggestion) {
                final district = suggestion!;
                print('DISTRICT ::::: ${district.district}');
                return ListTile(
                  title: Text(
                    district.district,
                  ),
                );
              },
              noItemsFoundBuilder: (context) => const SizedBox(
                  height: 100,
                  child: Center(
                    child: Text('No district Found'),
                  )),
              onSuggestionSelected: (suggestion) {
                final district = suggestion!;
                clickOnSuggestion(district.district, controller);
              })),
    ],
  );
}

Widget SchoolSearchFieldWidget(
    label, controller, isPassword, isValid, getSchools, clickOnSchool) {
  // final String label;
  // TextFieldWidget ({super.key,required this.label,});
  return Column(
    children: [
      SizedBox(
        height: 30,
        width: double.infinity,
        child: Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Text(label,
                textAlign: TextAlign.left,
                style: const TextStyle(fontWeight: FontWeight.w500))),
      ),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
          height: 50,
          width: double.infinity,
          child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  // hintText: 'Enter a search term',
                ),
                controller: controller,
              ),
              suggestionsCallback: getSchools,
              itemBuilder: (context, School? school) {
                final schoolData = school!;
                // print('DISTRICT ::::: ${district.district}');
                return ListTile(
                  title: Text(
                    schoolData.name,
                  ),
                );
              },
              noItemsFoundBuilder: (context) => const SizedBox(
                  height: 100,
                  child: Center(
                    child: Text('No School Found'),
                  )),
              onSuggestionSelected: (school) {
                final schoolData = school!;
                clickOnSchool(schoolData.id, schoolData.name, controller);
              })),
    ],
  );
}

Widget PasswordFieldWidget(
    label, controller, isPassword, isValid, isEnabled, changeVisiblity) {
  // final String label;
  // TextFieldWidget ({super.key,required this.label,});
  return Column(
    children: [
      SizedBox(
        height: 30,
        width: 350,
        child: Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Text(label,
                textAlign: TextAlign.left,
                style: const TextStyle(fontWeight: FontWeight.w500))),
      ),
      const SizedBox(
        height: 10,
      ),
      SizedBox(
          height: 50,
          width: 350,
          child: TextField(
            enabled: isEnabled,
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              suffixIcon: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // added line
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    isValid
                        ? SvgPicture.asset("assets/svg/check.svg")
                        : Container(),
                    IconButton(
                        onPressed: () {
                          changeVisiblity();
                        },
                        icon: SvgPicture.asset("assets/svg/Eye.svg"))
                  ]),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Colors.black)),
              hintText: !isPassword ? label : "**********",
            ),
          )),
    ],
  );
}
