import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:my_pets/l10n/app_localizations.dart';
import 'main_navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  Timer? _fallbackTimer;
  bool _initialized = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/splash.mp4');
    _controller
        .initialize()
        .then((_) {
          if (!mounted) return;
          setState(() {
            _initialized = true;
          });
          _controller.setVolume(0.0); // Sessiz (Mute)
          _controller.setLooping(false);
          _controller.play();
          _controller.addListener(_onVideoProgress);
        })
        .catchError((Object error) {
          // Do not leave iOS users stuck on the splash screen when the video
          // cannot be decoded.
          debugPrint('Splash video could not be initialized: $error');
          _navigateToHome();
        });

    // Guarantee that the app always reaches the home screen.
    _fallbackTimer = Timer(const Duration(seconds: 10), _navigateToHome);
  }

  void _onVideoProgress() {
    if (!_controller.value.isInitialized) return;
    final position = _controller.value.position;
    final duration = _controller.value.duration;
    if (duration > Duration.zero && position >= duration) {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    if (mounted && !_navigated) {
      _navigated = true;
      _fallbackTimer?.cancel();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    }
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    _controller.removeListener(_onVideoProgress);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _initialized
                ? SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size.width,
                        height: _controller.value.size.height,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  )
                : const CircularProgressIndicator(color: Colors.white),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: SafeArea(
              child: TextButton(
                onPressed: _navigateToHome,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black54,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(l10n.skip),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
