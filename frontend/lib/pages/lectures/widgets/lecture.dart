import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:plan_pm/global/colors.dart';
import 'package:plan_pm/pages/lectures/widgets/description_item.dart';
import 'package:plan_pm/l10n/app_localizations.dart';

List<LinearGradient> softHorizontalGradients = [
  LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)], // blue-500 → purple-600
  ),
  LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFF14B8A6), Color(0xFF06B6D4)], // teal-500 → cyan-500
  ),
  LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFFF59E0B), Color(0xFFEF4444)], // amber-500 → red-500
  ),
  LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)], // pink-500 → purple-600
  ),
  LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFFF43F5E), Color(0xFFFB923C)], // rose-500 → orange-400
  ),
  LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFF6EE7B7), Color(0xFF3B82F6)], // green-300 → blue-500
  ),
  LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFFA855F7), Color(0xFF6366F1)], // fuchsia-500 → indigo-500
  ),
  LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [Color(0xFFFB7185), Color(0xFFFACC15)], // red-400 → yellow-400
  ),
];

String longToShort(String long) {
  final pieces = long
      .split(",")
      .map((piece) => piece.split("/")[0])
      .toString()
      .replaceAll("(", "")
      .replaceAll(")", "");

  return pieces;
}

class Lecture extends StatefulWidget {
  const Lecture({
    super.key,
    required this.idx,
    required this.name,
    required this.timeFrom,
    required this.timeTo,
    this.location,
    this.professor,
    required this.group,
    required this.duration,
    this.notes,
  });

  final int idx;
  final String name;
  final String timeFrom;
  final String timeTo;
  final String? location;
  final String? professor;
  final String group;
  final String duration;
  final String? notes;

  @override
  State<Lecture> createState() => _LectureState();
}

class _LectureState extends State<Lecture> {
  bool expanded = false;
  void switchExpanded() {
    setState(() {
      HapticFeedback.lightImpact();
      expanded = !expanded;
    });
  }

  //
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      color: AppColor.surface,
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                gradient:
                    softHorizontalGradients[widget.idx %
                        softHorizontalGradients.length],

                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: switchExpanded,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: AppColor.onPrimary,
                              ),
                            ),
                          ),
                          !expanded
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    LucideIcons.chevronDown,
                                    color: AppColor.onPrimary,
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    LucideIcons.chevronUp,
                                    color: AppColor.onPrimary,
                                  ),
                                ),
                        ],
                      ),
                      Row(
                        spacing: 5,
                        children: [
                          Icon(
                            LucideIcons.clock,
                            size: 16,
                            color: AppColor.onPrimary,
                          ),
                          Text(
                            "${widget.timeFrom} - ${widget.timeTo}",
                            style: TextStyle(color: AppColor.onPrimary),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            LucideIcons.mapPin,
                            size: 16,
                            color: AppColor.onPrimary,
                          ),
                          Expanded(
                            child: Text(
                              // Ten kod jest po to, zeby nie dodawać spacji przed przecinkiem jezeli są więcej niz dwie sale.
                              // Przed: ' , ' Po: ', '
                              // Ludzie nie stawiajcie spacji przed przecinkiem!!!!!!!!
                              widget.location != null
                                  ? widget.location!.split(" , ").length == 1
                                        ? widget.location!
                                        : widget.location!
                                              .split(" , ")
                                              .join(", ")
                                  : l10n.roomNaN,
                              style: TextStyle(color: AppColor.onPrimary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          expanded
              ? Container(
                  decoration: BoxDecoration(
                    color: AppColor.surface,
                    boxShadow: [BoxShadow()],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: switchExpanded,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        spacing: 10,
                        children: [
                          widget.professor != null
                              ? DescriptionItem(
                                  icon: LucideIcons.user,
                                  color: Colors.blue,
                                  name: l10n.professorLabel,
                                  content:
                                      widget.professor ?? l10n.professorNaN,
                                )
                              : Container(),
                          DescriptionItem(
                            icon: LucideIcons.bookLock,
                            color: Colors.green,
                            name: l10n.groupLabel,
                            content: longToShort(widget.group),
                          ),
                          DescriptionItem(
                            icon: LucideIcons.clock,
                            color: Colors.purple,
                            name: l10n.lengthLabel,
                            content: widget.duration,
                          ),
                          widget.notes != null
                              ? DescriptionItem(
                                  icon: LucideIcons.stickyNote,
                                  color: Colors.yellow,
                                  name: l10n.notesLabel,
                                  content: widget.notes ?? l10n.emptyNotesLabel,
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
