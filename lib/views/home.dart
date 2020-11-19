import 'package:flutter/material.dart';
import 'package:chitchat/views/chatroom.dart';
import 'package:chitchat/views/maps.dart';
import 'package:chitchat/views/search.dart';


class BottomNavigation extends StatefulWidget {

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final navigatorKey = GlobalKey<NavigatorState>();

  int _currentIndex = 0;

  final bottomPagesRoute = {
    "/": () => MaterialPageRoute(
          builder: (context) => ChatRoom()
        ),
    "search": () => MaterialPageRoute(
          builder: (context) => SearchScreen()
        ),
    "maps": () => MaterialPageRoute(
          builder: (context) => Maps()
        ),
  };

  @override
  Widget build(BuildContext context) => MaterialApp(
          debugShowCheckedModeBanner: false,

        home: Scaffold(
          body: _buildBody(),
          bottomNavigationBar: _buildBottomNavigationBar(context),
        ),
      );

  Widget _buildBody() =>
      MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        onGenerateRoute: (route) => bottomPagesRoute[route.name]()
        );

  Widget _buildBottomNavigationBar(context) => BottomNavigationBar(
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey.shade400,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Maps',
          ),
        ],
         onTap:(index){
          setState(() {
            _currentIndex = index;
            navigatorKey.currentState.pushNamed(bottomPagesRoute.keys.toList()[index]);
          },
          
          );

        } ,
        //onTap: (routeIndex) =>
        //    navigatorKey.currentState.pushNamed(bottomPagesRoute.keys.toList()[routeIndex]),
      );
}