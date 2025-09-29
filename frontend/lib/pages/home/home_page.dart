import 'package:flutter/material.dart';
import 'package:plan_pm/global/student.dart';
import 'package:plan_pm/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(AppLocalizations.of(context)!.homePageLabel),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.facultyText,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      AppLocalizations.of(context)!.fieldText,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      AppLocalizations.of(context)!.specialisationText,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(AppLocalizations.of(context)!.yearText, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      AppLocalizations.of(context)!.typeText,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 250,
                      child: Text(Student.faculty ?? AppLocalizations.of(context)!.dataNaN),
                    ),
                    SizedBox(
                      width: 250,
                      child: Text(Student.degreeCourse ?? AppLocalizations.of(context)!.dataNaN),
                    ),
                    SizedBox(
                      width: 250,
                      child: Text(Student.specialisation ?? AppLocalizations.of(context)!.dataNaN),
                    ),
                    Text(
                      Student.year != 0
                          ? Student.year.toString()
                          : AppLocalizations.of(context)!.dataNaN,
                    ),
                    Text(Student.term ?? AppLocalizations.of(context)!.dataNaN),
                  ],
                ),
              ],
            ),
          ),
          Text(
            "Piotr Wittig was here.",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
