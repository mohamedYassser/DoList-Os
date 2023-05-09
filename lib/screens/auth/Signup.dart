
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:workerr/constant/constant.dart';
import 'package:workerr/screens/auth/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workerr/screens/task_screen.dart';
import 'package:workerr/services/global_methods.dart';


class SignUP extends StatefulWidget {
  const SignUP({Key? key}) : super(key: key);

  @override
  _SignUPState createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> with TickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> animation;
  late final TextEditingController _controllerEmail = TextEditingController();
  late final TextEditingController _controllerPass = TextEditingController();

  late final TextEditingController _controllerFullName =
      TextEditingController();
  late final TextEditingController _controllerPosionCom =
      TextEditingController();
  late final TextEditingController _controllerNumberPhone =
      TextEditingController();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePass = FocusNode();
  final FocusNode _focusNodePhonrNumber = FocusNode();
  final FocusNode _focusNodePossCom = FocusNode();
  bool obscureText = true;
bool isLoading = false;
  final _signFormKey = GlobalKey<FormState>();

  File? imageFile;
final  FirebaseAuth _auth =FirebaseAuth.instance;
  @override
  void dispose() {
    _animationController.dispose();
    _controllerEmail.dispose();
    _controllerPass.dispose();
    _controllerPosionCom.dispose();
    _controllerFullName.dispose();
    _focusNodeEmail.dispose();

    _focusNodePhonrNumber.dispose();
     _focusNodePass.dispose();
    _focusNodePossCom.dispose();
    _controllerNumberPhone.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 30));
    animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
    super.initState();
  }


 void _submitFormLogin()async {


    final isValid = _signFormKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {

      setState(() {
        isLoading =true;
      });
      try{

   await     _auth.createUserWithEmailAndPassword(email: _controllerEmail.text.toUpperCase().trim(),
            password: _controllerPass.text.trim());

   //save data
   final User? user =_auth.currentUser;
   final _uid =user!.uid;
final ref=   FirebaseStorage.instance.ref().child("userImageUrl").child(_uid+ ".jpg");
await ref.putFile(imageFile!);
final url =  await ref.getDownloadURL();

 await  FirebaseFirestore.instance.collection("users").doc(_uid).set({
   "id":_uid,
   "name":_controllerFullName.text,
  "email":_controllerEmail.text,
   "userImageUrl":url,
   "poneNumber":_controllerNumberPhone.text,
   "companyposs":_controllerPosionCom.text,
   "createAt":Timestamp.now(),
 });


   Navigator.canPop(context) ? Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>
       TaskScreen( )
   )) : null;

        setState(() {
          isLoading =false;
        });

      }catch(error){
        GlobalMethod.showErrorDialog(
            error: 'Please pick an image',
            ctx: context);
        setState(() {
          isLoading =false;
        });


      }

    } else {
      setState(() {
        isLoading =false;
      });
      print("not hello");
    }
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    return Scaffold(
      //   backgroundColor: Colors.amber,
      body: Stack(
        children: [
          //PACKAGE CashedNetworkImage
          CachedNetworkImage(
            imageUrl:
                "https://www.webenalysis.com/wp-content/uploads/2021/10/IT.jpeg",
            placeholder: (context, url) => Image.asset(
              "assets/image/image1.jpg",
              fit: BoxFit.fill,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            alignment: FractionalOffset(animation.value, 0),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(children: [
              SizedBox(
                height: size.height * 0.1,
              ),
              const Text(
                "Sign UP",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  RichText(
                      text: const TextSpan(children: [
                    TextSpan(
                        text: ("Dontp\,have acount?"),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white)),
                  ])),
                  TextButton(
                      onPressed: () {
                        
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()));
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.blue, fontSize: 15),
                      )),
                ],
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Form(
                key: _signFormKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: 3,
                          child: TextFormField(
                            style: const TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("your Name is not validate");
                              }

                              return null;
                            },
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_focusNodeEmail),
                            controller: _controllerFullName,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              hintText: "Full Name",
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.pink),
                              ),
                            ),
                          ),
                        ),
                        Flexible(

                          child: Stack(
                          children: [ Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.90, color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: imageFile == null
                                  ? Image.network(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyaootB3GWh93iUE-2YQc7i3UknTmdr1w4NIx29H_DPQnXqA-kJi5xQpvqEvLyCALfXT0&usqp=CAU",
                                  fit: BoxFit.fill)
                                  : Image.file(
                                imageFile!,
                                fit: BoxFit.fill,

                              ),
                            ),
                          ),
                            Positioned(
                              top: 0,
                            right: 0,
                            child: InkWell(
                              onTap:(){setState(() {
                                _showDialoImagePicker(context);
                              });} ,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(width: 2,color: Colors.pink),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.pink

                                ),
                                child: Icon(imageFile == null ? Icons.add_a_photo:Icons.edit,size: 18,),
                              ),
                            ),
                          ),

                          ],
                          ),
                        )
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value!.isEmpty && value.contains("@")) {
                          return  "Please enter a valid Email";
                        }

                        return null;
                      },
                      onEditingComplete: () => FocusScope.of(context)
                          .requestFocus(_focusNodePass),
                      focusNode: _focusNodeEmail,
                      controller: _controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.pink),
                        ),
                      ),
                    ),
                    // password textField

                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 5) {
                          return  "Please enter a valid password";
                        }

                        return null;
                      },
                      onEditingComplete: () => FocusScope.of(context)
                          .requestFocus( _focusNodePhonrNumber),

                      focusNode: _focusNodePass,
                      obscureText: obscureText,
                      controller: _controllerPass,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        suffixIcon: InkWell(
                          child: Icon(Icons.visibility, size: 14),
                        ),
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.pink),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                TextFormField(
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "This Field is missing";
                        }

                        return null;
                      },

                  onChanged: (val){

                  }, onEditingComplete: () => FocusScope.of(context)
                    .requestFocus( _focusNodePossCom),

                      focusNode: _focusNodePhonrNumber,
                      controller: _controllerNumberPhone,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: "Number phone",
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.pink),
                        ),
                      ),
                    ),


                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: (){_taskShowDialo(context);},
                      child: TextFormField(

                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "This Field is missing";
                          }

                          return null;
                        },
                        enabled: false,
                        focusNode: _focusNodePossCom,
                        onEditingComplete: () =>_submitFormLogin(),
                        controller: _controllerPosionCom,
                        keyboardType: TextInputType.none,
                        decoration: const InputDecoration(
                          hintText: "Company Position",
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink),
                          ),
                          disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              isLoading?Center(
                child: Container(
                  height: 70,
                  width: 70,
                  child: CircularProgressIndicator(),
                ),
              )
             : MaterialButton(
                onPressed: _submitFormLogin,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "SIGN UP",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(
                      Icons.login,
                      color: Colors.white,
                    )
                  ],
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }



  // Pick an image
  void getImagePickGalary()async{

    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery,maxWidth: 1080,maxHeight: 1080);
    setState(() {


  imageFile= File(image!.path) ;

    });
    Navigator.pop(context);
  }

  // Capture a photo
  //final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

  void getImaggePickCamera()async{

    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera,maxWidth: 1080,maxHeight: 1080);
    setState(() {


      imageFile= File(image!.path) ;
    });
    Navigator.pop(context);
  }



  _showDialoImagePicker (context){
    return showDialog(context: context, builder: (context) {
      return  AlertDialog(
        title:Text("Please choose  an option"),
        content: Container(
          child:Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: getImaggePickCamera ,
                  child: Row(
                    children: const [
                      Icon(Icons.camera,color: Colors.purple,),
                      SizedBox(width: 7,),
                      Text("Camera",style: TextStyle(color: Colors.purple),),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: getImagePickGalary,
                  child: Row(
                    children:  const [
                      Icon(Icons.image,color: Colors.purple),
                       SizedBox(width: 7,),
                     Text("Gallery",style: TextStyle(color: Colors.purple),),
                    ],
                  ),
                ),
              ),
            ],
          )
        ),
      );
      }
    );


}
_taskShowDialo(context ) {

   Constants constants = Constants();
    Size size = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(

            title: const Text(
              "Company Position",
              style: TextStyle(

                  fontSize: 20,
                  fontWeight: FontWeight.bold),

            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount:Constants.listCompanyPosition.length,
                  itemBuilder: (BuildContext context, int index) {
                    return
                      Column(
                        children: [
                          InkWell(
                            onTap: (){setState(() {
                              _controllerPosionCom.text = Constants.listCompanyPosition[index];
                              Navigator.pop(context);
                            });},
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircleAvatar(child: Icon(
                                    Icons.check, color: Colors.white,),
                                    backgroundColor: Colors.pinkAccent,),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(Constants.listCompanyPosition[index],
                                    style: const TextStyle(fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54),),
                                ),
                              ],
                            ),
                          ),

                        ],
                      );
                  }),
            ),
            actions: [
              TextButton(onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              }, child: const Text("close")),
              TextButton(onPressed: () {

              }, child: const Text("cancel filter")),
            ],
          );
        });
  }



 void _errorSignShowDialo(error ) {



   showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(

            title: const Text(
              "ocurred error",
              style: TextStyle(
color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),

            ),
            content: (Text(error)),
            actions: [

              TextButton(onPressed: () {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              }, child: const Text("cancel filter")),
            ],
          );
        });
  }


}
