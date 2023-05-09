
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workerr/screens/auth/login_screen.dart';
import 'package:workerr/screens/task_screen.dart';
class UserState extends StatelessWidget {
  const UserState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //lisitin changestat
    return StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),builder: (context,userSnapshot){
      if(userSnapshot.data ==null){

        return Login();
      }else if(userSnapshot.hasData){
        return  const TaskScreen();
      }else if(
      userSnapshot.hasError
      ){
        return Center(child: Text("error ")
        );
      }
    return   Scaffold(
        body: Center(child: Text("error "),
      ),);


    });
  }
}
