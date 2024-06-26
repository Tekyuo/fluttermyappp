import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttermyappp/conts/conts.dart';
import 'package:fluttermyappp/views/appointment_view/appointment_emp_view.dart';
import 'package:fluttermyappp/views/reviews_view/emp_list_screen.dart';
import 'package:fluttermyappp/views/settings_view/settings_view_emp.dart';

class HomeEmp extends StatefulWidget {
  const HomeEmp({super.key});

  @override
  State<HomeEmp> createState() => _HomeEmpState();
}

class _HomeEmpState extends State<HomeEmp> {

  int selectedIndex = 0;
  List screenList = [
    const AppointmentEmpView(),
    const SettingsEmpView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenList.elementAt(selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.white.withOpacity(0.5),
        selectedItemColor: AppColors.whiteColor,
        selectedLabelStyle: TextStyle(
          color: AppColors.whiteColor,
        ),
        selectedIconTheme: IconThemeData(
          color: AppColors.whiteColor,
        ),
        backgroundColor: AppColors.blueColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Appointments"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}