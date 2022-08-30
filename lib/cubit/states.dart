abstract class ToDoStates {}

class InitialState extends ToDoStates{}

class CreateDatabaseState extends ToDoStates {}
class GetDatabaseLoadingState extends ToDoStates {}
class InsertDataState extends ToDoStates{}
class GetDataState extends ToDoStates{}
class AppUpdateDatabaseState extends ToDoStates {}

class AppDeleteDatabaseState extends ToDoStates {}
class ChangeBottomNavBarIndexState extends ToDoStates{}

class ChangeFabIconState extends ToDoStates{}
