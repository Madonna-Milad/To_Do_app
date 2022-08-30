import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/cubit/states.dart';
import 'package:to_do_app/shared/constants.dart';

import '../modules/archived_tasks.dart';
import '../modules/done_tasks.dart';
import '../modules/new_tasks.dart';

class ToDoCubit extends Cubit<ToDoStates> {
  ToDoCubit() : super(InitialState());

  static ToDoCubit get(context) => BlocProvider.of(context);

  int index = 0;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  bool isBottomSheetShown = false;
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  IconData icon = Icons.edit;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  late Database database;

  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  void createDatabase() {
    openDatabase(
      'todo1.db',
      version: 2,
      onCreate: (database, version) {
        print('Database created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT , date TEXT ,time TEXT, status Text)')
            .then((value) {
          print('Tables created');
        }).catchError((error) {
          print('Error when creating table ${error.toString()}');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);

        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(CreateDatabaseState());
    });
  }

  Future insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database.transaction((txn) async {
      txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date", "$time","new")');
      print('data inserted');
      emit(InsertDataState());
      getDataFromDatabase(database);
       emit(GetDataState());
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(GetDatabaseLoadingState());
 
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((item) {
        if (item['status'] == 'new')
          newTasks.add(item);
        else if (item['status'] == 'done')
          doneTasks.add(item);
        else
          archivedTasks.add(item);
      });
    });

    emit(GetDataState());
  }

  void changeFabIcon(IconData newIcon) {
    icon = newIcon;
    emit(ChangeFabIconState());
  }

  
  void updateData({
    required String status,
    required int id,
  }) async {
    database.rawUpdate('UPDATE tasks SET status=? WHERE id = ?',
        ['$status', id]).then((value) {
      emit(AppUpdateDatabaseState());
      getDataFromDatabase(database);
      emit(GetDataState());
    });
  }


  void deleteData({
   
    required int id,
  }) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?',
        [ id]).then((value) {
      emit(AppDeleteDatabaseState());
      getDataFromDatabase(database);
      emit(GetDataState());
    });
  }

  void changeBottomNavigationBarIndex(int value) {
    index = value;
    emit(ChangeBottomNavBarIndexState());
  }
}
