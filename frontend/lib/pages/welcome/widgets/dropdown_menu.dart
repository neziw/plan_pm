import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FacultyDropDownMenu extends StatefulWidget {
  const FacultyDropDownMenu({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.hint,
    required this.itemList,
    this.enabled = true,
    this.onChanged,
    this.selectedValue,
    required this.controller,
  });

  final String label;
  final IconData icon;
  final Color color;
  final String hint;
  final List<String> itemList;
  final bool? enabled;
  final ValueChanged<String?>? onChanged;
  final String? selectedValue;
  final TextEditingController controller;

  @override
  State<FacultyDropDownMenu> createState() => _FacultyDropDownMenuState();
}

class _FacultyDropDownMenuState extends State<FacultyDropDownMenu> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black.withAlpha(150),
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownMenu(
            trailingIcon: Icon(LucideIcons.chevronDown),
            enabled: widget.enabled!,
            controller: widget.controller,
            initialSelection: widget.selectedValue,
            hintText: widget.hint,
            onSelected: widget.onChanged,
            menuStyle: MenuStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.white),
            ),
            width: double.infinity,
            inputDecorationTheme: InputDecorationTheme(
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black.withAlpha(50)),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              border: OutlineInputBorder(
                // borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),

            dropdownMenuEntries: widget.itemList
                .map(
                  (faculty) => DropdownMenuEntry(
                    value: faculty,
                    label: faculty,
                    leadingIcon: faculty == widget.selectedValue
                        ? Icon(Icons.check)
                        : null,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
