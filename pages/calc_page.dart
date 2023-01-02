import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/class_item.dart';
import '../view_models/budget_view_model.dart';

class CalcPage extends StatelessWidget {
  const CalcPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        "Class",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        "Type",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Credit",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 20),
                      Text(
                        "Grade",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 15,
                      )
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
                            return ClassCard(
                              item: value.items[index],
                              index: index,
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

class ClassCard extends StatelessWidget {
  final ClassItem item;
  final int index;
  const ClassCard({required this.index, required this.item, Key? key})
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
                height: 400,
                child: Consumer<BudgetViewModel>(
                  builder: ((context, value, child) {
                    return AddClassInfoSheet(
                      classIndex: index,
                      addInfoTo: item,
                      updatedClass: (updatedClass) {
                        final budgetService = Provider.of<BudgetViewModel>(
                            context,
                            listen: false);

                        budgetService.editClassInfo(updatedClass, index);
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
                color: Colors.black.withOpacity(.05),
                offset: const Offset(0, 25),
                blurRadius: 50,
              )
            ],
          ),
          padding: const EdgeInsets.all(15.0),
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 150,
                child: Text(
                  item.className,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const Spacer(),
              item.courseType == '0'
                  ? SizedBox(
                      height: 20,
                      child: Center(
                        child: ElevatedButton(
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 0)),
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
                                    height: 400,
                                    child: Consumer<BudgetViewModel>(
                                      builder: ((context, value, child) {
                                        return AddClassInfoSheet(
                                          classIndex: index,
                                          addInfoTo: item,
                                          updatedClass: (updatedClass) {
                                            final budgetService =
                                                Provider.of<BudgetViewModel>(
                                                    context,
                                                    listen: false);

                                            budgetService.editClassInfo(
                                                updatedClass, index);
                                          },
                                        );
                                      }),
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Text('Fill in information')),
                      ),
                    )
                  : Row(
                      children: [
                        const SizedBox(width: 10),
                        SizedBox(width: 35, child: Text(item.courseType)),
                        const SizedBox(width: 20),
                        SizedBox(
                            width: 44,
                            child: Text(
                              item.credit.toString(),
                              textAlign: TextAlign.center,
                            )),
                        const SizedBox(width: 20),
                        SizedBox(
                            width: 43,
                            child: Text(
                              item.grade,
                              textAlign: TextAlign.center,
                            )),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddClassInfoSheet extends StatefulWidget {
  final Function(ClassItem) updatedClass;
  final ClassItem addInfoTo;
  final int classIndex;

  const AddClassInfoSheet({
    required this.addInfoTo,
    required this.updatedClass,
    required this.classIndex,
    Key? key,
  }) : super(key: key);

  @override
  State<AddClassInfoSheet> createState() => _AddClassInfoSheetState();
}

class _AddClassInfoSheetState extends State<AddClassInfoSheet> {
  final List<String> courseTypes = [
    'Gen',
    'AP',
    'IBSL',
    'IBHL',
  ];
  String selectedType = 'Gen';

  final List<String> credits = ['0.25', '0.50', '1.00', '1.50'];
  String selectedCredit = '0.25';

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
  String selectedGrade = 'A';

  @override
  void initState() {
    super.initState();
    final currInfo = widget.addInfoTo;
    if (currInfo.courseType != '0') {
      selectedType = currInfo.courseType;
    }
    if (currInfo.credit != '0') {
      selectedCredit = currInfo.credit;
    }
    if (currInfo.grade != '0') {
      selectedGrade = currInfo.grade;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    ClassItem currClass = widget.addInfoTo;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(children: [
        Text(
          'Add Information for ${widget.addInfoTo.className}',
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15.0),
            Stack(alignment: Alignment.center, children: [
              Container(
                width: screenSize.width - 30,
                height: 35,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
              ),
              SizedBox(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('Type',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: (screenSize.width - 138) / 4,
                        child: ListWheelScrollView(
                          controller: currClass.courseType == '0'
                              ? null
                              : FixedExtentScrollController(
                                  initialItem: courseTypes
                                      .indexOf(currClass.courseType)),
                          itemExtent: 25,
                          diameterRatio: 0.9,
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (value) {
                            selectedType = courseTypes[value];
                          },
                          children: courseTypes
                              .map((type) => DropdownMenuItem<String>(
                                  value: type, child: Text(type)))
                              .toList(),
                        ),
                      ),
                      const Text('Credit',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: (screenSize.width - 138) / 4,
                        child: ListWheelScrollView(
                          controller: currClass.credit == '0'
                              ? null
                              : FixedExtentScrollController(
                                  initialItem:
                                      credits.indexOf(currClass.credit)),
                          itemExtent: 25,
                          diameterRatio: 0.9,
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (value) {
                            selectedCredit = credits[value];
                          },
                          children: credits
                              .map((credit) => DropdownMenuItem<String>(
                                  value: credit, child: Text(credit)))
                              .toList(),
                        ),
                      ),
                      const Text('Grade',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 25,
                        child: ListWheelScrollView(
                          controller: currClass.grade == '0'
                              ? null
                              : FixedExtentScrollController(
                                  initialItem: grades.indexOf(currClass.grade)),
                          itemExtent: 25,
                          diameterRatio: 0.9,
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (value) {
                            selectedGrade = grades[value];
                          },
                          children: grades
                              .map((grade) => DropdownMenuItem<String>(
                                  value: grade, child: Text(grade)))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 40,
                      decoration: const BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(250, 250, 250, 1),
                          offset: Offset(0, -10),
                          blurRadius: 10,
                        )
                      ]),
                    ),
                    Container(
                      height: 40,
                      decoration: const BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(250, 250, 250, 1),
                          offset: Offset(0, 10),
                          blurRadius: 10,
                        )
                      ]),
                    ),
                  ],
                ),
              )
            ]),
          ],
        ),
        const SizedBox(height: 15.0),
        Consumer<BudgetViewModel>(builder: ((context, value, child) {
          return ElevatedButton(
              onPressed: () {
                ClassItem curr = widget.addInfoTo;
                widget.updatedClass(ClassItem(
                  className: curr.className,
                  abbreviatedName: curr.abbreviatedName,
                  periodCodes: curr.periodCodes,
                  periods: curr.periods,
                  colorIndex: curr.colorIndex,
                  courseType: selectedType,
                  credit: selectedCredit,
                  grade: selectedGrade,
                ));
                Navigator.pop(context);
              },
              child: const Text("Add"));
        }))
      ]),
    );
  }
}
