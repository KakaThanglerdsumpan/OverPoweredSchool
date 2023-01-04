import 'package:flutter/material.dart';
import '../model/class_item.dart';
import '../services/local_storage_service.dart';

class BudgetViewModel extends ChangeNotifier {
  List<dynamic> getMatrix() => LocalStorageService().getScheduleMatrix();
  List<dynamic> getAvailablePeriods() =>
      LocalStorageService().getAvailablePeriods();
  List<ClassItem> get items => LocalStorageService().getAllTransactions();

  void addItem(ClassItem item) {
    LocalStorageService().saveClassItem(item);
    LocalStorageService().updateScheduleMatrix(item);
    notifyListeners();
  }

  void editClassInfo(ClassItem updatedClass, int index) {
    LocalStorageService().updateClassInfo(updatedClass, index);
    notifyListeners();
  }

  void updateClass(ClassItem updatedClass, ClassItem currClass, int index) {
    LocalStorageService().updateClassInfo(updatedClass, index);
    LocalStorageService()
        .updateAvailablePeriodsAfterDelete(currClass.periodCodes);
    LocalStorageService().updateMatrixAfterDelete(currClass.periodCodes);
    LocalStorageService().updateAvailablePeriods(updatedClass.periodCodes);
    LocalStorageService().updateScheduleMatrix(updatedClass);
    notifyListeners();
  }

  void addSelectedPeriods(List<dynamic> periods) {
    LocalStorageService().updateAvailablePeriods(periods);

    notifyListeners();
  }

  List<double> updateGPA() {
    double totalCredits = 0;
    double totalUWGP = 0; // total unweighted grade points * credits
    double totalWGP = 0; // total weighted grade points * credits
    double uwgpa = 0;
    double gpa = 0;

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

    for (int i = 0; i < items.length; i++) {
      double uwgp = 0;
      double wgp = 0;
      String grade = items[i].grade;
      String courseType = items[i].courseType;
      double credit = double.parse(items[i].credit);

      totalCredits += credit;

      if (grade != 'F') {
        uwgp = 4.00 - (1 / 3) * grades.indexOf(grade);
        if (courseType == 'Gen' || grades.indexOf(grade) >= 8) {
          wgp = uwgp;
        } else if (courseType == 'AP' || courseType == 'IBHL') {
          wgp = uwgp + 0.50;
        } else if (courseType == 'IBSL') {
          wgp = uwgp + 0.25;
        }
      }

      totalUWGP += uwgp * credit;
      totalWGP += wgp * credit;
    }

    uwgpa = totalUWGP / totalCredits;
    gpa = totalWGP / totalCredits;

    return [uwgpa, gpa, totalCredits];
  }

  void deleteItem(ClassItem item) {
    final localStorage = LocalStorageService();

    localStorage.deleteClassItem(item);

    notifyListeners();
  }
}
