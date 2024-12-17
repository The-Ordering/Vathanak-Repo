import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_hive/model/category_home_model.dart';

enum Category {Education,Work,Groceries}
enum Priority {Low,Medium,High}
enum OnPageChange {create,edit}

class TodoNotifier extends ChangeNotifier{
  final TextEditingController dateTimeController = TextEditingController();
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  TimeOfDay? selectedStartTime = TimeOfDay.now();
  TimeOfDay? selectedEndTime = TimeOfDay.now();
  Category? selectCategory;
  Priority? selectPriority;
  OnPageChange? pageChange;
  String? category,priority;
  String? startTime,endTime;
  late String idTodo;

  void clearTodo(){
    taskNameController.clear();         // Clears the task name text field
    selectCategory = null;              // Resets selected category
    dateTimeController.clear();         // Clears the date time text field
    startTime = null;                   // Resets the start time string
    selectedStartTime = null;           // Resets the selected start time
    endTime = null;                     // Resets the end time string
    selectedEndTime = null;             // Resets the selected end time
    selectPriority = null;              // Resets selected priority
    descriptionController.clear();
    category = null;
    priority = null;
    notifyListeners();
  }

  void getEditDate(String id,String name,String categorys,String dateTime,String startTimes,String endTimes,String prioritys,String description){
    pageChange = OnPageChange.edit;
    idTodo = id;
    taskNameController.text = name;
    selectCategory = Category.values.firstWhere(
        (e) => e.name == categorys,
      orElse:  () => Category.Education,
    );
    category = categorys;
    dateTimeController.text = dateTime;
    startTime = startTimes;
    selectedStartTime = _parseTimeOfDay(startTimes);
    endTime = endTimes;
    selectedEndTime = _parseTimeOfDay(endTimes);
    selectPriority = Priority.values.firstWhere(
          (e) => e.name == prioritys,
      orElse:  () => Priority.Low,
    );
    priority = prioritys;
    descriptionController.text = description;
    notifyListeners();
  }

  TimeOfDay _parseTimeOfDay(String timeString) {
    // Format: "09:00 PM"
    final timeParts = timeString.split(' ');
    final time = timeParts[0].split(':');
    final period = timeParts[1];

    int hour = int.parse(time[0]);
    final int minute = int.parse(time[1]);

    // Convert to 24-hour format if needed
    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  Color getPriorityColorButton(Priority prio){
    return selectPriority == prio ? Color(0xFF9747FF) : Color(0x4D9747FF);
  }

  Color getPriorityColorTextButton(Priority prio){
    return selectPriority == prio ? Colors.white : Colors.black;
  }

  void selectedPriority(Priority prio){
    selectPriority = prio;
    priority = selectPriority?.name;
    print('${priority}');
    notifyListeners();
  }

  Color getCategoryColorButton(Category cat){
    return selectCategory == cat ? Color(0xFF9747FF) : Color(0x4D9747FF);
  }

  Color getCategoryColorTextButton(Category cat){
    return selectCategory == cat ? Colors.white : Colors.black;
  }

  void selectedCategory(Category cat){
    selectCategory = cat;
    category = selectCategory?.name;
    print('${category}');
    notifyListeners();
  }

  Future<void> selectEndTime(BuildContext context) async{
    final TimeOfDay? timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if(timePicked != null){
      selectedEndTime = timePicked;
      endTime = formatTime(selectedEndTime!);
      notifyListeners();
    }
  }

  Future<void> selectStartTime(BuildContext context) async{
   final TimeOfDay? timePicked = await showTimePicker(
       context: context,
       initialTime: TimeOfDay.now(),
   );
   if(timePicked != null){
     selectedStartTime = timePicked;
     startTime = formatTime(selectedStartTime!);
     notifyListeners();
   }
  }

  String formatTime(TimeOfDay time){
    final now  = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour,time.minute);
    return DateFormat('hh:mm a').format(dt);
  }

  String getMonthName(int month){
    List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month - 1];
  }

  String getDayName(int weekDay){
    List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[weekDay -1];
  }

  void getDateTime(DateTime selectedDate){
    String formattedDate = '${selectedDate.day} ${getMonthName(selectedDate.month)}, ${getDayName(selectedDate.weekday)}';
    dateTimeController.text = formattedDate;
    notifyListeners();
  }
}