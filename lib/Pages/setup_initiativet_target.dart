import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/pages/setup_initiative_grade.dart';

class SetupInitiativeTarget extends StatefulWidget {
  final String id;
  final String name;
  const SetupInitiativeTarget(
      {super.key, required this.id, required this.name});

  @override
  State<SetupInitiativeTarget> createState() => _InitiativeTargetState();
}

class _InitiativeTargetState extends State<SetupInitiativeTarget> {
  List<dynamic> targets = [
    500,
    1000,
    2500,
    5000,
    10000,
    25000,
    'Enter Custom Amount'
  ];

  late dynamic id = widget.id;
  late dynamic name = widget.name;
  late dynamic target = 0;
  late dynamic selectedItem = 0;

  @override
  Widget build(context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset("assets/svg/Vector.svg")),
        backgroundColor: Colors.white,
        title: const Text(
          'Select Your target',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20, right: 30, left: 30, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What is your \$ target',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            for (var tgt in targets)
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedItem = tgt;
                    if (tgt != 'Enter Custom Amount') {
                      target = tgt;
                    }
                  });
                },
                child: ListTile(
                  title: Row(
                    children: [
                      Expanded(
                          child: Text(tgt == 'Enter Custom Amount'
                              ? '$tgt'
                              : '\$ $tgt')),
                      Radio(
                        value: tgt,
                        groupValue: selectedItem,
                        onChanged: (value) {
                          setState(() {
                            selectedItem = tgt;
                            if (tgt != 'Enter Custom Amount') {
                              target = tgt;
                            }
                          });
                        },
                        activeColor: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            if (selectedItem == 'Enter Custom Amount')
              Container(
                alignment: Alignment.center,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    enabled: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter Amount',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(
                              color: Color.fromRGBO(231, 231, 231, 1))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(
                              color: Color.fromRGBO(231, 231, 231, 1))),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    onChanged: (value) {
                      // log(value);
                      setState(() {
                        target = value;
                      });
                    },
                  ),
                ),
              ),
            const Spacer(),
            ButtonTheme(
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.secondary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)))),
                  onPressed: target != 0
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SetupInitiativeGrade(
                                  initiativeTypeId: id,
                                  initiativeType: name,
                                  target: target),
                            ),
                          );
                        }
                      : null,
                  child: Text(
                    "Next",
                    style: TextStyle(
                      color: target != 0
                          ? Colors.white
                          : const Color.fromARGB(255, 212, 211,
                              211), // Set the color when button is disabled
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
