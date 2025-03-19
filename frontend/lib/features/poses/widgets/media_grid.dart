import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:frontend/models/pose_model.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// import 'package:aperturama/utils/main_drawer.dart';
// import '../utils/user.dart';

// TODO Move this to media widgets, make it take in a custom POSE card for formatting from pose widget
import 'package:frontend/core/utils/media.dart';

class MediaList extends StatefulWidget {
  const MediaList({super.key});

  @override
  State<MediaList> createState() => _MediaListState();
}

class _MediaListState extends State<MediaList> {
  int _gridSize = 0; // Start at 0 and set during the first build
  int _gridSizeMax = 0; // Start at 0 and set during the first build
  String jwt = "";
  String code = "";

  // TODO: Enable swipe down to reload

  // Store the URLs for all the photos the app needs to download and cache
  Future<List> _getMediaList() async {

    List media = [];
    return media;

  //
  //   // Send a request to the backend
  //   String serverAddress = await User.getServerAddress();
  //   jwt = await User.getJWT();
  //   http.Response resp;
  //   try {
  //     resp = await http.get(Uri.parse(serverAddress + '/api/v1/media'),
  //         headers: { HttpHeaders.authorizationHeader: 'Bearer ' + jwt });
  //
  //     if(resp.statusCode != 200) {
  //       log("Media listing failed: Code " + resp.statusCode.toString());
  //       return media;
  //     }
  //
  //     final responseJson = jsonDecode(resp.body);
  //
  //     // For each media item we got
  //     for (int i = 0; i < responseJson.length; i++) {
  //       media.add(Media(
  //         responseJson[i]["media_id"].toString(), MediaType.photo,
  //         serverAddress + "/api/v1/media/" + responseJson[i]["media_id"].toString() + '/thumbnail',
  //         serverAddress + "/api/v1/media/" + responseJson[i]["media_id"].toString() + '/media',
  //       ));
  //       media[i].filename = responseJson[i]["filename"];
  //       media[i].takenTimestamp = (responseJson[i]["date_taken"] != null) ? DateTime.parse(responseJson[i]["date_taken"]) : DateTime.now();
  //     }
  //
  //   } on SocketException {
  //     log("Media listing failed: Socket exception");
  //     return media;
  //   }
  //
  //   // TODO: Save and load from disk if network is unavailable
  //
  //   return media;
  }

  // Function to handle changing the size of the photo grid
  void _changeGridSize(int amount) {
    // Make sure the grid size can't go below 1 or above the max size

    if (_gridSize > 10) {
      amount *= kIsWeb ? 2 : 1;
    }

    if (amount < 0) {
      if (_gridSize + amount <= 0) {
        _gridSize = 1;
      } else {
        _gridSize += amount;
      }
    } else if (amount > 0) {
      if (_gridSize + amount >= _gridSizeMax) {
        _gridSize = _gridSizeMax;
      } else {
        _gridSize += amount;
      }
    }
    setState(() {
      _gridSize;
    });
  }

  @override
  Widget build(BuildContext context) {

    // Set up the initial grid sizing
    // TODO: This doesn't reload when a web browser's size is changed, should probably be fixed
    if (_gridSize == 0 && _gridSizeMax == 0) {
      double width = MediaQuery.of(context).size.width;
      _gridSize = math.max(4, (width / 200.0).round());
      _gridSizeMax = math.max(8, (width / 100.0).round());
      debugPrint('$width $_gridSize $_gridSizeMax');
    }

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Aperturama"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () {
                _changeGridSize(1);
              },
              tooltip: 'Decrease Image Size',
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                _changeGridSize(-1);
              },
              tooltip: 'Increase Image Size',
            ),
          ],
        ),
        body: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Container(
          //   child: kIsWeb ? const MainDrawer() : null,
          // ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _getMediaList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!.isNotEmpty ? MediaGrid(snapshot.data!, _gridSize, jwt, code)
                      : const Center(child: Text("No media items found."));
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Error"));
                }
                return const Center(child: Text("Loading..."));
              },
            ),
          ),
        ]),
        drawer: null
    ); //kIsWeb ? null : const MainDrawer());
  }
}

class MediaGrid extends StatelessWidget {
  const MediaGrid(this.media, this.gridSize, this.jwt, this.code, {Key? key}) : super(key: key);

  final List media; // TODO change all list dynamics to something better
  final int gridSize;
  final String jwt;
  final String code;

  Widget _createTappableMediaIcon(BuildContext context, PoseModel poses) {
    // Make a nice button that has the thumbnail inside it
    return GestureDetector(
      onTap: () =>
      { Navigator.pushNamed(
        context,
        '/media_viewer',
        arguments: <String, dynamic>{
          'media': poses,
          'jwt': jwt,
          'code': "",
        },
      )},
      child: MediaIcon(poses, jwt, code),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      // This is needed for the shared media page
      // so that it doesn't scroll within the larger scrollable list
      physics: const ClampingScrollPhysics(),
      gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: gridSize),
      itemBuilder: (BuildContext context, int index) {
        return _createTappableMediaIcon(context, media[index]);
      },
      itemCount: media.length,
    );
  }
}

class MediaIcon extends StatelessWidget {
  const MediaIcon(final this.poses, this.jwt, this.code, {Key? key}) : super(key: key);

  final PoseModel poses;
  final String jwt;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Center(
        child: CachedNetworkImage(
            httpHeaders: { HttpHeaders.authorizationHeader: 'Bearer ' + jwt },
            imageUrl: poses.primaryImageId + (code.isEmpty ? "" : "?code=" + code),
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                SizedBox(width: 32, height: 32, child: CircularProgressIndicator(value: downloadProgress.progress)),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            imageBuilder: (context, imageProvider) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}