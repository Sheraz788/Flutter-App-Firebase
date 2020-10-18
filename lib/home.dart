import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_practices/UserData.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  UserData userInfo;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserDataFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  CircleAvatar(
                    child: Icon(Icons.account_circle_outlined),
                  ),
                  SizedBox(height: 15,),
                  Text("${userInfo.username}"),
                  SizedBox(height: 15,),
                  Text("${userInfo.email}"),
                ],
              ),
            ),
            ListTile(
              title: Text("Home"),
              onTap: (){

              },
            ),
            ListTile(
              title: Text("Contact us"),
              onTap: (){

              },
            ),
            ListTile(
              title: Text("Logout"),
              onTap: (){

                Navigator.pop(context);
                _buildAlertDialog();
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Text("Welcome ${userInfo.username}" , style: TextStyle(fontSize:  30),),
        ),
      ),
    );
  }

  void getCurrentUserDataFromFirebase(){

    FirebaseDatabase.instance.reference().child("users").child(FirebaseAuth.instance.currentUser.uid)
        .once().then((DataSnapshot snapshot){
      print(snapshot.value);

      setState(() {
        userInfo = UserData();
        userInfo.username = snapshot.value['username'];
        userInfo.email = snapshot.value['email'];
        userInfo.password = snapshot.value['password'];
        print(userInfo.username);
      });

    });
  }

  Future<void> _buildAlertDialog() async {

    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Logout Confirmation'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text("Are you sure you want to logout?")
                ],
              ),
            ),

            actions: [
              TextButton(onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamed(context, '/login');
              },
                  child: Text("Ok"))
            ],
          );
        }

    );
  }

}




