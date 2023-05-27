import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Pages/setup_initiativet_target.dart';
import 'package:http/http.dart' as http;

class SetupInitiative extends StatefulWidget {
  const SetupInitiative({Key? key}) : super(key: key);

  @override
  State<SetupInitiative> createState() => _InitiativeState();
}

class _InitiativeState extends State<SetupInitiative> {
  List<dynamic> initiativeTypes = [];
  String selectedOption = '';

  late var id = '';
  late var name = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await http.get(Uri.parse(
          'https://ddxiecjzr8.execute-api.us-east-1.amazonaws.com/v1/initiative-types'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['message'] == 'success') {
          setState(() {
            initiativeTypes = data['data'];
            isLoading = false;
          });
        }
      } else {
        log('Failed to fetch data: ${response.statusCode}');
        isLoading = false;
      }
    } catch (error) {
      log('Failed to fetch data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = Container(
      margin: const EdgeInsets.only(top: 20, right: 30, left: 30, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Set up your initiative',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'What are you fundraising for?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(112, 112, 112, 1),
            ),
          ),
          const SizedBox(height: 10),
          isLoading
              ? Column(children: const [
                  SizedBox(height: 30),
                  Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      color: Color.fromRGBO(54, 189, 151, 1),
                    ),
                  ),
                ])
              : Expanded(
                  child: ListView.builder(
                    itemCount: initiativeTypes.length,
                    itemBuilder: (context, index) {
                      final initiativeType = initiativeTypes[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            id = initiativeType['id'];
                            selectedOption = initiativeType['name'];
                            if (initiativeType['name'] !=
                                'Other (enter below)') {
                              name = initiativeType['name'];
                            }
                          });
                        },
                        child: ListTile(
                          title: Row(
                            children: [
                              Expanded(child: Text(initiativeType['name'])),
                              Radio(
                                value: initiativeType['name'],
                                groupValue: selectedOption,
                                onChanged: (value) {
                                  setState(() {
                                    id = initiativeType['id'];
                                    selectedOption = value;
                                    if (initiativeType['name'] !=
                                        'Other (enter below)') {
                                      name = initiativeType['name'];
                                    }
                                  });
                                },
                                activeColor: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
          if (selectedOption == 'Other (enter below)')
            Container(
              alignment: Alignment.center,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  enabled: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter your customized type',
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
                      name = value;
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
                    const Color.fromRGBO(54, 189, 151, 1),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                onPressed: name.isNotEmpty
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SetupInitiativeTarget(name: name, id: id),
                          ),
                        );
                      }
                    : null,
                child: Text(
                  "Next",
                  style: TextStyle(
                    color: name.isNotEmpty
                        ? Colors.white
                        : const Color.fromARGB(255, 212, 211, 211),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset("assets/svg/Vector.svg"),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Setup Initiative',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxHeight > MediaQuery.of(context).size.height) {
            return SingleChildScrollView(child: content);
          } else {
            return content;
          }
        },
      ),
    );
  }
}
