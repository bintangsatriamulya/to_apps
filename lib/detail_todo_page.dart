import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_apps/input_todo.dart';
import 'package:to_apps/list_to_do.dart';
import 'package:to_apps/todo.dart';

class DetailTodoPage extends StatelessWidget {
  final Todo todo;

  DetailTodoPage({required this.todo});

  Future<void> deleteData(Todo todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();List<String> dataList = prefs.getStringList('data') ?? [];dataList.removeWhere((data) {
      final Map<String, dynamic> decodedData = jsonDecode(data);
      final String id = decodedData['id'];
      return id == todo.id;
      }
    );
      prefs.setStringList('data', dataList);
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Details'),
      ),
      body: Column(
        children: [
          if(todo.attachments.isEmpty)
          Image.file(File(todo.attachments),width: 150,height: 150,),
          buildDetailItem('Title', todo.title),
          buildDetailItem('Description', todo.description),
          buildDetailItem('Priority', todo.priority.toString()),
          buildDetailItem('Due Date', todo.dueDate),
          buildDetailItem('Status', todo.status),
          buildDetailItem('Tags', todo.tags.join(', ')),
          SizedBox(height: 16,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => InputTodoPage(todo: todo,)
                  ));
                }, 
                child: Text('Edit'),
                ),
                SizedBox(height: 16,),
                ElevatedButton(
                  onPressed: (){
                    showDialog(
                      context: context, 
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confrim Delete'),
                          content: Text('Are you sure to delete this item ?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              }, child: Text('Cancel')
                              ),
                              TextButton(
                                onPressed: (){
                                  deleteData(todo);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ListTodoPage(),
                                  ),
                                  );
                                }, child: Text('Delete'))
                          ],
                        );
                      }
                    );
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.green[400]),
                  child: Text('Delete'),
                )
            ],
          )

        ],
      ),
    );
  }
}
 Widget buildDetailItem(String label,String value){
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Row(
      children: [
        Text('$label: ',style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value)
      ],
    ),

  );

 }