import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttermyappp/conts/conts.dart';
import 'package:fluttermyappp/views/salons_view/salons_view.dart';

class SalonsAllView extends StatelessWidget {
  const SalonsAllView({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: AppStyles.bold(
          title: AppStrings.salons,
          size: AppSizes.size18,
          color: AppColors.whiteColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder<QuerySnapshot>(
          future: getEmployeesList(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var data = snapshot.data!.docs;
              Set salonNamesSet = data.map((doc) => doc['empSaloon'] ?? '').toSet();
              List salonNames = salonNamesSet.toList();

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Определяем количество элементов в строке
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: salonNames.length,
                itemBuilder: (BuildContext context, int index) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('employees')
                        .where('empSaloon', isEqualTo: salonNames[index])
                        .snapshots(),
                    builder: (context, employeeSnapshot) {
                      if (employeeSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (employeeSnapshot.hasData) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SalonsView(salName: salonNames[index]),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.blueColor,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    AppAssets.icSalon,
                                    width: 40,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                                SizedBox(height: 10),
                                AppStyles.bold(
                                  title: salonNames[index],
                                  color: AppColors.whiteColor,
                                  size: AppSizes.size16,
                                ),
                                SizedBox(height: 5),
                                AppStyles.normal(
                                  title: "${employeeSnapshot.data!.docs.length} employees",
                                  color: AppColors.whiteColor.withOpacity(0.5),
                                  size: AppSizes.size12,
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Text('No data');
                      }
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<QuerySnapshot> getEmployeesList() async {
    return FirebaseFirestore.instance.collection('employees').get();
  }
}

