import 'package:flutter/material.dart';

import 'package:flutter_netflix_responsive_ui/widgets/widgets.dart';
import 'package:video_player/video_player.dart';

import '../models/content_model.dart';

class ContentHeader extends StatelessWidget {
  final Content featuredContent;
  const ContentHeader({
    Key? key,
    required this.featuredContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: _ContentHeaderMobile(featuredContent: featuredContent),
        tablet: _ContentHeaderMobile(featuredContent: featuredContent),
        desktop: _ContentHeaderDesktop(featuredContent: featuredContent));
  }
}

class _ContentHeaderMobile extends StatelessWidget {
  final Content featuredContent;
  const _ContentHeaderMobile({
    Key? key,
    required this.featuredContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        height: 500.0,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(featuredContent.imageUrl), fit: BoxFit.cover),
        ),
      ),
      Container(
        height: 500.0,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
      ),
      Positioned(
        bottom: 10.0,
        right: 0.0,
        left: 0.0,
        child: SizedBox(
          height: 250.0,
          child: Image.asset(featuredContent.titleImageUrl!),
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 40.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            VerticalIconButton(
                icon: Icons.add,
                title: 'List',
                onTap: () => debugPrint('My List')),
            const _PlayButton(),
            VerticalIconButton(
                icon: Icons.info_outline,
                title: 'Info',
                onTap: () => debugPrint('Info')),
          ],
        ),
      )
    ]);
  }
}

class _ContentHeaderDesktop extends StatefulWidget {
  final Content featuredContent;
  const _ContentHeaderDesktop({
    Key? key,
    required this.featuredContent,
  }) : super(key: key);

  @override
  State<_ContentHeaderDesktop> createState() => _ContentHeaderDesktopState();
}

class _ContentHeaderDesktopState extends State<_ContentHeaderDesktop> {
  late VideoPlayerController _playerController;
  bool _isMuted = true;

  @override
  void initState() {
    super.initState();
    _playerController =
        VideoPlayerController.network(widget.featuredContent.videoUrl!)
          ..initialize().then((_) {
            setState(() {});
          })
          ..setVolume(0)
          ..play();
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _playerController.value.isPlaying
          ? _playerController.pause()
          : _playerController.play(),
      child: Stack(alignment: Alignment.bottomLeft, children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: -1.0,
          child: AspectRatio(
            aspectRatio: _playerController.value.isInitialized
                ? _playerController.value.aspectRatio
                : 2.344,
            child: _playerController.value.isInitialized
                ? VideoPlayer(_playerController)
                : Image.asset(
                    widget.featuredContent.imageUrl,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        AspectRatio(
          aspectRatio: _playerController.value.isInitialized
              ? _playerController.value.aspectRatio
              : 2.344,
          child: Container(
            height: 500.0,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
        ),
        Positioned(
          left: 60.0,
          right: 60.0,
          bottom: 150.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 250.0,
                child: Image.asset(widget.featuredContent.titleImageUrl!),
              ),
              const SizedBox(height: 15.0),
              Text(
                widget.featuredContent.description!,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(2.0, 4.0),
                        blurRadius: 6.0,
                      ),
                    ]),
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  const _PlayButton(),
                  const SizedBox(width: 16.0),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      padding:
                          const EdgeInsets.fromLTRB(25.0, 10.0, 30.0, 10.0),
                    ),
                    onPressed: () => debugPrint('More Info'),
                    icon: const Icon(
                      Icons.info_outline,
                      color: Colors.black,
                      size: 30.0,
                    ),
                    label: const Text('More Info',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black)),
                  ),
                  const SizedBox(width: 20.0),
                  if (_playerController.value.isInitialized)
                    IconButton(
                      icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
                      iconSize: 30.0,
                      onPressed: () {
                        setState(() {
                          _isMuted
                              ? _playerController.setVolume(100)
                              : _playerController.setVolume(0);
                          _isMuted = _playerController.value.volume == 0;
                        });
                      },
                    ),
                ],
              ),
            ],
          ),
        )
      ]),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: !Responsive.isDesktop(context)
          ? const EdgeInsets.fromLTRB(15.0, 5.0, 20.0, 5.0)
          : const EdgeInsets.fromLTRB(25.0, 10.0, 30.0, 10.0),
      child: ElevatedButton.icon(
        onPressed: () => debugPrint('Play'),
        style: ElevatedButton.styleFrom(primary: Colors.white),
        icon: const Icon(
          Icons.play_arrow,
          size: 30.0,
          color: Colors.black,
        ),
        label: const Text(
          'Play',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
