import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '/blocs/notification_bloc.dart';
import '/pages/blogs.dart';
// import '/pages/bookmark.dart';
import '/pages/explore.dart';
import '/pages/profile.dart';
import '/pages/states.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 0;
  PageController _pageController = PageController();

  List<IconData> iconList = [
    Icons.home,
    Icons.explore,
    Icons.list,
    Icons.bookmark,
    Icons.person,
    //Icons.settings,
  ];


  void onTabTapped(int index) {
    setState(() {
     _currentIndex = index;
     
   });
   _pageController.animateToPage(index,
      curve: Curves.easeIn,
      duration: Duration(milliseconds: 400));
   
  }



 @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0))
    .then((value) async{
      await context.read<NotificationBloc>().initFirebasePushNotification(context);
    });
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: 
      CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.blue,
        buttonBackgroundColor: Colors.blue,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 400),
        height: 50,
        items:iconList.map((e) => Icon(e, size: 30, color: Colors.white,)).toList(),
        onTap: (index) => onTabTapped(index),
      ),
      body: PageView(
        controller: _pageController,

        physics: NeverScrollableScrollPhysics(),  
        children: <Widget>[
          Explore(),
          StatesPage(),
          BlogPage(),
          // BookmarkPage(),
          ProfilePage(),
        ],
      ),
    );
  }
}
