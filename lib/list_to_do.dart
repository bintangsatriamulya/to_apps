import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_apps/detail_todo_page.dart';
import 'package:to_apps/input_todo.dart';
import 'package:to_apps/todo.dart';

class ListTodoPage extends StatefulWidget {
  @override
  _ListTodoPageState createState() => _ListTodoPageState();
  
}
class _ListTodoPageState extends State<ListTodoPage> {
  List<Todo> todos = [];

  void initState (){
    super.initState();
    getData();
  }

Future<void> getData() async {
 SharedPreferences prefs = await SharedPreferences.getInstance();
 List<String> dataList = prefs.getStringList('data') ?? [];
 List<Todo> parsedData = [];
 for (String dataItem in dataList) {
 debugPrint(dataItem);
 Map<String, dynamic> decodedData = jsonDecode(dataItem);
 Todo todo = Todo(
 id: decodedData['id'],
 title: decodedData['title'],
 description: decodedData['description'],
 priority: decodedData['priority'],
 dueDate: decodedData['dueDate'] ?? "-",
 status: decodedData['Status'] ?? "-",
 tags: (decodedData['Tags'] as String).replaceAll('[', '').replaceAll(']', '').split(', '),
 attachments: decodedData['attachments'] ?? "-",
 );
 parsedData.add(todo);
 
}
 setState(() {
 todos = parsedData;
 });
 
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('MyTodo App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: <Widget>[
          IconButton(
            onPressed:(){
              getData();
            }, 
            icon:Icon(Icons.refresh_rounded),
            ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        child: todos.isEmpty ? Center(child: Text('No Data Available'),) :
        ListView.separated(
          separatorBuilder: (context, index) => Divider(color: Colors.black54,),
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int index){
            Todo todo =todos[index];
            return ListTile(
              leading: SizedBox(
                 width: 56, // Adjust the width as needed
                 child: todo.attachments.isNotEmpty? Image.file(File(todo.attachments)): Icon(Icons.image),
                 ), 
              title: Text(todo.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description: ${todo.description}'),
                  Text('Priority: ${todo.priority}'),
                  Text('Due Date: ${todo.dueDate}'),
                  Text('Status: ${todo.status}'),
                  Text('Tags: ${todo.tags}'),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> DetailTodoPage(todo: todo),
                ));
              },
            );
           
          }
        
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
         Navigator.of(context).push(MaterialPageRoute(
          builder: (context)=> InputTodoPage(),
          ));
        },
        child: Icon(Icons.add),
        ),
    );
  }
}