import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/class_item.dart';
import '../services/theme_service.dart';
import '../view_models/budget_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final themeService = Provider.of<ThemeService>(context, listen: false);

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<dynamic>(
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            context: context,
            builder: (context) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: Consumer<BudgetViewModel>(
                  builder: ((context, value, child) {
                    return AddTransactionDialog(
                      itemToAdd: (transactionItem) async {
                        final budgetService = Provider.of<BudgetViewModel>(
                            context,
                            listen: false);

                        budgetService.addItem(transactionItem);
                      },
                      periodsToUpdate: (periods) {
                        final budgetService = Provider.of<BudgetViewModel>(
                            context,
                            listen: false);

                        budgetService.addSelectedPeriods(periods);
                      },
                    );
                  }),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: screenSize.width,
              height: screenSize.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text(
                        "Classes",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        "Periods",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Consumer<BudgetViewModel>(
                    builder: ((context, value, child) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: value.items.length,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return TransactionCard(
                              index: index,
                              item: value.items[index],
                            );
                          });
                    }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final ClassItem item;
  final int index;
  const TransactionCard({required this.item, required this.index, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet<dynamic>(
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            context: context,
            builder: (context) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: Consumer<BudgetViewModel>(
                  builder: ((context, value, child) {
                    return EditClassSheet(
                      curr: item,
                      classIndex: index,
                      classToEdit: (edittedClass) {
                        final budgetService = Provider.of<BudgetViewModel>(
                            context,
                            listen: false);

                        budgetService.updateClass(edittedClass, item, index);
                      },
                      periodsToUpdate: (periods) {
                        final budgetService = Provider.of<BudgetViewModel>(
                            context,
                            listen: false);

                        budgetService.addSelectedPeriods(periods);
                      },
                    );
                  }),
                ),
              );
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  spreadRadius: 1.2,
                  blurRadius: 1.2,
                  color: Colors.black.withOpacity(0.05))
            ],
          ),
          padding: const EdgeInsets.all(15.0),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Text(
                item.className,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              Text(
                item.periods.toString(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddTransactionDialog extends StatefulWidget {
  final Function(ClassItem) itemToAdd;
  final Function(List<dynamic>) periodsToUpdate;

  const AddTransactionDialog({
    required this.itemToAdd,
    required this.periodsToUpdate,
    Key? key,
  }) : super(key: key);

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController abbreviatedNameController =
      TextEditingController();
  final List<String> courseTypes = [
    'Gen',
    'AP',
    'IBSL',
    'IBHL',
  ];
  String? selectedType;

  final List<String> credits = ['0.25', '0.50', '1.00', '1.50'];
  String? selectedCredit;

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

  final List<int> colorIndices = [0, 1, 2, 3, 4, 5, 6, 7];
  int? selectedColor;

  final List<String> grades = [
    'A',
    'A-',
    'B+',
    'B',
    'B-',
    'C+',
    'C',
    'C-',
    'D+',
    'D',
    'D-',
    'F'
  ];
  String? selectedGrade;
  List<dynamic> isPeriodSelected = [
    [false, false, false, false, false],
    [false, false, false, false, false],
    [false, false, false, false, false],
    [false, false, false, false, false],
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const Text(
              'Add a Class',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 15.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  autocorrect: false,
                  controller: classNameController,
                  decoration: const InputDecoration(hintText: "Name of Class"),
                ),
                const SizedBox(height: 15.0),
                TextField(
                  textCapitalization: TextCapitalization.characters,
                  autocorrect: false,
                  maxLength: 5,
                  controller: abbreviatedNameController,
                  decoration:
                      const InputDecoration(hintText: "Abbreviated Name"),
                ),
                const Text('Periods: '),
                Column(
                  children: [
                    SizedBox(
                      width: 390,
                      height: 250,
                      child: Consumer<BudgetViewModel>(
                          builder: (context, value, child) {
                        List<dynamic> unavailablePeriods =
                            value.getAvailablePeriods();
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: 4,
                            itemBuilder: (context, i) {
                              String day = '';

                              if (i == 0) {
                                day = 'A';
                              } else if (i == 1) {
                                day = 'B';
                              } else if (i == 2) {
                                day = 'C';
                              } else if (i == 3) {
                                day = 'D';
                              }

                              return Column(
                                children: [
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: 390,
                                    height: 48,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: 5,
                                            itemBuilder: (context, j) {
                                              return OutlinedButton(
                                                  onPressed: unavailablePeriods[
                                                          i][j]
                                                      ? null
                                                      : () {
                                                          setState(() {
                                                            isPeriodSelected[i]
                                                                    [j] =
                                                                !isPeriodSelected[
                                                                    i][j];
                                                          });
                                                        },
                                                  style: OutlinedButton.styleFrom(
                                                      backgroundColor:
                                                          unavailablePeriods[i]
                                                                  [j]
                                                              ? Colors.grey[400]
                                                              : (isPeriodSelected[
                                                                      i][j]
                                                                  ? Colors
                                                                      .indigoAccent
                                                                  : Colors
                                                                      .white)),
                                                  child: Text(
                                                    '$day${j + 1}',
                                                    style: TextStyle(
                                                        color: unavailablePeriods[
                                                                i][j]
                                                            ? Colors.white
                                                            : (isPeriodSelected[
                                                                    i][j]
                                                                ? Colors.white
                                                                : Colors
                                                                    .indigo)),
                                                  ));
                                            }),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            });
                      }),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Color:'),
                    const SizedBox(width: 5),
                    DropdownButton2(
                      buttonDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey)),
                      buttonPadding: const EdgeInsets.only(left: 10),
                      underline: Container(),
                      dropdownDecoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      dropdownMaxHeight: 120,
                      dropdownWidth: 50,
                      icon: null,
                      alignment: Alignment.center,
                      itemPadding: const EdgeInsets.all(8.0),
                      items: colorIndices
                          .map((index) => DropdownMenuItem<int>(
                              value: index,
                              child:
                                  ColorDropDownItemChild(color: colors[index])))
                          .toList(),
                      value: selectedColor,
                      onChanged: (int? index) {
                        setState(() {
                          selectedColor = index;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                List<dynamic> selectedPeriodCodes = []; // in the form [i,j]
                List<String> selectedPeriods = []; // in the form A3, B2, etc

                selectedPeriods.clear();

                for (int i = 0; i < 4; i++) {
                  String day = '';
                  if (i == 0) {
                    day = 'A';
                  } else if (i == 1) {
                    day = 'B';
                  } else if (i == 2) {
                    day = 'C';
                  } else if (i == 3) {
                    day = 'D';
                  }
                  for (int j = 0; j < 5; j++) {
                    if (isPeriodSelected[i][j]) {
                      selectedPeriods.add('$day${j + 1}');
                      selectedPeriodCodes.add([i, j]);
                    }
                  }
                }

                widget.itemToAdd(
                  ClassItem(
                    className: classNameController.text,
                    periods: selectedPeriods,
                    periodCodes: selectedPeriodCodes,
                    abbreviatedName: abbreviatedNameController.text,
                    colorIndex: selectedColor!,
                  ),
                );

                widget.periodsToUpdate(selectedPeriodCodes);

                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}

class EditClassSheet extends StatefulWidget {
  final Function(ClassItem) classToEdit;
  final Function(List<dynamic>) periodsToUpdate;
  final ClassItem curr;
  final int classIndex;

  const EditClassSheet({
    required this.classToEdit,
    required this.periodsToUpdate,
    required this.curr,
    required this.classIndex,
    Key? key,
  }) : super(key: key);

  @override
  State<EditClassSheet> createState() => _EditClassSheetState();
}

class _EditClassSheetState extends State<EditClassSheet> {
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController abbreviatedNameController =
      TextEditingController();

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

  final List<int> colorIndices = [0, 1, 2, 3, 4, 5, 6, 7];
  int? selectedColor;

  List<dynamic> isPeriodSelected = [
    [false, false, false, false, false],
    [false, false, false, false, false],
    [false, false, false, false, false],
    [false, false, false, false, false],
  ];

  List<dynamic> currSelectedPeriods = [];
  @override
  void initState() {
    super.initState();
    final curr = widget.curr;
    classNameController.text = curr.className;
    abbreviatedNameController.text = curr.abbreviatedName;
    selectedColor = curr.colorIndex;

    currSelectedPeriods = curr.periodCodes;

    for (int i = 0; i < currSelectedPeriods.length; i++) {
      List<int> period = currSelectedPeriods[i];
      isPeriodSelected[period[0]][period[1]] = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    int indexOfCSP = 0;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 32),
                  const Text(
                    'Edit Class',
                    style: TextStyle(fontSize: 18),
                  ),
                  IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () => showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(children: [
                                  const SizedBox(
                                      width: 150,
                                      child: Text(
                                        "Do you want to delete this class?",
                                      )),
                                  const Spacer(),
                                  TextButton(
                                      onPressed: () {
                                        final budgetViewModel =
                                            Provider.of<BudgetViewModel>(
                                                context,
                                                listen: false);
                                        budgetViewModel.deleteItem(widget.curr);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Yes")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("No"))
                                ]),
                              ),
                            );
                          }),
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.primary,
                      ))
                ],
              ),
            ),
            const SizedBox(height: 15.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  autocorrect: false,
                  controller: classNameController,
                  decoration: const InputDecoration(hintText: "Name of Class"),
                ),
                const SizedBox(height: 15.0),
                TextField(
                  textCapitalization: TextCapitalization.characters,
                  autocorrect: false,
                  maxLength: 5,
                  controller: abbreviatedNameController,
                  decoration:
                      const InputDecoration(hintText: "Abbreviated Name"),
                ),
                const Text('Periods: '),
                Column(
                  children: [
                    SizedBox(
                      width: 390,
                      height: 250,
                      child: Consumer<BudgetViewModel>(
                          builder: (context, value, child) {
                        List<dynamic> unavailablePeriods =
                            value.getAvailablePeriods();
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: 4,
                            itemBuilder: (context, i) {
                              String day = '';

                              if (i == 0) {
                                day = 'A';
                              } else if (i == 1) {
                                day = 'B';
                              } else if (i == 2) {
                                day = 'C';
                              } else if (i == 3) {
                                day = 'D';
                              }

                              return Column(
                                children: [
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: 390,
                                    height: 48,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: 5,
                                            itemBuilder: (context, j) {
                                              List<dynamic> blockCode = [i, j];
                                              bool notCurrSelected = true;
                                              if (currSelectedPeriods
                                                  .isNotEmpty) {
                                                if (currSelectedPeriods[
                                                            indexOfCSP][0] ==
                                                        blockCode[0] &&
                                                    currSelectedPeriods[
                                                            indexOfCSP][1] ==
                                                        blockCode[1]) {
                                                  indexOfCSP++;
                                                  notCurrSelected = false;
                                                  if (indexOfCSP ==
                                                      currSelectedPeriods
                                                          .length) {
                                                    indexOfCSP = 0;
                                                  }
                                                }
                                              }

                                              return OutlinedButton(
                                                  onPressed: unavailablePeriods[
                                                              i][j] &&
                                                          notCurrSelected
                                                      ? null
                                                      : () {
                                                          setState(() {
                                                            isPeriodSelected[i]
                                                                    [j] =
                                                                !isPeriodSelected[
                                                                    i][j];
                                                            print(
                                                                currSelectedPeriods);
                                                          });
                                                        },
                                                  style: OutlinedButton.styleFrom(
                                                      backgroundColor:
                                                          unavailablePeriods[i]
                                                                      [j] &&
                                                                  notCurrSelected
                                                              ? Colors.grey[400]
                                                              : (isPeriodSelected[
                                                                      i][j]
                                                                  ? Colors
                                                                      .indigoAccent
                                                                  : Colors
                                                                      .white)),
                                                  child: Text(
                                                    '$day${j + 1}',
                                                    style: TextStyle(
                                                        color: unavailablePeriods[
                                                                    i][j] &&
                                                                notCurrSelected
                                                            ? Colors.white
                                                            : (isPeriodSelected[
                                                                    i][j]
                                                                ? Colors.white
                                                                : Colors
                                                                    .indigo)),
                                                  ));
                                            }),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            });
                      }),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Color:'),
                    const SizedBox(width: 5),
                    DropdownButton2(
                      buttonDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey)),
                      buttonPadding: const EdgeInsets.only(left: 10),
                      underline: Container(),
                      dropdownDecoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      dropdownMaxHeight: 120,
                      dropdownWidth: 50,
                      icon: null,
                      alignment: Alignment.center,
                      itemPadding: const EdgeInsets.all(8.0),
                      items: colorIndices
                          .map((index) => DropdownMenuItem<int>(
                              value: index,
                              child:
                                  ColorDropDownItemChild(color: colors[index])))
                          .toList(),
                      value: selectedColor,
                      onChanged: (int? index) {
                        setState(() {
                          selectedColor = index;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                List<dynamic> selectedPeriodCodes = []; // in the form [i,j]
                List<String> selectedPeriods = []; // in the form A3, B2, etc
                ClassItem curr = widget.curr;
                selectedPeriods.clear();

                for (int i = 0; i < 4; i++) {
                  String day = '';
                  if (i == 0) {
                    day = 'A';
                  } else if (i == 1) {
                    day = 'B';
                  } else if (i == 2) {
                    day = 'C';
                  } else if (i == 3) {
                    day = 'D';
                  }
                  for (int j = 0; j < 5; j++) {
                    if (isPeriodSelected[i][j]) {
                      selectedPeriods.add('$day${j + 1}');
                      selectedPeriodCodes.add([i, j]);
                    }
                  }
                }

                print(selectedPeriods);

                widget.classToEdit(
                  ClassItem(
                    className: classNameController.text,
                    periods: selectedPeriods,
                    periodCodes: selectedPeriodCodes,
                    abbreviatedName: abbreviatedNameController.text,
                    colorIndex: selectedColor!,
                    courseType: curr.courseType,
                    credit: curr.credit,
                    grade: curr.grade,
                  ),
                );

                widget.periodsToUpdate(selectedPeriodCodes);

                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}

class ColorDropDownItemChild extends StatelessWidget {
  final Color color;
  const ColorDropDownItemChild({required this.color, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: color),
    );
  }
}
