// import 'package:flutter/material.dart';
// import 'package:happy_hearts_pet_care_services/screens/NearBy/nearBy.dart';
// import 'package:happy_hearts_pet_care_services/screens/drawer.dart';

// class NearbyPage extends StatefulWidget {
//   @override
//   _NearbyPageState createState() => _NearbyPageState();
// }

// class _NearbyPageState extends State<NearbyPage> {
//   @override
//   void initState() {
//     // favoriteRestaurents();
//     super.initState();
//   }

//   // Future favoriteRestaurents() async {
//   //   likedRestaurent = [];
//   //   FavouriteApi().favouriteApi(userID).then((favourite) {
//   //     for (FavRestaurants data in favourite.restaurants) {
//   //       setState(() {
//   //         likedRestaurent.add(data.resId);
//   //       });
//   //     }
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0XFF003F4F),
//       appBar: AppBar(
//         backgroundColor: Color(0XFF1A5361),
//         title: Text(
//           "Near By store",
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => FullScreenDrawer()),
//             );
//           },
//           child: Container(
//               height: 100,
//               width: 100,
//               child: Image.asset(
//                 'assets/images/menuicon.png',
//               )),
//         ),
//         actions: <Widget>[
//           Padding(
//               padding: EdgeInsets.only(right: 20.0),
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Icon(
//                   Icons.arrow_back,
//                   color: Colors.white,
//                 ),
//               )),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 0.0, right: 0.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               // searchField(),
//               Container(
//                 height: 10,
//               ),

//               NearBy(),
//               // titleText('Favourite Restaurants'),
//               // FavouriteRestaurant(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
