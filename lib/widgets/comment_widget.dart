
import 'package:flutter/material.dart';

import '../screens/profile_screen.dart';

class CommentWidget extends StatelessWidget {


  final String commentId;
  final String commetBody;
  final String commentImageUrl;
  final  String commentName;
  final String comenterId;

  CommentWidget({ required this.commentId, required this.commetBody,
    required this.commentImageUrl, required this.commentName, required this.comenterId}) ;
  final List <Color>_colors=[
    Colors.pink,
    Colors.orange,
    Colors.pink,
    Colors.purple,
    Colors.teal,
  ];
  @override
  Widget build(BuildContext context) {
    _colors.shuffle();

    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen(userId: comenterId,)));
            
      },


      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
       children: [SizedBox(width: 5,),

         Flexible(
           child: Container(
             width: 50,
             height: 50,
             decoration: BoxDecoration(
                 border: Border.all(
                   width: 2,
                   color: _colors[1],
                 ),
                 color:_colors[1],
                 shape: BoxShape.circle,
                 image: DecorationImage(
                   fit: BoxFit.fill,
                   image:  NetworkImage(

                       commentImageUrl==null?      "https://www.clipartmax.com/png/middle/171-1717870_stockvader-predicted-cron-for-may-user-profile-icon-png.png":commentImageUrl),
                 )
             ),



           ),
         ),
Flexible(
  flex: 4,
  child:   Padding(
      padding: const EdgeInsets.all(8.0),
      child:   Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children:[
  
          Text(commentName==null?"":commentName,
        style: TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),

          ),SizedBox(height:5,),
          Text(

            commetBody == null?"": commetBody,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
  ),
)
       ],
      ),
    );
  }
}
