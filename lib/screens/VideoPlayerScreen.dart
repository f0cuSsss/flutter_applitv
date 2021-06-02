import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatelessWidget {
  String url = "";

  VideoPlayerScreen({this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey<String>('video_player'),
      body: _RemoteVideo(video_url: url),
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
                  ClosedCaption(text: _controller.value.caption.text),
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
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: 50,
          color: Colors.blueGrey,
          child: Column(
            children: [
              //     RawMaterialButton(
              //   shape: CircleBorder(),
              //   padding: const EdgeInsets.all(10.0),
              //   focusColor: Colors.grey[600],
              //   fillColor: Colors.black,
              //   // autofocus: true,
              //   child: Icon(
              //     controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              //     size: 28,
              //     color: Colors.white,
              //   ),
              //   onPressed: () {
              //     controller.value.isPlaying
              //         ? controller.pause()
              //         : controller.play();
              //   },
              // ),
              // Align(
              //   alignment: Alignment.topRight,
              //   child: PopupMenuButton<double>(
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
              //             child: Text('${speed}x'),
              //           )
              //       ];
              //     },
              //     child: Padding(
              //       padding: const EdgeInsets.symmetric(
              //         vertical: 12,
              //         horizontal: 16,
              //       ),
              //       child: Text('${controller.value.playbackSpeed}x'),
              //     ),
              //   ),
              // ),
              // Align(
              //   alignment: Alignment.topLeft,
              //   child: IconButton(
              //     icon: Icon(Icons.close),
              //     onPressed: () => Navigator.pop(context),
              //   ),
              // ),
            ],
          ),
        )
      ],
    );
  }
}
