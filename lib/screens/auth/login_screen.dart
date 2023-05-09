import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workerr/screens/auth/Signup.dart';
import 'package:workerr/screens/auth/forget_pass.dart';
import 'package:workerr/screens/task_screen.dart';

import '../../shared/local/cache_helper.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> animation;
  late final TextEditingController _controllerEmail = TextEditingController();
  late final TextEditingController _controllerPass = TextEditingController();
  bool obscureText = true;

  final _loginForKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  @override
  void dispose() {
    _animationController.dispose();
    _controllerEmail.dispose();
    _controllerPass.dispose();
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

  void _submitFormLogin() async {
    final isValid = _loginForKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      setState(() {
        isLoading = true;
      });
      try {
        await _auth.signInWithEmailAndPassword(
            email: _controllerEmail.text.toUpperCase().trim(),
            password: _controllerPass.text.trim());

        CacheHelper.saveData(
          key: 'onBoarding ',
          value: _controllerEmail.text,
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TaskScreen(),
            ));

        setState(() {
          isLoading = false;
        });
      } catch (error) {
        _errorSignUpShowDialo("error ${error.toString()}");

        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
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
                "LOGIN",
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
                    TextSpan(text: " "),
                    // onTap =()=>Navigator.push(context,
                    //     MaterialPageRoute(
                    //       builder: (context)=>SignUP(),
                    //     )
                    // );
                    // TextSpan(
                    //   text: "Sign Up",
                    //
                    //
                    //     style: TextStyle(
                    //
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 16,
                    //         color: Colors.blueAccent,
                    //         decoration: TextDecoration.underline)),
                  ])),
                  TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUP(),
                          )),
                      child: const Text("signup")),
                ],
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              Form(
                key: _loginForKey,
                child: Column(
                  children: [
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value!.isEmpty && value.contains("@")) {
                          return ("Please enter a valid Email");
                        }

                        return null;
                      },
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

                    const SizedBox(
                      height: 10,
                    ),

                    // password textField

                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 5) {
                          return ("Please enter a valid Password");
                        }

                        return null;
                      },
                      obscureText: obscureText,
                      controller: _controllerPass,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        suffixIcon: InkWell(
                          child: Icon(Icons.clear, size: 14),
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
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgetPass()));
                      },
                      child: const Text(
                        ("Forget Password ?"),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      )),
                ],
              ),
              MaterialButton(
                onPressed: _submitFormLogin,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Login",
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

  void _errorSignUpShowDialo(error) {
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
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text("cancel filter")),
            ],
          );
        });
  }
}
