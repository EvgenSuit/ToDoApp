import 'dart:io';
import 'dart:ui' as ui;
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'todo_page.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  CameraController? controller;
  FaceDetector? _faceDetector;
  bool _isCameraInitialized = false;
  bool doesSmile = false;
  List<Face>? _faces;
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;

  initializeCamera() async {
    final cameras = await availableCameras();
    _controller =
        CameraController(cameras[1], ResolutionPreset.high, enableAudio: false);
    setState(() {
      _initializeControllerFuture = _controller.initialize();
    });
  }

  loadModel() {
    final FaceDetector faceDetector = GoogleVision.instance.faceDetector(
        FaceDetectorOptions(
            mode: FaceDetectorMode.accurate, enableClassification: true));
    setState(() {
      _faceDetector = faceDetector;
    });
  }

  detectFaces() async {
    final image = await _controller.takePicture();
    final imFile = File(image.path);
    final visionImage = GoogleVisionImage.fromFile(imFile);
    final faces = await _faceDetector?.processImage(visionImage);
    setState(() {
      _faces = faces;
    });
    transferToMainPage();
  }

  transferToMainPage() {
    if (_faces != null) {
      for (var face in _faces!) {
        if (face.smilingProbability! > 0.5) {
          setState(() {
            doesSmile = true;
          });
        }
      }
    }

    if (doesSmile) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ToDoApp(),
        ),
      );
    }
  }

  void initState() {
    super.initState();
    initializeCamera();
    loadModel();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in using mood detection'),
        toolbarHeight: 60,
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Expanded(
                flex: 2,
                child: FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CameraPreview(_controller);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              Center(
                child: TextButton(
                  child: Text('Sign in'),
                  onPressed: () {
                    detectFaces();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
