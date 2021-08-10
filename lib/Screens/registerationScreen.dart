import 'package:car_app/Screens/MainScreen.dart';
import 'package:car_app/Screens/loginScreen.dart';
import 'package:car_app/Widgest/progressDialog.dart';
import 'package:car_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterScreen extends StatelessWidget
{
  static const String idScreen = "register";

  TextEditingController nameTextEditingController =TextEditingController();
  TextEditingController emailTextEditingController =TextEditingController();
  TextEditingController phoneTextEditingController =TextEditingController();
  TextEditingController passwordTextEditingController =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20.0,),

              Image(
                image:AssetImage("images/3644592.jpg"),
                height: 350.0,
                width: 350.0,
                alignment: Alignment.center,
              ),

              SizedBox(height: 1.0,),

              Text(
                " Register as a Rider",
                style: TextStyle(fontSize: 24.0),
                textAlign: TextAlign.center,
              ),


              Padding(
                padding:EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 1.0,),

                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text ,
                      decoration: InputDecoration(
                        labelText: "Name",
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
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone",
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
                        if(nameTextEditingController.text.length < 3 )
                          {
                             displayToastMessage(context, "Name must be at least 3 characters.");
                          }
                        else if(!emailTextEditingController.text.contains("@"))
                          {
                            displayToastMessage(context, "Email address is not Valid.");
                          }
                        else if(passwordTextEditingController.text.isEmpty)
                        {
                          displayToastMessage(context, "Phone Number is mandatory.");
                        }
                        else if(passwordTextEditingController.text.length < 6)
                        {
                          displayToastMessage(context, "Password must be at least 6 characters.");
                        }
                        else
                          {
                            registerNewUser(context);
                          }
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Create Account",
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
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.idScreen, (route) => false);

                },
                child: Text(
                    "Already have Account? Login Here."
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
//-------------------------------------
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
 void registerNewUser(BuildContext context) async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return ProgressDialog(message: "Registering, Please wait...",);
        }
    );

   final User? user =
   (
       await _firebaseAuth.createUserWithEmailAndPassword
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


   if(user != null)//user created
    {
      // save  user info  to database
     Map userDataMap ={
       "name" : nameTextEditingController.text.trim(),
       "email" : emailTextEditingController.text.trim(),
       "phone" : phoneTextEditingController.text.trim()
     };

     usersRef.child(user.uid).set(userDataMap);
     displayToastMessage(context, "Congratulations, your account has been created.");
     Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);

   }
   else
     {
       Navigator.pop(context);
       displayToastMessage(context, "New user account  has not been Created");
     }
  }
//-------------------------------------

}

//------------------------------------
displayToastMessage(BuildContext context , String message)
{
  Fluttertoast.showToast(
      msg: message
  );
}
//------------------------------------
