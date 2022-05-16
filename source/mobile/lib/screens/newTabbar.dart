import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:happy_hearts_pet_care_services/constant/global.dart';
import 'package:happy_hearts_pet_care_services/favourite/favourite.dart';
import 'package:happy_hearts_pet_care_services/screens/categoriesNew.dart';

import 'package:happy_hearts_pet_care_services/screens/homeAllRes.dart';
import 'package:happy_hearts_pet_care_services/screens/homeNew.dart';

import 'package:happy_hearts_pet_care_services/screens/profile.dart';
import 'package:happy_hearts_pet_care_services/share_preference/preferencesKey.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabbarScreen extends StatefulWidget {
  final String userID;
  TabbarScreen({this.userID});
  @override
  _TabbarScreenState createState() => _TabbarScreenState();
}

class _TabbarScreenState extends State<TabbarScreen> {
  int _currentIndex = 0;

  // ignore: unused_field
  List<dynamic> _handlePages = [
    HomeNew(),
    DiscoverNew(),
    CategoriesNew(),
    FavouriteRest(),
    Profile(),
    // SearchRestaurent(),
    // ShareApp(),

    // HomeNew(),
    // FavouriteRest(),
    // NearRestaurentOnMap(),

    // WelcomeScreen(),
  ];

  @override
  void initState() {
    getUserDataFromPrefs();
    super.initState();
  }

  getUserDataFromPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userDataStr =
        preferences.getString(SharedPreferencesKey.LOGGED_IN_USERRDATA);
    Map<String, dynamic> userData = json.decode(userDataStr);
    print(userData);

    setState(() {
      userID = userData['user_id'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          HomeNew(),
          DiscoverNew(),
          CategoriesNew(),
          FavouriteRest(),
          Profile(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF1E3C72),
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: <BottomNavigationBarItem>[
          _currentIndex == 0
              ? BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Home",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              : BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: Colors.grey,
                  ),
                  title: Text(
                    "Home",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
          _currentIndex == 1
              ? BottomNavigationBarItem(
                  icon: Icon(
                    Icons.explore,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Explore",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              : BottomNavigationBarItem(
                  icon: Icon(
                    Icons.explore,
                    color: Colors.grey,
                  ),
                  title: Text(
                    "Explore",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
          _currentIndex == 2
              ? BottomNavigationBarItem(
                  icon: Icon(
                    Icons.category,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Catrgories",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              : BottomNavigationBarItem(
                  icon: Icon(
                    Icons.category,
                    color: Colors.grey,
                  ),
                  title: Text(
                    "Catrgories",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
          _currentIndex == 3
              ? BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Favourite",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              : BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.grey,
                  ),
                  title: Text(
                    "Favourite",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
          _currentIndex == 4
              ? BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Profile",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              : BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                  title: Text(
                    "Profile",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
        ],
      ),
    );
  }
}
