import 'package:flutter/material.dart';
import 'package:plan_pm/global/colors.dart';
import 'package:plan_pm/global/notifiers.dart';

List<String> daysShort = ["Pon", "Wt", "Śr", "Czw", "Pt"];
List<String> days = ["poniedziałek", "wtorek", "środa", "czwartek", "piątek"];
int selectedDay = 0;

class DaySelection extends StatefulWidget {
  const DaySelection({super.key});

  @override
  State<DaySelection> createState() => _DaySelectionState();
}

class _DaySelectionState extends State<DaySelection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.light.backgroundSecondary,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              daysShort.length,
              (index) => index == selectedDay
                  ? Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColor.light.backgroundPrimary,
                          side: BorderSide.none,
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedDay = index;
                          });
                        },
                        child: Text(
                          daysShort[index],
                          textAlign: TextAlign.center,
                          softWrap: false,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            selectedDay = index;
                            Notifiers.selectedDay.value = days[index];
                          });
                        },
                        child: Text(
                          daysShort[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
