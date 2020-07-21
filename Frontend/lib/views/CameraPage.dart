
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:io';
import 'dart:convert';

import '../services/api.services.dart';

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

          //grab picture in base64
          getBase64Pic().then((encoded) => {
            
            Query(
              options: QueryOptions(
                documentNode: gql(GET_BOOK),
                variables: {
                  'imgBinary': encoded
                }
              ),

              builder: (QueryResult result, {VoidCallback refetch, FetchMore fetchMore}) {

                if (result.hasException) {
                  // print(result.exception);
                }

                if (result.loading) {
                }

                // print('resutl'+result.data.toString());

              }
            )

          });


        },
      ),
    );
  }

  Future<String> getBase64Pic() async {

    try {
      await _initalizedControllerFuture;

      final path = join((await getTemporaryDirectory()).path, '${DateTime.now()}.png' ); 

      ImageCache().clear();
      await _controller.takePicture(path);

      List<int> bytes = await File(path).readAsBytes(); 
      return base64.encode(bytes);

    } catch(e) {
      print(e);

    }

  }
}
