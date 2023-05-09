
import 'package:flutter/material.dart';
import 'package:workerr/screens/profile_screen.dart';

class Users_Widget extends StatefulWidget {
  final String name;
  final  String  userId;
  final  String  userimageUrl;
  final String   phoneNumber;
  final  String  userComanyPoss;
  final   String  userEmail;
  Users_Widget ({
    required this.userId,
    required this.name,
    required this.phoneNumber,
    required this.userComanyPoss,
    required this.userEmail,
    required this.userimageUrl});
  @override
  _Users_WidgetState createState() => _Users_WidgetState();
}

class _Users_WidgetState extends State<Users_Widget> {
  // Constants _constants = Constants();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        onTap: () {  Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=>
         ProfileScreen(userId: widget.userId,),));},



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
              widget.userimageUrl ==null?
                "https://www.clipartmax.com/png/middle/171-1717870_stockvader-predicted-cron-for-may-user-profile-icon-png.png":widget.userimageUrl),
          ),
        ),
        //... make
        title:  Text(
         widget. name ,
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
           "${widget.userComanyPoss }/ ${widget.phoneNumber}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "${widget.userEmail}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        trailing: Icon(
          Icons.email_outlined,
          size: 30,
          color: Colors.pink.shade500,
        ),
      ),
    );
  }




}
