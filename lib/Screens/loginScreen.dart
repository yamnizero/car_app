import 'package:car_app/Screens/registerationScreen.dart';
import 'package:car_app/Widgest/progressDialog.dart';
import 'package:car_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'MainScreen.dart';

class LoginScreen extends StatelessWidget
{
  static const String idScreen = "login";
  TextEditingController emailTextEditingController =TextEditingController();
  TextEditingController passwordTextEditingController =TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(8.0),
          child: Column(
            children: [
               SizedBox(height: 45.0,),

              Image(
                  image:AssetImage("images/3644592.jpg"),
                height: 350.0,
                width: 350.0,
                alignment: Alignment.center,
              ),

              SizedBox(height: 1.0,),

              Text(
                  "Login as a Rider",
                style: TextStyle(fontSize: 24.0),
                textAlign: TextAlign.center,
              ),


              Padding(
                  padding:EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 1.0,),

                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),

                    SizedBox(height: 1.0,),

                    TextField(
                      controller: passwordTextEditingController,
                     obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),

                    SizedBox(height: 35.0,),

                    RaisedButton(
                        onPressed:()
                        {
                          if(!emailTextEditingController.text.contains("@"))
                          {
                            displayToastMessage(context, "Email address is not Valid.");
                          }
                          else if(passwordTextEditingController.text.isEmpty)
                          {
                            displayToastMessage(context, "Password is mandatory.");
                          }
                          else
                            {
                              loginAndAuthenticateUser(context);
                            }
                        },
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                    ),
                  ],
                ),
              ),

              TextButton(
                  onPressed: ()
                  {
                    Navigator.pushNamedAndRemoveUntil(context, RegisterScreen.idScreen, (route) => false);
                  },
                  child: Text(
                    "Do not have Account? Register Here."
                  ),
              ),

            ],
          ),
        ),
      ),
    );
  }
//---------------------------------
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginAndAuthenticateUser(BuildContext context) async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return ProgressDialog(message: "Authenticating, Please wait...",);
        }
    );
    
    final User? user =
        (
            await _firebaseAuth.signInWithEmailAndPassword
              (
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text
            ).catchError((errMsg){
              Navigator.pop(context);
              displayToastMessage(
                context,
                "Error:" + errMsg.toString(),
              );
            })
        ).user;
    if(user != null)
    {

      usersRef.child(user.uid).once().then((DataSnapshot snap){
        if(snap.value != null)
          {
            Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
            displayToastMessage(context, "you are logged-in now.");
          }
          else
          {
            Navigator.pop(context);
            _firebaseAuth.signOut();
            displayToastMessage(context, "No record exists for this user. Please create new account.");
          }
      });
    }
    else
    {
      Navigator.pop(context);
      displayToastMessage(context, "Error Occured, can not be Singed-in. ");
    }
  }
//---------------------------------
}
