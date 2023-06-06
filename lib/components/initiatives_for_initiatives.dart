import 'package:flutter/material.dart';
import 'collectibles.dart';
// import 'package:frontend/Pages/gallery.dart';
import 'package:frontend/Pages/initiative_details.dart';

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
    return Row(
      children: [
        CollectiblesWidget(
          collectibleImage: images.isNotEmpty? images[0] : '',
          dimension: 120,
        ),
        // CachedNetworkImage(
        //     width: 140,
        //     height: 140,
        //     fit: BoxFit.cover,
        //     imageUrl: images[0],
        //     progressIndicatorBuilder: (context, url, downloadProgress) =>
        //         SizedBox(
        //           height: 100,
        //           width: 100,
        //           child: CircularProgressIndicator(
        //               valueColor: const AlwaysStoppedAnimation<Color>(
        //                   Theme.of(context).colorScheme.secondary),
        //               value: downloadProgress.progress),
        //         )),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text("$grade Grade"),
              ),
              // Row(
              //   children: [
              //     const Text("Amount Raised"),
              //     Padding(
              //         padding: const EdgeInsets.only(left: 50),
              //         child: Text(
              //           target.toString(),
              //           style: const TextStyle(fontWeight: FontWeight.w700),
              //         )),
              //   ],
              // ),
              ButtonTheme(
                child: SizedBox(
                  width: 220,
                  child: ElevatedButton(
                      // onPressed: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (_) => Gallery(
                      //           isUpdate: true,
                      //           updateInitiativeId: id,
                      //           initiativeTypeId: initiativeTypeId,
                      //           initiativeType: name,
                      //           target: target,
                      //           grade: grade,
                      //           noOfStudents: numberOfStudents),
                      //     ),
                      //   );
                      // },
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
                                      borderRadius:
                                          BorderRadius.circular(30.0)))),
                      child: const Text("View")),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
