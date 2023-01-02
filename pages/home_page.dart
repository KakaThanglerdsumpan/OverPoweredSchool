import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:opschooldraft1/main.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import '../model/transaction_item.dart';
import '../services/period_selection_service.dart';
import '../view_models/budget_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
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
              return Container(
                height: MediaQuery.of(context).size.height * 0.75,
                child: Consumer<BudgetViewModel>(
                  builder: ((context, value, child) {
                    return AddTransactionDialog(
                      itemToAdd: (transactionItem) {
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
  final TransactionItem item;
  const TransactionCard({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, top: 5.0),
      child: GestureDetector(
        onTap: () => showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(children: [
                    const Text("Delete Item"),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          final budgetViewModel = Provider.of<BudgetViewModel>(
                              context,
                              listen: false);
                          budgetViewModel.deleteItem(item);
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
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                offset: const Offset(0, 25),
                blurRadius: 50,
              )
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
  final Function(TransactionItem) itemToAdd;
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
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
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
    Size screenSize = MediaQuery.of(context).size;
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
                  // mainAxisAlignment: MainAxisAlignment.center,
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
                  TransactionItem(
                    className: classNameController.text,
                    periods: selectedPeriods,
                    periodCodes: selectedPeriodCodes,
                    abbreviatedName: abbreviatedNameController.text,
                    colorIndex: selectedColor!,
                  ),
                );

                widget.periodsToUpdate(selectedPeriodCodes);

                // periodSelectionService.periods = [];
                // periodSelectionService.periodCodes = [];
                // periodSelectionService.isPeriodSelectedTMP = [
                //   [false, false, false, false, false], // day A
                //   [false, false, false, false, false], // day B
                //   [false, false, false, false, false], // day C
                //   [false, false, false, false, false], // day D
                // ];
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

class SelectPeriod extends StatefulWidget {
  final Function(List<String>) periodsToAdd;
  final Function(List<dynamic>) periodCodesToAdd;
  final Function(List<dynamic>) periodSelections;
  final List<dynamic> isPeriodSelectedTMP;

  SelectPeriod({
    required this.periodsToAdd,
    required this.periodCodesToAdd,
    required this.periodSelections,
    this.isPeriodSelectedTMP = const [
      [false, false, false, false, false],
      [false, false, false, false, false],
      [false, false, false, false, false],
      [false, false, false, false, false],
    ],
    Key? key,
  }) : super(key: key);

  @override
  State<SelectPeriod> createState() => _SelectPeriodState();
}

class _SelectPeriodState extends State<SelectPeriod> {
  List<dynamic> isPeriodSelected = [
    [false, false, false, false, false],
    [false, false, false, false, false],
    [false, false, false, false, false],
    [false, false, false, false, false],
  ];

  List<String> selectedPeriods = [];
  @override
  void initState() {
    super.initState();
    isPeriodSelected = widget.isPeriodSelectedTMP;
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 390,
          height: 250,
          child: Consumer<BudgetViewModel>(builder: (context, value, child) {
            List<dynamic> unavailablePeriods = value.getAvailablePeriods();
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: 5,
                                itemBuilder: (context, j) {
                                  return OutlinedButton(
                                      onPressed: unavailablePeriods[i][j]
                                          ? null
                                          : () {
                                              setState(() {
                                                isPeriodSelected[i][j] =
                                                    !isPeriodSelected[i][j];
                                              });
                                            },
                                      style: OutlinedButton.styleFrom(
                                          backgroundColor: unavailablePeriods[i]
                                                  [j]
                                              ? Colors.grey[400]
                                              : (isPeriodSelected[i][j]
                                                  ? Colors.indigoAccent
                                                  : Colors.white)),
                                      child: Text(
                                        '$day${j + 1}',
                                        style: TextStyle(
                                            color: unavailablePeriods[i][j]
                                                ? Colors.white
                                                : (isPeriodSelected[i][j]
                                                    ? Colors.white
                                                    : Colors.indigo)),
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
        ElevatedButton(
            onPressed: () {
              List<dynamic> selectedPeriodCodes = [];

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

              widget.periodsToAdd(selectedPeriods);
              widget.periodCodesToAdd(selectedPeriodCodes);
              widget.periodSelections(isPeriodSelected);
            },
            child: const Text("Done"))
      ],
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
