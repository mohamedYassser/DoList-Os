import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workerr/screens/auth/login_screen.dart';
import 'package:workerr/services/global_methods.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

import 'package:workerr/widgets/drawer_widget.dart';

class ProfileScreen extends StatefulWidget {


  final String ?userId;

  ProfileScreen({required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String phoneNumber = "";

  String email = "";
  late String name = "";

  String jobPoss = "";
  late String imageUrl = "";

  late String joinAt = "";

  bool isSameProf = false;

  final imgUrl = "https://img.freepik.com/free-vector/alarm-clock-ringing_1450-142.jpg?w=740&t=st=1671094028~exp=1671094628~hmac=d135f20ac9fd77f17017b3dd4190076ada586b98f071ad16f41fde691df24ef6";

  @override
  void initState() {
    fetchDataUser();
    super.initState();
  }


  void fetchDataUser() async {
    print('${widget.userId}');
    try {
      final DocumentSnapshot profilUserDoc =
      await FirebaseFirestore.instance.collection("users")
          .doc(widget.userId)
          .get();
      if (profilUserDoc == null) {
        return;
      } else {
        setState(() {
          phoneNumber = profilUserDoc.get("poneNumber");
          email = profilUserDoc.get("email");
          name = profilUserDoc.get("name");
          jobPoss = profilUserDoc.get("companyposs");
          imageUrl = profilUserDoc.get("userImageUrl");

          Timestamp timestamp = profilUserDoc.get("createAt");

          DateTime joindate = timestamp.toDate();
          joinAt = "${joindate.day}-${joindate.month}-${joindate.year}";
        });
        //check same user
        final _auth = FirebaseAuth.instance;
        final User? user = _auth.currentUser;
        String uid = user!.uid;

        setState(() {
          isSameProf = uid == widget.userId;
        });
      //  print('${isSameProf}');
      }
    } catch (error) {
      GlobalMethod.showErrorDialog(
          error: 'You cant perform this action',
          ctx: context);
    }
  }

  @override
  Widget build(BuildContext context) {
   // final auth = FirebaseAuth.instance;
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black87
        ),
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
        title: const Text("Profile", style: TextStyle(color: Colors.pink),),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Card(
                margin: const EdgeInsets.all(20),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                      const SizedBox(
                        height: 50,
                      ),
                      Align(
                        child: Text(
                            name,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        child: Text(
                          jobPoss,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Divider(
                        thickness: 1.0,
                      ),
                      const SizedBox(height: 20,),
                      const Text(
                        "Contact Info",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Align(
                        child: Text(
                          joinAt,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10,),
                      info(label: 'Email :', contect: email),

                      const SizedBox(height: 20,),
                      info(label: 'Phone Number :', contect: phoneNumber),
                      const SizedBox(height: 30,),
                      if (isSameProf) Container() else
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                          children: [
                            _contactBy(
                              color: Colors.green,
                              fct: () {
                                _openWhatsAppChat();
                              },
                              icon: FontAwesome5.whatsapp,
                            ),
                            _contactBy(
                                color: Colors.red,
                                fct: () {
                                  _mailTo();
                                },
                                icon: Icons.mail_outline),
                            _contactBy(
                                color: Colors.purple,
                                fct: () {
                                  _callPhoneNumber();
                                },
                                icon: Icons.call_outlined),
                          ],
                        ),
                      const SizedBox(height: 40,),
                      !isSameProf ? Container() :
                      Center(
                        child: Container(

                          width: 140,
                          child: MaterialButton(

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                              side: BorderSide.none,
                            ),
                            color: Colors.pink.shade800,
                            onPressed: () {
                              void _logOut(context) {
                                final FirebaseAuth _auth = FirebaseAuth
                                    .instance;

                                showDialog(
                                    context: context, builder: (context) {
                                  return AlertDialog(

                                    title: Row(
                                      children: [
                                        Icon(Icons.exit_to_app_rounded,
                                          color: Colors.red,),
                                        SizedBox(width: 10,),
                                        const Text("Sign OUT"),
                                      ],
                                    ),
                                    content: const Text("Do you Want signOut ?",
                                      style: TextStyle(color: Colors.black),),
                                    actions: [TextButton(onPressed: () {
                                      _auth.signOut();
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(
                                            builder: (context) => Login(),));





                                    },
                                        child: const Text("Yes",
                                          style: TextStyle(color: Colors.red),


                                        )),
                                      TextButton(onPressed: () {

                                      },
                                          child: const Text("No",
                                            style: TextStyle(
                                                color: Colors.red),)),
                                    ],
                                  );
                                });
                              }
                            },

                            child:


                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "LogOut",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  Icons.logout_outlined,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  height: 15,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],


                  ),
                ),


              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: imgUrl.isNotEmpty
                          ? NetworkImage(imageUrl)
                          : null,
                    ),
                    width: 80,
                    height: 80,

                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _openWhatsAppChat() async {
    var url = 'https://wa.me/$phoneNumber?text=HelloWorld';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Erorr');
      throw 'Error occured';
    }
  }

  void _mailTo() async {
    var mailUrl = 'mailto://$email';
    if (!await canLaunch(mailUrl)) {
      await launch(mailUrl);
    } else {
      print('Erorr');
      throw 'Error occured';
    }
  }

  void _callPhoneNumber() async {
    var url = 'tel://$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Error occured';
    }
  }

  Widget _contactBy(
      {required Color color, required Function fct, required IconData icon}) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
          radius: 23,
          backgroundColor: Colors.white,
          child: IconButton(
            icon: Icon(
              icon,
              color: color,
            ),
            onPressed: () {
              fct();
            },
          )),
    );
  }

  _iconWidget(
      {required IconData icon, required Function fuc, required Color color}) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: color,
      child: CircleAvatar(
        radius: 23,
        backgroundColor: Colors.white,
        child: IconButton(
          onPressed: () {
            fuc();
          },


          icon: Icon(icon), color: color,),
      ),
    );
  }

  Widget info({required String label, required String contect}) {
    return
      Row(children: [Text(label, style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold
      ),),
        Text(contect, style: const TextStyle(
            color: Colors.blue,
            fontSize: 16,
            fontWeight: FontWeight.bold
        ),),


      ],


      );
  }


}






