import 'package:flutter/material.dart';
import 'collectibles.dart';
import 'package:frontend/pages/initiative_details.dart';

class InitiativesForInitiativeWidget extends StatelessWidget {
  final String id;
  final String initiativeTypeId;
  final int target;
  final int numberOfStudents;
  final String grade;
  final String name;
  final List<String> images;

  const InitiativesForInitiativeWidget(
      {super.key,
      required this.initiativeTypeId,
      required this.id,
      required this.images,
      required this.target,
      required this.numberOfStudents,
      required this.grade,
      required this.name});

  @override
  Widget build(context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        CollectiblesWidget(
          collectibleImage: images.isNotEmpty ? images[0] : '',
          dimension: 120,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.length > 25 ? '${name.substring(0, 25)}...' : name,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(fontSize: width <= 351 ? 15 :18, fontWeight: FontWeight.w700),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(grade),
              ),
              ButtonTheme(
                child: SizedBox(
                  width: width <= 351 ? 160 : 200,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => InitiativesDetailsWidget(id: id),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
                      ),
                      child: const Text("View",style: TextStyle(color: Colors.white))),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
