import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:happy_hearts_pet_care_services/block/allres_block.dart';
import 'package:happy_hearts_pet_care_services/constant/global.dart';
import 'package:happy_hearts_pet_care_services/constant/sizeconfig.dart';
import 'package:happy_hearts_pet_care_services/images/images.dart';
import 'package:happy_hearts_pet_care_services/models/allrestaurent_model.dart';
import 'package:happy_hearts_pet_care_services/models/favourite_restaurent_modal.dart';
import 'package:happy_hearts_pet_care_services/provider/allres_api.dart';
import 'package:happy_hearts_pet_care_services/provider/favourite_api.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:happy_hearts_pet_care_services/screens/ResDetailsNew.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class NearRestaurentOnMap extends StatefulWidget {
  @override
  _NearRestaurentOnMapState createState() => _NearRestaurentOnMapState();
}

class _NearRestaurentOnMapState extends State<NearRestaurentOnMap> {
  String _mapStyle;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  Set<Marker> _markers = {};
  Position currentLocation;
  bool _showLoader = true;
  ItemScrollController _scrollController = ItemScrollController();
  @override
  void initState() {
    super.initState();

    //  allRestaurents = [];

    getResFirst();

    rootBundle.loadString('assets/mapStyle/map_style.txt').then((string) {
      _mapStyle = string;
    });
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

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
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

  @override
  Widget build(BuildContext context) {
    allres.allresSink();
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      key: _drawerKey,
      // drawer: BuildDrawer(),
      // appBar: customAppBar(
      //   title: 'Restaurant near you',
      //   leading: GestureDetector(
      //     onTap: () => _drawerKey.currentState.openDrawer(),
      //     child: Icon(
      //       Icons.menu,
      //       color: Colors.black,
      //     ),
      //   ),
      // ),
      body: _showLoader
          ? Center(child: CupertinoActivityIndicator())
          : Stack(
              children: <Widget>[
                GoogleMap(
                  markers: _markers,
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  mapToolbarEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      currentLocation.latitude,
                      currentLocation.longitude,
                    ),
                    zoom: 10,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    mapController = controller;
                    mapController.setMapStyle(_mapStyle);
                  },
                ),
                _allresContainer()
              ],
            ),
    );
  }

  Widget _allresContainer() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: SizeConfig.blockSizeVertical * 40,
        width: SizeConfig.screenWidth,
        child: Column(
          children: <Widget>[
            Container(
              height: SizeConfig.blockSizeVertical * 30,
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

  Widget widgetCard(Restaurants categories) {
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
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: EdgeInsets.only(left: 25, right: 0, top: 70, bottom: 0),
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

  // ignore: unused_element
  void _restaurentDetailsBottomsheet(
      BuildContext context, Restaurants data) async {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF1E3C72),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              height: 270,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      // color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width - 70,
                          padding: EdgeInsets.only(left: 20.0),
                          // color: Colors.red,
                          child: Text(
                            data.resName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.close,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    height: 120,
                    // color: Colors.red,
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: data.resImage.resImag0,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
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
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            appColorGreen),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ),
                        Container(width: 10.0),
                        Container(
                          height: 90,
                          width: MediaQuery.of(context).size.width - 150,
                          alignment: Alignment.centerLeft,
                          // color: Colors.yellow,
                          child: Text(
                            data.resDesc,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 17,
                                fontStyle: FontStyle.normal,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: FloatingActionButton(
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                        ),
                        backgroundColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ResDetailsNew(
                                likeStatus: likedRestaurent.contains(data.resId)
                                    ? 'yes'
                                    : 'no',
                                restID: data.resId,
                                restName: data.resName,
                                resNameU: data.resNameU,
                                restDesc: data.resDesc,
                                restDescU: data.resDescU,
                                resWebsite: data.resWebsite,
                                restImage: data.resImage.resImag0,
                                resPhone: data.resPhone,
                                resAddress: data.resAddress,
                                restRatings: data.resRatings,
                                mfo: data.mfo,
                                // mfc: categories.mfc,
                                // sso: categories.sso,
                                // ssc: categories.ssc,

                                lat: data.lat,
                                lon: data.lon,
                                count: data.reviewCount,
                                images: data.allImage,
                                resVideo: data.resVideo,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
