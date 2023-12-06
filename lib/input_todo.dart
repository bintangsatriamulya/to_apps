// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_apps/list_to_do.dart';
import 'package:to_apps/todo.dart';
import 'package:uuid/uuid.dart';

class InputTodoPage extends StatefulWidget {

  final Todo? todo;

  InputTodoPage({this.todo});


  @override
  _InputTodoPageState createState() => _InputTodoPageState();
}

class _InputTodoPageState extends State<InputTodoPage> {

  final _formKey =GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  TextEditingController dueDateController=TextEditingController();
  String _selectedPriority = 'IMPORTANT';
  DateTime _dueDate = DateTime.now();
  String _selectedStatus = ' Not Started';
  List<String> _selectedTags = [];
  File? _image;

  void initState(){
    super.initState();
        if (widget.todo != null) {
      titleController.text = widget.todo!.title;
      descriptionController.text = widget.todo!.description;
      _selectedPriority = widget.todo!.priority;
      // Parse and set the dueDate
      if (widget.todo!.dueDate != null) {
        _dueDate = DateFormat('dd-MM-yyyy').parse(widget.todo!.dueDate);
        dueDateController.text = widget.todo!.dueDate;
      }
      // Set the selectedStatus
      _selectedStatus = widget.todo!.status;
      // Set the selectedTags
      _selectedTags = widget.todo!.tags;
      // Load and set the image
      if (widget.todo!.attachments != null) {
        _image = File(widget.todo!.attachments);
      }
    }
  }

  Future<void> _pickImage() async {final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);  
  if (pickedFile != null) {
    setState(() {
      _image = File(pickedFile.path);
      });
      }
  }

  Future<void> saveOrUpdateData(Todo todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();List<String> dataList = prefs.getStringList('data') ?? [];Map<String, String> newData = {
      'id': todo.id,
      'title': todo.title,
      'description': todo.description,
      'priority': todo.priority,
      'dueDate': todo.dueDate,
      'Status': todo.status,
      'attachment': todo.attachments,
      'Tags': todo.tags.toString(),
      };
      int dataIndex = -1;
 // Check if the item with the same ID already exists in the list
    for (int i = 0; i < dataList.length; i++) {
      Map<String, dynamic> item = jsonDecode(dataList[i]);
      if (item['id'] == todo.id) {
        dataIndex = i;
        break;
 
  }
}
 if (dataIndex != -1) {dataList[dataIndex] = jsonEncode(newData); // Edit the existing item
 } else {
  dataList.add(jsonEncode(newData)); // Add a new item to the list
 
}
 prefs.setStringList('data', dataList); // Save the updated list to local storage
 debugPrint(dataList.toString());
 
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo == null ? 'Create Todo' : 'Edit Todo'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator:(value) {
                    if (value!.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  minLines: 5,
                  maxLines: 10,
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                     if (value!.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                    value: _selectedPriority,
                    onChanged: (String? newValue){
                      setState(() {
                        _selectedPriority = newValue!;
                      });
                    },
                      items: ['IMPORTANT','MEDIUM','LOW'].map((priority){
                        return DropdownMenuItem(child: Text(priority),value:priority);
                      }).toList(),
                    decoration: InputDecoration(labelText: 'Priority'),
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: dueDateController,
                    decoration: InputDecoration(labelText: 'Due Date'),
                    onTap: () async {
                      final pickDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101));
                      if(pickDate !=null && pickDate != _dueDate){
                        setState(() {
                          _dueDate = pickDate;
                          dueDateController.text = DateFormat('dd-MM-yyyy').format(pickDate);
                        });
                      }
                    },
                    validator:(value){
                      if(value!.isEmpty){
                        return 'Please enter date';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text('Status'),
                      ),
                      Row(
                        children: <Widget>[
                          Radio<String>(
                            value: 'Not Started', 
                            groupValue: _selectedStatus, 
                            onChanged: (String? value){
                              setState(() {
                                _selectedStatus = value!;
                              });
                            },
                            ),
                              Text('Not Started')
                        ],
                      ),
                      Row(children: <Widget>[
                          Radio<String>(
                            value: 'In Progress', 
                            groupValue: _selectedStatus, 
                            onChanged: (String? value){
                              setState(() {
                                _selectedStatus = value!;
                              });
                            },
                            ),
                              Text('In Progrees')
                        ],),
                         Row(children: <Widget>[
                          Radio<String>(
                            value: 'Done', 
                            groupValue: _selectedStatus, 
                            onChanged: (String? value){
                              setState(() {
                                _selectedStatus = value!;
                              });
                            },
                            ),
                              Text('Done'),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text('Tags'),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _selectedTags.contains('Sekolah'), 
                            onChanged:(bool? value) {
                              if (value!= null && value) {
                                _selectedTags.add('Sekolah');
                              }
                              else{
                                _selectedTags.remove('Sekolah');
                              }
                            },
                            ),
                            Text('Sekolah'),
                            Checkbox(
                            value: _selectedTags.contains('Rumah'), 
                            onChanged:(bool? value) {
                              if (value!= null && value) {
                                _selectedTags.add('Rumah');
                              }
                              else{
                                _selectedTags.remove('Rumah');
                              }
                            },
                            ),
                            Text('Rumah'),
                            Checkbox(
                            value: _selectedTags.contains('Kantor'), 
                            onChanged:(bool? value) {
                              if (value!= null && value) {
                                _selectedTags.add('Kantor');
                              }
                              else{
                                _selectedTags.remove('Kantor');
                              }
                            },
                            ),
                            Text('Kantor'),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      _pickImage();
                    },
                    child: _image == null
                        ? Container(
                      width: 100,
                      height: 100,
                      color: Colors.green, // Tampilkan warna latar belakang default jika tidak ada gambar yang dipilih
                      child: Icon(Icons.camera_alt, size: 50, color: Colors.white),
                    )
                        : Image.file(_image!,width: 320,height: 320),
                  ),
                  
                  ElevatedButton(
                    onPressed: (){
                      if (_formKey.currentState!.validate()) {
                        String id = widget.todo != null ? widget.todo!.id: Uuid().v4();
                        String title = titleController.text;
                        String description = descriptionController.text;
                        String priority=_selectedPriority;
                        String dueDate = dueDateController.text;
                        String Status = _selectedStatus;
                        debugPrint('----------------');
                        debugPrint(id);
                        debugPrint(title);
                        debugPrint(description);
                        debugPrint(priority);
                        debugPrint(dueDate);
                        debugPrint(Status);
                        debugPrint(_selectedTags.toString());
                        debugPrint(_image!.path);
                        debugPrint('----------------');
                        final todo = Todo(id: id,title: title,description: description,priority: priority,dueDate: dueDate,status: _selectedStatus, tags: _selectedTags, attachments: _image!.path);
                        saveOrUpdateData(todo);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ListTodoPage(),
                      ),
                    );    
                  };
                }, child: Text('SAVE'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}