import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/transaction_item.dart';
import '../view_models/budget_view_model.dart';
import 'home_page.dart';

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
  final TransactionItem item;
  const ClassCard({required this.item, Key? key}) : super(key: key);

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
              return Container(
                height: 400,
                child: Consumer<BudgetViewModel>(
                  builder: ((context, value, child) {
                    return AddClassInfoSheet(
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
              const SizedBox(width: 10),
              const SizedBox(width: 35, child: Text('IBSL')),
              const SizedBox(width: 20),
              const SizedBox(width: 44, child: Text('1.50')),
              const SizedBox(width: 20),
              const SizedBox(width: 43, child: Text('D-')),
            ],
          ),
        ),
      ),
    );
  }
}

class AddClassInfoSheet extends StatefulWidget {
  final Function(TransactionItem) itemToAdd;
  final Function(List<dynamic>) periodsToUpdate;

  const AddClassInfoSheet({
    required this.itemToAdd,
    required this.periodsToUpdate,
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
  String? selectedType;

  final List<String> credits = ['0.25', '0.50', '1.00', '1.50'];
  String? selectedCredit;

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

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(children: [
        const Text(
          'Add Class Information',
          style: TextStyle(fontSize: 18),
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

                      // const SizedBox(width: 5),
                      SizedBox(
                        width: (screenSize.width - 138) / 4,
                        child: ListWheelScrollView(
                          itemExtent: 25,
                          physics: const FixedExtentScrollPhysics(),
                          children: courseTypes
                              .map((type) => DropdownMenuItem<String>(
                                  value: type, child: Text(type)))
                              .toList(),
                        ),
                      ),
                      const Text('Credit',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      // const SizedBox(width: 5),
                      SizedBox(
                        width: (screenSize.width - 138) / 4,
                        child: ListWheelScrollView(
                          itemExtent: 25,
                          physics: const FixedExtentScrollPhysics(),
                          children: credits
                              .map((credit) => DropdownMenuItem<String>(
                                  value: credit, child: Text(credit)))
                              .toList(),
                        ),
                      ),
                      const Text('Grade',
                          style: TextStyle(fontWeight: FontWeight.bold)),

                      // const SizedBox(width: 5),
                      SizedBox(
                        width: 25,
                        child: ListWheelScrollView(
                          itemExtent: 25,
                          physics: const FixedExtentScrollPhysics(),
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
            ]),
          ],
        ),
        const SizedBox(height: 15.0),
        Consumer<BudgetViewModel>(builder: ((context, value, child) {
          return ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Add"));
        }))
      ]),
    );
  }
}
