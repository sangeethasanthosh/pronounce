import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happy_hearts_pet_care_services/block/allcate_block.dart';
import 'package:happy_hearts_pet_care_services/constant/global.dart';
import 'package:happy_hearts_pet_care_services/constant/sizeconfig.dart';
import 'package:happy_hearts_pet_care_services/models/categories_model.dart';
import 'package:happy_hearts_pet_care_services/screens/ViewRes.dart';

class CategoriesNew extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<CategoriesNew> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    allcate.allcateSink();

    super.initState();

    getCurrentLocation().then((_) async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 30),
                  child: Text(
                    "Categories",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.blockSizeHorizontal * 5),
                  ),
                ),
                Container(
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
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
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
          ),
        ),
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
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, bottom: 20),
        child: new Card(
          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  child: Container(
                    height: 170.0,
                    width: MediaQuery.of(context).size.width,
                    child: FittedBox(
                      child: CachedNetworkImage(
                        imageUrl: categories.img,
                        placeholder: (context, url) => Center(
                          child: Container(
                            margin: EdgeInsets.all(70.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  appColorGreen),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 150,
                          width: 150,
                          child: Icon(
                            Icons.error,
                          ),
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(270, 270, 270, 0.50),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      categories.cName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'bold',
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
