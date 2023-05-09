
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import 'package:workerr/widgets/drawer_widget.dart';
import 'package:workerr/widgets/useres_widget.dart';

class All_Users_Screen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.pink),


        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          "ALL USERS",
          style: TextStyle(color: Colors.pinkAccent),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: ( context,snapshot){
if(snapshot.connectionState ==ConnectionState.waiting){
  return  Center(
   child: CircularProgressIndicator(),
          );
}else if(snapshot.connectionState == ConnectionState.active){
  if(snapshot.data!.docs.isNotEmpty){

    return
       ListView.builder(itemCount: snapshot.data!.docs.length,itemBuilder:(context, index){
         return Users_Widget(
           userimageUrl:snapshot.data!.docs [index]["userImageUrl"],
           userEmail:snapshot.data!.docs [index]["email"],
           userId: snapshot.data!.docs [index]["id"],
           phoneNumber: snapshot.data!.docs [index]["poneNumber"],
           name: snapshot.data!.docs [index]["name"],
           userComanyPoss:  snapshot.data!.docs [index]["companyposs"],);

       }
       );
  }else{
    return Center(child: const Text('There is no users'));
  }
}else{
  return const Center(child: Text(" Something went wrong"));
}

      },)
    );
  }

}
