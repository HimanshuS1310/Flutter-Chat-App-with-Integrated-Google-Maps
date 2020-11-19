import 'package:chitchat/helper/constants.dart';
import 'package:chitchat/services/database.dart';
import 'package:chitchat/views/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}
String _myName;
class _SearchScreenState extends State<SearchScreen> {
 TextEditingController searchTextEditingController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  QuerySnapshot searchSnapshot;

   Widget searchList(){
    return searchSnapshot != null ? ListView.builder(
      itemCount: searchSnapshot.docs.length,
      shrinkWrap: true,
      itemBuilder: (context, index){
        return SearchTile(
          userName: searchSnapshot.docs[index].data()["name"],
          userEmail: searchSnapshot.docs[index].data()["email"],
        );
      }) : Container();
  }

  initiateSearch(){
    databaseMethods.getUserByUsername(searchTextEditingController.text).then((value){
      setState(() {
         searchSnapshot = value;
      });
   });
  }

// Create chatroom, send user to conversation screen, pushreplacement
 createChatroomAndStartConversation({ String userName}){
   if(userName != Constants.myName){
     String chatRoomId = getChatRoomId(userName, Constants.myName);
   List<String> users = [userName,Constants.myName];
   Map<String, dynamic> chatRoomMap = {
     "users" : users,
     "chatRoomId" : chatRoomId,
   };
   DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
   Navigator.push(context, MaterialPageRoute(builder: (context)=> ConversationScreen(chatRoomId)
   ));
   }else{
     
     final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Cannot send message to yourself.'),
      );
      Scaffold.of(context).showSnackBar(snackBar); 
   }
   
 }
 
 
 Widget SearchTile({String userName, String userEmail}){
   return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
              Text(userEmail, style: TextStyle(color: Colors.black,),),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatroomAndStartConversation(userName: userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.pink[300],
                borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("Message",),
            ),
          )

        ],
      ),
    );
 }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: SingleChildScrollView(
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
                    Text("Search",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),
             Container(
        child:Column(
          children: [
            Container(
              child:Padding(
              padding: EdgeInsets.only(top: 16,left: 16,right: 16),
              child: TextField(
                controller: searchTextEditingController,
                onChanged: (value){
                  initiateSearch();
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 20, ),
                  prefixIcon: Icon(Icons.search,color: Colors.grey.shade400,size: 20,),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: Colors.grey.shade100
                      )
                  ),
                ),
              ),
            ),
            ),
          /*  Padding(
              padding: EdgeInsets.only(top: 16,left: 16,right: 16),
              child: TextField(
                controller: searchTextEditingController,
                onChanged: (value){
                  initiateSearch();
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 20, ),
                  prefixIcon: Icon(Icons.search,color: Colors.grey.shade400,size: 20,),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: Colors.grey.shade100
                      )
                  ),
                ),
              ),
            ),*/
            searchList(),
          ],)
      ),
          ],
          ),
          ),
      ));
  }
} 
    
    
    
    
    
    
    
    
    
    
  
    
    
    
    
    
    /*
    Scaffold(
      body: Container(
        child:Column(
          children: [
            /*Container(
              child:Padding(
              padding: EdgeInsets.only(top: 16,left: 16,right: 16),
              child: TextField(
                controller: searchTextEditingController,
                onChanged: (value){
                  initiateSearch();
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 20, ),
                  prefixIcon: Icon(Icons.search,color: Colors.grey.shade400,size: 20,),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: Colors.grey.shade100
                      )
                  ),
                ),
              ),
            ),
            ),*/
            Padding(
              padding: EdgeInsets.only(top: 160,left: 16,right: 16),
              child: TextField(
                controller: searchTextEditingController,
                onChanged: (value){
                  initiateSearch();
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 20, ),
                  prefixIcon: Icon(Icons.search,color: Colors.grey.shade400,size: 20,),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: Colors.grey.shade100
                      )
                  ),
                ),
              ),
            ),
            searchList(),
          ],)
      ),
      
    );
  }
}


*/



getChatRoomId(String a, String b){
  if(a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)){
    return "$b\_$a";
  }else {
    return "$a\_$b";
  }
}