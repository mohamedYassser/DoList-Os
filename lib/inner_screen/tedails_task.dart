import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:workerr/services/global_methods.dart';
import 'package:workerr/widgets/comment_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
class TedailsTask extends StatefulWidget {
  final String? taskId;
  final String? uploadBy;

  const TedailsTask({Key? key, this.taskId, this.uploadBy}) : super(key: key);

  @override
  State<TedailsTask> createState() => _TedailsTaskState();
}

class _TedailsTaskState extends State<TedailsTask> {
  bool isComment = false;

  String? autherName;
  String? postion;
  String? taskDescription;
  String? taskTitle;
  bool? isDone;

  Timestamp? postDatTimeStamp;
  Timestamp? dateLinTimeStamp;
  String? postDate;
  String? datelineadDeat;
  bool isAvilablDateLined = false;
  String? userImage;

  String? _loggedUserName;
  String? _loggedInUserImageUrl;
  final TextEditingController _controllerdesc = TextEditingController();
  TextEditingController _commentController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _controllerdesc.text;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    User? user = auth.currentUser;
    final _uid = user!.uid;
    final DocumentSnapshot getCommenterInfoDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    if (getCommenterInfoDoc == null) {
      return;
    } else {
      setState(() {
        _loggedUserName = getCommenterInfoDoc.get('name');
        _loggedInUserImageUrl = getCommenterInfoDoc.get('userImageUrl');
      });
    }
    final DocumentSnapshot taskUserDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uploadBy)
        .get();
    if (taskUserDoc == null) {
      return;
    } else {
      setState(() {
        userImage = taskUserDoc.get("userImageUrl");
        autherName = taskUserDoc.get("name");
        postion = taskUserDoc.get("companyposs");
      });
    }

    final DocumentSnapshot taskDoc = await FirebaseFirestore.instance
        .collection("tasks")
        .doc(widget.taskId)
        .get();
    if (taskDoc == null) {
      return;
    } else {
      setState(() {
        isDone = taskDoc.get("isDoe");
        datelineadDeat = taskDoc.get("deadLinedDate");
        taskDescription = taskDoc.get("taskDescription");
        postDatTimeStamp = taskDoc.get("createAt");
        var timePost = postDatTimeStamp!.toDate();
        postDate = "${timePost.year}-${timePost.month}-${timePost.day}";
        dateLinTimeStamp = taskDoc.get("deadLinedDateStamp");
        var date = dateLinTimeStamp!.toDate();
        isAvilablDateLined = date.isAfter(DateTime.now());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: TextButton(
            onPressed: () {},
            child: const Text(
              "Back",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            )),
        backgroundColor: Colors.grey.shade200,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                taskTitle == null ? "" : taskTitle!,
                style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Uploaded By",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          const Spacer(),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border.all(width: 3),
                                color: Colors.pink,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(userImage == null
                                      ? "https://www.clipartmax.com/png/middle/171-1717870_stockvader-predicted-cron-for-may-user-profile-icon-png.png"
                                      : userImage!),
                                )),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            children: [
                              Text(
                                autherName == null ? "" : autherName!,
                                style: const TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                postDate == null ? "" : postion!,
                                style: const TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Uploaded Onc :",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          const Spacer(),
                          Text(
                            postDate == null ? "" : postDate!,
                            style: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "DeatLine Date :",
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                          const Spacer(),
                          Text(
                            datelineadDeat == null ? "" : datelineadDeat!,
                            style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: Text(
                        isAvilablDateLined
                            ? "still have enough time"
                            : "no time left",
                        style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      )),
                      const Divider(
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Done State :",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: TextButton(
                              onPressed: () {
                                final User? user = auth.currentUser;
                                String uid = user!.uid;
                                if (uid == widget.uploadBy) {
                           try{
                             FirebaseFirestore.instance
                                 .collection("tasks")
                                 .doc(widget.taskId)
                                 .update({"isDoe": false});}catch(e){
                             GlobalMethod.showErrorDialog(
                                 error: 'Action cant be performed',
                                 ctx: context);
    }
                                } else {
                                  GlobalMethod.showErrorDialog(
                                      error: 'You cant perform this action',
                                      ctx: context);
                                }
                              },
                              child: const Text(
                                "Done:",
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 10),
                              ),
                            ),
                          ),
                          Opacity(
                              opacity: isDone == false ? 1 : 0,
                              child: const Icon(
                                Icons.check_box,
                                color: Colors.green,
                              )),
                          const SizedBox(
                            width: 50,
                          ),
                          Flexible(
                            child: TextButton(
                              onPressed: () {
                                final User? user = auth.currentUser;
                                String uid = user!.uid;
                                if (uid == widget.uploadBy) {
                                 try{ FirebaseFirestore.instance
                                     .collection("tasks")
                                     .doc(widget.taskId)
                                     .update({"isDoe": true});}catch(e){  GlobalMethod.showErrorDialog(
                                     error: 'Action cant be performed',
                                     ctx: context);}
                                } else {
                                  GlobalMethod.showErrorDialog(
                                      error: 'You cant perform this action',
                                      ctx: context);
                                }

                                fetchData();
                              },
                              child: const Text(
                                "Not Done",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 10),
                              ),
                            ),
                          ),
                          Opacity(
                              opacity: isDone == true ? 1 : 0,
                              child: const Icon(
                                Icons.check_box,
                                color: Colors.redAccent,
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Task Description :",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        taskDescription == null ? "" : taskDescription!,
                        style: const TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.normal,
                            fontSize: 13),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: isComment
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: TextField(
                                      maxLength: 3000,
                                      maxLines: 6,
                                      controller: _controllerdesc,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          fillColor: Colors.grey.shade50,
                                          filled: true,
                                          border: const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.blue)),
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.redAccent)),
                                          errorBorder:
                                              const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.red)),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                            color: Colors.pink,
                                          ))),
                                    ),
                                    flex: 3,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            MaterialButton(
                                              color: Colors.red,
                                              onPressed: () async {
                                                fetchData();
                                                setState(() {
                                                  isComment = !isComment;
                                                });
                                                User? user = auth.currentUser;
                                                final _uid = user!.uid;
                                                try {
                                                  final _genratedId =
                                                      const Uuid().v4();
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("tasks")
                                                      .doc(widget.taskId)
                                                      .update({
                                                    "taskComment":
                                                        FieldValue.arrayUnion([
                                                      {
                                                        "commentImageUrl":
                                                            _loggedInUserImageUrl,
                                                        "userId": _uid,
                                                        "commentId":
                                                            _genratedId,
                                                        "name": _loggedUserName,
                                                        "commentBody":
                                                            _controllerdesc
                                                                .text,
                                                        "time": Timestamp.now(),
                                                      }
                                                    ])
                                                  });
                                                } catch (e) {
                                                  await Fluttertoast.showToast(
                                                      msg: "The task has been uploaded",
                                                      toastLength: Toast.LENGTH_LONG,
                                                      // gravity: ToastGravity.,
                                                      backgroundColor: Colors.grey,
                                                      fontSize: 18.0);
                                                  _commentController.clear();
                                                }
                                              },
                                              child: Row(
                                                children: const [
                                                  Text(
                                                    "ADD",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                 isComment = !isComment;
                                                });
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                          ],
                                        ),
                                      ))
                                ],
                              )
                            : Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(50.0),
                                  child: Container(
                                    width: 140,
                                    height: 40,
                                    child: MaterialButton(
                                      color: Colors.red,
                                      onPressed: () {
                                        setState(() {
                                          isComment = !isComment;
                                        });
                                      },
                                      child: Row(
                                        children: const [
                                          Text(
                                            "ADD COMMENT",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection("tasks")
                              .doc(widget.taskId)
                              .get(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return  Center(
                                  child: CircularProgressIndicator());
                            } else {
                              if (snapshot.data == null) {
                                return
                                Center(child: Text('No Comment for this task'));
                              }
                              return ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (ctx, index) {
                                    return CommentWidget(
                                      commentName: snapshot.data!['taskComment']
                                          [index]["name"],
                                      commentImageUrl:
                                          snapshot.data!['taskComment'][index]
                                              ["commentImageUrl"],
                                      commetBody: snapshot.data!['taskComment']
                                          [index]["commentBody"],
                                      commentId: snapshot.data!['taskComment']
                                          [index]["commentId"],
                                      comenterId: snapshot.data!['taskComment']
                                          [index]["userId"],
                                    );
                                  },
                                  separatorBuilder: (ctx, index) {
                                    return const Divider(   thickness: 1,);
                                  },
                                  itemCount:
                                      snapshot.data!['taskComment'].length);
                            }
                          })
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
