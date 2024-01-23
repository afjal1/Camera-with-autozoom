import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:gsoc/main.dart';
import 'package:gsoc/start.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

class CameraPage extends StatefulWidget {
  const CameraPage({super.key, required this.cameras});

  final List<CameraDescription>? cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  bool _isRearCameraSelected = true;
  tfl.Interpreter? interpreter;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadModel();
    initCamera(widget.cameras![0]);
  }

  final tfl.InterpreterOptions interpreterOptions = tfl.InterpreterOptions()
    ..addDelegate(tfl.GpuDelegateV2(
        options: tfl.GpuDelegateOptionsV2(
      isPrecisionLossAllowed: false,
    )));

  Future takePicture() async {
    // stop image stream
    _cameraController.stopImageStream();
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      // await _cameraController.setFlashMode(FlashMode.off);
      XFile picture = await _cameraController.takePicture();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ImageView(path: picture.path)));
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {
          _cameraController.startImageStream((image) {
            if (!mounted) return;
            setState(() {
              img = image;
              runModel();
            });
          });
        });
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  CameraImage? img;
  String output = '';
  double zoomLevel = 1.0; // initial zoom level
  double maxAvailableZoom = 1.0; //
  runModel() async {
    double maxZoomLevel = await _cameraController.getMaxZoomLevel();
    try {
      if (img != null) {
        final imgBytes = img!.planes.map((plane) {
          return plane.bytes;
        }).toList();
        final imgHeight = img!.height;
        final imgWidth = img!.width;
        final inputSize = imgHeight * imgWidth;
        final input = imgBytes.reshape([1, inputSize]);
        int startTime = DateTime.now().millisecondsSinceEpoch;

        interpreter!.run(input, output);
        print(output);
        final recognitions = output[0];

        int endTime = DateTime.now().millisecondsSinceEpoch;
        print("Detection took ${endTime - startTime}");

        // if (recognitions[0]['label'] == 'Labrador retriever') {
        //   double newZoomLevel = maxZoomLevel / 2;
        //   _cameraController.setZoomLevel(newZoomLevel);
        // }

        // await Tflite.runModelOnFrame(
        //   bytesList: img!.planes.map((plane) {
        //     return Uint8List.fromList(plane.bytes);
        //   }).toList(),
        //   imageHeight: img!.height,
        //   imageWidth: img!.width,
        //   numResults: 2,
        //   asynch: true,
        //   threshold: 0.1,
        //   rotation: 90,
        // ).then((recognitions) {
        //   int endTime = DateTime.now().millisecondsSinceEpoch;
        //   print("Detection took ${endTime - startTime}");
        //   setState(() {
        //     output = recognitions![0]['label'];
        //     if (output == 'Labrador retriever') {
        //       double newZoomLevel = maxZoomLevel / 2;
        //       _cameraController.setZoomLevel(newZoomLevel);
        //     }
        //   });
        // });
      }
    } catch (e) {
      print(e);
    }
  }

  Future loadModel() async {
    interpreter = await tfl.Interpreter.fromAsset(
        'assets/mobilenet_v1_1.0_224.tflite',
        options: interpreterOptions);

    print('Model loaded');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        (_cameraController.value.isInitialized)
            ? CameraPreview(_cameraController)
            : Container(
                color: Colors.black,
                child: const Center(child: CircularProgressIndicator())),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.20,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  color: Colors.black),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                    child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 30,
                  icon: Icon(
                      _isRearCameraSelected
                          ? CupertinoIcons.switch_camera
                          : CupertinoIcons.switch_camera_solid,
                      color: Colors.white),
                  onPressed: () {
                    setState(
                        () => _isRearCameraSelected = !_isRearCameraSelected);
                    initCamera(widget.cameras![_isRearCameraSelected ? 0 : 1]);
                  },
                )),
                Expanded(
                    child: IconButton(
                  onPressed: takePicture,
                  iconSize: 50,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.circle, color: Colors.white),
                )),
                const Spacer(),
              ]),
            )),
      ]),
    ));
  }
}

class ImageView extends StatefulWidget {
  final String path;
  const ImageView({super.key, required this.path});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  Future<void> saveImageToGallery(String imagePath) async {
    try {
      final result = await GallerySaver.saveImage(imagePath);
      print('Image saved to gallery: $result');
    } catch (e) {
      print('Failed to save image to gallery: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await saveImageToGallery(widget.path).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Image saved to gallery'),
              ));
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Start()));
            });
          },
          child: const Icon(Icons.save),
        ),
        body: Center(
          child: Image.file(File(widget.path)),
        ));
  }
}




// Load model

// Prepare input


// Run model on frame


// Process output
