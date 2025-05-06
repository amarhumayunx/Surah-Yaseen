import 'package:flutter/material.dart';
import 'package:surah_yaseen/Colors/colors.dart';
import '../../constants/app_assets.dart';
import '../../constants/app_strings.dart';

class ListenAudioWithTranslationRukuFourthAudioPlayer extends StatefulWidget {
  final Function()? onPlayPause;
  final Function()? onSkipNext;
  final Function()? onSkipPrevious;
  final bool isPlaying;
  final String? title;
  final String? subtitle;

  const ListenAudioWithTranslationRukuFourthAudioPlayer({
    Key? key,
    this.onPlayPause,
    this.onSkipNext,
    this.onSkipPrevious,
    this.isPlaying = false,
    this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  State<ListenAudioWithTranslationRukuFourthAudioPlayer> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<ListenAudioWithTranslationRukuFourthAudioPlayer> {
  double _sliderValue = 0.65; // Assume progress for now
  final double _maxDuration = 95; // In seconds
  final double _currentDuration = 73; // In seconds

  String _formatTime(double seconds) {
    final min = seconds ~/ 60;
    final sec = (seconds % 60).toInt().toString().padLeft(2, '0');
    return '$min:$sec';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Replacing Icon with Title Text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.title ?? AppStrings.listenAudioWithTranslationScreenString.Ruku4title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.PrimaryColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Slider + Time Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Slider(
                value: _sliderValue,
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value;
                  });
                },
                activeColor: AppColors.PrimaryColor,
                inactiveColor: const Color(0xFFD9D58E),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatTime(_currentDuration),
                      style: TextStyle(
                          color: Colors.grey.shade700),
                    ),
                    Text(
                      _formatTime(_maxDuration),
                      style: TextStyle(
                          color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ],
          ),

        ),
        const SizedBox(height: 10),

        // Control Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _iconControlButton(
              Image.asset(
                AppAssets.backwardarrow,
                width: 30,
                height: 30,
              ),
              widget.onSkipPrevious,
            ),
            const SizedBox(width: 25),
            _roundPlayButton(
                widget.isPlaying,
                widget.onPlayPause),
            const SizedBox(width: 25),
            _iconControlButton(
              Image.asset(
                AppAssets.forwardarrow,
                width: 30,
                height: 30,
              ),
              widget.onSkipNext,
            ),
          ],
        )


      ],
    );
  }

  Widget _iconControlButton(
      Widget icon,
      Function()? onPressed) {
    return IconButton(
      icon: icon,
      onPressed: onPressed,
      iconSize: 30,
    );
  }


  Widget _roundPlayButton(
      bool isPlaying,
      Function()? onPressed) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: AppColors.BarColor,
            width: 3),
        color: AppColors.PrimaryColor,
      ),
      child: IconButton(
        icon: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              AppAssets.playbutton,
              width: 20, // Try adjusting this to 40–60 based on your design
              height: 20,
              fit: BoxFit.contain, // ensures the image fits well
            ),
            IconButton(
              icon: Image.asset(
                isPlaying ? AppAssets.playbutton
                    : AppAssets.playbutton,
                width: 30,
                height: 30,
                fit: BoxFit.contain,
              ),
              onPressed: onPressed,
              iconSize: 50,
            ),
          ],
        ),
        onPressed: onPressed,
        iconSize: 50, // this controls the tap area
      ),
    );
  }
}
