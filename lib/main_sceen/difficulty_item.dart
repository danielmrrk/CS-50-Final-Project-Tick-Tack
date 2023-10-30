import 'package:flutter/material.dart';
import 'package:tic_tac/general/theme/text_theme.dart';
import 'package:tic_tac/main_sceen/difficulty.dart';

class DifficultyItem extends StatefulWidget {
  const DifficultyItem({
    super.key,
    this.leftSide,
    this.rightSide,
    this.upSide,
    this.downSide,
    required this.setFocus,
    required this.maybeDarken,
    required this.difficultyDisplay,
  });

  final bool? leftSide;
  final bool? rightSide;
  final bool? downSide;
  final bool? upSide;
  final Function(String difficultyName) setFocus;
  final bool maybeDarken;
  final Difficulty difficultyDisplay;

  @override
  State<DifficultyItem> createState() => _DifficultyItemState();
}

class _DifficultyItemState extends State<DifficultyItem> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        widget.rightSide == true
            ? !widget.difficultyDisplay.focused
                ? 6
                : 0
            : 0,
        widget.downSide == true
            ? !widget.difficultyDisplay.focused
                ? 6
                : 0
            : 0,
        widget.leftSide == true
            ? !widget.difficultyDisplay.focused
                ? 6
                : 0
            : 0,
        widget.upSide == true
            ? !widget.difficultyDisplay.focused
                ? 6
                : 0
            : 0,
      ),
      child: GestureDetector(
        onTap: () {
          widget.setFocus(widget.difficultyDisplay.displayName);
        },
        child: SizedBox(
          height: 196,
          width: 172,
          child: Card(
            margin: EdgeInsets.all(widget.difficultyDisplay.focused ? 0 : 4),
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                  color: widget.difficultyDisplay.focused ? const Color(0xff00A5EC) : Colors.white,
                  width: widget.difficultyDisplay.focused ? 4 : 2,
                  strokeAlign: -1),
            ),
            child: Stack(children: [
              Image(
                image: AssetImage(
                  widget.difficultyDisplay.focused
                      ? "assets/edited_${widget.difficultyDisplay.technicalName}.png"
                      : widget.maybeDarken
                          ? "assets/grey_${widget.difficultyDisplay.technicalName}.png"
                          : "assets/${widget.difficultyDisplay.technicalName}.png",
                ),
                fit: BoxFit.cover,
              ),
              const Spacer(
                flex: 1,
              ),
              StrokeText(text: widget.difficultyDisplay.displayName).body!,
            ]),
          ),
        ),
      ),
    );
  }
}
