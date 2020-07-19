
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  final CameraDescription camera;

  const CameraPage({
    Key key,
    @required this.camera,
  }) : super(key:key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {

  CameraController _controller;
  Future<void> _initalizedControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initalizedControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initalizedControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {

            return CameraPreview(_controller);

          } else {
            return Center(child: CircularProgressIndicator());
          }

        }
      ),

      floatingActionButton: FloatingActionButton(
        child: Text("P"),

        onPressed: () async {

          try {
            await _initalizedControllerFuture;

            final path = join((await getTemporaryDirectory()).path, '${DateTime.now()}.png' ); 

            await _controller.takePicture(path);

          } catch(e) {
            print(e);

          }

        },
      ),
    );
  }
}