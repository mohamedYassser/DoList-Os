import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workerr/constant/constant.dart';
import 'package:uuid/uuid.dart';
import 'package:workerr/services/global_methods.dart';
import 'package:fluttertoast/fluttertoast.dart';
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _controllerCat =
      TextEditingController(text: "Task Category");

  final TextEditingController _controllerTitle = TextEditingController();

  final TextEditingController _controllerdesc = TextEditingController();

  final TextEditingController _controllerUpdat =
      TextEditingController(text: "Task UpDate");

  final _addTaskForKey = GlobalKey<FormState>();
  Timestamp? _deadLinedDateStamp;
  final Constants _constant = Constants();
  DateTime? picked;
 bool isloading =false;
  @override
  void dispose() {
    _controllerUpdat.dispose();
    _controllerdesc.dispose();
    _controllerCat.dispose();
    _controllerTitle.dispose();
    super.dispose();
  }

  void _uploadFormAddTask()async {
    final  FirebaseAuth _auth =FirebaseAuth.instance;
    final User? user =_auth.currentUser;
    final _uid =user!.uid;
    final isValid = _addTaskForKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      if(_controllerCat.text  =='Task Category' ||_controllerUpdat.text == 'Task UpDate'){
      //  print("not ");
        GlobalMethod.showErrorDialog(
            error: 'Please pick everything', ctx: context);
        return;

      }

      setState(() {
      isloading=true;
      });
     final taskId =const Uuid().v4();
   try{




     await FirebaseFirestore.instance.collection("tasks").doc(taskId).set({
       "taskId": taskId,
       "uploadBy" :_uid,
       "taskTitle": _controllerTitle.text,
       "taskDescription":_controllerdesc.text,
       "deadLinedDate":_controllerUpdat.text,
       "deadLinedDateStamp":   _deadLinedDateStamp,
       "taskCategory":_controllerCat.text,
       "taskComment":[],
       "isDoe":false,
       "createAt": Timestamp.now(),


     });
     // make blank after update as new add task
     await Fluttertoast.showToast(
         msg: "The task has been uploaded",
         toastLength: Toast.LENGTH_LONG,
         // gravity: ToastGravity.,
         backgroundColor: Colors.grey,
         fontSize: 18.0);
     setState(() {
       _controllerUpdat.text = "Task UpDate";
     _controllerCat.text ="Task Category";
     });
     _controllerdesc.clear();
     _controllerTitle.clear();
   }catch(e){
//print(e);
   }finally{ setState(() {
     isloading=false;
   });}



      GlobalMethod.showErrorDialog(
          error: 'You cant perform this action',
          ctx: context);
    } else {


      GlobalMethod.showErrorDialog(
          error: 'You cant perform this action',
          ctx: context);
    }
  }

  taskShowDialoge() {
    Size size = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Tasks",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
               width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _constant.listCategory.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (){
                        setState(() {
                          _controllerCat.text= _constant.listCategory[index];
                          Navigator.pop(context);

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
                                  _constant.listCategory[index],
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
              // TextButton(onPressed: () {
              //   Navigator.canPop(context) ? Navigator.pop(context) : null;
              // }, child: const Text("close")),
              TextButton(onPressed: () {
                Navigator.pop(context);
              }, child: const Text("DONE")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Card(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Align(
                alignment: AlignmentDirectional.center,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "All Field Are Required",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              Form(
                  key: _addTaskForKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      addTaskText(lable: "Task Category"),
                      _textFormField(
                          func: () =>taskShowDialoge,
                          controller: _controllerCat,
                          maxlin: 100,
                          enabled: false,
                          valuekey: "TaskCategory"),
                      addTaskText(lable: "Task Title"),
                      _textFormField(
                          func: () {

                          },
                          controller: _controllerTitle,
                          maxlin: 100,
                          enabled: true,
                          valuekey: "Task Title"),
                      addTaskText(lable: "Task Description"),
                      _textFormField(
                          func: () {},
                          controller: _controllerdesc,
                          maxlin: 100,
                          enabled: true,
                          valuekey: "Task Description"),
                      addTaskText(lable: "Task DateLine Date"),
                      _textFormField(
                          func: ()=>_datePiker,
                          controller: _controllerUpdat,
                          maxlin: 100,
                          enabled: false,
                          valuekey: "Task UpDate"),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Container(
                            width: 140,
                            child: isloading ?const Center(child: CircularProgressIndicator()) :MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                                side: BorderSide.none,
                              ),
                              color: Colors.pink.shade800,
                              onPressed: _uploadFormAddTask,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Add Task ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.task,
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
                      )
                    ],
                  )),
            ],
          )),
        ),
      ),
    );
  }

  _textFormField(


      {
    required Function func,
    required TextEditingController controller,
    required bool enabled,

    required String valuekey,
    required int maxlin,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: func(

        ),
        child: TextFormField(
          key: ValueKey(valuekey),
          controller: controller,
          validator: (valu) {
            if (valu!.isEmpty) {
              return "this value cannot empty";
            }
            return null;
          },
          keyboardType: TextInputType.text,
          enabled: enabled,
          maxLines: valuekey == "Task Description" ? 3 : 1,
          maxLength: 1000,
          decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink)),
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red))),
        ),
      ),
    );
  }

  addTaskText({required String lable}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        lable,
        style: const TextStyle(
            color: Colors.pink, fontSize: 19, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _datePiker()async{
 var picked =await  showDatePicker(context: context, initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 0)), lastDate: DateTime(2050));

 if(picked != null){
   setState(() {
     _deadLinedDateStamp = Timestamp.fromMicrosecondsSinceEpoch(picked.microsecondsSinceEpoch);
     _controllerUpdat.text = '${picked.year} - ${picked.month} - ${picked.day}';
   });
 }
  }
}
