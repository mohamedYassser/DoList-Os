
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workerr/inner_screen/tedails_task.dart';
import 'package:workerr/services/global_methods.dart';

class TaskWidget extends StatefulWidget{

final String taskId;
final String titleTask;
 final String taskDescrription;
final String taskUpladBy;
 final  bool isDone;
 TaskWidget({required this.taskId,
  required this.titleTask,
  required this.taskDescrription,
  required this.taskUpladBy,
  required this.isDone});
  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  // Constants _constants = Constants();

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(

        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        onTap: () {_navigaToUserScreent(context);},

        //show alert dialog...
        onLongPress: () {
          showDialog(context: context, builder: (context){
            return AlertDialog(

           title: Center(child: Text("Do you want Delete")),
              content: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.delete,color: Colors.pink.shade500,),
                SizedBox(width: 10,),
                Text("Delete",style: TextStyle(color: Colors.pink.shade500),),
                ],

              ),
              actions: [TextButton(onPressed: ()async{

                try{
        final User? user =auth.currentUser;
        String uid = user!.uid;

        if(uid == widget.taskUpladBy){

    await FirebaseFirestore.instance.collection("tasks").doc(widget.taskId).delete();
    await Fluttertoast.showToast(
    msg: "Task has been deleted",
    toastLength: Toast.LENGTH_LONG,
    // gravity: ToastGravity.,
    backgroundColor: Colors.grey,
    fontSize: 18.0);
    }  else {
      GlobalMethod.showErrorDialog(
          error: 'You cannot perfom this action', ctx: context);
    }}catch(e){
                  GlobalMethod.showErrorDialog(
                      error: 'this task can\'t be deleted', ctx: context);
                }
    },

               child: Text("Yes")),
            TextButton(onPressed: (){}, child: Text("No"),),
              ],
            );
          });

        },
        leading: Container(
          padding: const EdgeInsets.only(right: 8),
          decoration: const BoxDecoration(
              border: Border(
                  right: BorderSide(
                    width: 0.5,
                  ))),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 20,
            child: Image.network(
                 widget.isDone?"https://i.pinimg.com/474x/48/1c/45/481c45a0f12013908fa484a574ac62f6.jpg":
                 "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJZF9D2fCaeuNMpcsIuqbggqQ7OA9ynw2PcQ&usqp=CAU"),
          ),
        ),
        //... make
        title:  Text(
         widget.titleTask,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.linear_scale,
              color: Colors.pinkAccent.shade400,
            ),
           Text(
              widget.taskDescrription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_right,
          size: 30,
          color: Colors.pink.shade500,
        ),
      ),
    );
  }



  void _navigaToUserScreent(context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>
     TedailsTask(uploadBy:widget.taskUpladBy, taskId:  widget.taskId,),
    ));
  }

}
