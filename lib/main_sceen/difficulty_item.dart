import 'package:flutter/material.dart';
import 'package:tic_tac/general/theme/text_theme.dart';
import 'package:tic_tac/main_sceen/difficulty.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DifficultyItem extends StatefulWidget {
  const DifficultyItem({
    super.key,
    required this.setFocus,
    required this.maybeDarken,
    required this.difficultyDisplay,
  });

  final Function(String difficultyName) setFocus;
  final bool maybeDarken;
  final Difficulty difficultyDisplay;

  @override
  State<DifficultyItem> createState() => _DifficultyItemState();
}

class _DifficultyItemState extends State<DifficultyItem> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GestureDetector(
        onTap: () {
          widget.setFocus(widget.difficultyDisplay.displayName);
        },
        child: SizedBox(
          height: 196,
          width: 170,
          child: Card(
            margin: EdgeInsets.all(widget.difficultyDisplay.focused ? 0 : 8),
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                  color: widget.difficultyDisplay.focused ? const Color(0xff00A5EC) : Colors.white,
                  width: widget.difficultyDisplay.focused ? 4 : 2,
                  strokeAlign: -1),
            ),
            child: Image(
              image: AssetImage(
                widget.difficultyDisplay.focused
                    ? "assets/edited_${widget.difficultyDisplay.technicalName}.png"
                    : widget.maybeDarken
                        ? "assets/grey_${widget.difficultyDisplay.technicalName}.png"
                        : "assets/${widget.difficultyDisplay.technicalName}.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      Column(
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              const Spacer(),
              StrokeText(text: widget.difficultyDisplay.time).body!,
              SvgPicture.asset(
                "assets/hourglass_outlined.svg",
                width: 20,
              ),
              const SizedBox(width: 20)
            ],
          ),
          const Spacer(),
          StrokeText(text: widget.difficultyDisplay.displayName).body!,
          const SizedBox(height: 16),
        ],
      ),
    ]);
  }
}
