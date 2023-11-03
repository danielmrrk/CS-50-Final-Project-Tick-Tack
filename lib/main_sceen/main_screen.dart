import 'package:flutter/material.dart';
import 'package:tic_tac/game/game_screen.dart';
import 'package:tic_tac/general/theme/button_theme.dart';
import 'package:tic_tac/general/util/navigation.dart';
import 'package:tic_tac/general/theme/text_theme.dart';
import 'package:tic_tac/general/util/snackbar.dart';
import 'package:tic_tac/main_sceen/difficulty.dart';
import 'package:tic_tac/main_sceen/difficulty_grid.dart';

final images = [
  "grey_drunkard.png",
  "drunkard.png",
  "edited_drunkard.png",
  "grey_novice.png",
  "novice.png",
  "edited_novice.png",
  "grey_white knight.png",
  "white knight.png",
  "edited_white knight.png",
  "grey_dark wizard.png",
  "dark wizard.png",
  "edited_dark wizard.png"
];

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.reset = false});

  final bool reset;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  Difficulty? _selectedDifficulty;
  late bool _reset;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    precache();
    _reset = widget.reset;
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      precache();
    }
    super.didChangeAppLifecycleState(state);
  }

  void precache() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (var image in images) {
        precacheImage(AssetImage("assets/images/$image"), context);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_reset) {
      for (var rank in Difficulty.ranks) {
        rank.focused = false;
      }
      _reset = false;
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(31, 100, 31, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Choose your difficulty",
              style: TTTextTheme.strikingTitle,
            ),
            const SizedBox(height: 20),
            DifficultyGrid(
              setSelectedDifficulty: setSelectedDifficulty,
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const TTButton(title: "New Game").fullWidthButton(
                    () {
                      if (_selectedDifficulty == null) {
                        showSnackbar(context, "Please select a difficulty", 600);
                        return;
                      }
                      navigateTo(GameScreen(difficultyDisplay: _selectedDifficulty!), context);
                    },
                  ),
                  const SizedBox(height: 8),
                  const TTButton(title: "Stats & Challenges").fullWidthButton(() {}),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void setSelectedDifficulty(Difficulty rank) {
    _selectedDifficulty = rank.focused ? rank : null;
  }
}
