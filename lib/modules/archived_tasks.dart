import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../shared/componants.dart';

class ArchivedTasks extends StatelessWidget {
  const ArchivedTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return  BlocConsumer<ToDoCubit,ToDoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List<Map> tasks=ToDoCubit.get(context).archivedTasks;
        return buildTaskScreen(tasks, width);
      },
     
    );
    
  }
}