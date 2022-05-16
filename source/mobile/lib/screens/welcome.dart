import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happy_hearts_pet_care_services/constant/sizeconfig.dart';
import 'package:happy_hearts_pet_care_services/screens/login.dart';
import 'package:happy_hearts_pet_care_services/screens/signup.dart';
import 'package:progress_dialog/progress_dialog.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  ProgressDialog pr;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Showing some progress...');
    pr.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Container(
        height: 10,
        width: 10,
        margin: EdgeInsets.all(5),
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation(Colors.blue),
        ),
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Container(
        //  decoration: BoxDecoration(
        //     image: DecorationImage(
        //       image: AssetImage('assets/images/back.jpg'),
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: LayoutBuilder(builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: SizeConfig.blockSizeVertical * 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'assets/images/transparent_n_80.png',
                                  width: SizeConfig.blockSizeHorizontal * 12,
                                ),
                                Text('Skip',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 4.5,
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text('Welcome to Nlytical',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 6,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                'There\'s so much to explore. let\'s get started.',
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                                )),
                            SizedBox(
                              height: SizeConfig.blockSizeVertical * 10,
                            ),
                            Container(
                              width: SizeConfig.screenWidth,
                              child: Image.asset(
                                'assets/images/bg.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.blockSizeVertical * 10,
                            ),
                            // Container(
                            //   width: SizeConfig.screenWidth,
                            //   height: SizeConfig.blockSizeVertical * 6,
                            //   child: Padding(
                            //     padding:
                            //         const EdgeInsets.only(left: 10, right: 10),
                            //     child: RaisedButton(
                            //         elevation: 0.0,
                            //         shape: new RoundedRectangleBorder(
                            //             side: BorderSide(
                            //                 color: Colors.black, width: 1),
                            //             borderRadius:
                            //                 new BorderRadius.circular(5.0)),
                            //         padding: EdgeInsets.only(
                            //             top: 7.0,
                            //             bottom: 7.0,
                            //             right: 40.0,
                            //             left: 7.0),
                            //         onPressed: () {
                            //           pr.show();
                            //           signInWithGoogle().whenComplete(() async {
                            //             Navigator.of(context)
                            //                 .pushAndRemoveUntil(
                            //               MaterialPageRoute(
                            //                 builder: (context) => HomeNew(),
                            //               ),
                            //               (Route<dynamic> route) => false,
                            //             );
                            //             pr.hide();
                            //           });
                            //         },
                            //         child: Padding(
                            //           padding: const EdgeInsets.only(
                            //               left: 10, right: 10),
                            //           child: new Row(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.spaceBetween,
                            //             children: <Widget>[
                            //               new Image.asset(
                            //                 'assets/images/brands-and-logotypes.png',
                            //                 height: 20.0,
                            //                 width: 20.0,
                            //               ),
                            //               Padding(
                            //                   padding:
                            //                       EdgeInsets.only(left: 10.0),
                            //                   child: new Text(
                            //                     "Continue with Google",
                            //                     style: TextStyle(
                            //                         fontSize: 15.0,
                            //                         fontWeight:
                            //                             FontWeight.bold),
                            //                   )),
                            //               new Text('',
                            //                   style: TextStyle(
                            //                     color: Colors.transparent,
                            //                   )),
                            //             ],
                            //           ),
                            //         ),
                            //         textColor: Color(0xFF292929),
                            //         color: Colors.white),
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 20,
                            // ),
                            // Container(
                            //   width: SizeConfig.screenWidth,
                            //   height: SizeConfig.blockSizeVertical * 6,
                            //   child: Padding(
                            //     padding:
                            //         const EdgeInsets.only(left: 10, right: 10),
                            //     child: RaisedButton(
                            //         elevation: 0.0,
                            //         shape: new RoundedRectangleBorder(
                            //             side: BorderSide(
                            //                 color: Colors.black, width: 1),
                            //             borderRadius:
                            //                 new BorderRadius.circular(5.0)),
                            //         padding: EdgeInsets.only(
                            //             top: 7.0,
                            //             bottom: 7.0,
                            //             right: 40.0,
                            //             left: 7.0),
                            //         onPressed: () {},
                            //         child: Padding(
                            //           padding: const EdgeInsets.only(
                            //               left: 10, right: 10),
                            //           child: new Row(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.spaceBetween,
                            //             children: <Widget>[
                            //               new Image.asset(
                            //                 'assets/images/facebook.png',
                            //                 height: 20.0,
                            //                 width: 20.0,
                            //               ),
                            //               Padding(
                            //                   padding:
                            //                       EdgeInsets.only(left: 10.0),
                            //                   child: new Text(
                            //                     "Continue with facebook",
                            //                     style: TextStyle(
                            //                         fontSize: 15.0,
                            //                         fontWeight:
                            //                             FontWeight.bold),
                            //                   )),
                            //               new Text('',
                            //                   style: TextStyle(
                            //                     color: Colors.transparent,
                            //                   )),
                            //             ],
                            //           ),
                            //         ),
                            //         textColor: Colors.white,
                            //         color: Color(0xFF3b5998)),
                            //   ),
                            // ),
                            SizedBox(
                              height: SizeConfig.blockSizeVertical * 2,
                            ),
                            Container(
                              width: SizeConfig.screenWidth,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height:
                                            SizeConfig.blockSizeVertical * 5,
                                        decoration:
                                            BoxDecoration(border: Border.all()),
                                        child: RaisedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Login()),
                                            );
                                          },
                                          textColor: Colors.black,
                                          color: Colors.white,
                                          padding: const EdgeInsets.all(8.0),
                                          child: new Text(
                                            "Log in",
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Container(
                                        height:
                                            SizeConfig.blockSizeVertical * 5,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color(0xFF0096EC))),
                                        child: RaisedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignUp()),
                                            );
                                          },
                                          textColor: Colors.white,
                                          color: Color(0xFF0096EC),
                                          padding: const EdgeInsets.all(8.0),
                                          child: new Text(
                                            "Sign Up",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.blockSizeVertical * 2,
                            ),
                          ],
                        ),
                      ),
                    )),
              );
            })),
      ),
    );
  }
}
