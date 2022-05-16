import 'dart:math';

import 'package:awesome_loader/awesome_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:happy_hearts_pet_care_services/block/favourite_bloc.dart';

import 'package:happy_hearts_pet_care_services/constant/global.dart';
import 'package:happy_hearts_pet_care_services/constant/sizeconfig.dart';
import 'package:happy_hearts_pet_care_services/models/favourite_restaurent_modal.dart';
import 'package:happy_hearts_pet_care_services/provider/favourite_api.dart';
import 'package:happy_hearts_pet_care_services/provider/like_api.dart';
import 'package:happy_hearts_pet_care_services/provider/unlike_api.dart';
import 'package:happy_hearts_pet_care_services/screens/ResDetailsNew.dart';
import 'package:line_icons/line_icons.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteRestaurentList extends StatefulWidget {
  @override
  FavouriteRestaurentListState createState() => FavouriteRestaurentListState();
}

class FavouriteRestaurentListState extends State<FavouriteRestaurentList> {
  var data1;
  Position currentLocation;
  @override
  void initState() {
    likedRestaurent = [];
    favouriteBloc.favouriteSink(userID);
    super.initState();
    getCurrentLocation().then((_) async {
      setState(() {});
    });
  }

  Future<LocationData> getCurrentLocation() async {
    print("getCurrentLocation");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('currentLat') && prefs.containsKey('currentLon')) {
      locationData = LocationData.fromMap({
        "latitude": prefs.getDouble('currentLat'),
        "longitude": prefs.getDouble('currentLon')
      });
    } else {
      setCurrentLocation().then((value) {
        if (prefs.containsKey('currentLat') &&
            prefs.containsKey('currentLon')) {
          locationData = LocationData.fromMap({
            "latitude": prefs.getDouble('currentLat'),
            "longitude": prefs.getDouble('currentLon')
          });
        }
      });
    }
    return locationData;
  }

  Future<LocationData> setCurrentLocation() async {
    var location = new Location();
    location.requestService().then((value) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        locationData = await location.getLocation();
        await prefs.setDouble('currentLat', locationData.latitude);
        await prefs.setDouble('currentLon', locationData.longitude);
      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          print('Permission denied');
        }
      }
    });
    return locationData;
  }

  Future getUserCurrentLocation() async {
    await Geolocator().getCurrentPosition().then((position) {
      setState(() {
        currentLocation = position;
      });
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 0.0, left: 10.0, right: 10.0),
      height: safeQueries(context)
          ? MediaQuery.of(context).size.height - 200
          : MediaQuery.of(context).size.height - 150,
      //color: Colors.red,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<FavouriteModal>(
          stream: favouriteBloc.favouriteStream,
          builder: (context, AsyncSnapshot<FavouriteModal> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: AwesomeLoader(
                  color: appColorGreen,
                  loaderType: 4,
                ),
              );
            }
            List<FavRestaurants> allRest = snapshot.data.restaurants != null
                ? snapshot.data.restaurants
                : [];
            return allRest.length > 0
                ? ListView.builder(
                    itemCount: allRest.length,
                    itemBuilder: (context, int index) {
                      return _nearYouBuildItem(allRest[index]);
                    },
                  )
                : Center(
                    child: Text(
                      "Your wishlist list is empty",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  );
          }),
    );
  }

  Widget _nearYouBuildItem(FavRestaurants categories) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ResDetailsNew(
                  likeStatus:
                      likedRestaurent.contains(categories.resId) ? 'yes' : 'no',
                  restID: categories.resId,
                  restName: categories.resName,
                  resNameU: categories.resNameU,
                  restDesc: categories.resDesc,
                  restDescU: categories.resDescU,
                  resWebsite: categories.resWebsite,
                  restImage: categories.resImage.resImag0,
                  resPhone: categories.resPhone,
                  resAddress: categories.resAddress,
                  restRatings: categories.resRatings,
                  mfo: categories.mfo,
                  // mfc: categories.mfc,
                  // sso: categories.sso,
                  // ssc: categories.ssc,

                  lat: categories.lat,
                  lon: categories.lon,
                  count: categories.reviewCount,
                  images: categories.allImage,
                  resVideo: categories.resVideo,
                  resUrl: categories.resUrl,
                ),
              ),
            );
          },
          child: Container(
            height: ScreenUtil.getInstance().setHeight(470),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                  ),
                  child: Stack(
                    children: <Widget>[
                      Material(
                        elevation: 5.0,
                        shadowColor: Colors.white,
                        borderRadius: BorderRadius.circular(14.0),
                        child: Container(
                          height: ScreenUtil.getInstance().setHeight(415),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 0.0,
                              bottom: 00.0,
                              left: 0.0,
                              right: 0.0,
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: ScreenUtil.screenWidth,
                                  height:
                                      ScreenUtil.getInstance().setHeight(300),
                                  child: FittedBox(
                                    child: CachedNetworkImage(
                                      imageUrl: categories.resImage.resImag0,
                                      placeholder: (context, url) => Center(
                                        child: Container(
                                          margin: EdgeInsets.all(70.0),
                                          child: CupertinoActivityIndicator(),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        height: 5,
                                        width: 5,
                                        child: Icon(
                                          Icons.error,
                                        ),
                                      ),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 10),
                                            child: Text(
                                              categories.resName,
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil.getInstance()
                                                          .setSp(30),
                                                  fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                              softWrap: true,
                                            ),
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(7)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.star,
                                                    color: Color(0xFF1E3C72),
                                                    size: 10,
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    categories.resRatings,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: SizeConfig
                                                                .blockSizeHorizontal *
                                                            2.5),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          likedRestaurent
                                                  .contains(categories.resId)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10),
                                                  child: InkWell(
                                                      onTap: () {
                                                        // likeBloc.likeSink(userID, restaurants.resId).then((_) {
                                                        //   favouriteBloc.favouriteSink(userID);
                                                        // });
                                                        Loader().showIndicator(
                                                            context);
                                                        UnlikeApi()
                                                            .unlikeApi(
                                                                userID,
                                                                categories
                                                                    .resId)
                                                            .then((onValue) {
                                                          Loader()
                                                              .hideIndicator(
                                                                  context);

                                                          favouriteBloc
                                                              .favouriteSink(
                                                                  userID);
                                                          likedRestaurent = [];
                                                          FavouriteApi()
                                                              .favouriteApi(
                                                                  userID)
                                                              .then(
                                                                  (favourite) {
                                                            if (favourite
                                                                    .status ==
                                                                1) {
                                                              for (FavRestaurants data
                                                                  in favourite
                                                                      .restaurants) {
                                                                setState(() {
                                                                  likedRestaurent
                                                                      .add(data
                                                                          .resId);
                                                                });
                                                              }
                                                            } else {
                                                              setState(() {});
                                                            }
                                                          });
                                                        });
                                                      },
                                                      child: Icon(
                                                          LineIcons.heart)),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10),
                                                  child: InkWell(
                                                      onTap: () {
                                                        // likeBloc.likeSink(userID, restaurants.resId).then((_) {
                                                        //   favouriteBloc.favouriteSink(userID);
                                                        // });
                                                        Loader().showIndicator(
                                                            context);
                                                        LikeApi()
                                                            .likeApi(
                                                                userID,
                                                                categories
                                                                    .resId)
                                                            .then((onValue) {
                                                          favouriteBloc
                                                              .favouriteSink(
                                                                  userID);
                                                          likedRestaurent = [];
                                                          FavouriteApi()
                                                              .favouriteApi(
                                                                  userID)
                                                              .then(
                                                                  (favourite) {
                                                            for (FavRestaurants data
                                                                in favourite
                                                                    .restaurants) {
                                                              setState(() {
                                                                likedRestaurent
                                                                    .add(data
                                                                        .resId);
                                                              });
                                                            }

                                                            Loader()
                                                                .hideIndicator(
                                                                    context);
                                                          });
                                                        });
                                                      },
                                                      child: Icon(
                                                          LineIcons.heart_o)),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                              alignment: Alignment.topLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, top: 0),
                                                child: Text(
                                                  categories.resAddress,
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil
                                                              .getInstance()
                                                          .setSp(25),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey),
                                                  maxLines: 1,
                                                  softWrap: true,
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                              alignment: Alignment.topLeft,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, top: 10),
                                                  child:
                                                      _distance(categories))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, top: 10),
                            child: Container(
                              height: SizeConfig.blockSizeVertical * 3,
                              width: SizeConfig.blockSizeHorizontal * 20,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color(0xFF1E3C72),
                                    Color(0xFF2A5298),
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(80.0)),
                              ),
                              child: Center(
                                child: Text(
                                  categories.cName,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )

        // GestureDetector(
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       CupertinoPageRoute(
        //         builder: (context) => RestaurentDesc(
        //           likeStatus: likedRestaurent.contains(categories.resId)
        //               ? 'yes'
        //               : 'no',
        //           restID: categories.resId,
        //           restName: categories.resName,
        //           resNameU: categories.resNameU,
        //           restDesc: categories.resDesc,
        //           restDescU: categories.resDescU,
        //           resWebsite: categories.resWebsite,
        //           restImage: categories.resImage.resImag0,
        //           resPhone: categories.resPhone,
        //           resAddress: categories.resAddress,
        //           restRatings: categories.resRatings,
        //           mfo: categories.mfo,
        //           // mfc: restaurants.mfc,
        //           // sso: restaurants.sso,
        //           // ssc: restaurants.ssc,
        //           images: categories.allImage,
        //           lat: categories.lat,
        //           lon: categories.lon,
        //           resVideo: categories.resVideo,
        //           count: categories.reviewCount,
        //         ),
        //       ),
        //     );
        //   },
        //   child: Container(
        //     margin: const EdgeInsets.only(top: 10),
        //     height: 130,
        //     // width: MediaQuery.of(context).size.width - 20,
        //     decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(8.0),
        //     ),
        //     child: Row(
        //       children: <Widget>[
        //         _itemImage(categories),
        //         Padding(
        //           padding: const EdgeInsets.only(left: 10, top: 15),
        //           child: _itemDetail(categories),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  // ignore: unused_element
  Widget _itemImage(FavRestaurants restaurants) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, bottom: 0),
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: CachedNetworkImage(
            imageUrl: restaurants.resImage.resImag0,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => Center(
              child: Container(
                margin: EdgeInsets.all(35.0),
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: new AlwaysStoppedAnimation<Color>(appColorGreen),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _itemDetail(FavRestaurants restaurants) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Container(
        height: 140,
        width: MediaQuery.of(context).size.width - 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _itemNameAndLike(restaurants),
            Container(
              height: 5,
            ),
            _ratingAndCount(restaurants),
            // _openCloseStatus(restaurants),
            _itemDescription(restaurants),
            _distance(restaurants),
          ],
        ),
      ),
    );
  }

  Widget _itemNameAndLike(FavRestaurants restaurants) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 6,
          // width: MediaQuery.of(context).size.width - 200,
          child: Text(
            restaurants.resName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0XFF106C6F),
            ),
          ),
        ),
        Expanded(
          // width: MediaQuery.of(context).size.width - 325,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    likedRestaurent.contains(restaurants.resId);
                    Loader().showIndicator(context);
                    UnlikeApi()
                        .unlikeApi(userID, restaurants.resId)
                        .then((onValue) {
                      favouriteBloc.favouriteSink(userID);
                      likedRestaurent = [];
                      // FavouriteApi().favouriteApi(userID).then((favourite) {
                      //   for (FavRestaurants data in favourite.restaurants) {
                      //     setState(() {
                      //       likedRestaurent.add(data.resId);
                      //     });
                      //   }

                      //   setState(() {});
                      //   // Loader().hideIndicator(context);
                      // });
                      Loader().hideIndicator(context);
                    });
                    // Loader().hideIndicator(context);
                  },
                  child: Image.asset(
                    'assets/images/close.png',
                    height: 15.0,
                    width: 15.0,
                    color: Color(0XFF106C6F),
                  ),
                ),

                // : InkWell(
                //     onTap: () {
                //       // likeBloc.likeSink(userID, restaurants.resId);
                //       LikeApi()
                //           .likeApi(userID, restaurants.resId)
                //           .then((onValue) {
                //         likedRestaurent = [];
                //         FavouriteApi().favouriteApi(userID).then((favourite) {
                //           for (FavRestaurants data in favourite.restaurants) {
                //             setState(() {
                //               likedRestaurent.add(data.resId);
                //             });
                //           }
                //         });
                //       });
                //     },
                //     child: SvgPicture.asset(
                //       Images.heart,
                //       height: 20.0,
                //       width: 20.0,
                //     ),
                //   ),
                Container(width: 5.0),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _ratingAndCount(FavRestaurants restaurants) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Row(
        children: <Widget>[
          RatingBar(
            initialRating: restaurants.resRatings != 'none'
                ? double.parse(restaurants.resRatings)
                : 0.0,
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 18,
            ignoreGestures: true,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Color(0XFF106C6F),
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
          SizedBox(width: 7),
          Text(
            restaurants.resRatings,
            style: TextStyle(
                color: Color(0XFF106C6F),
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
          // Text("(45)")
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _openCloseStatus(FavRestaurants restaurants) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: <Widget>[
          Container(width: 5.0),
          Text(
            restaurants.resIsOpen,
            style: TextStyle(fontStyle: FontStyle.normal, color: appColorGreen),
          )
        ],
      ),
    );
  }

  Widget _itemDescription(FavRestaurants restaurants) {
    return Container(
      // width: 200,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Text(
          restaurants.resDescU,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
    );
  }

  Widget _distance(FavRestaurants restaurants) {
    if (locationData != null &&
        restaurants.lat != "" &&
        restaurants.lon != "") {
      double distanceInKm = calculateDistance(
        locationData.latitude,
        locationData.longitude,
        double.parse(restaurants.lat),
        double.parse(restaurants.lon),
      );
      print(double.parse(distanceInKm.toStringAsFixed(2)));

      data1 = distanceInKm.toStringAsFixed(0);
    } else {
      double distanceInKm = calculateDistance(
        0.0,
        0.0,
        0.0,
        0.0,
      );
      print(double.parse(distanceInKm.toStringAsFixed(2)));

      data1 = distanceInKm.toStringAsFixed(0);
    }
    return Padding(
      padding: const EdgeInsets.only(right: 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          data1 != null
              ? Text(
                  data1 + ' KM',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                )
              : Text(
                  "",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
        ],
      ),
    );
  }
}
