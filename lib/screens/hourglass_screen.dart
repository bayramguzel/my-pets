import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math' as math;

class HourglassScreen extends StatefulWidget {
  const HourglassScreen({super.key});

  @override
  State<HourglassScreen> createState() => _HourglassScreenState();
}

class _HourglassScreenState extends State<HourglassScreen>
    with TickerProviderStateMixin {
  late AnimationController _sandFlowController;
  late AnimationController _rotationController;
  late AnimationController _sandStreamController;
  Timer? _timer;

  double _duration = 60.0; // seconds
  double _timeRemaining = 60.0;
  bool _isRunning = false;
  bool _isPaused = false;

  // Sand flow animation values
  double _topSandLevel = 1.0; // 1.0 = full, 0.0 = empty
  double _bottomSandLevel = 0.0; // 0.0 = empty, 1.0 = full
  double _sandStreamOpacity = 0.0; // For flowing sand animation

  @override
  void initState() {
    super.initState();
    _sandFlowController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _sandStreamController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _resetTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _sandFlowController.dispose();
    _rotationController.dispose();
    _sandStreamController.dispose();
    super.dispose();
  }

  void _resetTimer() {
    setState(() {
      _timeRemaining = _duration;
      _topSandLevel = 1.0;
      _bottomSandLevel = 0.0;
      _isRunning = false;
      _isPaused = false;
    });
    _timer?.cancel();
  }

  void _startTimer() {
    if (_isPaused) {
      setState(() {
        _isRunning = true;
        _isPaused = false;
      });
    } else {
      _resetTimer();
      setState(() {
        _isRunning = true;
      });
    }

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _timeRemaining -= 0.1;

        // Update sand levels based on time remaining
        double progress = (_duration - _timeRemaining) / _duration;
        _topSandLevel = 1.0 - progress;
        _bottomSandLevel = progress;

        // Animate sand stream when running
        _sandStreamOpacity = _isRunning ? 0.8 : 0.0;

        if (_timeRemaining <= 0) {
          _timeRemaining = 0;
          _isRunning = false;
          _sandStreamOpacity = 0.0;
          timer.cancel();
          _onTimerComplete();
        }
      });
    });
  }

  void _pauseTimer() {
    setState(() {
      _isRunning = false;
      _isPaused = true;
    });
    _timer?.cancel();
  }

  void _onTimerComplete() {
    // Play system sound for completion
    try {
      HapticFeedback.mediumImpact();
    } catch (e) {
      // Fallback if haptic feedback fails
    }

    // Rotate hourglass when complete
    _rotationController.forward().then((_) {
      _rotationController.reset();
    });

    // Show completion dialog
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('⏰ Time\'s Up!'),
          content: const Text('Your hourglass timer has completed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  String _formatTime(double seconds) {
    int minutes = seconds ~/ 60;
    int secs = (seconds % 60).round();
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hourglass Timer'),
        backgroundColor: isDark ? null : Colors.white,
        foregroundColor: isDark ? null : Colors.black,
        elevation: 0,
      ),
      backgroundColor: isDark
          ? theme.scaffoldBackgroundColor
          : const Color(0xFFFAF9F6), // Cream background for light mode
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Time display
            Text(
              _formatTime(_timeRemaining),
              style: theme.textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Hourglass animation
            AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationController.value * math.pi,
                  child: SizedBox(
                    width: 200,
                    height: 300,
                    child: CustomPaint(
                      painter: HourglassPainter(
                        topSandLevel: _topSandLevel,
                        bottomSandLevel: _bottomSandLevel,
                        sandStreamOpacity: _sandStreamOpacity,
                        isDark: isDark,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // Duration slider - refined thin design with edge ticks
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Text(
                    'Duration: ${_duration.round()} seconds',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2.0, // Very thin track
                      activeTrackColor: theme.colorScheme.primary,
                      inactiveTrackColor: (isDark ? Colors.white : Colors.black)
                          .withValues(alpha: 0.3),
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8.0,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 16.0,
                      ),
                      tickMarkShape: const RoundSliderTickMarkShape(
                        tickMarkRadius: 3.0,
                      ),
                      activeTickMarkColor: theme.colorScheme.primary,
                      inactiveTickMarkColor:
                          (isDark ? Colors.white : Colors.black).withValues(
                            alpha: 0.5,
                          ),
                      showValueIndicator: ShowValueIndicator.onlyForDiscrete,
                      valueIndicatorShape:
                          const PaddleSliderValueIndicatorShape(),
                      valueIndicatorColor: theme.colorScheme.primary,
                      valueIndicatorTextStyle: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 14,
                      ),
                    ),
                    child: Slider(
                      value: _duration,
                      min: 10,
                      max: 300,
                      divisions: 29,
                      label: '${_duration.round()}s',
                      onChanged: _isRunning
                          ? null
                          : (value) {
                              setState(() {
                                _duration = value;
                                _resetTimer();
                              });
                            },
                    ),
                  ),
                  // Edge tick labels
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '10s',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                        Text(
                          '300s',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isRunning ? _pauseTimer : _startTimer,
                  icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(
                    _isRunning ? 'Pause' : (_isPaused ? 'Resume' : 'Start'),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HourglassPainter extends CustomPainter {
  final double topSandLevel;
  final double bottomSandLevel;
  final double sandStreamOpacity;
  final bool isDark;

  HourglassPainter({
    required this.topSandLevel,
    required this.bottomSandLevel,
    required this.sandStreamOpacity,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()..style = PaintingStyle.fill;

    // Colors based on theme
    final frameColor = isDark ? Colors.white70 : Colors.black87;
    final sandColor = isDark ? Colors.amber.shade200 : Colors.amber.shade600;
    final glassColor = isDark ? Colors.white10 : Colors.grey.shade100;

    paint.color = frameColor;
    fillPaint.color = glassColor;

    final center = Offset(size.width / 2, size.height / 2);
    final topCenter = Offset(center.dx, size.height * 0.25);
    final bottomCenter = Offset(center.dx, size.height * 0.75);

    // Draw hourglass frame
    final path = Path();

    // Top chamber
    path.moveTo(center.dx - 60, topCenter.dy - 60);
    path.lineTo(center.dx + 60, topCenter.dy - 60);
    path.lineTo(center.dx + 60, topCenter.dy + 40);
    path.lineTo(center.dx + 20, center.dy);
    path.lineTo(center.dx - 20, center.dy);
    path.lineTo(center.dx - 60, topCenter.dy + 40);
    path.close();

    // Bottom chamber
    final bottomPath = Path();
    bottomPath.moveTo(center.dx - 20, center.dy);
    bottomPath.lineTo(center.dx + 20, center.dy);
    bottomPath.lineTo(center.dx + 60, bottomCenter.dy - 40);
    bottomPath.lineTo(center.dx + 60, bottomCenter.dy + 60);
    bottomPath.lineTo(center.dx - 60, bottomCenter.dy + 60);
    bottomPath.lineTo(center.dx - 60, bottomCenter.dy - 40);
    bottomPath.close();

    // Fill glass chambers
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(bottomPath, fillPaint);

    // Draw sand in top chamber
    if (topSandLevel > 0) {
      final sandPaint = Paint()
        ..color = sandColor
        ..style = PaintingStyle.fill;

      final sandHeight =
          (topCenter.dy + 40 - (topCenter.dy - 60)) * topSandLevel;
      final sandTop = topCenter.dy + 40 - sandHeight;

      final sandPath = Path();
      sandPath.moveTo(center.dx - 60, topCenter.dy + 40);

      if (sandTop <= center.dy) {
        // Sand reaches the narrow part
        final narrowWidth =
            20 * (center.dy - sandTop) / (topCenter.dy + 40 - center.dy);
        sandPath.lineTo(center.dx - narrowWidth, sandTop);
        sandPath.lineTo(center.dx + narrowWidth, sandTop);
      } else {
        // Sand only in wide part
        sandPath.lineTo(center.dx - 60, sandTop);
        sandPath.lineTo(center.dx + 60, sandTop);
      }

      sandPath.lineTo(center.dx + 60, topCenter.dy + 40);
      sandPath.lineTo(center.dx + 20, center.dy);
      sandPath.lineTo(center.dx - 20, center.dy);
      sandPath.close();

      canvas.drawPath(sandPath, sandPaint);
    }

    // Draw sand in bottom chamber
    if (bottomSandLevel > 0) {
      final sandPaint = Paint()
        ..color = sandColor
        ..style = PaintingStyle.fill;

      final sandHeight =
          (bottomCenter.dy + 60 - (bottomCenter.dy - 40)) * bottomSandLevel;
      final sandTop = bottomCenter.dy + 60 - sandHeight;

      final sandPath = Path();
      sandPath.moveTo(center.dx - 60, bottomCenter.dy + 60);
      sandPath.lineTo(center.dx + 60, bottomCenter.dy + 60);

      if (sandTop >= center.dy) {
        // Sand only in wide part
        sandPath.lineTo(center.dx + 60, sandTop);
        sandPath.lineTo(center.dx - 60, sandTop);
      } else {
        // Sand reaches narrow part
        final narrowWidth =
            20 * (sandTop - center.dy) / (center.dy - (bottomCenter.dy - 40));
        sandPath.lineTo(center.dx + 60, bottomCenter.dy - 40);
        sandPath.lineTo(center.dx + narrowWidth, sandTop);
        sandPath.lineTo(center.dx - narrowWidth, sandTop);
        sandPath.lineTo(center.dx - 60, bottomCenter.dy - 40);
      }

      sandPath.close();
      canvas.drawPath(sandPath, sandPaint);
    }

    // Draw frame outline
    canvas.drawPath(path, paint);
    canvas.drawPath(bottomPath, paint);

    // Draw center connection
    canvas.drawLine(
      Offset(center.dx - 20, center.dy),
      Offset(center.dx + 20, center.dy),
      paint,
    );

    // Draw flowing sand stream effect when timer is running
    if (sandStreamOpacity > 0 && topSandLevel > 0.1) {
      final streamPaint = Paint()
        ..color = sandColor.withValues(alpha: sandStreamOpacity)
        ..style = PaintingStyle.fill;

      // Create narrow sand stream through center
      const streamWidth = 2.0;
      final streamRect = Rect.fromLTRB(
        center.dx - streamWidth,
        center.dy - 15,
        center.dx + streamWidth,
        center.dy + 15,
      );

      canvas.drawRect(streamRect, streamPaint);

      // Add some sand particles effect
      final random = math.Random(42); // Fixed seed for consistent animation
      for (int i = 0; i < 5; i++) {
        final x = center.dx + (random.nextDouble() - 0.5) * 8;
        final y = center.dy + (random.nextDouble() - 0.5) * 25;
        canvas.drawCircle(Offset(x, y), 1.0, streamPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
