import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1990),
                lastDate: DateTime(2030, DateTime.december, 30),
              );
              print(date);
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              print(time);
              final booking = await showDateRangePicker(
                context: context,
                firstDate: DateTime(1990),
                lastDate: DateTime(2030, DateTime.december, 30),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData(
                      appBarTheme: const AppBarTheme(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              print(booking);
            },
            title: const Text('When is your birthday?'),
          ),
          const AboutListTile(
            // AboutListTile : ListTile -> onTap -> showAboutDialog() 자동 적용된 것
            applicationVersion: 'version 2.0',
          ),
        ],
      ),

      // Column(
      //   children: [
      //     CupertinoActivityIndicator(
      //       radius: 40,
      //       // animating: false,
      //     ),
      //     CircularProgressIndicator(),
      //     /* CircularProgressIndicator.adaptive => 현재 플랫폼에 따라 위 indecators 둘 중 하나의 형태로 출력 */
      //     CircularProgressIndicator.adaptive(),
      //   ],
      // )

      /* ListWheelScrollView => 원통형 스크롤 위젯 */
      // ListWheelScrollView(
      //   itemExtent: 200,
      //   diameterRatio: 1.3,
      //   offAxisFraction: -0.5,
      //   // useMagnifier: true,
      //   // magnification: 1.5,
      //   children: [
      //     for (var x in [1, 2, 3, 5, 5, 6, 2, 2, 43, 53, 6, 5, 353, 434, 234])
      //       FractionallySizedBox(
      //         widthFactor: 1,
      //         child: Container(
      //           color: Colors.teal,
      //           alignment: Alignment.center,
      //           child: const Text(
      //             'Pick me!',
      //             style: TextStyle(
      //               color: Colors.white,
      //               fontSize: Sizes.size36,
      //             ),
      //           ),
      //         ),
      //       )
      //   ],
      // ),
    );
  }
}
