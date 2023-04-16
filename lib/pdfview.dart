import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:share_plus/share_plus.dart';

import 'globalvar.dart';
import 'mainpage.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:path_provider/path_provider.dart';

void main() async {
  runApp(MaterialApp(home: PDFViewpage()));
}

class PDFViewpage extends StatefulWidget {
  @override
  State<PDFViewpage> createState() => _PDFViewpageState();
}

class _PDFViewpageState extends State<PDFViewpage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filenameinurl = pdfurl.toString().substring(
        pdfurl.toString().lastIndexOf("%2F") + 3,
        pdfurl.toString().lastIndexOf("?alt="));
    asd = pathxy.toString().replaceAll("/", "");

    downloadfile();
  }

  @override
  Widget build(BuildContext context) {
    String pdfpagetitle = "View PDF";

    pdfpagetitle = pgtitle.toString();
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Home(
                      title: pgtitle,
                    )),
          );
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(pdfpagetitle), //appbar title
              backgroundColor: Colors.amber, //appbar background color

              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: IconButton(
                    iconSize: 20,
                    icon: const Icon(Icons.share),
                    onPressed: () {
                      sharefile(asd);
                      // ...
                    },
                  ),
                ),
              ],
            ),
            body: Container(
                child: isloadin
                    ? Center(child: CircularProgressIndicator())
                    : PDF().cachedFromUrl(
                        pdfurl,
                        maxAgeCacheObject:
                            const Duration(days: 7), //duration of cache
                        placeholder: (progress) =>
                            Center(child: Text('$progress %')),
                        errorWidget: (error) =>
                            Center(child: Text(error.toString())),
                      ))));
  }

  downloadfile() async {
    //check for permission
    var status = await Permission.storage.status;

    if (status.isDenied) {
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
    }
    status = await Permission.storage.status;
    if (status.isDenied) {
      return;
    }

    setState(() {
      isloadin = true;
    });

    if (!await Directory('storage/emulated/0/Download/SBE/$asd').exists()) {
      await Directory('storage/emulated/0/Download/SBE/$asd').create();
      savethepdfindevice(asd);
    } else {
      setState(() {
        isloadin = false;
      });
      print("object");
      var filesinfolder =
          await Directory('storage/emulated/0/Download/SBE/$asd')
              .listSync(recursive: true, followLinks: false)[0]
              .toString();

      var filenameindevice = filesinfolder.substring(
          filesinfolder.lastIndexOf("/") + 1, filesinfolder.length - 5);
      print(filenameindevice);
      print(filenameinurl);

      if (filenameindevice != filenameinurl) {
        print(filesinfolder.toString().substring(7, filesinfolder.length - 1));
        deleteFile(File(
            filesinfolder.toString().substring(7, filesinfolder.length - 1)));
        savethepdfindevice(asd);
      }
    }

    //share file;

    // delete the locally stored file

    //deleteFile(File('/storage/emulated/0/Download/sdff.pdf'));
  }

////////   next time before updating do so that the pdf is stored in downloads in some folder to reduce bandwidth consumption in firebase
  ///
  ///also while storing in firebase do so that the uploaded file is stored with datet and time so that whenever user requests for a pdf to view
  ///
  ///it will check fo rthe name in storage with the name in firebase if it matches then load form storage or else download form firebse delete the old one and continue..........

  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {}
  }

  savethepdfindevice(asd) async {
    // write file in local storage
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(pdfurl));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);

    File file =
        File('/storage/emulated/0/Download/SBE/$asd/$filenameinurl.pdf');
    await file.writeAsBytes(bytes);

    setState(() {
      isloadin = false;
    });
  }

  sharefile(asd) async {
    await Share.shareFiles(
        ['/storage/emulated/0/Download/SBE/$asd/$filenameinurl.pdf']);
  }
}
