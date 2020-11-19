import 'package:chitchat/helper/constants.dart';
import 'package:chitchat/helper/helperfunction.dart';
import 'package:chitchat/services/auth.dart';
import 'package:chitchat/helper/authenticate.dart';
import 'package:chitchat/services/database.dart';
import 'package:chitchat/views/conversation.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomsStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot){
      return snapshot.hasData ? ListView.builder(
        itemCount: snapshot.data.documents.length,
        itemBuilder: (context, index){
        return ChatRoomTile(
          snapshot.data.docs[index].data()["chatRoomId"]
          .toString().replaceAll("_", "")
          .replaceAll(Constants.myName, ""),
          snapshot.data.docs[index].data()["chatRoomId"]
        );
      }) : Container();
    },);
  }

  @override
  void initState() {
    getUserInfo();
    
    super.initState();
  }

  getUserInfo() async{
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomsStream = value;
      });
    });
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text("Chats", style: TextStyle(color:Colors.black, fontSize: 30,fontWeight: FontWeight.bold),),
        actions: [
         Padding(
           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
           child: Container(
                padding: EdgeInsets.only(left: 8,right: 8,top: 5,bottom: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.pink[50],
                ),
                child: GestureDetector(
               onTap: (){
                          authMethods.signOut();
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()
                          ));
                        },
               child: Row(
                          children: <Widget>[
                            Icon(Icons.exit_to_app,color: Colors.pink,size: 20,),
                            SizedBox(width: 2,),
                            Text("LogOut",style: TextStyle( color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold),),
                          ],
                        ),
                ),
            ),
         ),
  ],
      ),
      body: Scaffold(
        body: chatRoomList(),
        
        /*SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16,right: 16,top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Chats",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                    Container(
                      padding: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.pink[50],
                      ),
                      child: GestureDetector(
                        onTap: (){
                          authMethods.signOut();
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()
                          ));
                        },
                        
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.exit_to_app,color: Colors.pink,size: 20,),
                            SizedBox(width: 2,),
                            Text("LogOut",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            chatRoomList(),
          ],
          ),
          ),*/
      )
      );
  }
}


class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName, this.chatRoomId);

  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ConversationScreen(chatRoomId)
   ));
      },
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          border: new Border(
            bottom: new BorderSide(
              color: Colors.grey,
              width: 0.5,
              style: BorderStyle.solid
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration:  BoxDecoration(
                color: Colors.pink[400],
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${userName.substring(0,1).toUpperCase()}",
              style: TextStyle(color: Colors.white, fontSize: 17),),
            ),
            SizedBox(width: 8,),
            Text(userName, style: TextStyle(color: Colors.black, fontSize: 17),)
          ],),    
      ),
    );
  }
}






