import 'package:flutter/material.dart';
import 'collectibles.dart';

class SingleInitiativeWidget extends StatelessWidget {
  final List<String> images;
  final String firstName;
  final String lastName;

  const SingleInitiativeWidget(
      {super.key,
      required this.images,
      required this.firstName,
      required this.lastName});

  @override
  Widget build(context) {
    return Column(
      children: [
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$firstName $lastName",
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
              "${images.length} ${images.length > 1 ? 'works' : 'work'}",
              style: const TextStyle(fontSize: 12)),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              ...images.map((e) => Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, top: 20),
                      child: CollectiblesWidget(
                        collectibleImage: e,
                        dimension: 150,
                      ),
                    ),
                  ))
            ]),
          ),
        )
      ],
    );
  }
}
