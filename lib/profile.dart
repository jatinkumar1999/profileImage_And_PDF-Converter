import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

CollectionReference imageRef;
firebase_storage.Reference ref;
List<File> image;
final picker = ImagePicker();
bool isloading = false;
double val = 0;

class _ProfileState extends State<Profile> {
  bool checked = true;
  @override
  Widget build(BuildContext context) {
    String imgurl;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          imgurl == null ? chooseimage() : uploadimage(imgurl),
          SizedBox(
            height: 30.0,
          ),
          Container(
            child: Text('Jatin Kumar',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                )),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Text(
              "bhardwajjatin1999@gmail.com",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget chooseimage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2.3,
      padding: EdgeInsets.only(top: 80),
      child: Center(
        child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black26,
                width: 5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
              borderRadius: BorderRadius.circular(100),
              color: Colors.blue[100],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    chooseImage();
                  },
                  child: Icon(
                    Icons.photo,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "choose photo",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget uploadimage(imageurl) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2.7,
        padding: EdgeInsets.only(top: 80),
        child: Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
              borderRadius: BorderRadius.circular(100),
            ),
            child: Image.asset(
              imageurl,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
        ));
  }

  chooseImage() async {
    final pickedfiles = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      image.add(File(pickedfiles?.path));
    });
    if (pickedfiles.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        image.add(File(response.file.path));
      });
    } else {
      print(response.file);
    }
  }

  Future<void> uploadImage() async {
    for (var img in image) {
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child("images//${Path.basename(img.path)}");
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          imageRef.add({"URl": value});
        });
      });
    }
  }

  @override
  void initState() {
    imageRef = FirebaseFirestore.instance.collection('imagesUrl');
    super.initState();
  }
}
