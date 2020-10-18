import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Signup extends StatefulWidget {
  @override
  _SignupCustomFormState createState() => _SignupCustomFormState();
}

class _SignupCustomFormState extends State<Signup> {

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  TextEditingController emailController;
  final _formKey = GlobalKey<FormState>();
  final _ref = FirebaseDatabase.instance.reference().child("users");
  final firebase_auth = FirebaseAuth.instance;

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Sign up"),
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
                    controller: userNameController,
                    validator: (value){
                      if(value.isEmpty){
                        return "Username is required";
                      }else{
                        return null;
                      }
                  },
                    decoration: InputDecoration(
                      labelText: "Username",
                      hintText: "Enter username",
                      prefixIcon: Icon(Icons.account_circle)
                    ),
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter email",
                      prefixIcon: Icon(Icons.email)
                    ),
                    validator: (value){
                      if(value.isEmpty){
                        return "Email is required";
                      }else{
                        return null;
                      }
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
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
                  TextFormField(
                    obscureText: true,
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      hintText: "Confirm password",
                        prefixIcon: Icon(Icons.lock)
                    ),
                    validator: (value){
                      if(value.isEmpty){
                        return "Field is required";
                      }else if(value != passwordController.text){
                        return "Confirm password is not match";
                      }else{
                        return null;
                      }
                    },
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: ButtonTheme(
                      minWidth: 200,
                      height: 40,
                      child: RaisedButton(
                        onPressed: (){
                          if(_formKey.currentState.validate()){
                            registerUserToFirebase();
                          }
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Text("Sign up"),
                      ),
                    ),
                  )

                ],
              ),
            )),
      ),
    );
  }

  void registerUserToFirebase() async {

    String email = emailController.text;
    String password = passwordController.text;

    try{
      UserCredential userCredential = await firebase_auth.createUserWithEmailAndPassword(email: email, password: password);
      if(userCredential.user != null){
        saveUsersToFirebase(userCredential.user.uid);
      }
    } on FirebaseAuthException catch(e){
      if(e.code == "weak-password"){
        print("The password provided is too weak");
      }else if(e.code == "email-already-in-use"){
        print("The account already exists for that email");
      }
    }catch(e){
      print(e);
    }



  }

  void saveUsersToFirebase(String uid){

    String username = userNameController.text;
    String email = emailController.text;
    String password = passwordController.text;


     Map<String, String> user = {
       "username" : username,
       "email" : email,
       "password" : password
     };

      print(user);
    _ref.child(uid).set(user).then((value) {

      _buildAlertDialog();


    }).catchError((onError){
      print(onError);
    });


  }

  Future<void> _buildAlertDialog() async {

    return showDialog<void>(
        context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
          return AlertDialog(
            title: Text('Sign Up'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text("Account is Created Successfully.")
                ],
              ),
            ),

            actions: [
              TextButton(onPressed: (){
                Navigator.popAndPushNamed(context, '/home');
              },
                  child: Text("Ok"))
            ],
          );
      }

    );
  }

}

