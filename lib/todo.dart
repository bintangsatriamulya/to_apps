class Todo {
 final String id;
 final String title;
 final String description;
 final String priority;
 final String dueDate;
 final String status;
 final List<String> tags;
 final String attachments;

 Todo({
 required this.id,
 required this.title,
 required this.description,
 required this.priority,
 required this.dueDate,
 required this.status,
 required this.tags,
 required this.attachments, 
 });

@override
  String toString() {
    return "id=$id,title=$title,description=$description,priority=$priority,dueDate=$dueDate,Status=$status,attachments=$attachments,Tags=${tags.toString()}";
  }


}