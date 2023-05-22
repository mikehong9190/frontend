import 'package:flutter/material.dart';
import 'package:frontend/Pages/setup_initiative.dart';

class Initiative extends StatefulWidget {
  const Initiative({super.key});

  @override
  State<Initiative> createState() => _InitiativeState();
}

class _InitiativeState extends State<Initiative> {
  @override
  Widget build(context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            const Spacer(),
            Image.asset("assets/images/swiirl-black.png"),
            const SizedBox(
              height: 30,
            ),
            ButtonTheme(
              child: SizedBox(
                height: 70,
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromRGBO(0, 0, 0, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)))),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SetupInitiative(),
                      ),
                    );
                  },
                  child: const Text("Start a new Initiative !"),
                ),
              ),
            ),
          ],
        ));
  }
}
