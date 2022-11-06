import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sbe/showFullImage.dart';

import 'globalvar.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
//changes for carousel start -1
  int activeIndex = 0;

  late TransformationController controller;
  TapDownDetails? tapDownDetails;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    img.clear();
    {
      categories[0]["images"] = categories[0]["images"].toString().substring(
          1,
          categories[0]["images"].toString().length -
              1); //get only the urls by removing square brackets

      categories[0]["images"] =
          categories[0]["images"].toString().split(","); // split the urls

      // assign the values

      for (var mx in categories[0]["images"]) {
        if (mx == "") continue;
        img.add(mx.toString().trim());
      }
    }
    if (img.length == 0) {
      img.add(noimglink);
    }
    controller = TransformationController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
//changes for carousel end -1

  var sdf = new ScrollController(initialScrollOffset: 0);
  @override
  Widget build(BuildContext context) {
    price = categories[0]["price"] == null
        ? "Contact for price details"
        : categories[0]["price"].toString();
    desc =
        categories[0]["desc"] == null ? "" : categories[0]["desc"].toString();

    // this section splits image urls from categories[0]["images"] and appends in the list img

    // price =
    //     "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";
    // desc = "qqqqqqqqqqqqqqqqqqqqq\n\n\n\n\qqqqqqqq ";
    // img = [
    //   "https://firebasestorage.googleapis.com/v0/b/vehicle-8c2b1.appspot.com/o/MainPage%2Fstar%2Fdatauser0com.example.anythingcachescaled_image_picker4762345049938705367.jpg?alt=media&token=ac262309-1538-4ce5-abef-1a6e59865105"
    // ];lib/landingpage2.dart
    return Scaffold(
      body: SizedBox(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height + 100,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CarouselSlider.builder(
                      itemCount: img.length,
                      options: CarouselOptions(
                          height: MediaQuery.of(context).size.height - 550,
                          enlargeCenterPage: true,
                          aspectRatio: 16 / 9,
                          autoPlay: true,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: img.length == 1
                              ? false
                              : true, // hjghbhjbjkhbbbbbbbbbbbbbbbbbbbbbbbbb see here
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                          onPageChanged: (index, reason) {
                            setState(() => activeIndex = index);
                          }),
                      itemBuilder: (context, index, realIndex) {
                        return InkWell(
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ShowFullmages(
                                        url: img[index],
                                      ))),
                          child: Container(
                            margin: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color:
                                  img[index] == noimglink ? null : Colors.grey,
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                fit: BoxFit.fitHeight,
                                image: NetworkImage(img[index]),
                              ),
                            ),
                          ),
                        );
                        //  GestureDetector(
                        //   onDoubleTapDown: (details) =>
                        //       tapDownDetails = details,
                        //   onDoubleTap: () {
                        //     final position = tapDownDetails!.localPosition;
                        //     final double scale = 3;
                        //     final x = -position.dx * (scale - 1);
                        //     final y = -position.dy * (scale - 1);

                        //     final zoomed = Matrix4.identity()
                        //       ..translate(x, y)
                        //       ..scale(scale);
                        //     final value = controller.value.isIdentity()
                        //         ? zoomed
                        //         : Matrix4.identity();
                        //     controller.value = value;
                        //   },
                        //   child: InteractiveViewer(
                        //     transformationController: controller,
                        //     child: Container(
                        //       margin: EdgeInsets.all(5.0),
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(10.0),
                        //         image: DecorationImage(
                        //           fit: BoxFit.cover,
                        //           image: NetworkImage(img[index]),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // );
                      }),
                ),
                Container(
                  child: desc == ""
                      ? null
                      : Expanded(
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 20, top: 10, right: 20),
                            child: Scrollbar(
                              controller:
                                  new ScrollController(initialScrollOffset: 0),
                              child: SingleChildScrollView(
                                controller: new ScrollController(
                                    initialScrollOffset: 0),
                                child: desc == ""
                                    ? null
                                    : Container(
                                        padding: const EdgeInsets.only(
                                            top: 8,
                                            bottom: 8,
                                            left: 12,
                                            right: 12),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Text(desc.toString(),
                                            style: TextStyle(fontSize: 18)),
                                      ),
                              ),
                            ),
                          ),
                        ),
                ),
                Container(
                  child: price == ""
                      ? null
                      : Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 20, top: 22, right: 20, bottom: 20),
                            child: Scrollbar(
                              isAlwaysShown: true,
                              controller: sdf,
                              child: SingleChildScrollView(
                                controller: sdf,
                                child: price == ""
                                    ? null
                                    : Container(
                                        width: 2000,
                                        padding: const EdgeInsets.only(
                                            top: 5,
                                            bottom: 15,
                                            left: 12,
                                            right: 12),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Text(
                                          price.toString(),
                                          style: TextStyle(fontSize: 18),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void deactivate() {
    super.deactivate();
  }
}