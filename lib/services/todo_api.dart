import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TodoApi{

  Future<List> getCategoryData({required String Categories}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("todos").get();

    List cateogorys = querySnapshot.docs
        .map((doc) {
      return doc.get("category").toString();
    })
        .where((category) => category == Categories && category.isNotEmpty)
        .toList();
    return cateogorys;
  }

   Future<void> deleteTodoData(BuildContext context,String id) async{
    DocumentReference documentReference = FirebaseFirestore.instance.collection('todos').doc(id);
    documentReference.delete().whenComplete((){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete Todo Completed'),
            duration: const Duration(seconds: 1),
          )
      );
    });
  }

  Future<void> updateCompleteTodo(BuildContext context,String id,bool completed) async{
    DocumentReference documentReference = FirebaseFirestore.instance.collection('todos').doc(id);
    Map<String, dynamic> Todos = {
      'completed': completed,
    };
    documentReference.update(Todos).whenComplete((){
      print('Update Completed');
    });
  }

   Future<void> updateTodoData(BuildContext context,String id,String name,String category,String dateTime,String startTime,String endTime,String priority,String description) async{
    DocumentReference documentReference = FirebaseFirestore.instance.collection('todos').doc(id);

    Map<String, dynamic> Todos = {
      'name': name,
      'category': category,
      'dateTime': dateTime,
      'startTime': startTime,
      'endTime': endTime,
      'priority': priority,
      'description': description,
    };

    documentReference.update(Todos).whenComplete((){
      print('Update Todo complete');
    });
  }

  Future<void> createTodoData(BuildContext context,String name,String category,String dateTime,String startTime,String endTime,String priority,String description) async{
    var uuid = Uuid();
    String id = uuid.v1();

    DocumentReference documentReference = FirebaseFirestore.instance.collection('todos').doc(id);

    Map<String, dynamic> Todos = {
      'id': id,
      'name': name,
      'category': category,
      'dateTime': dateTime,
      'startTime': startTime,
      'endTime': endTime,
      'priority': priority,
      'description': description,
      'isCompleted': false,
    };

    documentReference.set(Todos).whenComplete((){
      print('Create Todo complete');
    });
  }

}