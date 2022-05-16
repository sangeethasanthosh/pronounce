import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:happy_hearts_pet_care_services/block/favourite_bloc.dart';
import 'package:happy_hearts_pet_care_services/block/get_rest_review.dart';
import 'package:happy_hearts_pet_care_services/block/like_bloc.dart';
import 'package:happy_hearts_pet_care_services/constant/global.dart';
import 'package:happy_hearts_pet_care_services/constant/sizeconfig.dart';
import 'package:happy_hearts_pet_care_services/models/favourite_restaurent_modal.dart';
import 'package:happy_hearts_pet_care_services/models/get_review.dart';
import 'package:happy_hearts_pet_care_services/provider/favourite_api.dart';
import 'package:happy_hearts_pet_care_services/provider/like_api.dart';
import 'package:happy_hearts_pet_care_services/provider/unlike_api.dart';
import 'package:happy_hearts_pet_care_services/screens/login.dart';
import 'package:happy_hearts_pet_care_services/screens/ratingscreen.dart';
import 'package:happy_hearts_pet_care_services/share_preference/preferencesKey.dart';
import 'package:happy_hearts_pet_care_services/webview/web_view_container.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class ResDetailsNew extends StatefulWidget {
  final String restID;
  final String restName;
  final String resNameU;
  final String restDesc;
  final String restDescU;
  final String resWebsite;
  final String restImage;
  final String resPhone;
  final String resAddress;
  final String restRatings;
  final String mfo;
  final List images;
  // final String mfc;
  // final String sso;
  // final String ssc;

  final String lat;
  final String lon;
  final int count;
  final String resVideo;
  final String resUrl;
  String likeStatus;

  ResDetailsNew({
    this.restID,
    this.restName,
    this.resNameU,
    this.restDesc,
    this.restDescU,
    this.resWebsite,
    this.restImage,
    this.resPhone,
    this.resAddress,
    this.restRatings,
    this.mfo,
    this.images,
    // this.mfc,
    // this.sso,
    // this.ssc,
    this.lat,
    this.lon,
    this.count,
    this.resVideo,
    this.resUrl,
    this.likeStatus,
  });
  @override
  _ResDetailsNewState createState() => _ResDetailsNewState(
        restID: restID,
        restName: restName,
        resNameU: resNameU,
        restDesc: restDesc,
        restDescU: restDescU,
        resWebsite: resWebsite,
        restImage: restImage,
        resPhone: resPhone,
        resAddress: resAddress,
        restRatings: restRatings,
        mfo: mfo,
        images: images,
        // mfc: mfc,
        // sso: sso,
        // ssc: ssc,
        lat: lat,
        lon: lon,
        count: count,
        likeStatus: likeStatus,
        resVideo: resVideo,
        resUrl: resUrl,
      );
}

class _ResDetailsNewState extends State<ResDetailsNew> {
  String data;
  Position currentLocation;
  // ignore: unused_field
  int _current = 0;
  final String restID;
  final String restName;
  final String resNameU;
  final String restDesc;
  final String restDescU;
  final String resWebsite;
  final String restImage;
  final String resPhone;
  final String resAddress;
  final String restRatings;
  final String mfo;
  final List images;
  // final String mfc;
  // final String sso;
  // final String ssc;
  final String lat;
  final String lon;
  final int count;
  final String resVideo;
  final String resUrl;

  String likeStatus;

  _ResDetailsNewState({
    this.restID,
    this.restName,
    this.resNameU,
    this.restDesc,
    this.restDescU,
    this.resWebsite,
    this.restImage,
    this.resPhone,
    this.resAddress,
    this.restRatings,
    this.mfo,
    this.images,
    // this.mfc,
    // this.sso,
    // this.ssc,
    this.lat,
    this.lon,
    this.count,
    this.resVideo,
    this.resUrl,
    this.likeStatus,
  });

  // ignore: unused_field
  final _reviewController = TextEditingController();
  void initState() {
    getSavedInfo();
    print(userID);
    print('videolinkStatus: ' + resVideo);
    getUserDataFromPrefs();
    // RestReviewApi().restReviewApi(restID);
    super.initState();

    getUserCurrentLocation().then((_) async {
      double distanceInKm = calculateDistance(
        currentLocation.latitude,
        currentLocation.longitude,
        double.parse(lat),
        double.parse(lon),
      );
      // print(distanceInKm);
      print(double.parse(distanceInKm.toStringAsFixed(2)));

      data = distanceInKm.toStringAsFixed(0);
    });
  }

  getUserDataFromPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userDataStr =
        preferences.getString(SharedPreferencesKey.LOGGED_IN_USERRDATA);
    // Map<String, dynamic> userData = json.decode(userDataStr);
    print(userDataStr);

    setState(() {
      user = (userDataStr);
    });
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

  var dataReview;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  GetRestReview user1;

  Future<GetRestReview> getSavedInfo() async {
    getRestRreviewBloc.favouriteSink(restID).then((value) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      if (preferences.containsKey("review")) {
        Map userMap = jsonDecode(preferences.getString("review"));
        user1 = GetRestReview.fromJson(userMap);
        setState(() {
          dataReviewWidget();
        });
      }
    });

    return user1;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Container(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: DefaultTabController(
              length: 3,
              initialIndex: 0,
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          width: SizeConfig.screenWidth,
                          decoration: new BoxDecoration(
                            color: Colors.grey[100],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _poster2(context),
                              _nameAndLike(),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: TabBar(
                                  labelColor: Colors.black,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  isScrollable: true,
                                  labelStyle: TextStyle(
                                      fontSize: 15.0, fontFamily: 'Montserrat'),
                                  indicator: UnderlineTabIndicator(
                                    borderSide: BorderSide(
                                        color: Color(0xFF1E3C72), width: 3.0),
                                    // insets:
                                    //     EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 40.0),
                                  ),
                                  tabs: <Widget>[
                                    Tab(
                                      text: 'About',
                                    ),
                                    Tab(
                                      text: 'Reviews',
                                    ),
                                    Tab(
                                      text: 'Opening Hours',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Container(
                                color: Colors.white,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        restDesc,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.blockSizeHorizontal *
                                                    3.5),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            dataReviewWidget(),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    color: Colors.white,
                                    height: MediaQuery.of(context).size.height,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text(
                                        mfo,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Column(
                            //   children: <Widget>[
                            //     Expanded(
                            //       child: Container(
                            //         color: Colors.white,
                            //         height: MediaQuery.of(context).size.height,
                            //         child: videoList(),
                            //       ),
                            //     ),
                            //   ],
                            // )
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: _customAppbar(),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: CupertinoButton(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => RateRiview(
                                likeStatus:
                                    likedRestaurent.contains(widget.restID)
                                        ? 'yes'
                                        : 'no',
                                restID: widget.restID,
                                restName: widget.restName,
                                restDesc: widget.restDesc,
                                resNameU: widget.resNameU,
                                resWebsite: widget.resWebsite,
                                restImage: widget.restImage,
                                resPhone: widget.resPhone,
                                resAddress: widget.resAddress,
                                restRatings: widget.restRatings,
                                count: widget.count,
                                images: widget.images,
                              ),
                            ),
                          )
                        },
                        color: Color(0xFF1E3C72),
                        borderRadius: new BorderRadius.circular(30.0),
                        child: new Text(
                          "Submit Review",
                          textAlign: TextAlign.center,
                          style: new TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            floatingActionButton: new FloatingActionButton(
                elevation: 0.0,
                child: new Icon(Icons.video_library),
                backgroundColor: new Color(0xFF1E3C72),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewContainer(resUrl != ""
                          ? resUrl.toString()
                          : resVideo.toString()),
                    ),
                  );
                })),
      ),
    );
  }

  Widget dataReviewWidget() {
    return user1 != null
        ? Column(
            children: <Widget>[
              Expanded(
                child: Container(
                    color: Colors.white,
                    width: SizeConfig.screenWidth,
                    height: MediaQuery.of(context).size.height,
                    child: user1.review.length > 0
                        ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: user1.review.length,
                            //scrollDirection: Axis.horizontal,
                            itemBuilder: (context, int index) {
                              return Column(
                                children: <Widget>[
                                  widgetCard(user1.review[index]),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 80, bottom: 20),
                                    child: Divider(
                                      thickness: 1,
                                    ),
                                  )
                                ],
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              "No Review Found",
                              style: TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )),
              ),
            ],
          )
        : Container();
  }

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
                      child: CachedNetworkImage(
                        imageUrl: it,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
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
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  appColorGreen),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
                showIndicator: true,
                dotBgColor: Colors.transparent,
                borderRadius: false,
                autoplay: false,
                dotSize: 5.0,
                dotSpacing: 15.0,
              ),
              // _customAppbar()
            ],
          );

    return SizedBox(
        height: 200, width: SizeConfig.screenWidth, child: carousel);
  }

  Widget _nameAndLike() {
    String mob = resPhone;
    return Container(
      color: Colors.grey[100],
      height: SizeConfig.blockSizeVertical * 35,
      width: SizeConfig.screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: SizeConfig.blockSizeHorizontal * 70,
                    child: Text(
                      restName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.blockSizeHorizontal * 4),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: InkWell(
                    onTap: () {
                      likeBloc.likeSink(userID, restID);
                    },
                    child: likeStatus == 'no'
                        ? InkWell(
                            onTap: () {
                              Loader().showIndicator(context);
                              LikeApi().likeApi(userID, restID).then((onValue) {
                                favouriteBloc.favouriteSink(userID);
                                likedRestaurent = [];
                                FavouriteApi()
                                    .favouriteApi(userID)
                                    .then((favourite) {
                                  for (FavRestaurants data
                                      in favourite.restaurants) {
                                    setState(() {
                                      likedRestaurent.add(data.resId);
                                    });
                                  }
                                  likeStatus = 'yes';
                                  setState(() {});
                                  Loader().hideIndicator(context);
                                });
                              });
                            },
                            child: Icon(LineIcons.heart_o))
                        : InkWell(
                            onTap: () {
                              Loader().showIndicator(context);
                              UnlikeApi()
                                  .unlikeApi(userID, restID)
                                  .then((onValue) {
                                favouriteBloc.favouriteSink(userID);
                                likedRestaurent = [];
                                FavouriteApi()
                                    .favouriteApi(userID)
                                    .then((favourite) {
                                  if (favourite.status == 1) {
                                    for (FavRestaurants data
                                        in favourite.restaurants) {
                                      setState(() {
                                        likedRestaurent.add(data.resId);
                                      });
                                    }
                                  } else {
                                    setState(() {});
                                  }
                                  likeStatus = 'no';
                                  setState(() {});
                                  Loader().hideIndicator(context);
                                });
                              });
                            },
                            child: Icon(LineIcons.heart)),
                  ),
                )
              ],
            ),
          ),
          yelloCardForReview(context),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Color(0xFF1E3C72),
                ),
                SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 1,
                ),
                Text(
                  resAddress,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.blockSizeHorizontal * 4),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              MapsLauncher.launchCoordinates(
                  double.parse(lat), double.parse(lon), 'Location');
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: SizeConfig.blockSizeHorizontal * 7,
                  ),
                  data != null
                      ? Flexible(
                          child: Text(
                            'About ' + data + ' km for you',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: SizeConfig.safeBlockHorizontal * 4,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : Center(
                          child: SpinKitRipple(
                            color: Colors.grey,
                          ),
                        ),
                ],
              ),
            ),
          ),
          Divider(),
          Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 20, right: 0, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () => launch('tel:$mob'),
                    child: Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: Color(0xFF1E3C72),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: SizeConfig.safeBlockHorizontal * 30,
                          child: Text(
                            resPhone,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.blockSizeHorizontal * 4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding:
                const EdgeInsets.only(top: 0, left: 20, right: 0, bottom: 0),
            child: Center(
              child: Row(
                children: [
                  Icon(
                    Icons.public,
                    color: Color(0xFF1E3C72),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: SizeConfig.safeBlockHorizontal * 35,
                    child: Linkify(
                      onOpen: _onOpen,
                      text: resWebsite,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.blockSizeHorizontal * 4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }

  Widget yelloCardForReview(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 15, right: 10),
      child: InkWell(
        onTap: () {},
        child: Container(
          height: SizeConfig.safeBlockVertical * 5,
          // margin: EdgeInsets.only(top: 20.0),
          width: MediaQuery.of(context).size.width,

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      RatingBar(
                        initialRating:
                            restRatings != '' ? double.parse(restRatings) : 0.0,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 18,
                        ignoreGestures: true,
                        unratedColor: Colors.grey,
                        itemBuilder: (context, _) =>
                            Icon(Icons.star, color: Color(0xFF1E3C72)),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: Container(
                          width: SizeConfig.blockSizeHorizontal * 15,
                          child: Text(
                            restRatings.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      // Text("(45)")
                    ],
                  ),
                ),
                // Expanded(
                //   child: Padding(
                //     padding: const EdgeInsets.only(),
                //     child: InkWell(
                //       onTap: () {
                //         MapsLauncher.launchCoordinates(
                //             double.parse(lat), double.parse(lon), 'Location');
                //       },
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.end,
                //         children: <Widget>[
                //           Icon(
                //             Icons.location_on,
                //             size: 20,
                //             color: Color(0xFF1E3C72),
                //           ),
                //           SizedBox(width: 7),
                //           data != null
                //               ? Flexible(
                //                   child: Text(
                //                     data + ' KM',
                //                     style: TextStyle(
                //                       color: Colors.grey,
                //                       fontSize:
                //                           SizeConfig.safeBlockHorizontal * 4,
                //                     ),
                //                     overflow: TextOverflow.ellipsis,
                //                   ),
                //                 )
                //               : Center(
                //                   child: SpinKitRipple(
                //                     color: Colors.grey,
                //                   ),
                //                 ),
                //         ],
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navigationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  Widget widgetCard(RestReview review) {
    dataReview = review.revText;

    return Container(
      // margin: EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: review.revUserData != null
                        ? Image.network(
                            review.revUserData.profilePic,
                            height: 70.0,
                            width: 70.0,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/unknown.png',
                            height: 50.0,
                            width: 50.0,
                            fit: BoxFit.cover,
                          )),
                Container(width: 10.0),
                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Container(height: 10.0),
                      Text(
                        review.revUser,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: SizeConfig.blockSizeHorizontal * 4),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeHorizontal * 1,
                      ),
                      Text(
                        DateFormat('dd MMM yyyy,').format(
                            DateTime.fromMillisecondsSinceEpoch(int.parse(
                          review.revDate,
                        ))),
                        style: TextStyle(
                          color: Color(0xFF1E3C72),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeHorizontal * 3,
                      ),
                      RatingBar(
                        initialRating: review.revStars != 'none'
                            ? double.parse(review.revStars)
                            : 0.0,
                        minRating: 0,
                        direction: Axis.horizontal,
                        // allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 15,
                        ignoreGestures: true,
                        unratedColor: Colors.grey,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Color(0xFF1E3C72),
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeHorizontal * 2,
                      ),
                      Text(
                        review.revText,
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                        // maxLines: 2,
                        overflow: TextOverflow.clip,
                      ),
                      // Text(
                      //   dateformate,
                      //   style: TextStyle(fontSize: 12),
                      // ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget videoList() {
    return resVideo.length > 0
        ? InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewContainer(resVideo.toString()),
                ),
              );
            },
            child: Stack(
              alignment: Alignment.topRight,
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.orange)),
                          child: CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(restImage),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: new Icon(
                    Icons.play_arrow,
                    size: 30.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        : Container();
  }

  Widget _customAppbar() {
    return Container(
      color: Colors.transparent,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 30,
              ),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 30,
              ),
              color: Colors.transparent,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
