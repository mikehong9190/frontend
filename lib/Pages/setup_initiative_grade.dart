import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/pages/gallery.dart';

class SetupInitiativeGrade extends StatefulWidget {
  final String initiativeTypeId;
  final String initiativeType;
  final dynamic target;
  const SetupInitiativeGrade(
      {super.key,
      required this.initiativeTypeId,
      required this.initiativeType,
      required this.target});

  @override
  State<SetupInitiativeGrade> createState() => _InitiativeGradeState();
}

class _InitiativeGradeState extends State<SetupInitiativeGrade> {
  String selectedOption = '';

  late dynamic id = widget.initiativeTypeId;
  late dynamic name = widget.initiativeType;
  late dynamic target = widget.target;
  late dynamic grade = '';
  late dynamic noOfStudents = 0;

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
          'Enter Grade details',
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
              'Initiative Grade Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Class or Grade Name"),
                const SizedBox(height: 5),
                TextField(
                  enabled: true,
                  decoration: const InputDecoration(
                    hintText: '4th Grade',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide:
                          BorderSide(color: Color.fromRGBO(231, 231, 231, 1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide:
                          BorderSide(color: Color.fromRGBO(231, 231, 231, 1)),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      grade = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Number of Students"),
                const SizedBox(height: 5),
                TextField(
                  enabled: true,
                  decoration: const InputDecoration(
                    hintText: '68',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide:
                          BorderSide(color: Color.fromRGBO(231, 231, 231, 1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide:
                          BorderSide(color: Color.fromRGBO(231, 231, 231, 1)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      noOfStudents = value;
                    });
                  },
                ),
              ],
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
                            borderRadius: BorderRadius.circular(30.0))),
                  ),
                  onPressed: grade.isNotEmpty && noOfStudents != 0
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Gallery(
                                  initiativeTypeId: id,
                                  initiativeType: name,
                                  target: target,
                                  grade: grade,
                                  noOfStudents: noOfStudents),
                            ),
                          );
                        }
                      : null,
                  child: Text(
                    "Next",
                    style: TextStyle(
                      color: grade.isNotEmpty && noOfStudents != 0
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
