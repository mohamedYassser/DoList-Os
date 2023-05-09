
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workerr/inner_screen/add_task_screen.dart';
import 'package:workerr/screens/all_users_screen.dart';
import 'package:workerr/screens/auth/login_screen.dart';
import 'package:workerr/screens/profile_screen.dart';
import 'package:workerr/screens/task_screen.dart';

class DrawerWidget extends StatelessWidget {

  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(decoration: BoxDecoration(color: Colors.cyan.shade500),child:Column(
            children: [
              const SizedBox(height: 15,),
              Flexible(child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4NvulqnupAbFAIQTdEipkhVOR6zw-NE7jrHu46quQDB7YuVuBvR11LGHpYe7c8kbRZV4&usqp=CAU",fit: BoxFit.fill,)),
             const SizedBox(height :20),
             const Flexible(child: Text(" Work Os ",
               style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 20),)),
            ],
          ) ,),
          const SizedBox(height: 20,),
          _listTileDrawer(fuc: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
            TaskScreen(),
         ));},
              icon: Icons.task_outlined,label:"All Tasks" ),
          _listTileDrawer(fuc:() {_navigaToMyProileScreent(context);},icon: Icons.settings_outlined,label:"My Account" ),
          _listTileDrawer(fuc: (){_navigaToUserScreent(context);},icon: Icons.workspaces_outlined,label:"Registered workers" ),
          _listTileDrawer(fuc: (){_addTaskScreen(context);},icon: Icons.add_task_outlined,label:"Add Tasks" ),
          const Divider(thickness :1),
          _listTileDrawer(fuc: (){_logOut(context);},icon: Icons.logout_outlined,label:"LogOut" ),
        ],
      ),
    );
  }

  void _navigaToMyProileScreent(context){
    final _auth =FirebaseAuth.instance;
    final User? user =_auth .currentUser;
    final userId = user!.uid;
    Navigator.push(context, MaterialPageRoute(builder: (context)=>
        ProfileScreen(userId: userId,),
    ));
  }
  void _navigaToUserScreent(context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>
        All_Users_Screen(),
    ));
  }
  void _addTaskScreen(context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>
      AddTaskScreen(),
    ));
  }
  void _logOut(context){

    final FirebaseAuth _auth = FirebaseAuth.instance;

    showDialog(context:context, builder: (context){
      return AlertDialog(

title: Row(
  children: [
Icon(Icons.exit_to_app_rounded,color: Colors.red,),
    SizedBox(width: 10,),
    const Text("Sign OUT"),
  ],
),
        content: const Text("Do you Want signOut ?",style: TextStyle(color: Colors.black),),
        actions: [TextButton(onPressed: (){

          _auth.signOut();
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login(),));},
            child:const Text("Yes",style: TextStyle(color: Colors.red),


            )),
          TextButton(onPressed: (){

          }, child:const Text("No",style: TextStyle(color: Colors.red),)),
        ],
      );

    });
  }

  Widget _listTileDrawer (
      {required Function fuc,
      required String label,
      required IconData icon}){
    return  ListTile(
onTap: (){fuc();},
      leading: Icon(icon,color: Colors.black54,),
      title: Text(label,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 20,
          fontStyle: FontStyle.italic

      ),),

    );
  }

}
