import 'dart:math';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:happy_hearts_pet_care_services/block/favourite_bloc.dart';
import 'package:happy_hearts_pet_care_services/block/getRes_bloc.dart';
import 'package:happy_hearts_pet_care_services/block/getvipResCate_block.dart';

import 'package:happy_hearts_pet_care_services/block/nearByStore_block.dart';
import 'package:happy_hearts_pet_care_services/constant/global.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:happy_hearts_pet_care_services/constant/sizeconfig.dart';

import 'package:happy_hearts_pet_care_services/models/favourite_restaurent_modal.dart';
import 'package:happy_hearts_pet_care_services/models/getvipresCate_model.dart';
import 'package:happy_hearts_pet_care_services/models/nearByStore.dart';
import 'package:happy_hearts_pet_care_services/provider/favourite_api.dart';
import 'package:happy_hearts_pet_care_services/provider/like_api.dart';

import 'package:happy_hearts_pet_care_services/provider/unlike_api.dart';
import 'package:happy_hearts_pet_care_services/screens/ResDetailsNew.dart';

import 'package:line_icons/line_icons.dart';
import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ViewRes extends StatefulWidget {
  String id;
  String name;
  String cNameA;
  String icon;
  ViewRes({this.id, this.name, this.cNameA, this.icon});

  @override
  _ViewResState createState() => _ViewResState();
}

class _ViewResState extends State<ViewRes> {
  Position currentLocation;
  var data1;

  var data2;

  List<RestaurantsN> allRestaurents = [];
  // ignore: unused_field
  bool _showLoader = true;
  ProgressDialog pr;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  LocationData locationData;
  @override
  void initState() {
    getVipCatebloc.getVipResCateSink(widget.id);
    // allcate.allcateSink();
    super.initState();
    allres.allresSink(widget.id);

    getCurrentLocation().then((_) async {
      setState(() {});
    });

    // getUserCurrentLocation().then((_) async {
    //   // nearbyBloc.nearbySink();

    //   await GetResApi().getResApi(widget.id).then((nearbyRest) {
    //     for (Restaurants1 data in nearbyRest.restaurants) {
    //       if (data.lat != "" && data.lon != "") {
    //         double distanceInKm = calculateDistance(
    //           currentLocation.latitude,
    //           currentLocation.longitude,
    //           double.parse(data.lat),
    //           double.parse(data.lon),
    //         );
    //         print(double.parse(distanceInKm.toStringAsFixed(2)));

    //         data2 = distanceInKm.toStringAsFixed(0);
    //       }
    //     }

    //     setState(() {});
    //   });
    // });
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

  // Future getUserCurrentLocation() async {
  //   await Geolocator().getCurrentPosition().then((position) {
  //     setState(() {
  //       currentLocation = position;
  //     });
  //   });
  // }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);

    getResbloc.getResSink(widget.id);
    return Container(
      color: Colors.white,
      // decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //         begin: Alignment.topLeft,
      //         end: Alignment.bottomRight,
      //         colors: <Color>[
      //       Color(0xFF26A2C6),
      //       Color(0xFF24CAB9),
      //     ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // appBar: AppBar(
        //   backgroundColor: Color(0XFF20B7BE),
        //   // title: Text("Hello Appbar"),
        //   leading: GestureDetector(
        //     onTap: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => FullScreenDrawer()),
        //       );
        //     },
        //     child: Container(
        //         height: 100,
        //         width: 100,
        //         child: Image.asset(
        //           'assets/images/menuicon.png',
        //         )),
        //   ),
        //   actions: <Widget>[
        //     Padding(
        //         padding: EdgeInsets.only(right: 20.0),
        //         child: GestureDetector(
        //           onTap: () {
        //             Navigator.pop(context);
        //           },
        //           child: Icon(
        //             Icons.arrow_back,
        //             color: Colors.white,
        //           ),
        //         )),
        //   ],
        // ),
        appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            flexibleSpace: Container(),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.name),
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
            // leading: GestureDetector(
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => FullScreenDrawer()),
            //     );
            //   },
            //   child: Container(
            //       height: 100,
            //       width: 100,
            //       child: Image.asset(
            //         'assets/images/menuicon.png',
            //       )),
            // ),

            ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 15, bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              "Featured Stores",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 7),
              _cardwidget1(context),
              SizedBox(
                height: 20,
              ),
              // newSerchField(),
              // SearchTextfield(),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 0, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'All Stores',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   height: 15,
              // ),
              Flexible(fit: FlexFit.loose, child: _caterestlist(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget newSerchField() {
    return Padding(
      padding: const EdgeInsets.only(left: 22, right: 22, top: 15, bottom: 20),
      child: Container(
        height: SizeConfig.blockSizeVertical * 7,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(15.0),
          ),
          onPressed: () {
            // Navigator.push(
            //   context,
            //   CupertinoPageRoute(
            //     builder: (context) => SearchRestaurent(),
            //   ),
            // );
          },
          color: Colors.white,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 0, top: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Search Here',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF003F4F),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.search,
                  color: Color(0XFF003F4F),
                  size: 35,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardwidget1(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        child: Container(
          child: SizedBox(
            height: SizeConfig.blockSizeVertical * 22,
            child: StreamBuilder<VipResCateModel>(
              stream: getVipCatebloc.getVipResStream,
              builder: (context, AsyncSnapshot<VipResCateModel> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: AwesomeLoader(
                      color: appColorWhite,
                      loaderType: 4,
                    ),
                  );
                }
                List<Restaurants> allcategory =
                    snapshot.data.restaurants != null
                        ? snapshot.data.restaurants
                        : [];
                return allcategory.length > 0
                    ? ListView.builder(
                        padding: EdgeInsets.only(left: 0, right: 0, bottom: 10),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,

                        itemCount: allcategory.length,
                        //scrollDirection: Axis.horizontal,
                        itemBuilder: (context, int index) {
                          return InkWell(
                            onTap: () {},
                            child: widgetCard(allcategory[index]),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          "No item in this category ",
                          style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      );
              },
            ),
          ),
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
    return GestureDetector(
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

  Widget _caterestlist(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Container(
          width: SizeConfig.screenWidth,
          child: StreamBuilder<NearByStores>(
            stream: allres.allresStream,
            builder: (context, AsyncSnapshot<NearByStores> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: AwesomeLoader(
                    color: Colors.black,
                    loaderType: 4,
                  ),
                );
              }
              List<RestaurantsN> allRestaurent =
                  snapshot.data.restaurants != null
                      ? snapshot.data.restaurants
                      : [];
              return allRestaurent.length > 0
                  ? ListView.builder(
                      padding: EdgeInsets.only(bottom: 0, top: 30),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: allRestaurent.length,
                      //scrollDirection: Axis.horizontal,
                      itemBuilder: (
                        context,
                        int index,
                      ) {
                        return _nearYouBuildItem(allRestaurent[index]);
                      },
                    )
                  : Center(
                      child: Text(
                        "No Item in this Category",
                        style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
            },
          ),
        ));
  }

  Widget _nearYouBuildItem(RestaurantsN categories) {
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
                                Container(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 10),
                                      child: Text(
                                        categories.resName,
                                        style: TextStyle(
                                            fontSize: ScreenUtil.getInstance()
                                                .setSp(30),
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
                                              width: SizeConfig
                                                      .blockSizeHorizontal *
                                                  40,
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
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )
                                                    : Text(
                                                        "",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0XFF106C6F),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Container(
                                        width:
                                            SizeConfig.blockSizeHorizontal * 30,
                                        child: RaisedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    ResDetailsNew(
                                                  likeStatus:
                                                      likedRestaurent.contains(
                                                              categories.resId)
                                                          ? 'yes'
                                                          : 'no',
                                                  restID: categories.resId,
                                                  restName: categories.resName,
                                                  resNameU: categories.resNameU,
                                                  restDesc: categories.resDesc,
                                                  restDescU:
                                                      categories.resDescU,
                                                  resWebsite:
                                                      categories.resWebsite,
                                                  restImage: categories
                                                      .resImage.resImag0,
                                                  resPhone: categories.resPhone,
                                                  resAddress:
                                                      categories.resAddress,
                                                  restRatings:
                                                      categories.resRatings,
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
                                                style: TextStyle(
                                                    color: Colors.white),
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
                                              borderRadius:
                                                  BorderRadius.circular(7)),
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
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: InkWell(
                                                    onTap: () {
                                                      // likeBloc.likeSink(userID, restaurants.resId).then((_) {
                                                      //   favouriteBloc.favouriteSink(userID);
                                                      // });
                                                      Loader().showIndicator(
                                                          context);
                                                      UnlikeApi()
                                                          .unlikeApi(userID,
                                                              categories.resId)
                                                          .then((onValue) {
                                                        Loader().hideIndicator(
                                                            context);

                                                        favouriteBloc
                                                            .favouriteSink(
                                                                userID);
                                                        likedRestaurent = [];
                                                        FavouriteApi()
                                                            .favouriteApi(
                                                                userID)
                                                            .then((favourite) {
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
                                                    child:
                                                        Icon(LineIcons.heart)),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: InkWell(
                                                    onTap: () {
                                                      // likeBloc.likeSink(userID, restaurants.resId).then((_) {
                                                      //   favouriteBloc.favouriteSink(userID);
                                                      // });
                                                      Loader().showIndicator(
                                                          context);
                                                      LikeApi()
                                                          .likeApi(userID,
                                                              categories.resId)
                                                          .then((onValue) {
                                                        favouriteBloc
                                                            .favouriteSink(
                                                                userID);
                                                        likedRestaurent = [];
                                                        FavouriteApi()
                                                            .favouriteApi(
                                                                userID)
                                                            .then((favourite) {
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
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 2.5),
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
        ),
      ],
    );
  }
}
