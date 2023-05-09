import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workerr/constant/constant.dart';
import 'package:workerr/widgets/drawer_widget.dart';
import 'package:workerr/widgets/tasks_widget.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  String? taskCat;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const DrawerWidget(),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.pink),
          //return openDrrawer
          // leading: Builder(
          //   builder: (ctx) {
          //     return IconButton(icon: const Icon(Icons.menu_open_outlined,color: Colors.pinkAccent,),onPressed: (){
          //       Scaffold.of(ctx).openDrawer();
          //     },);
          //   }
          // ),
          actions: [
            IconButton(
                onPressed: () {
                  taskShowDialo(context);
//                 showDialog(
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//
//                         title: const Text(
//                           "Tasks",
//                           style: TextStyle(
//
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold),
//
//                         ),
// content: Container(
//   width: size.width*0.9,
//   child:   ListView.builder(
//     shrinkWrap: true,
//       itemCount: _constants.listCategory.length,
//       itemBuilder:(BuildContext context ,int index){
//
//     return
//      Column(
//        children: [
//          Row(
//             children:  [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: CircleAvatar(child: Icon(Icons.check,color: Colors.white,),backgroundColor: Colors.pinkAccent,),
//               ),
//
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(_constants.listCategory[index],style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black54),),
//               ),
//             ],
//           ),
//
//        ],
//      );
//
//   } ),
// ),
//                         actions: [
//                           TextButton(onPressed: (){
//                             Navigator.canPop(context)?Navigator.pop(context):null;
//                           }, child:const Text("close")),
//                           TextButton(onPressed: (){
//
//                           }, child:const Text("cancel filter")),
//                         ],
//                       );
//                     });
                },
                icon: const Icon(
                  Icons.filter_list_outlined,
                  color: Colors.black,
                )),
          ],

          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const Center(
              child: Text(
            "Tasks",
            style: TextStyle(color: Colors.pinkAccent),
          )),
        ),
        body: StreamBuilder<QuerySnapshot>(
//get tasks from firebase
          //there was a null error just add those lines
          stream: taskCat == null
              ? FirebaseFirestore.instance
                  .collection("tasks")
                  .orderBy('createAt', descending: true)
                  .snapshots()
              : FirebaseFirestore.instance
                  .collection("tasks")
                  .where("taskCategory", isEqualTo: taskCat)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return TaskWidget(
                        taskDescrription: snapshot.data!.docs[index]
                            ['taskDescription'],
                        titleTask: snapshot.data!.docs[index]["taskTitle"],
                        taskId: snapshot.data!.docs[index]["taskId"],
                        taskUpladBy: snapshot.data!.docs[index]["uploadBy"],
                        isDone: snapshot.data!.docs[index]["isDoe"],
                      );
                    });
              } else {
                return const Center(child: Text("There is no tasks"));
              }
            }
            return const Center(child: Text('Something went wrong'));
          },
        ));
  }

  taskShowDialo(context) {
    Constants _constants = Constants();
    Size size = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Tasks",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _constants.listCategory.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.canPop(context)
                            ? Navigator.pop(context)
                            : null;
                        setState(() {
                          taskCat = _constants.listCategory[index];
                        });
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                  backgroundColor: Colors.pinkAccent,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  _constants.listCategory[index],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text("close")),
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                    setState(() {
                      taskCat = null;
                    });
                  },
                  child: const Text("cancel filter")),
            ],
          );
        });
  }
}
