import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:happy_hearts_pet_care_services/block/allres_block.dart';
import 'package:happy_hearts_pet_care_services/block/favourite_bloc.dart';
import 'package:happy_hearts_pet_care_services/constant/global.dart';
import 'package:happy_hearts_pet_care_services/constant/sizeconfig.dart';
import 'package:happy_hearts_pet_care_services/images/images.dart';
import 'package:happy_hearts_pet_care_services/models/allrestaurent_model.dart';
import 'package:happy_hearts_pet_care_services/models/favourite_restaurent_modal.dart';
import 'package:happy_hearts_pet_care_services/provider/allres_api.dart';
import 'package:happy_hearts_pet_care_services/provider/favourite_api.dart';
import 'package:happy_hearts_pet_care_services/provider/like_api.dart';
import 'package:happy_hearts_pet_care_services/provider/unlike_api.dart';
import 'package:happy_hearts_pet_care_services/screens/ResDetailsNew.dart';
import 'package:happy_hearts_pet_care_services/screens/filter/filterOption.dart';
import 'package:line_icons/line_icons.dart';
import 'package:location/location.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class DiscoverNew extends StatefulWidget {
  @override
  _DiscoverNewState createState() => _DiscoverNewState();
}

class _DiscoverNewState extends State<DiscoverNew> {
  String _mapStyle;
  // ignore: unused_field
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  Set<Marker> _markers = {};
  Position currentLocation;
  // ignore: unused_field
  bool _showLoader = true;
  ItemScrollController _scrollController = ItemScrollController();

  var data1;
  bool explorScreen = true;
  bool mapScreen = false;

  @override
  void initState() {
    allres.allresSink();

    super.initState();

    getCurrentLocation().then((_) async {
      setState(() {});
    });
    rootBundle.loadString('assets/mapStyle/map_style.txt').then((string) {
      _mapStyle = string;
    });

    getResFirst();
  }

  getResFirst() {
    getUserCurrentLocation().then((_) async {
      favoriteRestaurents();
      await AllResApi().resApi().then((nearbyRest) async {
        for (Restaurants data in nearbyRest.restaurants) {
          for (int i = 0; i < nearbyRest.restaurants.length; i++) {
            print(
                ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

            print(nearbyRest.restaurants.length);

            nar(data, nearbyRest, [i]);
          }
        }
        _showLoader = false;
      });
    });
  }

  Future getUserCurrentLocation() async {
    await Geolocator().getCurrentPosition().then((position) {
      setState(() {
        currentLocation = position;
      });
    });
  }

  Future favoriteRestaurents() async {
    likedRestaurent = [];
    FavouriteApi().favouriteApi(userID).then((favourite) {
      for (FavRestaurants data in favourite.restaurants) {
        setState(() {
          likedRestaurent.add(data.resId);
        });
      }
    });
  }

  void nar(data, nearbyRest, res) async {
    if (data.lat != "" && data.lon != "") {
      var markerIdVal = generateIds();
      final MarkerId markerId = MarkerId(markerIdVal.toString());
      final Uint8List markerIcon = await getBytesFromAsset(Images.mappin, 90);
      final Marker marker = Marker(
        icon: BitmapDescriptor.fromBytes(markerIcon),
        markerId: markerId,
        position: LatLng(
          double.parse(data.lat),
          double.parse(data.lon),
        ),
        infoWindow: InfoWindow(
          title: data.resName,
        ),
        onTap: () {
          print(res[0]);
          _scrollController.scrollTo(
              index: res[0], duration: Duration(seconds: 3));
          // setState(() {
          //   _allresContainer();
          // });

          // _restaurentDetailsBottomsheet(context, data);
        },
      );

      setState(() {
        _markers.add(marker);
      });
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  int generateIds() {
    var rng = new Random();
    var randomInt;
    randomInt = rng.nextInt(100);
    return randomInt;
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
    allres.allresSink();
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
                          explorScreen == true
                              ? _listdatawidget(context)
                              : mapScreen == true
                                  ?
                                  //                   _showLoader ? Center(child: CupertinoActivityIndicator())
                                  // :
                                  Expanded(
                                      child: Stack(
                                        children: <Widget>[
                                          GoogleMap(
                                            markers: _markers,
                                            mapType: MapType.normal,
                                            myLocationButtonEnabled: true,
                                            myLocationEnabled: true,
                                            mapToolbarEnabled: false,
                                            initialCameraPosition:
                                                CameraPosition(
                                              target: LatLng(
                                                currentLocation.latitude,
                                                currentLocation.longitude,
                                              ),
                                              zoom: 10,
                                            ),
                                            onMapCreated: (GoogleMapController
                                                controller) {
                                              controller.setMapStyle(_mapStyle);
                                              _controller.complete(controller);
                                            },
                                          ),
                                          _allresContainer()
                                        ],
                                      ),
                                    )
                                  : Container()
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
      height: SizeConfig.blockSizeVertical * 15,
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
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        height: SizeConfig.blockSizeVertical * 5,

                        // width: SizeConfig.blockSizeHorizontal * 25,
                        child: mapScreen == false
                            ? RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    explorScreen = false;
                                    mapScreen = true;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      bottomLeft: Radius.circular(40)),
                                ),
                                padding: const EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: <Color>[
                                          Color(0xFF1E3C72),
                                          Color(0xFF2A5298),
                                        ]),
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(40),
                                        bottomLeft: Radius.circular(40)),
                                  ),
                                  child: Container(
                                    constraints: const BoxConstraints(
                                        minWidth: 88.0,
                                        minHeight:
                                            36.0), // min sizes for Material buttons
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'assets/images/location1.png',
                                      color: Colors.white,
                                      width: SizeConfig.blockSizeHorizontal * 5,
                                    ),
                                  ),
                                ),
                              )
                            : RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    explorScreen = false;
                                    mapScreen = true;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      bottomLeft: Radius.circular(40)),
                                ),
                                padding: const EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(40),
                                        bottomLeft: Radius.circular(40)),
                                  ),
                                  child: Container(
                                    constraints: const BoxConstraints(
                                        minWidth: 88.0,
                                        minHeight:
                                            36.0), // min sizes for Material buttons
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'assets/images/location1.png',
                                      width: SizeConfig.blockSizeHorizontal * 5,
                                    ),
                                  ),
                                ),
                              )),
                    Container(
                        height: SizeConfig.blockSizeVertical * 5,

                        // width: SizeConfig.blockSizeHorizontal * 25,
                        child: explorScreen == false
                            ? RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    explorScreen = true;
                                    mapScreen = false;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(40),
                                        bottomRight: Radius.circular(40))),
                                padding: const EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: <Color>[
                                          Color(0xFF1E3C72),
                                          Color(0xFF2A5298),
                                        ]),
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(40),
                                        bottomRight: Radius.circular(40)),
                                  ),
                                  child: Container(
                                    constraints: const BoxConstraints(
                                        minWidth: 88.0,
                                        minHeight:
                                            36.0), // min sizes for Material buttons
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'assets/images/list.png',
                                      color: Colors.black,
                                      width: SizeConfig.blockSizeHorizontal * 5,
                                    ),
                                  ),
                                ),
                              )
                            : RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    explorScreen = true;
                                    mapScreen = false;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(40),
                                      bottomRight: Radius.circular(40)),
                                ),
                                padding: const EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                      //  border: Border.all(color: Colors.white),
                                      // gradient: LinearGradient(
                                      //     begin: Alignment.topLeft,
                                      //     end: Alignment.bottomRight,
                                      //     colors: <Color>[
                                      //       Color(0xFF1E3C72),
                                      //       Color(0xFF2A5298),
                                      //     ]),

                                      ),
                                  child: Container(
                                    constraints: const BoxConstraints(
                                        minWidth: 88.0,
                                        minHeight:
                                            36.0), // min sizes for Material buttons
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      'assets/images/list.png',
                                      color: Colors.blue[900],
                                      width: SizeConfig.blockSizeHorizontal * 5,
                                    ),
                                  ),
                                ),
                              )),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: const EdgeInsets.only(right: 20, top: 20),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SelectFilter()),
                      );
                    },
                    child: Image.asset(
                      'assets/images/filter.png',
                      width: SizeConfig.blockSizeHorizontal * 6,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _listdatawidget(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      child: StreamBuilder<allResModel>(
        stream: allres.allresStream,
        builder: (context, AsyncSnapshot<allResModel> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CupertinoActivityIndicator());
          }
          List<Restaurants> allRestaurent = snapshot.data.restaurants != null
              ? snapshot.data.restaurants
              : [];
          return allRestaurent.length > 0
              ? ListView.builder(
                  padding: EdgeInsets.only(bottom: 200, top: 30),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
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
                                        width:
                                            SizeConfig.blockSizeHorizontal * 10,
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

  Widget _allresContainer() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: SizeConfig.blockSizeVertical * 30,
        width: SizeConfig.screenWidth,
        child: Column(
          children: <Widget>[
            Container(
              height: SizeConfig.blockSizeVertical * 20,
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
                      ? ScrollablePositionedList.builder(
                          itemScrollController: _scrollController,
                          padding: EdgeInsets.only(left: 0, right: 30),
                          scrollDirection: Axis.horizontal,
                          // shrinkWrap: true,
                          // physics: const NeverScrollableScrollPhysics(),
                          itemCount: allRestaurent.length,
                          //scrollDirection: Axis.horizontal,
                          itemBuilder: (
                            context,
                            int index,
                          ) {
                            return widgetCard1(allRestaurent[index]);
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

  Widget widgetCard1(Restaurants categories) {
    allres.allresSink();
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
        margin: EdgeInsets.only(left: 25, right: 0, top: 0, bottom: 0),
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
                            Text(categories.resAddress,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 2.5,
                                    color: Colors.grey)),
                            // Row(
                            //   children: Helper.getStarsList(double.parse(restaurant.rate)),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, top: 10),
                  child: Container(
                    width: 50,
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
                                fontSize: SizeConfig.blockSizeHorizontal * 2.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
