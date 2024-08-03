import 'dart:math';

import 'app_state.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';

import '../model/notes_list.dart';
import '../screens/edit.dart';
import '../widgets/button.dart';
import 'home_experimental.dart';

class NotesHome extends StatefulWidget {
  const NotesHome({super.key});

  @override
  State<NotesHome> createState() => _NotesHomeState();
}

class _NotesHomeState extends State<NotesHome> {
  List<Note> filteredNotes = [];
  bool sorted = false;


//modified part 2:
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateFilteredNotes(); // Ensure this runs after the initial layout
    });
  }

//added
  void updateFilteredNotes() {
    setState(() {
      if(!sorted){
        filteredNotes = List.from(AppState().notes);
      }

      else{
        filteredNotes = List.from(AppState().notes.reversed);
      }

    });
  }





  List<Note> sortNotesByModifiedTime(List<Note> notes) {//sort the notes
    if (sorted) {//compare notes to each other and sort them
      notes.sort((a, b) => a.modifiedTime.compareTo(b.modifiedTime));//sort notes based on time
    } else {//if sorted is false then reverse them to be sorted
      notes.sort((b, a) => a.modifiedTime.compareTo(b.modifiedTime));
    }

    sorted = !sorted;//reverse the value of sorted

    return notes;
  }

 
  Color getCardColor() {
    //unused function for now
    return tdGrey; // Define tdDarkestGrey in `colors.dart`, if there are issues assign it to line 223
  }

//modified
  void onSearchTextChanged(String searchText) {
    setState(() {
      filteredNotes = AppState().notes
          .where((note) =>
      note.content.toLowerCase().contains(searchText.toLowerCase()) ||
          note.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  void deleteNote(int index) {
    setState(() {
      Note note = filteredNotes[index];//save the note int the note variable
      AppState().removeNoteById(note.id); // Use AppState singleton
      filteredNotes.removeAt(index);//delete it from filtered list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // prvs for  dark Colors.grey.shade900,//to set the background color to grey
      appBar: AppBar(
        backgroundColor:Colors.white, // dark: Colors.grey.shade900 ,
        elevation: 0, //removes the shadow under the appbar
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                //to be implemented later for the user
              },

            );
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),//la ynazelon shwy 3an top
        child: Column(

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //to make space between the word notes and the icon
              children: [
                const Text(
                  'Notes',//title of the page
                  style: TextStyle(fontSize: 30, color: tdBlack),//prvs Colors.white

                ),
                IconButton(

                    onPressed: () {
                      setState(() {
                        filteredNotes = sortNotesByModifiedTime(filteredNotes);
                        //call the function to sort the notes
                        //it will change the order of the list based on the modified time
                      });
                    },


                    padding: const EdgeInsets.all(0),//to decrease the size of the icon inside container
                    icon: Container(//put icon in a container
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade800.withOpacity(.8),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(
                        Icons.sort,
                        color: Colors.white,
                      ),

                    )
                ),


              ],

            ),


            const SizedBox(
              height: 20,
            ),

            /*------------------------------------Search textfield---------------------*/
        Container(
          width: double.infinity,
          child:
            TextField(
                onChanged: onSearchTextChanged,
                style: const TextStyle(fontSize: 16, color: Colors.black),//size and color of the text when we make search
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),//decrease padding of textfield
                  hintText: "Search notes...",//text inside textfield
                  hintStyle: const TextStyle(color: Colors.grey,),//color of the text
                  prefixIcon: const Icon(//add the search icon and set its color to grey
                    Icons.search,
                    color: Colors.grey,
                  ),
                  fillColor: tdBGColor,//Colors.grey.shade800,//background color of the textfield
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),//to make radius of the border circular
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(//to stay as we make it even if we didn't make focus on it
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
        ),
            SizedBox(height: 20,),

            /*--------------------------------------------------List of notes---------------*/
            Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 30),//space between lines in the card
                  itemCount: filteredNotes.length,//length of the list created
                  itemBuilder: (context, index) {
                    /*---------------------------------------The note itself -------------------------*/
                    return Card(//put the text in the card
                      margin: const EdgeInsets.only(bottom: 20),//set margin bottom to 20
                      color: tdGrey,
                      elevation: 3,
                      shape: RoundedRectangleBorder(//makes the note card rounded
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListTile(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    EditScreen(note: filteredNotes[index]),
                              ),
                            );
                            if (result != null) {
                              print('Result: $result');
                              setState(() {
                                int originalIndex = AppState().notes.indexOf(filteredNotes[index]);
                                if (originalIndex != -1) {
                                  print('$originalIndex');
                                  AppState().notes[originalIndex] = Note(
                                    id: AppState().notes[originalIndex].id,
                                    title: result[0],
                                    content: result[1],
                                    modifiedTime: DateTime.now(),
                                  );
                                  updateFilteredNotes();// Refresh filtered notes to reflect the changes
                                } else {
                                  print('Error: Original note not found in AppState().notes');
                                }
                              });

                            }
                          },
                          title: RichText(
                            maxLines: 3,//make maxline to 3 to all have same size
                            overflow: TextOverflow.ellipsis,//to show the continue dots in card
                            text: TextSpan(
                                text: '${filteredNotes[index].title} \n',//to display title in the list
                                style: const TextStyle(
                                    color: Colors.white,//set color to white
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    height: 1.5),
                                children: [
                                  TextSpan(
                                    text: filteredNotes[index].content,//display content found in the list
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 14,
                                        height: 1.5),
                                  )
                                ]),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '${DateFormat('EEE MMM d, yyyy h:mm a').format(filteredNotes[index].modifiedTime)}',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontStyle: FontStyle.italic,
                                  color:Colors.white ),//prvs
                            ),
                          ),

                          trailing: IconButton(
                            onPressed: () async {
                              final result = await confirmDialog(context);//when we click on delete icon a dialog will appear to ask
                              if (result != null && result) {
                                deleteNote(index);
                              }
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ))
          ],
        ),
      ),

      /*----------------------------------------------Add a new note-------------------------------------------------*/
      //modified
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const EditScreen(),
            ),
          );

          if (result != null) {
            setState(() {
              final newNote = Note(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: result[0],
                content: result[1],
                modifiedTime: DateTime.now(),
              );

              AppState().addNote(newNote);
              updateFilteredNotes(); // Update filteredNotes after adding a new note
            });
          }
        },
        elevation: 10,
        backgroundColor: Colors.grey.shade800,
        child: const Icon(
          color: Colors.white,
          Icons.add,
          size: 38,
        ),
      ),


      /*---------------------------Button nav bar-----------------------------*/

      bottomNavigationBar: MyButtonNavBar(
        selectedIndex: _selectedIndexPage,
        onItemTapped: _onButtonNavItemTapped,
      ),


    );
  }

  Future<dynamic> confirmDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade900,
            icon: const Icon(
              Icons.info,
              color: Colors.grey,
            ),
            title: const Text(
              'Are you sure you want to delete?',
              style: TextStyle(color: Colors.white),
            ),
            content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: tdGrey),
                      child: const SizedBox(
                        width: 60,
                        child: Text(
                          'Yes',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const SizedBox(
                        width: 60,
                        child: Text(
                          'No',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ]),
          );
        });
  }
  /*------------------------------------------Some other  methods-------------------------------------*/

  int _selectedIndexPage = 0; // Default index for 'Notes'

  void _onButtonNavItemTapped(int index) {
    setState(() {
      if (index != _selectedIndexPage) { // Only navigate if the index changes
        _selectedIndexPage = index;
        if (index == 0) {
          // Navigate to HomeNotes page (this page)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NotesHome()),
          );
        } else if (index == 1) {
          // Navigate to HomeExperimental page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeExperimental()),
          );
        }
        // Add navigation logic for other items if needed
      }
    });
  }

}