import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_demo/pages/home.dart';
class FirebaseAuthPage extends StatefulWidget {
  const FirebaseAuthPage({super.key});

  @override
  State<FirebaseAuthPage> createState() => FirebaseAuthPageState();
}

class FirebaseAuthPageState extends State<FirebaseAuthPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text("Log In"),
        centerTitle: true,
      ),
      body: Container(
        height: 520,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder()
                  ),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder()
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    auth.signInWithEmailAndPassword(
                      email: usernameController.text, 
                      password: passwordController.text
                    ).then((value) {
                      print("Successfully Logged In");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                    }).catchError((error) {
                      print("Failed to login");
                      print(error.toString());
                    });
                  }, 
                  child: Text("Log In")
                ),
                ElevatedButton(
                  onPressed: (){
                      auth.createUserWithEmailAndPassword(
                      email: usernameController.text, 
                      password: passwordController.text
                    ).then((value) {
                      print("successfully signed up the user");
                    }).catchError((error) {
                      print("Failed to sign up the user");
                      print(error.toString());
                    });
                  }, 
                  child: Text("Sign Up")
                )
              ],
            ),
          )
        ),
      )
    );
  }
}