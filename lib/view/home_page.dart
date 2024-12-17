import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_hive/main.dart';
import 'package:todo_hive/model/category_home_model.dart';
import 'package:todo_hive/services/auth_notifiier.dart';
import 'package:todo_hive/services/todo_api.dart';
import 'package:todo_hive/services/todo_notifier.dart';
import 'package:todo_hive/view/edit_todo_page.dart';
import 'package:todo_hive/view/profile_page.dart';

class HomeScreen extends StatelessWidget {
  static const String routerName = 'homePage';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todoNotifier = Provider.of<TodoNotifier>(context);
    final authenNotifier = Provider.of<AuthNotifier>(context);
    final todoApi = TodoApi();
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Hello ${authenNotifier.getName() ?? 'Random User'},",
                                style:
                                TextStyle(fontSize: 20, fontWeight: FontWeight.bold,fontFamily: 'poppins')),
                            Text("You have work today",
                                style: TextStyle(color: Colors.grey,fontFamily: 'poppins',fontSize: 12)),
                          ],
                        ),
                        CircleAvatar(
                          radius: 24,
                          child: GestureDetector(
                            onTap: (){
                              authenNotifier.editUserProfile();
                              context.goNamed(ProfilePage.routerName);
                            },
                            child: Hero(
                                tag: 'profile_tag',
                                child: Image.asset('assets/images/profile_image.png',fit: BoxFit.cover,)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 240,
                    child: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
                      stream: FirebaseFirestore.instance.collection('todos').snapshots(),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const Center(child: CircularProgressIndicator(),);
                        }
                          final docs = snapshot.data!.docs;
                          CategoryHomeModel.updateCategoryCounts(docs);
                          return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount: 2,
                                childAspectRatio: 1.5,
                              ),
                              itemCount: CategoryHomeModel.categoryHomeList.length,
                              itemBuilder: (context,index){
                                CategoryHomeModel.categoryHomeList[0].count = docs.length;
                                final category = CategoryHomeModel.categoryHomeList[index];
                                return _taskCategory(category.color, category.iconData, category.name,category.count);
                              }
                          );

                      }
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9.0),
                    child: const Text("Today's Tasks",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,fontFamily: 'poppins')),
                  ),
                  SizedBox(height: 13,),
                  SizedBox(
                    width: double.infinity,
                    child: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
                      stream: FirebaseFirestore.instance.collection('todos').snapshots(),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                          return const Center(child: Text('No Todo Task',style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,fontFamily: 'poppins')));
                        }

                          final docs = snapshot.data!.docs;
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: docs.length,
                              itemBuilder: (context,index){
                                final todos = docs[index].data();
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    width: 317,
                                    height: 85,
                                    decoration: BoxDecoration(
                                        color: todos['completed'] == true ? Color(0xFFCFF3E9) : Colors.transparent,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(color: Color(0xFFD5D5D5))
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Slidable(
                                        endActionPane: ActionPane(
                                            motion: const StretchMotion(),
                                            children: [
                                              SlidableAction(
                                                onPressed: (context) async{
                                                  final newStatus = !(todos['completed'] ?? false);
                                                  await todoApi.updateCompleteTodo(context, todos['id'], newStatus);
                                                },
                                                backgroundColor: todos['completed'] == true ? Colors.red : Color(0xFF7BC043),
                                                foregroundColor: Colors.white,
                                                icon: todos['completed'] == true ? Icons.remove_circle_outline : Icons.edit,
                                                label: todos['completed'] == true ? 'Remove' : 'Completed',
                                              ),
                                            ]),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            AnimatedContainer(
                                              duration: Duration(milliseconds: 500),
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                color: todos['completed'] == true ? Color(0xFF34A853) : Colors.transparent,
                                                shape: BoxShape.circle,
                                                border: Border.all(color: Color(0xC4757575),width: 2.5),
                                              ),
                                              child: Icon(todos['completed'] == true ? Icons.check: null,size: 15,color: Colors.white,),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 158,
                                                  height: 24,
                                                  child: Text("${todos['name']}",
                                                      overflow: TextOverflow.ellipsis,
                                                      style:
                                                      TextStyle(fontSize: 17, fontWeight: FontWeight.bold,fontFamily: 'poppins')),
                                                ),
                                                SizedBox(height: 3,),
                                                Text("${todos['startTime']} to ${todos['endTime']}",
                                                    style: TextStyle(color: Colors.grey,fontFamily: 'poppins',fontSize: 11)),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                    onTap: () async{
                                                      todoNotifier.getEditDate(
                                                          todos['id'],
                                                          todos['name'],
                                                          todos['category'],
                                                          todos['dateTime'],
                                                          todos['startTime'],
                                                          todos['endTime'],
                                                          todos['priority'],
                                                          todos['description']
                                                      );
                                                      context.goNamed(EditTaskScreen.routerName);
                                                    },
                                                    child: Icon(Icons.edit,size: 20,color: Color(0xC4757575),)),
                                                SizedBox(width: 10,),
                                                GestureDetector(
                                                    onTap: (){
                                                      showDialog(context: context, builder: (context)=>AlertDialog(
                                                          title: Text('Delete'),
                                                          content: Text('Do you want to delete?'),
                                                          actions: [
                                                            TextButton(onPressed: (){
                                                              context.pop();
                                                            }, child: Text('No')),
                                                            TextButton(onPressed: () async{
                                                              await todoApi.deleteTodoData(context, todos['id']);
                                                              context.pop();
                                                            }, child: Text('Yes')),
                                                          ]
                                                      ));
                                                    },
                                                    child: Icon(Icons.delete_outline,size: 20,color: Colors.red,)),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });

                      }
                    )
                  ),
                  SizedBox(height: 65,),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Color(0xFF9747FF),
                  ),
                  onPressed: () {
                    todoNotifier.pageChange = OnPageChange.create;
                    context.goNamed(EditTaskScreen.routerName);
                  },
                  child: const Text("Create new task",
                      style: TextStyle(color: Colors.white, fontSize: 18,fontFamily: 'poppins')),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _taskCategory(Color color, IconData icon, String name,int count) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(icon,size: 13,color: color,),
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Text(name,
                  style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold,fontFamily: 'poppins')),
              const SizedBox(height: 8),
              Spacer(),
              Text(count.toString(), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold,fontFamily: 'poppins')),
            ],
          ),
        ],
      ),
    );
  }
}
