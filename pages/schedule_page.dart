import 'package:flutter/material.dart';
import 'package:opschooldraft1/view_models/budget_view_model.dart';
import 'package:provider/provider.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<BudgetViewModel>(builder: (context, value, child) {
        List<dynamic> matrix = value.getMatrix();
        print(matrix);
        return ListView.builder(
          shrinkWrap: true,
          itemCount: 4,
          itemBuilder: (context, i) {
            return Column(
              children: [
                const SizedBox(height: 10.0),
                SizedBox(
                  width: 390.0,
                  height: 48.0,
                  child: Row(
                    children: [
                      ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (context, j) {
                            return Container(
                              width: 390 / 5,
                              decoration: BoxDecoration(
                                  color: Colors.indigoAccent,
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 234, 234, 234)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0))),
                              child: Center(
                                child: Text(
                                  matrix[i][j],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                )
              ],
            );
          },
        );
      }),
    );
  }
}
