import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Login extends StatefulWidget {
  @override
  CustomFormState createState() => CustomFormState();
}

class CustomFormState extends State<Login> {

  bool _initialized = false;
  bool _error = false;
  Map data = {};
  TextEditingController _emailController, _passwordController;

  final _formKey = GlobalKey<FormState>();

  void initializeFlutterFire() async {
    try{

      await Firebase.initializeApp();

      setState(() {
        _initialized = true;
      });

    }catch(e){
      setState(() {
        _error = true;
        print(e);
      });
    }
  }


  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {

    final _ref = FirebaseDatabase.instance.reference().child('users');

    if(_error){
      return Text("Something went Wrong");
    }

    if(!_initialized){
      return Text("Not initialized Yet");
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        labelText: "Username",
                        hintText: "Enter username",
                      prefixIcon: Icon(Icons.account_circle)
                    ),
                    validator: (value){
                      if(value.isEmpty){
                        return "Username is required";
                      }else{
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter password",
                      prefixIcon: Icon(Icons.lock)
                    ),
                    validator: (value){
                      if(value.isEmpty){
                        return "Password is required";
                      }else{
                        return null;
                      }
                    },
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),

                    child: ButtonTheme(
                      minWidth: 200,
                      height: 40,
                      child: RaisedButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: (){
                          if(_formKey.currentState.validate()){
                            authenticateUser();
                           // Navigator.pushNamed(context, '/home');
                            // Scaffold
                            //     .of(context)
                            //     .showSnackBar(SnackBar(content: Text("Processing Data")));
                          }
                        },
                        child: Text("Login"),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: ButtonTheme(
                      minWidth: 200,
                      height: 40,
                      child: RaisedButton(
                        onPressed: ()  {
                           Navigator.pushNamed(context, '/signup');
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Text("Sign up"),
                      ),
                    ),
                  ),

                ],
              ),
            )
        ),
      ),
    );
  }

  void showToast(String error){
    Fluttertoast.showToast(
        msg: error,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM
    );
  }

  void authenticateUser() async{

    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      
      if(userCredential.user != null){
        Navigator.pushNamed(context, '/home');
      }
      
    }on FirebaseAuthException catch (e){
      if(e.code == 'user-not-found'){
        print("No user fount for that email.");
        showToast("No user fount for that email.");
      }else if(e.code == "wrong-password"){
        print("Wrong password provided for that user");
        showToast("Wrong password provided for that user");
      }
    }
  }
}