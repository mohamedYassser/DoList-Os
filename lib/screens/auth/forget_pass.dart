
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';




class ForgetPass extends StatefulWidget {
  const ForgetPass({Key? key}) : super(key: key);

  @override
  _ForgetPassState createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> with TickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> animation;
  late final TextEditingController _controllerEmail = TextEditingController();
  late final TextEditingController _controllerForgetPassword= TextEditingController();
  bool obscureText = true;

  final _loginForKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _animationController.dispose();
    _controllerForgetPassword.dispose();

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

void _submitForgetPass(){
    print("_controllerForgetPassword.text ${_controllerForgetPassword.text}");
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
                "FORGET PASSWORD",
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
                            text: ("EMAIL ADDRESS"),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white)),



                      ])),

                ],
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
             TextField(
key: _loginForKey,
               controller: _controllerForgetPassword,
               decoration: const InputDecoration(
                 filled: true,
                 fillColor: Colors.white,
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
                height: 10,
              ),
              MaterialButton(

                onPressed: _submitForgetPass,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "REST CODE",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
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
}
