import 'package:chitchat/helper/helperfunction.dart';
import 'package:chitchat/services/auth.dart';
import 'package:chitchat/services/database.dart';
import 'package:chitchat/views/home.dart';
import 'package:chitchat/widgets/FadeAnimation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
 
  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  signIN(){

    if(formKey.currentState.validate()){

      HelperFunctions.saveUserEmailSharedPreference(
        emailTextEditingController.text);
      //HelperFunctions.saveUserEmailSharedPreference(userNameTextEditingController.text);

      databaseMethods.getUserByUserEmail(emailTextEditingController.text)
           .then((value){
             snapshotUserInfo = value;
             HelperFunctions.saveUserNameSharedPreference(
               snapshotUserInfo.docs[0].data()["name"]);
           });
      
      //TODO function to get userDetails
      setState(() {
        isLoading = true;
      });

      authMethods.signInWithEmailAndPassword(
       emailTextEditingController.text,
       passwordTextEditingController.text).then((value){
         if(value != null){
           
           HelperFunctions.saveUserLoggedInSharedPreference(true);
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => BottomNavigation()
              ));
         }

       });

       
    }
  }
 
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: appbar(context),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
      	child: Container(
	        child: Column(
	          children: <Widget>[
	            Container(
	             //height: 400,
               height: MediaQuery.of(context).size.height * 0.49,
	              decoration: BoxDecoration(
	                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)),
                  image: DecorationImage(
	                  image: AssetImage('assets/bg.jpg'),
	                  fit: BoxFit.cover
                  
	                )
	              ),
	              child: Stack(
	                children: <Widget>[
	                 /*Positioned(
	                    left: 110,
	                    width:200,
	                    height: 200,
	                    child: FadeAnimation(1, Container(
	                      /*decoration: BoxDecoration(
	                        image: DecorationImage(
	                          image: AssetImage('assets/light-1.png')
	                        )
	                      ),*/
	                    )),
	                  ),*/
	                  /*Positioned(
	                    left: 140,
	                    width: 80,
	                    height: 150,
	                    child: FadeAnimation(1.3, Container(
	                      /*decoration: BoxDecoration(
	                        image: DecorationImage(
	                          image: AssetImage('assets/light-2.png')
	                        )
	                      ),*/
	                    )),
	                  ),*/
	                 /* Positioned(
	                    right: 40,
	                    top: 40,
	                    width: 80,
	                    height: 150,
	                    child: FadeAnimation(1.5, Container(
	                      decoration: BoxDecoration(
	                        image: DecorationImage(
	                          image: AssetImage('assets/clock.png')
	                        )
	                      ),
	                    )),
	                  ),*/
	                  Positioned(
	                    child: FadeAnimation(1.6, Container(
	                      margin: EdgeInsets.all(20),
	                      child: Center(
	                        child: Text("Login", style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.height *0.09, fontFamily: 'Consolas', fontWeight: FontWeight.bold),),
	                      ),
	                    )),
	                  )
	                ],
	              ),
	            ),
	            Padding(
	              padding: EdgeInsets.all(30.0),
	              child: Column(
	                children: <Widget>[
	                  FadeAnimation(1.8, Container(
	                    padding: EdgeInsets.all(5),
	                    decoration: BoxDecoration(
	                      color: Colors.white,
	                      borderRadius: BorderRadius.circular(10),
	                      boxShadow: [
	                        BoxShadow(
	                          color: Color.fromRGBO(143, 148, 251, .2),
	                          blurRadius: 20.0,
	                          offset: Offset(0, 10)
	                        )
	                      ]
	                    ),
	                    child: Form(
                        key: formKey,
                        child: Column(
	                        children: <Widget>[
	                          Container(
	                            padding: EdgeInsets.all(8.0),
	                            decoration: BoxDecoration(
	                              border: Border(bottom: BorderSide(color: Colors.grey[100]))
	                            ),
	                            child: TextFormField(
                                validator: (value){
                                  return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)
                                ? null
                                : "Please Enter Correct Email";
                          },
                              controller: emailTextEditingController,
                              keyboardType: TextInputType.emailAddress,
	                              decoration: InputDecoration(
	                                border: InputBorder.none,
	                                hintText: "Email",
	                                hintStyle: TextStyle(color: Colors.grey[400])
	                              ),
	                            ),
	                          ),
	                          Container(
	                            padding: EdgeInsets.all(8.0),
	                            child: TextFormField(
                                validator: (val) {
                            return val.length > 6
                                ? null
                                : "Enter Password of more than 6 characters";
                          },
                              controller: passwordTextEditingController,
                              obscureText: true,
                              decoration: InputDecoration(
	                                border: InputBorder.none,
	                                hintText: "Password",
	                                hintStyle: TextStyle(color: Colors.grey[400])
	                              ),
	                            ),
	                          )
	                        ],
	                      ),
	                    ),
	                  )),
	                  SizedBox(height: 30,),
	                  FadeAnimation(2, GestureDetector(
                      onTap: (){
                        signIN();

                      },
                     child: Container(
	                      height: 50,
	                      decoration: BoxDecoration(
	                        borderRadius: BorderRadius.circular(10),
	                        gradient: LinearGradient(
	                          colors: [
                            Color.fromRGBO(255, 55, 141, 1),
                            Color.fromRGBO(255, 148, 251, 1),

	                           // Color.fromRGBO(143, 148, 251, 1),
	                            //Color.fromRGBO(143, 148, 251, .6),
	                          ]
	                        )
	                      ),
	                      child: Center(
	                        child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
	                      ),
	                    ),
	                  )),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      /*onTap: (){
                        Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUp()),
                      );
                      },*/
                    child: FadeAnimation(1.5, Text("Forgot Password?", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),
                      )
                      )
                      ),
	                  SizedBox(height: 30,),
                    FadeAnimation(1.5, Text("Don't have an account? ", style: TextStyle(color: Colors.black87),)),
	                  GestureDetector(
                      onTap: (){
                        widget.toggle();
                       // Navigator.push(context,
                     // MaterialPageRoute(builder: (context) => SignUp()),
                    //  );
                      },
                      child: FadeAnimation(1.5, Text("SignUp now", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),
                      )
                      )
                      ),
	                ],
	              ),
	            )
	          ],
	        ),
	      ),
      )
    );
  }
}