import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (BuildContext context) {
          return MyHomePage();
        },
//        '/my_second_page': (BuildContext context) {
//          return MySecondPage();
//        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;
  List<Face> allFaces;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
      scanImage(_image);
    });
  }

  Future scanImage(File _image) async {
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(_image);
    final FaceDetector faceDetector = FirebaseVision.instance.faceDetector(FaceDetectorOptions(enableClassification: true));
    List<Face> allFaces = await faceDetector.detectInImage(visionImage);
    for (Face face in allFaces) {
      if (face.smilingProbability != null) {
        final double smileProb = face.smilingProbability;
        if(smileProb>=0.80){
          print("Happy!");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Welcome to Moodsic!'),
        ),
        body: new Center(
          child: _image == null
              ? new Text('Moodsic\nMusic to Fit Your Mood')
              : new Image.file(_image),
        ),
        floatingActionButton: new FloatingActionButton(
          onPressed: getImage,
          tooltip: 'Pick Image',
          child: new Icon(Icons.add_a_photo),
        ),
    );
  }
}