import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:smr_app/ux/context.dart';
import 'package:smr_app/ux/widgets/ml_vision_camera.dart';

class FaceDetectionCamera extends StatefulWidget {
  const FaceDetectionCamera({this.onFacesChanged});

  final ValueChanged<List<Face>> onFacesChanged;

  @override
  _FaceDetectionCameraState createState() => _FaceDetectionCameraState();
}

class _FaceDetectionCameraState extends State<FaceDetectionCamera> with WidgetContext {
  int detectedFaces = 0;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SizedBox(
        width: 175,
        child: RotatedBox(
          quarterTurns: 1,
          child: MlVisionCamera<List<Face>>(
            detector: FirebaseVision.instance.faceDetector().processImage,
            cameraLensDirection: CameraLensDirection.front,
            resolution: ResolutionPreset.low,
            overlayBuilder: (context) {
              return RotatedBox(
                quarterTurns: 3,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: StreamBuilder<bool>(
                    initialData: backend.faceService.facesPresent,
                    stream: backend.faceService.facesPresentStream,
                    builder: (context, snapshot) {
                      return Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Text(
                          'Faces: $detectedFaces\nFacesPresent: ${snapshot.data}',
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            onResult: (faces) {
              if (detectedFaces != faces.length) {
                setState(() {
                  widget.onFacesChanged(faces);
                  detectedFaces = faces.length;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
