// import 'dart:math';

// import 'package:awesome_loader/awesome_loader.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:happy_hearts_pet_care_services/block/favourite_bloc.dart';
// import 'package:happy_hearts_pet_care_services/block/like_bloc.dart';
// import 'package:happy_hearts_pet_care_services/constant/global.dart';
// import 'package:happy_hearts_pet_care_services/constant/sizeconfig.dart';
// import 'package:happy_hearts_pet_care_services/images/images.dart';
// import 'package:happy_hearts_pet_care_services/models/favourite_restaurent_modal.dart';
// import 'package:happy_hearts_pet_care_services/models/nearByStore.dart';
// import 'package:happy_hearts_pet_care_services/provider/favourite_api.dart';
// import 'package:happy_hearts_pet_care_services/provider/like_api.dart';
// import 'package:happy_hearts_pet_care_services/provider/nearByStore_api.dart';
// import 'package:happy_hearts_pet_care_services/provider/unlike_api.dart';
// import 'package:happy_hearts_pet_care_services/screens/restaurent_des.dart';
// import 'package:location/location.dart';
// import 'package:progress_dialog/progress_dialog.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class NearBy extends StatefulWidget {
//   @override
//   _NearByState createState() => _NearByState();
// }

// class _NearByState extends State<NearBy> {
//   Position currentLocation;
//   List<RestaurantsN> allRestaurents = [];
//   bool _showLoader = true;
//   var scaffoldKey = GlobalKey<ScaffoldState>();
//   var data1;

//   LocationData locationData;

//   ProgressDialog pr;

//   @override
//   void initState() {
//     allRestaurents = [];
//     getUserCurrentLocation().then((_) async {
//       //  nearbyBloc.nearbySink();

//       await NearByStoreApi().resApi('5').then((nearbyRest) {
//         for (RestaurantsN data in nearbyRest.restaurants) {
//           if (data.lat != "" && data.lon != "") {
//             double distanceInKm = calculateDistance(
//               currentLocation.latitude,
//               currentLocation.longitude,
//               double.parse(data.lat),
//               double.parse(data.lon),
//             );
//             double distanceInMiles = distanceInKm * 0.621371;
//             if (distanceInMiles <= 20.0) {
//               allRestaurents.add(data);
//             }
//           }
//         }
//         _showLoader = false;
//         setState(() {});
//       });
//     });
//     getCurrentLocation().then((_) async {
//       setState(() {});
//     });

//     super.initState();
//   }

//   Future<LocationData> getCurrentLocation() async {
//     print("getCurrentLocation");
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (prefs.containsKey('currentLat') && prefs.containsKey('currentLon')) {
//       locationData = LocationData.fromMap({
//         "latitude": prefs.getDouble('currentLat'),
//         "longitude": prefs.getDouble('currentLon')
//       });
//     } else {
//       setCurrentLocation().then((value) {
//         if (prefs.containsKey('currentLat') &&
//             prefs.containsKey('currentLon')) {
//           locationData = LocationData.fromMap({
//             "latitude": prefs.getDouble('currentLat'),
//             "longitude": prefs.getDouble('currentLon')
//           });
//         }
//       });
//     }
//     return locationData;
//   }

//   Future<LocationData> setCurrentLocation() async {
//     var location = new Location();
//     location.requestService().then((value) async {
//       try {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         locationData = await location.getLocation();
//         await prefs.setDouble('currentLat', locationData.latitude);
//         await prefs.setDouble('currentLon', locationData.longitude);
//       } on PlatformException catch (e) {
//         if (e.code == 'PERMISSION_DENIED') {
//           print('Permission denied');
//         }
//       }
//     });
//     return locationData;
//   }

//   Future getUserCurrentLocation() async {
//     await Geolocator().getCurrentPosition().then((position) {
//       setState(() {
//         currentLocation = position;
//       });
//     });
//   }

//   double calculateDistance(lat1, lon1, lat2, lon2) {
//     var p = 0.017453292519943295;
//     var c = cos;
//     var a = 0.5 -
//         c((lat2 - lat1) * p) / 2 +
//         c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
//     return 12742 * asin(sqrt(a));
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return _showLoader
//         ? Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             child: AwesomeLoader(
//               color: appColorGreen,
//               loaderType: 4,
//             ),
//           )
//         : allRestaurents.length > 0
//             ? Container(
//                 // color: Colors.red,
//                 margin: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
//                 height: allRestaurents.length == 1 ? 155 : 310,
//                 width: MediaQuery.of(context).size.width,

//                 child: ListView.builder(
//                   itemCount: allRestaurents.length,
//                   itemBuilder: (context, int index) {
//                     return InkWell(
//                       onTap: () {
//                         // Navigator.push(
//                         //   context,
//                         //   CupertinoPageRoute(
//                         //     builder: (context) => RestaurentDesc(
//                         //       likeStatus: likedRestaurent
//                         //               .contains(allRestaurents[index].resId)
//                         //           ? 'yes'
//                         //           : 'no',
//                         //       restDesc: allRestaurents[index].resDesc,
//                         //       restID: allRestaurents[index].resId,
//                         //       restImage: allRestaurents[index].resImage,
//                         //       restName: allRestaurents[index].resName,
//                         //       restRatings: allRestaurents[index].resRatings,
//                         //     ),
//                         //   ),
//                         // );
//                       },
//                       child: Column(
//                         children: <Widget>[
//                           _nearYouBuildItem(allRestaurents[index]),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               )
//             : Container(
//                 padding: EdgeInsets.only(top: 20.0),
//                 alignment: Alignment.center,
//                 height: 40,
//                 // color: Colors.red,
//                 width: MediaQuery.of(context).size.width,
//                 child: Text(
//                   "You don't have any restaurent near you.",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       color: Colors.black, fontStyle: FontStyle.normal),
//                 ),
//               );
//   }

//   Widget _nearYouBuildItem(RestaurantsN restaurant) {
//     return Stack(
//       children: <Widget>[
//         GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               CupertinoPageRoute(
//                 builder: (context) => RestaurentDesc(
//                   likeStatus:
//                       likedRestaurent.contains(restaurant.resId) ? 'yes' : 'no',
//                   restID: restaurant.resId,
//                   restName: restaurant.resName,
//                   resNameU: restaurant.resNameU,
//                   restDesc: restaurant.resDesc,
//                   restDescU: restaurant.resDescU,
//                   resWebsite: restaurant.resWebsite,
//                   restImage: restaurant.resImage.resImag0,
//                   resPhone: restaurant.resPhone,
//                   resAddress: restaurant.resAddress,
//                   restRatings: restaurant.resRatings,
//                   mfo: restaurant.mfo,
//                   // mfc: categories.mfc,
//                   // sso: categories.sso,
//                   // ssc: categories.ssc,
//                   lat: restaurant.lat,
//                   lon: restaurant.lon,
//                   count: restaurant.reviewCount,
//                   images: restaurant.allImage,
//                   resVideo: restaurant.resVideo,
//                 ),
//               ),
//             );
//           },
//           child: Padding(
//             padding: const EdgeInsets.only(left: 17, right: 17, top: 5),
//             child: Container(
//               margin: EdgeInsets.only(top: 10.0),
//               height: SizeConfig.blockSizeVertical * 14,
//               width: MediaQuery.of(context).size.width - 20,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
//               ),
//               child: Row(
//                 children: <Widget>[
//                   _itemImage(restaurant),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: _itemDetail(context, restaurant),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _itemImage(RestaurantsN restaurant) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 10.0, bottom: 10, top: 10),
//       child: Container(
//         height: 80,
//         width: 80,
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: Colors.black,
//           ),
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(8.0),
//           child: CachedNetworkImage(
//             imageUrl: restaurant.logo,
//             imageBuilder: (context, imageProvider) => Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: imageProvider,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             placeholder: (context, url) => Center(
//               child: Container(
//                 margin: EdgeInsets.all(35.0),
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2.0,
//                   valueColor: new AlwaysStoppedAnimation<Color>(appColorGreen),
//                 ),
//               ),
//             ),
//             errorWidget: (context, url, error) => Icon(Icons.error),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _itemDetail(BuildContext context, RestaurantsN restaurant) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 10.0, top: 10),
//       child: Container(
//         height: 120,
//         width: MediaQuery.of(context).size.width - 175,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             _itemNameAndLike(restaurant),
//             SizedBox(height: 5),
//             _ratingAndCount(context, restaurant),
//             SizedBox(height: 5),
//             // _openCloseStatus(context, restaurant),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Container(
//                     width: SizeConfig.blockSizeHorizontal * 30,
//                     child: _itemDescription(restaurant)),
//                 _distance(restaurant),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _itemNameAndLike(RestaurantsN restaurant) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: <Widget>[
//         Container(
//           width: MediaQuery.of(context).size.width - 235,
//           child: Text(
//             restaurant.resName,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               color: Color(0XFF106C6F),
//               fontStyle: FontStyle.normal,
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//             ),
//           ),
//         ),
//         Container(
//           // width: MediaQuery.of(context).size.width - 325,
//           child: Row(
//             children: <Widget>[
//               likedRestaurent.contains(restaurant.resId)
//                   ? InkWell(
//                       onTap: () {
//                         // likeBloc.likeSink(userID, restaurants.resId).then((_) {
//                         //   favouriteBloc.favouriteSink(userID);
//                         // });
//                         Loader().showIndicator(context);
//                         UnlikeApi()
//                             .unlikeApi(userID, restaurant.resId)
//                             .then((onValue) {
//                           favouriteBloc.favouriteSink(userID);
//                           likedRestaurent = [];
//                           FavouriteApi().favouriteApi(userID).then((favourite) {
//                             for (FavRestaurants data in favourite.restaurants) {
//                               // setState(() {
//                               //   likedRestaurent.add(data.resId);
//                               // });
//                               likeBloc.likeSink(
//                                 userID,
//                                 restaurant.resId,
//                               );
//                             }
//                             pr.hide();
//                           });
//                         });
//                       },
//                       child: SvgPicture.asset(
//                         Images.heartfill,
//                         height: 20,
//                         width: 20,
//                         color: Colors.red,
//                       ),
//                     )
//                   : InkWell(
//                       onTap: () {
//                         // likeBloc.likeSink(userID, restaurants.resId).then((_) {
//                         //   favouriteBloc.favouriteSink(userID);
//                         // });
//                         Loader().showIndicator(context);
//                         LikeApi()
//                             .likeApi(userID, restaurant.resId)
//                             .then((onValue) {
//                           favouriteBloc.favouriteSink(userID);
//                           likedRestaurent = [];
//                           FavouriteApi().favouriteApi(userID).then((favourite) {
//                             for (FavRestaurants data in favourite.restaurants) {
//                               // setState(() {
//                               //   likedRestaurent.add(data.resId);
//                               // });
//                               likeBloc.likeSink(
//                                 userID,
//                                 restaurant.resId,
//                               );
//                             }

//                             Loader().hideIndicator(context);
//                           });
//                         });
//                       },
//                       child: SvgPicture.asset(
//                         Images.heart,
//                         height: 20,
//                         width: 20,
//                         color: Colors.red,
//                       ),
//                     ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _ratingAndCount(BuildContext context, RestaurantsN restaurant) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 2.0),
//       child: Row(
//         children: <Widget>[
//           RatingBar(
//             initialRating: restaurant.resRatings != 'none'
//                 ? double.parse(restaurant.resRatings)
//                 : 0.0,
//             minRating: 0,
//             direction: Axis.horizontal,
//             allowHalfRating: true,
//             itemCount: 5,
//             itemSize: 12,
//             ignoreGestures: true,
//             unratedColor: Colors.grey,
//             itemBuilder: (context, _) => Icon(
//               Icons.star,
//               color: Color(0XFF106C6F),
//             ),
//             onRatingUpdate: (rating) {
//               print(rating);
//             },
//           ),
//           SizedBox(width: 7),
//           Text(
//             restaurant.resRatings,
//             style: TextStyle(
//                 color: Color(0XFF106C6F),
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold),
//           )
//           // Text("(45)")
//         ],
//       ),
//     );
//   }

//   Widget _itemDescription(RestaurantsN restaurant) {
//     return Text(
//       restaurant.resDescU,
//       overflow: TextOverflow.fade,
//       maxLines: 1,
//       style: TextStyle(
//         fontStyle: FontStyle.normal,
//       ),
//     );
//   }

//   Widget _distance(RestaurantsN restaurants) {
//     if (locationData != null &&
//         restaurants.lat != "" &&
//         restaurants.lon != "") {
//       double distanceInKm = calculateDistance(
//         locationData.latitude,
//         locationData.longitude,
//         double.parse(restaurants.lat),
//         double.parse(restaurants.lon),
//       );
//       print(double.parse(distanceInKm.toStringAsFixed(2)));

//       data1 = distanceInKm.toStringAsFixed(0);
//     } else {
//       double distanceInKm = calculateDistance(
//         0.0,
//         0.0,
//         0.0,
//         0.0,
//       );
//       print(double.parse(distanceInKm.toStringAsFixed(2)));

//       data1 = distanceInKm.toStringAsFixed(0);
//     }
//     return Padding(
//       padding: const EdgeInsets.only(right: 0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           Column(
//             children: <Widget>[
//               Image.asset(
//                 'assets/images/map.png',
//                 color: Color(0XFF106C6F),
//                 height: 15,
//                 width: 15,
//               ),
//               data1 != null
//                   ? Text(
//                       data1 + ' KM',
//                       style: TextStyle(color: Color(0XFF106C6F), fontSize: 10),
//                       overflow: TextOverflow.ellipsis,
//                     )
//                   : Text(
//                       "",
//                       style: TextStyle(color: Color(0XFF106C6F), fontSize: 10),
//                     ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
