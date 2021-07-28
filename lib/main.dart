import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_converter/profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: Profile(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final picker = ImagePicker();
  final pdf = pw.Document();

  File _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Coverter"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                createpdf();
                savepdf();
              },
              icon: Icon(Icons.picture_as_pdf))
        ],
      ),
      body: _image != null
          ? Container(
              height: 400,
              width: double.infinity,
              margin: EdgeInsets.all(8),
              child: Image.file(
                _image,
                fit: BoxFit.cover,
              ))
          : Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          chooseimageFormGallery();
        },
        child: Icon(
          Icons.add_a_photo,
        ),
      ),
    );
  }

  chooseimageFormGallery() async {
    final pickedfile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedfile != null) {
        _image = File(pickedfile.path);
      } else {
        print("No image selected");
      }
    });
  }

  createpdf() async {
    final image = pw.MemoryImage(_image.readAsBytesSync());
    pdf.addPage(
      pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image),
            );
          }),
    );
  }

  savepdf() async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/filename.pdf');
      await file.writeAsBytes(await pdf.save());
    } catch (e) {
      print(e.toString());
    }
  }
}
