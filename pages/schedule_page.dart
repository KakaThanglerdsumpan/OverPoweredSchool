import 'package:flutter/material.dart';
import 'package:opschooldraft1/view_models/budget_view_model.dart';
import 'package:provider/provider.dart';

import '../services/theme_service.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context, listen: false);
    final screenSize = MediaQuery.of(context).size;
    final blockWidth = (screenSize.width - 35 - 10 - 10 - 10) / 5;

    final List<Color> colors = [
      Colors.red,
      Colors.orange,
      Colors.green,
      Colors.teal,
      Colors.blue,
      Colors.indigoAccent,
      Colors.purple,
      Colors.pink,
      Colors.grey[400]!,
    ];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text(
          "OverPowered School",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              themeService.darkTheme = !themeService.darkTheme;
            },
            icon: Icon(themeService.darkTheme ? Icons.sunny : Icons.dark_mode),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 37),
                    Container(
                      width: (screenSize.width - 35 - 10 - 12),
                      height: 30,
                      decoration: const BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(2.5),
                              bottomRight: Radius.circular(2.5))),
                      child: const Center(
                        child: Text(
                          'Period',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      height: 25,
                      width: 35,
                      decoration: const BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(2.5),
                              bottomLeft: Radius.circular(2.5),
                              bottomRight: Radius.circular(2.5))),
                      child: const Center(
                        child: Text(
                          'Day',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),
                    Container(
                      width: blockWidth,
                      height: 25,
                      decoration: const BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.all(Radius.circular(2.5)),
                      ),
                      child: const Center(
                          child:
                              Text('1', style: TextStyle(color: Colors.white))),
                    ),
                    const SizedBox(width: 2),
                    Container(
                      width: blockWidth,
                      height: 25,
                      decoration: const BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.all(Radius.circular(2.5)),
                      ),
                      child: const Center(
                          child:
                              Text('2', style: TextStyle(color: Colors.white))),
                    ),
                    const SizedBox(width: 2),
                    Container(
                      width: blockWidth,
                      height: 25,
                      decoration: const BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.all(Radius.circular(2.5)),
                      ),
                      child: const Center(
                          child:
                              Text('3', style: TextStyle(color: Colors.white))),
                    ),
                    const SizedBox(width: 2),
                    Container(
                      width: blockWidth,
                      height: 25,
                      decoration: const BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.all(Radius.circular(2.5)),
                      ),
                      child: const Center(
                          child:
                              Text('4', style: TextStyle(color: Colors.white))),
                    ),
                    const SizedBox(width: 2),
                    Container(
                      width: blockWidth,
                      height: 25,
                      decoration: const BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.all(Radius.circular(2.5)),
                      ),
                      child: const Center(
                          child:
                              Text('5', style: TextStyle(color: Colors.white))),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10, width: 25),
                        Container(
                          height: 48,
                          width: 35,
                          decoration: const BoxDecoration(
                            color: Colors.indigo,
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.5)),
                          ),
                          child: const Center(
                              child: Text('A',
                                  style: TextStyle(color: Colors.white))),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 48,
                          width: 35,
                          decoration: const BoxDecoration(
                            color: Colors.indigo,
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.5)),
                          ),
                          child: const Center(
                              child: Text('B',
                                  style: TextStyle(color: Colors.white))),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 48,
                          width: 35,
                          decoration: const BoxDecoration(
                            color: Colors.indigo,
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.5)),
                          ),
                          child: const Center(
                              child: Text('C',
                                  style: TextStyle(color: Colors.white))),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 48,
                          width: 35,
                          decoration: const BoxDecoration(
                            color: Colors.indigo,
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.5)),
                          ),
                          child: const Center(
                              child: Text('D',
                                  style: TextStyle(color: Colors.white))),
                        ),
                      ],
                    ),
                    const SizedBox(width: 2),
                    SizedBox(
                      width: 370,
                      child: Consumer<BudgetViewModel>(
                          builder: (context, value, child) {
                        List<dynamic> matrix = value.getMatrix();

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: 4,
                          itemBuilder: (context, i) {
                            return Column(
                              children: [
                                const SizedBox(height: 10.0),
                                SizedBox(
                                  width: 380.0,
                                  height: 48.0,
                                  child: Row(
                                    children: [
                                      ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: 5,
                                          itemBuilder: (context, j) {
                                            return Row(
                                              children: [
                                                Container(
                                                  width: blockWidth,
                                                  decoration: BoxDecoration(
                                                      color: colors[matrix[i][j]
                                                          .colorIndex],
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  5.0))),
                                                  child: Center(
                                                    child: Text(
                                                      matrix[i][j]
                                                          .abbreviatedName,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 2),
                                              ],
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
