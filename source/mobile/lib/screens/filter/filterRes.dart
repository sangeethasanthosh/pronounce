import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:happy_hearts_pet_care_services/block/favourite_bloc.dart';
import 'package:happy_hearts_pet_care_services/constant/global.dart';
import 'package:happy_hearts_pet_care_services/constant/sizeconfig.dart';
import 'package:happy_hearts_pet_care_services/models/favourite_restaurent_modal.dart';
import 'package:happy_hearts_pet_care_services/provider/favourite_api.dart';
import 'package:happy_hearts_pet_care_services/provider/like_api.dart';
import 'package:happy_hearts_pet_care_services/provider/unlike_api.dart';
import 'package:happy_hearts_pet_care_services/screens/ResDetailsNew.dart';
import 'package:happy_hearts_pet_care_services/screens/filter/filterModel.dart' as filter;
import 'package:happy_hearts_pet_care_services/screens/filter/filterModel.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterRes extends StatefulWidget {
  @override
  _DiscoverNewState createState() => _DiscoverNewState();
}

class _DiscoverNewState extends State<FilterRes> {

  var data1;

  @override
  void initState() {
     getSavedInfo();
    super.initState();
  }

  filter.FilterModel user;


    Future< filter.FilterModel> getSavedInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey("filter")) {
      Map userMap = jsonDecode(preferences.getString("filter"));
      user =  filter.FilterModel.fromJson(userMap);
      setState(() {
       _listdatawidget(context);
      });
    }

    return user;
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
    SizeConfig().init(context);
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);

    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Container(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: LayoutBuilder(builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: <Widget>[
                          header(),
                        _listdatawidget(context)
                              
                        ],
                      ),
                    )),
              );
            })),
      ),
    );
  }

  Widget header() {
    return Container(
      height: SizeConfig.blockSizeVertical * 12,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xFF1E3C72), Color(0xFF2A5298)]),
      ),
      child: Center(
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 25,left: 20),
                child:Row(
                  children: [
                    Text("Filter",style: TextStyle(color: Colors.white,fontSize: 18),),
                    Expanded(child:Text("")),
                    IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,), onPressed: (){
                      Navigator.pop(context);
                    })
                  ],
                )
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _listdatawidget(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      child:  user!=null && user.restaurants.length > 0
              ? ListView.builder(
                  padding: EdgeInsets.only(bottom: 200, top: 30),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: user.restaurants.length,
                  itemBuilder: (
                    context,
                    int index,
                  ) {
                    return widgetCard(user.restaurants[index]);
                  },
                )
              : Center(
                  child: Text(
                    "No search found",
                    style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
    );
  }

  Widget widgetCard(Restaurants categories) {
    if (locationData != null && categories.lat != "" && categories.lon != "") {
      double distanceInKm = calculateDistance(
        locationData.latitude,
        locationData.longitude,
        double.parse(categories.lat),
        double.parse(categories.lon),
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
    return Container(
      height: ScreenUtil.getInstance().setHeight(590),
      child: Stack(
        children: <Widget>[
          // Material(
          //   elevation: 5.0,
          //   borderRadius: BorderRadius.circular(14.0),
          //   child: Container(
          //     height: 150.0,
          //     width: MediaQuery.of(context).size.width,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(14.0),
          //       image: DecorationImage(
          //         image: AssetImage(feed.bannerImg),
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //   ),
          // ),

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
                    height: ScreenUtil.getInstance().setHeight(550),
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
                            height: ScreenUtil.getInstance().setHeight(300),
                            child: FittedBox(
                              child: CachedNetworkImage(
                                imageUrl: categories.resImage.resImag0,
                                placeholder: (context, url) => Center(
                                  child: Container(
                                    margin: EdgeInsets.all(70.0),
                                    child: CupertinoActivityIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
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
                          Container(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 10),
                                child: Text(
                                  categories.resName,
                                  style: TextStyle(
                                      fontSize:
                                          ScreenUtil.getInstance().setSp(30),
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  softWrap: true,
                                ),
                              )),
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
                                                fontSize:
                                                    ScreenUtil.getInstance()
                                                        .setSp(25),
                                                fontWeight: FontWeight.bold,
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
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 10),
                                          child: data1 != null
                                              ? Text(
                                                  data1 + ' KM',
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil
                                                              .getInstance()
                                                          .setSp(25),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )
                                              : Text(
                                                  "",
                                                  style: TextStyle(
                                                      color: Color(0XFF106C6F),
                                                      fontSize: 10),
                                                ),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(
                          //     height: ScreenUtil.getInstance().setHeight(5)),
                          Divider(
                            color: Colors.grey.withOpacity(0.6),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Container(
                                  width: SizeConfig.blockSizeHorizontal * 30,
                                  child: RaisedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => ResDetailsNew(
                                            likeStatus: likedRestaurent
                                                    .contains(categories.resId)
                                                ? 'yes'
                                                : 'no',
                                            restID: categories.resId,
                                            restName: categories.resName,
                                            resNameU: categories.resNameU,
                                            restDesc: categories.resDesc,
                                            restDescU: categories.resDescU,
                                            resWebsite: categories.resWebsite,
                                            restImage:
                                                categories.resImage.resImag0,
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
                                          ),
                                        ),
                                      );
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(80.0)),
                                    padding: const EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: <Color>[
                                            Color(0xFF1E3C72),
                                            Color(0xFF2A5298),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(80.0)),
                                      ),
                                      child: Container(
                                        constraints: const BoxConstraints(
                                            minWidth: 88.0,
                                            minHeight:
                                                36.0), // min sizes for Material buttons
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'View info',
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(7)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
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
                                                fontWeight: FontWeight.bold,
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
                                  likedRestaurent.contains(categories.resId)
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: InkWell(
                                              onTap: () {
                                                // likeBloc.likeSink(userID, restaurants.resId).then((_) {
                                                //   favouriteBloc.favouriteSink(userID);
                                                // });
                                                Loader().showIndicator(context);
                                                UnlikeApi()
                                                    .unlikeApi(userID,
                                                        categories.resId)
                                                    .then((onValue) {
                                                  Loader()
                                                      .hideIndicator(context);

                                                  favouriteBloc
                                                      .favouriteSink(userID);
                                                  likedRestaurent = [];
                                                  FavouriteApi()
                                                      .favouriteApi(userID)
                                                      .then((favourite) {
                                                    if (favourite.status == 1) {
                                                      for (FavRestaurants data
                                                          in favourite
                                                              .restaurants) {
                                                        setState(() {
                                                          likedRestaurent
                                                              .add(data.resId);
                                                        });
                                                      }
                                                    } else {
                                                      setState(() {});
                                                    }
                                                  });
                                                });
                                              },
                                              child: Icon(LineIcons.heart)),
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: InkWell(
                                              onTap: () {
                                                // likeBloc.likeSink(userID, restaurants.resId).then((_) {
                                                //   favouriteBloc.favouriteSink(userID);
                                                // });
                                                Loader().showIndicator(context);
                                                LikeApi()
                                                    .likeApi(userID,
                                                        categories.resId)
                                                    .then((onValue) {
                                                  favouriteBloc
                                                      .favouriteSink(userID);
                                                  likedRestaurent = [];
                                                  FavouriteApi()
                                                      .favouriteApi(userID)
                                                      .then((favourite) {
                                                    for (FavRestaurants data
                                                        in favourite
                                                            .restaurants) {
                                                      setState(() {
                                                        likedRestaurent
                                                            .add(data.resId);
                                                      });
                                                    }

                                                    Loader()
                                                        .hideIndicator(context);
                                                  });
                                                });
                                              },
                                              child: Icon(LineIcons.heart_o)),
                                        ),
                                ],
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
                          borderRadius: BorderRadius.all(Radius.circular(80.0)),
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
    );
  }
}
