import 'package:flutter/material.dart';
import 'package:to_do_app/cubit/cubit.dart';

Widget defaulTexttFormField({
  required TextEditingController controller,
  bool isPassword = false,
  Function? onSubmit,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressed,
  required Function validator,
  Function? onTap,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.visiblePassword,
    obscureText: isPassword,
    onTap: () {
      onTap!();
    },
    validator: (s) {
      validator(s);
    },
    onFieldSubmitted: (s) {
      onSubmit!(s);
    },
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
      prefixIcon: Icon(prefix),
      suffixIcon: suffix != null
          ? IconButton(
              onPressed: () {
                suffixPressed!();
              },
              icon: Icon(suffix))
          : null,
    ),
  );
}

Widget buildTaskItem(
    double width, List<Map> tasks, int index, BuildContext context) {
  return Dismissible(
    key: Key(tasks[index]['id'].toString()),
    onDismissed: (direction) {
      ToDoCubit.get(context).deleteData(id: tasks[index]['id']);
    },
    child: Padding(
      padding: EdgeInsets.all(width * .05),
      child: Row(
        children: [
          CircleAvatar(
            radius: width * .1,
            child: Text(tasks[index]['time']),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tasks[index]['title'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  tasks[index]['date'],
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              ToDoCubit.get(context)
                  .updateData(status: 'done', id: tasks[index]['id']);
            },
            icon: Icon(Icons.check_box),
            color: Colors.green,
          ),
          SizedBox(
            width: width * .02,
          ),
          IconButton(
            onPressed: () {
              ToDoCubit.get(context)
                  .updateData(status: 'archived', id: tasks[index]['id']);
            },
            icon: Icon(Icons.archive),
            color: Colors.black45,
          ),
        ],
      ),
    ),
  );
}



Widget buildTaskScreen(
List<Map> tasks,
double width,
){
  return tasks.length>0? ListView.separated(itemBuilder: ((context, index) =>buildTaskItem(width,tasks,index,context)),
       separatorBuilder: ((context, index) => Container(height: 1,color: Colors.grey,)), 
       itemCount: tasks.length)
       :Center(
         child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
         // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Icon(Icons.menu,size: width*.3,),
          Text('No Tasks yet !!',style: TextStyle(color: Colors.grey,fontSize: 20),),
         ],),
       );
}