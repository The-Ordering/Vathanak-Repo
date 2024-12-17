import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_hive/main.dart';
import 'package:todo_hive/services/todo_api.dart';
import 'package:todo_hive/services/todo_notifier.dart';

class EditTaskScreen extends StatelessWidget {
  static const String routerName = 'editTodo';

  const EditTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todoNotifier = Provider.of<TodoNotifier>(context);
    final todoApi = TodoApi();
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              todoNotifier.clearTodo();
              context.pop();
            },
            child: const Icon(Icons.arrow_back, size: 20,)),
        title: Text(todoNotifier.pageChange == OnPageChange.create ? "Create a new Task" : 'Edit the Task', style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'poppins')),
        actions: [Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: Icon(Icons.menu, size: 20,),
        )
        ],
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Task Name", style: TextStyle(fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'poppins')),
              const SizedBox(height: 10),
              TextField(
                controller: todoNotifier.taskNameController,
                decoration: InputDecoration(
                  hintText: "Input Task Name",
                  hintStyle: TextStyle(fontSize: 13, fontFamily: 'poppins',fontWeight: FontWeight.w500),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0x33000000))
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0x33000000))
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Category", style: TextStyle(fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'poppins')),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  categorySelector(context,"Education",Category.Education),
                  categorySelector(context,"Work",Category.Work),
                  categorySelector(context,"Groceries",Category.Groceries),
                ],
              ),
              const SizedBox(height: 20),
              const Text("Date & Time", style: TextStyle(fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'poppins')),
              const SizedBox(height: 8),
              TextField(
                controller: todoNotifier.dateTimeController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Pick a Date on the Calender",
                  hintStyle: TextStyle(fontSize: 13, fontFamily: 'poppins',fontWeight: FontWeight.w500),
                  suffixIcon: GestureDetector(
                      onTap: () async{
                        DateTime? selectedDate = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030)
                        );
                        if(selectedDate != null){
                          todoNotifier.getDateTime(selectedDate);
                        }
                      },
                      child: const Icon(Icons.calendar_month,color: Color(0xFF9747FF),)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0x33000000))
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0x33000000))
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Start Time', style: TextStyle(fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppins')),
                      const SizedBox(height: 5),
                      Container(
                        width: 129,
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0x33000000)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${todoNotifier.startTime ?? 'Pick Time'}', style: const TextStyle(fontSize: 12,fontFamily: 'poppins')),
                            GestureDetector(
                                onTap: () async{
                                  await todoNotifier.selectStartTime(context);
                                  print('${todoNotifier.startTime}');
                                  print('${todoNotifier.formatTime(todoNotifier.selectedStartTime!)}');
                                },
                                child: Icon(Icons.timer,color: Color(0xFF9747FF),size: 17,))
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('End Time', style: TextStyle(fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'poppins')),
                      const SizedBox(height: 5),
                      Container(
                        width: 129,
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0x33000000)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${todoNotifier.endTime ?? 'Pick Time'}', style: const TextStyle(fontSize: 12,fontFamily: 'poppins')),
                            GestureDetector(
                                onTap: () async{
                                  await todoNotifier.selectEndTime(context);
                                  print('${todoNotifier.endTime}');
                                  print('${todoNotifier.formatTime(todoNotifier.selectedEndTime!)}');
                                },
                                child: Icon(Icons.timer,color: Color(0xFF9747FF),size: 17,))
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text("Priority", style: TextStyle(fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'poppins')),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  prioritySelector(context,"Low",Priority.Low),
                  prioritySelector(context,"Medium",Priority.Medium),
                  prioritySelector(context,"High",Priority.High),
                ],
              ),
              const SizedBox(height: 20),
              const Text("Description", style: TextStyle(fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'poppins')),
              const SizedBox(height: 8),
              TextField(
                controller: todoNotifier.descriptionController,
                textInputAction: TextInputAction.done,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                  "Input Description here:",
                  hintStyle: TextStyle(fontSize: 13, fontFamily: 'poppins',fontWeight: FontWeight.w500),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0x33000000))
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0x33000000))
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 194,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF9747FF),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: (){
                      if(todoNotifier.pageChange == OnPageChange.create){
                        todoApi.createTodoData(context,
                            todoNotifier.taskNameController.text,
                            todoNotifier.category ?? 'Education',
                            todoNotifier.dateTimeController.text,
                            todoNotifier.formatTime(todoNotifier.selectedStartTime!),
                            todoNotifier.formatTime(todoNotifier.selectedEndTime!),
                            todoNotifier.priority ?? 'Low',
                            todoNotifier.descriptionController.text);
                        todoNotifier.clearTodo();
                        context.pop();
                      }else{
                        print('Edit Button');
                        todoApi.updateTodoData(context,todoNotifier.idTodo,
                            todoNotifier.taskNameController.text,
                            todoNotifier.category ?? 'Education',
                            todoNotifier.dateTimeController.text,
                            todoNotifier.formatTime(todoNotifier.selectedStartTime!),
                            todoNotifier.formatTime(todoNotifier.selectedEndTime!),
                            todoNotifier.priority ?? 'Low',
                            todoNotifier.descriptionController.text);
                        todoNotifier.clearTodo();
                        context.pop();
                      }
                    },
                    child: Text(
                      todoNotifier.pageChange == OnPageChange.create ?
                      "Save" : 'Edit',
                        style: TextStyle(color: Colors.white, fontSize: 18,fontFamily: 'poppins'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget categorySelector(BuildContext context,String text,Category cat) {
    final todoNotifier = Provider.of<TodoNotifier>(context);
    return Container(
      width: 100,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: todoNotifier.getCategoryColorButton(cat),
      ),
      child: TextButton(onPressed: () {
        todoNotifier.selectedCategory(cat);
      },
          child: Text('$text', style:
          TextStyle(
              color:  todoNotifier.getCategoryColorTextButton(cat),
              fontSize: 10,
          fontWeight: FontWeight.w500,
          fontFamily: 'poppins'))),
    );
  }

  Widget prioritySelector(BuildContext context,String text, Priority prio) {
    final todoNotifier = Provider.of<TodoNotifier>(context);
    return Container(
      width: 100,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: todoNotifier.getPriorityColorButton(prio),
      ),
      child: TextButton(onPressed: () async{
        todoNotifier.selectedPriority(prio);
      },
          child: Text('$text', style:
          TextStyle(
              color:  todoNotifier.getPriorityColorTextButton(prio),
              fontSize: 10,
              fontWeight: FontWeight.w500,
              fontFamily: 'poppins'))),
    );
  }
}
