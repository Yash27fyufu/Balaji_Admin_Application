import 'dart:async';

import 'package:sbe/globalvar.dart';
import 'package:sbe/mainpage.dart';
import 'package:sbe/storage_service.dart';
import 'package:sbe/updateData.dart';
import 'package:flutter/material.dart';

class GridWidget extends StatelessWidget {
  int length;
  Function acti;
  bool isSelected;
  List text;
  GridWidget({
    Key? key,
    required this.length,
    required this.text,
    required this.acti,
    required this.isSelected,
  }) : super(key: key);

  callupda(var context) {
    temp.clear();
    pickedimgList.clear();
    vehicleStream = database.child(pathxy).once().then((event) {
      dynamic data = event.snapshot.value;
      if (data["lp"] == "yes") {
        temp.add("yes");
        temp.add(event.snapshot.key);
        temp.add(data["images"]);

        temp.add(data["desc"]);
        temp.add(data["price"]);
      } else {
        temp.add("no");
        temp.add(event.snapshot.key);
        temp.add(data["images"]);

        // data["images"].toString() == "[]"
        //     ? temp.add([
        //         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTs0uyjWTrJw53i8IJPHJ3IIjxs3-UXMkN3LyaVEtU&s"
        //       ])
        //     : temp.add(data["images"]);

      }
    });

    var _timer = new Timer(const Duration(milliseconds: 800), () {
      temp[2] = temp[2].toString().substring(
          1,
          temp[2].toString().length -
              1); //get only the urls by removing square brackets

      temp[2] = temp[2].toString().split(","); // split the urls

      // assign the values

      for (var mx in temp[2]) {
        if (mx == "") continue;
        pickedimgList.add(mx);
      }

      alreadyimgcount = pickedimgList.length;

      for (var i = 2; i < temp.length; i++) {
        if (temp[i] == null) {
          temp[i] = "";
        }
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UpdateDetails(),
        ),
      );
    });

    // Future.delayed(Duration(milliseconds: 10000), () {
    //   // temp[2] = temp[2].toString().substring(
    //   //     1,
    //   //     temp[2].toString().length -
    //   //         1); //get only the urls by removing square brackets

    //   // temp[2] = temp[2].toString().split(","); // split the urls

    //   // // assign the values

    //   // pickedimgList = temp[2];

    //   // alreadyimgcount = pickedimgList.length;

    //   // Navigator.pushReplacement(
    //   //   context,
    //   //   MaterialPageRoute(
    //   //     builder: (context) => UpdateDetails(),
    //   //   ),
    //   // );
    // });
  }

  Storage storage = new Storage();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: storage.loadImages(),
        builder: (context, AsyncSnapshot<List> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 1,
              ),
              padding: EdgeInsets.only(top: 5, left: 5, right: 5),
              itemCount: length,
              itemBuilder: (context, idx) {
                return InkWell(
                  onTap: () {
                    pgtitle = categories[idx];

                    pathxy += "/" + categories[idx];
                    !isSelected
                        ? callupda(context)
                        : Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home(
                                      title: categories[idx],
                                    )),
                          );
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            child: Image.network(
                              img[idx].toString().trim(),
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                       
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    text[idx].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 15),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              IconButton(
                                iconSize: 22,
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Delete ${text[idx]}"),
                                          content: Text(
                                              "Are you sure you want to delete?"),
                                          actions: [
                                            RawMaterialButton(
                                              onPressed: () {
                                                gotolastpage(context);
                                              },
                                              child: Text("No"),
                                            ),
                                            RawMaterialButton(
                                                onPressed: () {
                                                  database
                                                      .child(pathxy)
                                                      .child(text[idx])
                                                      .remove()
                                                      .whenComplete(() {
                                                    gotolastpage(context);
                                                  });
                                                  final snackBar = SnackBar(
                                                    content: Text(
                                                        'Deleted ${text[idx]}'),
                                                  );

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                },
                                                child: Text("Yes "))
                                          ],
                                        );
                                      });
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
