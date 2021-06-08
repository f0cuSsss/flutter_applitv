import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myflutter/screens/NoInternetScreen.dart';
import 'package:myflutter/utils/check_internet_connection.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatelessWidget {
  String url = "";

  VideoPlayerScreen({this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey<String>('video_player'),
      body: FutureBuilder<bool>(
        future: IsInternetConnected(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return SizedBox(width: 0, height: 0);
          }

          if (snapshot.data) {
            return _RemoteVideo(video_url: url);
          } else {
            return NoInternetScreen();
          }
        },
      ),
    );
  }
}

class _RemoteVideo extends StatefulWidget {
  String video_url;

  _RemoteVideo({this.video_url});

  @override
  _RemoteVideoState createState() => _RemoteVideoState();
}

class _RemoteVideoState extends State<_RemoteVideo> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.video_url,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize();
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            // padding: const EdgeInsets.all(20),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
                  // ClosedCaption(text: _controller.value.caption.text),
                  _ControlsOverlay(controller: _controller),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key key, this.controller}) : super(key: key);

  static const _examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            height: 60,
            width: MediaQuery.of(context).size.width * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.blueGrey.withOpacity(0.5),
            ),
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RawMaterialButton(
                  shape: CircleBorder(),
                  padding: const EdgeInsets.all(10.0),
                  focusColor: Colors.grey[600],
                  fillColor: Colors.black.withOpacity(0.5),
                  // autofocus: true,
                  child: Icon(
                    Icons.close,
                    size: 28,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                RawMaterialButton(
                  shape: CircleBorder(),
                  padding: const EdgeInsets.all(10.0),
                  focusColor: Colors.grey[600],
                  fillColor: Colors.black.withOpacity(0.5),
                  child: Icon(
                    Icons.fast_rewind,
                    size: 28,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    controller.seekTo(
                      Duration(
                        seconds: controller.value.position.inSeconds - 5,
                      ),
                    );
                  },
                ),
                RawMaterialButton(
                  shape: CircleBorder(),
                  padding: const EdgeInsets.all(10.0),
                  focusColor: Colors.grey[600],
                  fillColor: Colors.black.withOpacity(0.5),
                  child: Icon(
                    controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 28,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    controller.value.isPlaying
                        ? controller.pause()
                        : controller.play();
                  },
                ),
                RawMaterialButton(
                  shape: CircleBorder(),
                  padding: const EdgeInsets.all(10.0),
                  focusColor: Colors.grey[600],
                  fillColor: Colors.black.withOpacity(0.5),
                  child: Icon(
                    Icons.fast_forward,
                    size: 28,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    controller.seekTo(
                      Duration(
                        seconds: controller.value.position.inSeconds + 5,
                      ),
                    );
                  },
                ),
                // RawMaterialButton(
                //   shape: CircleBorder(),
                //   padding: const EdgeInsets.all(10.0),
                //   focusColor: Colors.grey[600],
                //   fillColor: Colors.black.withOpacity(0.5),
                //   // autofocus: true,
                //   child: PopupMenuButton<double>(
                //     color: Colors.blueGrey[600],
                //     initialValue: controller.value.playbackSpeed,
                //     tooltip: 'Playback speed',
                //     onSelected: (speed) {
                //       controller.setPlaybackSpeed(speed);
                //     },
                //     itemBuilder: (context) {
                //       return [
                //         for (final speed in _examplePlaybackRates)
                //           PopupMenuItem(
                //             value: speed,
                //             child: Text(
                //               '${speed}x',
                //               style: TextStyle(color: Colors.white70),
                //             ),
                //           )
                //       ];
                //     },
                //     child: Icon(
                //       Icons.speed,
                //       size: 28,
                //       color: Colors.white,
                //     ),
                //   ),
                //   onPressed: () => Navigator.pop(context),
                // ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
