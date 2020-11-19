import 'package:chitchat/helper/helperfunction.dart';
import 'package:chitchat/widgets/FadeAnimation.dart';
import 'package:chitchat/services/auth.dart';
import 'package:chitchat/services/database.dart';
import 'package:chitchat/views/home.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  

  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  
  signUP(){
    if(formKey.currentState.validate()){

      Map<String,String> userInfoMap = {
                "name" : userNameTextEditingController.text,
                "email" : emailTextEditingController.text,
            };


      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);

        setState(() {
          isLoading = true;
        });

        authMethods.signUpWithEmailAndPassword(
          emailTextEditingController.text,
          passwordTextEditingController.text).then((value){
            //print("${value.uid}");

        

          databaseMethods.uploadUserInfo(userInfoMap);
          HelperFunctions.saveUserLoggedInSharedPreference(true);
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => BottomNavigation()
              ));
          });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator(
          backgroundColor:Colors.pink,
          ),
        ),
      ) : SingleChildScrollView(
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
	                 /* Positioned(
	                    left: 110,
	                    width:200,
	                    height: 200,
	                    child: FadeAnimation(1, Container(
	                      decoration: BoxDecoration(
	                        image: DecorationImage(
	                          image: AssetImage('assets/02-1User-2-512.png')
	                        )
	                      ),
	                    )),
	                  ),*/
	                  Positioned(
	                    left: 140,
	                    width: 80,
	                    height: 150,
	                    child: FadeAnimation(1.3, Container(
	                      /*decoration: BoxDecoration(
	                        image: DecorationImage(
	                          image: AssetImage('assets/images/light-2.png')
	                        )
	                      ),*/
	                    )),
	                  ),
	                  Positioned(
	                    right: 40,
	                    top: 40,
	                    width: 80,
	                    height: 150,
	                    child: FadeAnimation(1.5, Container(
	                    /*  decoration: BoxDecoration(
	                        image: DecorationImage(
	                          image: AssetImage('assets/images/clock.png')
	                        )
	                      ),*/
	                    )),
	                  ),
	                  Positioned(
	                    child: FadeAnimation(1.6, Container(
	                      margin: EdgeInsets.only(top: 20),
	                      child: Center(
	                        child: Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.height *0.08, fontFamily: 'Consolas', fontWeight: FontWeight.bold),),
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
                                  return value.isEmpty || value.length < 2 ? "Please Enter Valid UserName" : null;
                                },
                              controller: userNameTextEditingController,
                              /*onChanged: (value){
                               // name = value;
                              },*/
	                              decoration: InputDecoration(
	                                border: InputBorder.none,
	                                hintText: "Full Name",
	                                hintStyle: TextStyle(color: Colors.grey[400])
	                              ),
	                            ),
	                          ),
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
                               /*onChanged: (value){
                                //email = value;
                              },*/
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
	                              /*onChanged: (value){
                                //password = value;
                              },*/
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
	                  SizedBox(height: 25,),
	                  GestureDetector(
                      onTap: (){
                        signUP();
                        //_auth.createUserWithEmailAndPassword(
                         // email: email, 
                       //   password: password,
                       // ).then((user) => {

                      //  });
                       // Navigator.push(context,
                        //MaterialPageRoute(builder: (context) => LoginPage()),
                      //);
                     // print(name);
                    //  print(email);
                   //   print(password);
                      },
                      child: FadeAnimation(2, Container(
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
	                        child: Text("SignUp", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
	                      ),
	                    )),
	                  ),
	                  SizedBox(height: 20,),
                    FadeAnimation(1.5, Text("Already have an account? ", style: TextStyle(color: Colors.black87),)),
	                  GestureDetector(
                      onTap: (){
                        widget.toggle();
                       // Navigator.push(context,
                       // MaterialPageRoute(builder: (context) => SignIn()),
                     // );
                      },
                      child: FadeAnimation(1.5, Text("LogIn now", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),))),
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