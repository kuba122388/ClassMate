import 'package:audioplayers/audioplayers.dart';
import 'package:classmate/consts/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Task {
  final String task;
  final bool isDone;
  final Timestamp timestamp;

  Task({this.isDone = false, required this.task, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {'task': task, 'isDone': isDone, 'timestamp': timestamp};
  }

  Future<void> saveTask(String email) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .collection('tasks')
          .add(toMap());
    } catch (e) {
      print('Wystąpił błąd: $e');
    }
  }
}

class TaskList extends StatelessWidget {
  final String userEmail;

  TaskList({super.key, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    final AssetSource assetSource = AssetSource('../sounds/click.mp3');
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userEmail)
                .collection('tasks')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              } else if (snapshot.hasError) {
                return Center(child: Text('Wystąpił błąd: ${snapshot.error}'));
              }
              else {
                List<DocumentSnapshot> tasks = snapshot.data!.docs;
                if(tasks.isEmpty){
                  return const Text('Wszystko wykonane!', style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Asap',
                    fontStyle: FontStyle.italic
                  ),);
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const PageScrollPhysics(),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> taskData =
                        tasks[index].data() as Map<String, dynamic>;
                    return Container(
                        child: Row(children: [
                      IconButton(
                        icon: Icon(
                          taskData['isDone']
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: taskData['isDone']
                              ? COLOR_RADIO_BUTTON_CHECKED
                              : Colors.white,
                        ),
                        onPressed: () async {
                          try {
                            AudioPlayer().play(assetSource);
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(userEmail)
                                .collection('tasks')
                                .doc(tasks[index].id)
                                .update({'isDone': !taskData['isDone']});
                          } catch(e){
                            print('Error occured: {$e}');
                          }
                        },
                      ),
                      Expanded(
                          child: Text(
                        taskData['task'],
                        style: TextStyle(
                            decoration: taskData['isDone']
                                ? TextDecoration.lineThrough
                                : null,
                            color: taskData['isDone']
                                ? COLOR_RADIO_BUTTON_CHECKED
                                : Colors.white,
                            decorationColor: COLOR_RADIO_BUTTON_CHECKED,
                            fontSize: 16),
                      )),
                      Visibility(
                          visible: taskData['isDone'] ? true : false,
                          child: GestureDetector(
                              onTap: () async {
                                try {
                                  AudioPlayer().play(assetSource);
                                  taskData['isDone']
                                      ? await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(userEmail)
                                      .collection('tasks')
                                      .doc(tasks[index].id)
                                      .delete()
                                      : null;
                                } catch(e){
                                  print('Error occured: {$e}');
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.only(left: 10),
                                decoration: const BoxDecoration(
                                    color: COLOR_RADIO_BUTTON_CHECKED,
                                    shape: BoxShape.circle),
                                child: Image.asset('././images/minus.png',
                                    width: 10),
                              )))
                    ]));
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
