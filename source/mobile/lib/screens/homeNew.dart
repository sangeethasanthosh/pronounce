import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:happy_hearts_pet_care_services/block/allcate_block.dart';
import 'package:happy_hearts_pet_care_services/block/allres_block.dart';
import 'package:happy_hearts_pet_care_services/block/favourite_bloc.dart';
import 'package:happy_hearts_pet_care_services/block/sorting_block.dart';
import 'package:happy_hearts_pet_care_services/constant/global.dart';
import 'package:happy_hearts_pet_care_services/constant/sizeconfig.dart';
import 'package:happy_hearts_pet_care_services/models/allrestaurent_model.dart';
import 'package:happy_hearts_pet_care_services/models/categories_model.dart';
import 'package:happy_hearts_pet_care_services/models/favourite_restaurent_modal.dart';
import 'package:happy_hearts_pet_care_services/models/sorting_model.dart';
import 'package:happy_hearts_pet_care_services/provider/allres_api.dart';
import 'package:happy_hearts_pet_care_services/provider/favourite_api.dart';
import 'package:happy_hearts_pet_care_services/provider/like_api.dart';
import 'package:happy_hearts_pet_care_services/provider/unlike_api.dart';
import 'package:happy_hearts_pet_care_services/screens/ResDetailsNew.dart';
import 'package:happy_hearts_pet_care_services/screens/ViewRes.dart';
import 'package:happy_hearts_pet_care_services/screens/homeAllRes.dart';
import 'package:line_icons/line_icons.dart';

import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeNew extends StatefulWidget {
  @override
  _HomeNewState createState() => _HomeNewState();
}

class _HomeNewState extends State<HomeNew> {
  bool _showLoader = true;
  var data1;
  Map _pickedLocation;
  String _currentAddress;
  LocationData locationData;
  Position _currentPosition;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<Restaurants> allRestaurents = [];

  @override
  void initState() {
    _getCurrentLocation();
    sortingbloc.getResSink();
    allcate.allcateSink();
    allres.allresSink();

    super.initState();

    getCurrentLocation().then((_) async {
      await AllResApi().resApi().then((nearbyRest) {
        for (Restaurants data in nearbyRest.restaurants) {
          if (data.lat != "" && data.lon != "") {
            double distanceInKm = calculateDistance(
              locationData.latitude,
              locationData.longitude,
              double.parse(data.lat),
              double.parse(data.lon),
            );

            double distanceInMiles = distanceInKm * 0.621371;

            if (distanceInMiles <= 30.0) {
              allRestaurents.add(data);
            }
          }
        }
        _showLoader = false;

        setState(() {});
      });
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

  _getCurrentLocation() {
    geolocator.getCurrentPosition().then((Position position) {
      _currentPosition = position;
      // setState(() {
      //   _currentPosition = position;
      // });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];
      _currentAddress =
          "${place.subLocality},${place.locality},${place.country}";

      setState(() {
        _currentAddress =
            "${place.subLocality},${place.locality},${place.country}";
      });
    } catch (e) {
      print(e);
    }
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
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Container(
        //  decoration: BoxDecoration(
        //     image: DecorationImage(
        //       image: AssetImage('assets/images/back.jpg'),
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // SizedBox(
                //   height: SizeConfig.blockSizeVertical * 2,
                // ),
                _header(),
                _poster2(context),
                SizedBox(
                  height: 20,
                ),
                catContainer(),
                SizedBox(height: SizeConfig.blockSizeVertical * 5),
                _allresContainer(),
                SizedBox(height: SizeConfig.blockSizeVertical * 3),
                _nearByStore(),
                SizedBox(
                  height: 10,
                ),
                Flexible(fit: FlexFit.loose, child: _sortingStore(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      height: SizeConfig.blockSizeVertical * 14,
      width: SizeConfig.screenWidth,
      color: Color(0xFF1E3C72),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                //          Navigator.push(
                //   context,
                //   CupertinoPageRoute(
                //     builder: (context) => SignInPage(
                //     ),
                //   ),
                // );
              },
              child: Text(
                'Home',
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Container(
              // width: SizeConfig.blockSizeHorizontal * 70,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(7)),
              child: _pickedLocation != null
                  ? Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "$_pickedLocation",
                          style: TextStyle(
                              color: Color(0xFF1E3C72),
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                  : Container(
                      child: _currentAddress != null
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _currentAddress,
                                style: TextStyle(
                                    color: Color(0xFF1E3C72),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                                maxLines: 3,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Please Wait..",
                                style: TextStyle(
                                    color: Color(0xFF1E3C72), fontSize: 12),
                              ),
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  final List<String> images = [
    'https://res.cloudinary.com/urbanclap/image/upload/q_auto,f_auto,fl_progressive:steep,w_568/t_high_res_template/images/growth/home-screen/1599702942229-a35042.png',
    'https://res.cloudinary.com/urbanclap/image/upload/q_auto,f_auto,fl_progressive:steep,w_568/t_high_res_template/images/growth/home-screen/1597383629870-1f62e4.png',
    'https://res.cloudinary.com/urbanclap/image/upload/q_auto,f_auto,fl_progressive:steep,w_568/t_high_res_template/images/growth/home-screen/1597383702016-f000cd.jpeg',
  ];

  Widget _poster2(BuildContext context) {
    Widget carousel = images == null
        ? Center(
            child: SpinKitCubeGrid(
              color: Colors.white,
            ),
          )
        : Stack(
            children: <Widget>[
              Carousel(
                images: images.map((it) {
                  return ClipRRect(
                    // borderRadius: new BorderRadius.only(
                    //   bottomLeft: const Radius.circular(40.0),
                    //   bottomRight: const Radius.circular(40.0),
                    // ),
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: CachedNetworkImage(
                        imageUrl: it,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // borderRadius: new BorderRadius.only(
                            //   bottomLeft: const Radius.circular(40.0),
                            //   bottomRight: const Radius.circular(40.0),
                            // ),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Center(
                          child: Container(
                              height: 100,
                              width: 100,
                              // margin: EdgeInsets.all(70.0),
                              child: CupertinoActivityIndicator()),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
                showIndicator: true,
                dotBgColor: Colors.transparent,
                borderRadius: true,
                autoplay: false,
                dotSize: 5.0,
                dotColor: Colors.black,
                dotSpacing: 15.0,
              ),
              // _customAppbar()
            ],
          );

    return SizedBox(
        height: 200,
        width: SizeConfig.screenWidth,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: carousel,
        ));
  }

  Widget catContainer() {
    return Container(
      width: SizeConfig.screenWidth,
      child: Column(
        children: <Widget>[
          Container(
            height: SizeConfig.blockSizeVertical * 20,
            child: StreamBuilder<cateModel>(
              stream: allcate.allcateStream,
              builder: (context, AsyncSnapshot<cateModel> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CupertinoActivityIndicator());
                }
                List<Categories> allRestaurent =
                    snapshot.data.categories != null
                        ? snapshot.data.categories
                        : [];
                return allRestaurent.length > 0
                    ? ListView.builder(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        // physics: const NeverScrollableScrollPhysics(),
                        itemCount: allRestaurent.length,
                        //scrollDirection: Axis.horizontal,
                        // itemBuilder: (context, int index) => Column(
                        //   children: <Widget>[
                        //     Container(
                        //       // padding: EdgeInsets.only(top: 10),
                        //       child: Material(
                        //         color: index % 2 == 0
                        //             ? Color(0XFF062C3C)
                        //             : Color(0XFF003E4F),
                        //         child: Center(
                        //           child: widgetCatedata(allRestaurent[index]),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        itemBuilder: (context, int index) {
                          return //Text(allcategory.coursesList[index].firstName[0]);
                              widgetCatedata(allRestaurent[index]);
                        },

                        // {
                        //   return InkWell(
                        //     onTap: () {},
                        //     child:
                        //   );
                        // },
                      )
                    : Center(
                        child: Text(
                          "Don't have any restaurants now",
                          style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget widgetCatedata(Categories categories) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => ViewRes(
              id: categories.id,
              name: categories.cName,
              cNameA: categories.cNameA,
              icon: categories.icon,
            ),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            padding: const EdgeInsets.all(20.0),
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 10,
                  // offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: Center(
                child: new Image.network(
              categories.icon,
              width: SizeConfig.blockSizeHorizontal * 10,
            )),
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 2,
          ),
          Container(
              width: SizeConfig.blockSizeHorizontal * 20,
              child: Center(
                  child: Text(
                categories.cName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )))
        ],
      ),
    );
  }

  Widget _allresContainer() {
    return Container(
      child: Container(
        // height: SizeConfig.blockSizeVertical * 33,
        width: SizeConfig.screenWidth,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Find Your Perfect Store',
                    style: TextStyle(
                        fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                        fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DiscoverNew()),
                      );
                    },
                    child: Text(
                      'SEE ALL',
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 4,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3C72)),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: SizeConfig.blockSizeVertical * 22,
              width: SizeConfig.screenWidth,
              child: StreamBuilder<allResModel>(
                stream: allres.allresStream,
                builder: (context, AsyncSnapshot<allResModel> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CupertinoActivityIndicator());
                  }
                  List<Restaurants> allRestaurent =
                      snapshot.data.restaurants != null
                          ? snapshot.data.restaurants
                          : [];
                  return allRestaurent.length > 0
                      ? ListView.builder(
                          padding:
                              EdgeInsets.only(left: 0, right: 30, bottom: 10),
                          scrollDirection: Axis.horizontal,
                          // shrinkWrap: true,
                          // physics: const NeverScrollableScrollPhysics(),
                          itemCount: allRestaurent.length,
                          //scrollDirection: Axis.horizontal,
                          itemBuilder: (
                            context,
                            int index,
                          ) {
                            return widgetCard(allRestaurent[index]);
                          },
                        )
                      : Center(
                          child: Text(
                            "Don't have any restaurants now",
                            style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nearByStore() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      child: Container(
        child: Container(
          // height: SizeConfig.blockSizeVertical * 40,
          width: SizeConfig.screenWidth,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Nearby stores',
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                height: SizeConfig.blockSizeVertical * 23,
                width: SizeConfig.screenWidth,
                child: _showLoader
                    ? Container(
                        // width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height,
                        child: CupertinoActivityIndicator(),
                      )
                    : allRestaurents.length > 0
                        ? Container(
                            // color: Colors.red,
                            margin: EdgeInsets.only(
                                top: 15.0, left: 10.0, right: 10.0),
                            // height: allRestaurents.length == 1 ? 155 : 310,
                            width: MediaQuery.of(context).size.width,

                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              // physics: const NeverScrollableScrollPhysics(),
                              itemCount: allRestaurents.length,
                              itemBuilder: (context, int index) {
                                return _nearYouBuildItem(allRestaurents[index]);
                              },
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.only(top: 20.0),
                            alignment: Alignment.center,
                            height: 40,
                            // color: Colors.red,
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "There are no near by stores available from your location.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal),
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sortingStore(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Popular Store',
                style: TextStyle(
                    fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                    fontWeight: FontWeight.bold),
              ),
              // Text(
              //   'SEE ALL',
              //   style: TextStyle(
              //       fontSize: SizeConfig.blockSizeHorizontal * 4,
              //       fontWeight: FontWeight.bold,
              //       color: Color(0xFF1E3C72)),
              // ),
            ],
          ),
        ),
        StreamBuilder<SortingModel>(
          stream: sortingbloc.sortingStream,
          builder: (context, AsyncSnapshot<SortingModel> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
            List<RestaurantsSort> res = snapshot.data.restaurants != null
                ? snapshot.data.restaurants
                : [];
            return res.length > 0
                ? ListView.builder(
                    padding: EdgeInsets.only(bottom: 10, top: 30),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: res.length,
                    //scrollDirection: Axis.horizontal,
                    itemBuilder: (
                      context,
                      int index,
                    ) {
                      return sortingCard(context, res[index]);
                    },
                  )
                : Center(
                    child: Text(
                      "Don't have any restaurants now",
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  );
          },
        ),
      ],
    );
  }

  Widget _nearYouBuildItem(Restaurants categories) {
    return InkWell(
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
        width: 200,
        margin: EdgeInsets.only(left: 25, right: 0, top: 0, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 15,
                offset: Offset(0, 5)),
          ],
        ),
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Image of the card

                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: CachedNetworkImage(
                    height: 100,
                    fit: BoxFit.cover,
                    imageUrl: categories.resImage.resImag0,
                    placeholder: (context, url) => CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(categories.resName,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 3)),
                            // Text(
                            //   'asdasdsaaaaaaa',
                            //   overflow: TextOverflow.fade,
                            //   softWrap: false,
                            //   style: Theme.of(context).textTheme.caption,
                            // ),
                            SizedBox(height: 5),
                            // Row(
                            //   children: Helper.getStarsList(double.parse(restaurant.rate)),
                            // ),
                          ],
                        ),
                      ),
                      // SizedBox(width: 15),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(7)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 2.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
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
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.blockSizeHorizontal * 2.5),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
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

    return InkWell(
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
        width: 200,
        margin: EdgeInsets.only(left: 25, right: 0, top: 10, bottom: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.1),
                blurRadius: 15,
                offset: Offset(0, 5)),
          ],
        ),
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Image of the card

                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: CachedNetworkImage(
                    height: 100,
                    fit: BoxFit.cover,
                    imageUrl: categories.resImage.resImag0,
                    placeholder: (context, url) => CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(categories.resName,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 3)),
                            // Text(
                            //   'asdasdsaaaaaaa',
                            //   overflow: TextOverflow.fade,
                            //   softWrap: false,
                            //   style: Theme.of(context).textTheme.caption,
                            // ),
                            SizedBox(height: 5),
                            // Row(
                            //   children: Helper.getStarsList(double.parse(restaurant.rate)),
                            // ),
                          ],
                        ),
                      ),
                      // SizedBox(width: 15),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(7)),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 2.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
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
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.blockSizeHorizontal * 2.5),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget sortingCard(BuildContext context, RestaurantsSort categories) {
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
                                        width: 200,
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
                                            restRatings:
                                                categories.resRatings.length > 0
                                                    ? categories.resRatings
                                                    : "0",
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
                                                      setState(() {
                                                        _sortingStore(context);
                                                      });
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
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.blockSizeHorizontal * 2.5),
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
