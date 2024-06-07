import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttermyappp/conts/conts.dart';
import 'package:fluttermyappp/views/employees_profile_view/employees_profile_view.dart';

class SalonsView extends StatelessWidget {
  final String salName;

  const SalonsView({super.key, required this.salName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppStyles.bold(title: salName,
            color: AppColors.whiteColor,
            size: AppSizes.size18),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('employees')
            .where('empSaloon', isEqualTo: salName).get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else {
            var data = snapshot.data?.docs;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 170,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: data?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: AppColors.bgDarkColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(right: 8),
                    height: 100,
                    width: 150,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          color: AppColors.blueColor,
                          child: Image.asset(
                            AppAssets.imgHair,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        5.heightBox,
                        AppStyles.normal(title: data![index]['empName']),
                        5.heightBox,
                        AppStyles.normal(title: data![index]['empCategory']),
                        VxRating(
                          selectionColor: AppColors.yellowColor,
                          onRatingUpdate: (value){},
                          count: 5,
                          value: double.parse(data[index]['empRating'].toString()),
                          stepInt: true,
                        ),
                      ],
                    ),
                  ).onTap(() {
                    Get.to(()=>EmployeesProfileView(emp: data[index]));
                  });
                },
              ),
            );
          }
        },
      ),
    );
  }
}