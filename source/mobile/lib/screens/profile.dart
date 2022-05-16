import 'dart:io';

import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happy_hearts_pet_care_services/block/profile_bloc.dart';
import 'package:happy_hearts_pet_care_services/block/uProfileImg.dart';
import 'package:happy_hearts_pet_care_services/block/uProile_block.dart';
import 'package:happy_hearts_pet_care_services/constant/global.dart';
import 'package:happy_hearts_pet_care_services/constant/sizeconfig.dart';
import 'package:happy_hearts_pet_care_services/models/profile_model.dart';
import 'package:happy_hearts_pet_care_services/screens/CustomShape/shape.dart';
import 'package:happy_hearts_pet_care_services/screens/login.dart';
import 'package:happy_hearts_pet_care_services/screens/my_reviews.dart';
import 'package:happy_hearts_pet_care_services/share_preference/preferencesKey.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController _email = TextEditingController();
  TextEditingController _username = TextEditingController();

  File selectedImage;
  String imageUrl;

  @override
  Widget build(BuildContext context) {
    profileBloc.profileSink(userID);
    SizeConfig().init(context);
    return Scaffold(
        //  backgroundColor: Color(0xFFA6B8DD),
        body: _userInfo());
  }

  Widget _userInfo() {
    return StreamBuilder<ProfileModel>(
        stream: profileBloc.profileStream,
        builder: (context, AsyncSnapshot<ProfileModel> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: AwesomeLoader(
                loaderType: 4,
                color: appColorGreen,
              ),
            );
          }
          _username.text = snapshot.data.user.username;
          _email.text = snapshot.data.user.email;
          print(snapshot.data.user);
          return snapshot.data.user != null
              ? Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Container(
                        height: SizeConfig.screenHeight,
                        width: SizeConfig.screenWidth,
                        color: Colors.white,
                        child: Stack(
                          children: <Widget>[
                            CustomPaint(
                              child: Container(
                                height: 400.0,
                                child: Center(
                                  child: headerText(),
                                ),
                              ),
                              painter: CurvePainter(),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: SizeConfig.blockSizeVertical * 11,
                                ),
                                profilePic(snapshot.data.user),
                                SizedBox(
                                  height: SizeConfig.blockSizeVertical * 2,
                                ),
                                snapshot.data.user.username != null
                                    ? Text(
                                        snapshot.data.user.username,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                SizeConfig.blockSizeHorizontal *
                                                    5),
                                      )
                                    : Text(
                                        'Loading..',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                SizeConfig.blockSizeHorizontal *
                                                    5),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 50),
                                  child: Material(
                                    elevation: 5.0,
                                    shadowColor: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Container(
                                      height:
                                          SizeConfig.blockSizeVertical * 6.5,
                                      width: SizeConfig.screenWidth,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: 10.0,
                                          bottom: 00.0,
                                          left: 20.0,
                                          right: 20.0,
                                        ),
                                        child: InkWell(
                                          onTap: () {},
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "Name",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        "Poppins-Medium",
                                                    color: Colors.grey,
                                                    fontSize: SizeConfig
                                                            .safeBlockHorizontal *
                                                        3,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: SizeConfig
                                                          .blockSizeHorizontal *
                                                      20,
                                                  child: TextField(
                                                    controller: _username,
                                                    decoration:
                                                        new InputDecoration
                                                                .collapsed(
                                                            hintText: snapshot
                                                                .data
                                                                .user
                                                                .username,
                                                            hintStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20),
                                  child: Material(
                                    elevation: 5.0,
                                    shadowColor: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Container(
                                      height:
                                          SizeConfig.blockSizeVertical * 6.5,
                                      width: SizeConfig.screenWidth,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: 10.0,
                                          bottom: 00.0,
                                          left: 20.0,
                                          right: 20.0,
                                        ),
                                        child: InkWell(
                                          onTap: () {},
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "Email",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        "Poppins-Medium",
                                                    color: Colors.grey,
                                                    fontSize: SizeConfig
                                                            .safeBlockHorizontal *
                                                        3,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: SizeConfig
                                                          .blockSizeHorizontal *
                                                      45,
                                                  child: TextField(
                                                    controller: _email,
                                                    decoration:
                                                        new InputDecoration
                                                                .collapsed(
                                                            hintText: snapshot
                                                                .data
                                                                .user
                                                                .email,
                                                            hintStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       left: 20, right: 20, top: 20),
                                //   child: Material(
                                //     elevation: 5.0,
                                //     shadowColor: Colors.white,
                                //     borderRadius: BorderRadius.circular(10.0),
                                //     child: Container(
                                //       height:
                                //           SizeConfig.blockSizeVertical * 6.5,
                                //       width: SizeConfig.screenWidth,
                                //       decoration: BoxDecoration(
                                //           color: Colors.white,
                                //           borderRadius:
                                //               BorderRadius.circular(10.0),
                                //           border:
                                //               Border.all(color: Colors.black)),
                                //       child: Padding(
                                //         padding: EdgeInsets.only(
                                //           top: 10.0,
                                //           bottom: 00.0,
                                //           left: 20.0,
                                //           right: 20.0,
                                //         ),
                                //         child: InkWell(
                                //           onTap: () {},
                                //           child: Padding(
                                //             padding: const EdgeInsets.only(
                                //                 bottom: 10),
                                //             child: Row(
                                //               mainAxisAlignment:
                                //                   MainAxisAlignment
                                //                       .spaceBetween,
                                //               children: <Widget>[
                                //                 Text(
                                //                   "Phone",
                                //                   style: TextStyle(
                                //                     fontFamily:
                                //                         "Poppins-Medium",
                                //                     color: Colors.grey,
                                //                     fontSize: SizeConfig
                                //                             .safeBlockHorizontal *
                                //                         3,
                                //                   ),
                                //                 ),
                                //                 SizedBox(
                                //                   width: SizeConfig
                                //                           .blockSizeHorizontal *
                                //                       23,
                                //                   child: TextField(
                                //                     decoration:
                                //                         new InputDecoration
                                //                                 .collapsed(
                                //                             hintText:
                                //                                 '9809866544',
                                //                             hintStyle:
                                //                                 TextStyle(
                                //                               color:
                                //                                   Colors.black,
                                //                             )),
                                //                   ),
                                //                 ),
                                //               ],
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                SizedBox(
                                  height: SizeConfig.blockSizeVertical * 5,
                                ),
                                SizedBox(
                                  height: 55,
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  child: CustomButtom(
                                    title: 'Update',
                                    color: Colors.white,
                                    onPressed: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(builder: (context) => SignUp()),
                                      // );
                                      _signup(context);
                                      print('Button is pressed');
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.blockSizeVertical * 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: Material(
                                    elevation: 5.0,
                                    shadowColor: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Container(
                                      height:
                                          SizeConfig.blockSizeVertical * 6.5,
                                      width: SizeConfig.screenWidth,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: 10.0,
                                          bottom: 00.0,
                                          left: 20.0,
                                          right: 20.0,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyReviews()),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "My Review",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Poppins-Medium",
                                                      color: Colors.grey,
                                                      fontSize: SizeConfig
                                                              .safeBlockHorizontal *
                                                          3,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Icon(Icons.arrow_forward_ios)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.blockSizeVertical * 2,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: Material(
                                    elevation: 5.0,
                                    shadowColor: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Container(
                                      height:
                                          SizeConfig.blockSizeVertical * 6.5,
                                      width: SizeConfig.screenWidth,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: 10.0,
                                          bottom: 00.0,
                                          left: 20.0,
                                          right: 20.0,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            preferences
                                                .remove(SharedPreferencesKey
                                                    .LOGGED_IN_USERRDATA)
                                                .then((_) {
                                              likedRestaurent = [];
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                  builder: (context) => Login(),
                                                ),
                                                (Route<dynamic> route) => false,
                                              );
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "Logout",
                                                  style: TextStyle(
                                                      fontFamily:
                                                          "Poppins-Medium",
                                                      color: Colors.grey,
                                                      fontSize: SizeConfig
                                                              .safeBlockHorizontal *
                                                          3,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Icon(Icons.arrow_forward_ios)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Login To Get Profile",
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 6.5),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 3,
                    ),
                    Container(
                      width: SizeConfig.blockSizeHorizontal * 60,
                      height: SizeConfig.blockSizeVertical * 7,
                      child: CupertinoButton(
                        onPressed: () => {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => Login(),
                            ),
                          )
                        },
                        color: Color(0xFF1E3C72),
                        borderRadius: new BorderRadius.circular(30.0),
                        child: new Text(
                          "Login Now",
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.blockSizeHorizontal * 3.5),
                        ),
                      ),
                    ),
                  ],
                ));
        });
  }

  void _signup(BuildContext context) {
    closeKeyboard();
    if (selectedImage != null) {
      if (_email.text.isNotEmpty && _username.text.isNotEmpty) {
        Loader().showIndicator(context);

        uProfileImgBloc
            .uProfileImgSink(_email.text, _username.text, selectedImage, userID)
            .then(
          (userResponse) {
            if (userResponse.responseCode == '1') {
              // String userResponseStr = json.encode(userResponse);
              // preferences.setString(
              //     SharedPreferencesKey.LOGGED_IN_USERRDATA,
              //     userResponseStr);
              Loader().hideIndicator(context);
              uProfileImgBloc.dispose();
              errorDialog(
                context,
                "You succesfully update Profile",
                button: true,
              );
              // Navigator.of(context).pushAndRemoveUntil(
              //   MaterialPageRoute(
              //     builder: (context) => TabbarScreen(),
              //   ),
              //   (Route<dynamic> route) => false,
              // );
            } else if (userResponse.responseCode == '0') {
              Loader().hideIndicator(context);
              errorDialog(context, "Fail to update");
            } else {
              Loader().hideIndicator(context);
              errorDialog(
                  context, "Make sure you have entered right credential");
            }
          },
        );
      }
    } else {
      Loader().showIndicator(context);

      uProfileBloc.uProfileSink(_email.text, _username.text, userID).then(
        (userResponse) {
          if (userResponse.responseCode == '1') {
            // String userResponseStr = json.encode(userResponse);
            // preferences.setString(
            //     SharedPreferencesKey.LOGGED_IN_USERRDATA,
            //     userResponseStr);
            Loader().hideIndicator(context);
            uProfileImgBloc.dispose();
            errorDialog(
              context,
              "You succesfully update Profile",
              button: true,
            );
            // Navigator.of(context).pushAndRemoveUntil(
            //   MaterialPageRoute(
            //     builder: (context) => TabbarScreen(),
            //   ),
            //   (Route<dynamic> route) => false,
            // );
          } else if (userResponse.responseCode == '0') {
            Loader().hideIndicator(context);
            errorDialog(context, "Fail to update");
          } else {
            Loader().hideIndicator(context);
            errorDialog(context, "Fail");
          }
        },
      );
    }
  }

  Widget headerText() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Text(
          'Profile',
          style: TextStyle(
              color: Colors.white,
              fontSize: SizeConfig.blockSizeHorizontal * 5),
        ),
      ),
    );
  }

  Widget profilePic(User user) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        userImg(user),
        editIconForPhoto(),
      ],
    );
  }

  Widget userImg(User user) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        height: 150,
        width: 150,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: selectedImage == null
              ? user.profilePic != null
                  ? Image.network(user.profilePic, fit: BoxFit.cover)
                  : Icon(Icons.person, size: 100)
              : Image.file(selectedImage, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget editIconForPhoto() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      padding: EdgeInsets.all(5),
      child: Container(
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: Colors.grey[200]),
        child: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            openImageFromCamOrGallary(context);
          },
        ),
      ),
    );
  }

  void containerForSheet<T>({BuildContext context, Widget child}) {
    showCupertinoModalPopup<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {});
  }

  openImageFromCamOrGallary(BuildContext context) {
    containerForSheet<String>(
      context: context,
      child: CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(
              "Camera",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            onPressed: () {
              getImageFromCamera();
              Navigator.of(context, rootNavigator: true).pop("Discard");
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              "Photo & Video Library",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            onPressed: () {
              getImageFromGallery();
              Navigator.of(context, rootNavigator: true).pop("Discard");
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          isDefaultAction: true,
          onPressed: () {
            // Navigator.pop(context, 'Cancel');
            Navigator.of(context, rootNavigator: true).pop("Discard");
          },
        ),
      ),
    );
  }

  Future getImageFromCamera() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 30);
    setState(() {
      selectedImage = image;
    });
  }

  Future getImageFromGallery() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 30);
    setState(() {
      selectedImage = image;
    });
  }
}

//  user.profilePic!=null &&  user.profilePic.length>0?
//             Container(
//               height: 150,
//               width: 150,
//               color: Colors.white,
//               child:Image.network(user.profilePic)):
