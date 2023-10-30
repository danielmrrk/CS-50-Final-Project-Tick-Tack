import 'package:flutter/material.dart';
import 'package:tic_tac/main_sceen/difficulty.dart';

class DifficultyItem extends StatefulWidget {
  const DifficultyItem({
    super.key,
    this.leftSide,
    this.rightSide,
    this.upSide,
    this.downSide,
    required this.deactivateSelection,
    required this.deactivate,
    required this.isDarkened,
    required this.difficultyDisplay,
  });

  final bool? leftSide;
  final bool? rightSide;
  final bool? downSide;
  final bool? upSide;
  final Function(bool selected) deactivateSelection;
  final bool deactivate;
  final bool isDarkened;
  final Difficulty difficultyDisplay;

  @override
  State<DifficultyItem> createState() => _DifficultyItemState();
}

class _DifficultyItemState extends State<DifficultyItem> with TickerProviderStateMixin {
  bool selected = false;
  bool mainSelect = false;

  @override
  Widget build(BuildContext context) {
    if (widget.deactivate && !mainSelect) selected = false;
    mainSelect = false;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        widget.rightSide == true
            ? !selected
                ? 6
                : 0
            : 0,
        widget.downSide == true
            ? !selected
                ? 6
                : 0
            : 0,
        widget.leftSide == true
            ? !selected
                ? 6
                : 0
            : 0,
        widget.upSide == true
            ? !selected
                ? 6
                : 0
            : 0,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selected = !selected;
            widget.deactivateSelection(selected);
            mainSelect = true;
          });
        },
        child: SizedBox(
          height: 196,
          width: 172,
          child: Card(
            margin: EdgeInsets.all(selected ? 0 : 4),
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: selected ? const Color(0xff00A5EC) : Colors.white, width: selected ? 4 : 2, strokeAlign: -1),
            ),
            child: Image(
              image: AssetImage(
                selected
                    ? "assets/edited_${widget.difficultyDisplay.technicalName}.png"
                    : widget.isDarkened
                        ? "assets/grey_${widget.difficultyDisplay.technicalName}.png"
                        : "assets/${widget.difficultyDisplay.technicalName}.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
