
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/cubit/cubit.dart';
import 'package:to_do_app/cubit/states.dart';
import 'package:to_do_app/modules/archived_tasks.dart';
import 'package:to_do_app/modules/done_tasks.dart';
import 'package:to_do_app/modules/new_tasks.dart';
import 'package:to_do_app/shared/componants.dart';

import '../shared/constants.dart';

class LayoutScreen extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => ToDoCubit()..createDatabase(),
      child: BlocConsumer<ToDoCubit,ToDoStates>(
        listener: (context, state) {

          if(state is InsertDataState)
          {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          ToDoCubit cubit=ToDoCubit.get(context);
          return Scaffold(
          key: cubit.scaffoldKey,
          appBar: AppBar(
            title: Text('To Do List'),
          ),
          body:state is! GetDatabaseLoadingState?cubit.screens[cubit.index]:Center(child: CircularProgressIndicator()), 
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isBottomSheetShown) {

                if (cubit.formKey.currentState!.validate()) {
                 cubit.insertToDatabase(
                          title: cubit.titleController.text,
                          date: cubit.dateController.text,
                          time: cubit.timeController.text);
                      
                }
              } else {
                cubit.scaffoldKey.currentState!
                    .showBottomSheet((context) {
                      return Container(
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key:cubit. formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaulTexttFormField(
                                  controller: cubit.titleController,
                                  label: 'Title',
                                  prefix: Icons.title,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'title must not be empty';
                                    }
                                  }),
                              SizedBox(
                                height: height * .02,
                              ),
                              defaulTexttFormField(
                                  controller: cubit.dateController,
                                  label: 'Date',
                                  prefix: Icons.date_range,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Date must not be empty';
                                    }
                                  },
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.parse('2022-09-30'))
                                        .then((value) {
                                     cubit. dateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  }),
                              SizedBox(
                                height: height * .02,
                              ),
                              defaulTexttFormField(
                                  controller:cubit. timeController,
                                  label: 'Time',
                                  prefix: Icons.timer,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Time must not be empty';
                                    }
                                  },
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      cubit.timeController.text =
                                          value!.format(context).toString();
                                    });
                                  }),
                            ],
                          ),
                        ),
                      );
                    })
                    .closed
                    .then((value) {
                      cubit.isBottomSheetShown = false;
                     
                      cubit.changeFabIcon(Icons.edit);
                    });
                cubit.isBottomSheetShown = true;
                 cubit.changeFabIcon(Icons.add);
              }
            },
            child:cubit. isBottomSheetShown ? Icon(Icons.add) : Icon(Icons.edit),
          ),
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.index,
              onTap: (value) {
               cubit.changeBottomNavigationBarIndex(value);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Task'),
                BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: 'Archived'),
              ]),
        );
        },
        
      ),
    );
  }

  
}
