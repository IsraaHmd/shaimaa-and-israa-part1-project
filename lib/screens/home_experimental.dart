import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../constants/colors.dart';

import '../widgets/todolist_items.dart';
import '../widgets/button.dart';
import 'home_notes.dart';

import 'app_state.dart';
//the homepage here just includes the todo list
class HomeExperimental extends StatefulWidget {
  HomeExperimental({super.key});

  @override
  State<HomeExperimental> createState() => _HomeExperimentalState();
}

class _HomeExperimentalState extends State<HomeExperimental> {


 // final List<ToDo>  todosList = [];

  List<ToDo> _foundToDo = [];// to be used for search purposes and displaying tasks

  final _todoController = TextEditingController(); // A controller for the textField of adding the todo

  @override
  void initState() {
    super.initState();
    _foundToDo = AppState().todos; // Use AppState singleton
  }

  @override
  void dispose() {
    _todoController.dispose(); // Dispose of the controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //the background having the same color as the appbar:
        backgroundColor: Colors.white,//tdBGColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0, //removes the shadow under the appbar
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                 //to be implemented later for user
                },
              );
            },
          ),
        ),
        /*----------------------------Done with appBar-----------------------------------*/
      body: Stack(
                children: [
            Container(
            //padding for container
            child: Column(children: [
                Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
            ),
            child: Column(
              children: [
                Align(
                  alignment:
                  Alignment.topLeft, // Adjust this alignment as needed
                  child: Container(
                    //Heading 'My Tasks'
                    margin: EdgeInsets.only(
                      top: 30,
                      bottom: 20,
                      left: 0,
                    ),
                    child: Text(
                      'My Tasks',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: tdBlack),
                    ),
                  ),
                ),
                /*----------------------------------Search-----------------------*/
                searchBox(),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
          //it doesn't work now, to make it work shel el // mn 7ad onchange

          /*--------------Viewing tasks------------*/
          Expanded(
          child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.only(
          bottom: 50), // Add padding to avoid overlap with button
          children: [

          Container(
          margin: EdgeInsets.only(
          top: 20,
          bottom: 20,
          left: 0,
          ),
          ),
          //To do list items:
          for (ToDo todoo in _foundToDo)
          ToDoItem(
          todo: todoo,
          onToDoChanged: _handleToDoChange,
          onDeleteItem: _deleteToDoItem,
          ),
          ]),
          ),
          ),
          ])),
          /*------------------------------------------Done with tasks-----------------------------------*/
          /*------------------------------------------ Add text field and button-----------------------------------*/
          Align(
          alignment: Alignment.bottomRight, // Keep it bottomRight
          child: Container(
          margin: EdgeInsets.only(
          bottom: 20,
          right: 20, // Keep right margin
          ),
          child: ElevatedButton(
          child: Icon(
          Icons.add,
          size: 40,
          color: Colors.white,
          ),
          onPressed: () {
          // Call a function to show the new UI component with TextField
          _showAddTaskDialog(context);
          },
          style: ElevatedButton.styleFrom(
          shape: CircleBorder(), // Make the button circular
          backgroundColor: tdDarkestGrey,
          minimumSize: Size(60, 60),
          elevation: 10,
          ),
          ),
          ),
          ),
          ],
    ),
/*----------------------Bottom nav bar--------------------*/
      bottomNavigationBar: MyButtonNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onButtonNavItemTapped,
      ),
    );

  }
/*--------------------------------------Some methods--------------------------------*/
  //For buttom navbar:
  int _selectedIndex = 1; // Default index for 'Tasks'

  void _onButtonNavItemTapped(int index) {
    setState(() {
      if (index != _selectedIndex) { // Only navigate if the index changes
        _selectedIndex = index;
        if (index == 0) {
          // Navigate to HomeNotes page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NotesHome()),
          );
        } else if (index == 1) {
          // Navigate to HomeExperimental page (this page)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeExperimental()),
          );
        }
        // Add navigation logic for other items if needed
      }
    });
  }

  //for other functionalities
  //the funciton that shows the text field to add the task
  void _showAddTaskDialog(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: tdBGColor,
      context: context,
      isScrollControlled: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.5, // Adjust this factor as needed
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _todoController, //controller used
                  decoration: InputDecoration(
                    hintText: 'Input new task here',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  child: Text(
                    'Add',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onPressed: () {
                    _addToDoItem(_todoController.text);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tdDarkestGrey,
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //To check and uncheck the task:
  void _handleToDoChange(ToDo todo) {
    if (!mounted) return;
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }
  //the function that handles the functionality of delete button

  void _deleteToDoItem(String id) {
    if (!mounted) return;
    setState(() {
      AppState().removeToDoById(id); // Use AppState singleton
      _foundToDo = AppState().todos; // Update _foundToDo with singleton state
    });
  }

  void _addToDoItem(String toDo) {
    if (!mounted) return;
    setState(() {
      AppState().addToDo(ToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // unique id so that we could delete it later on
        todoText: toDo,
      ));
      _foundToDo = AppState().todos; // Update _foundToDo with singleton state
    });
    _todoController.clear();  // Clears the textfield
  }


/*-------------------------------------------search--------------------------*/

  void _runFilter(String enteredKeyword) {
    if (!mounted) return;
    List<ToDo> results = [];
    // if the user did not search for anything
    if (enteredKeyword.isEmpty) {
      results = AppState().todos; // Use AppState for default view
    }
    // if they entered something
    else {
      results = AppState().todos
          .where((item) => item.todoText!
          .toLowerCase()
          .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }


  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: tdBGColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

}
