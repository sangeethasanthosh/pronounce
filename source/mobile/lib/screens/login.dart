import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:happy_hearts_pet_care_services/block/login_bloc.dart';
import 'package:happy_hearts_pet_care_services/constant/global.dart';
import 'package:happy_hearts_pet_care_services/constant/sizeconfig.dart';
import 'package:happy_hearts_pet_care_services/screens/forgetpass.dart';
import 'package:happy_hearts_pet_care_services/screens/newTabbar.dart';
import 'package:happy_hearts_pet_care_services/screens/signup.dart';
import 'package:happy_hearts_pet_care_services/share_preference/preferencesKey.dart';
import 'package:happy_hearts_pet_care_services/strings/strings.dart';
import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ProgressDialog pr;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LocationData locationData;

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _loginForm(context),
          ],
        ),
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 0,
        right: 0,
      ),
      child: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // _appIcon(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/nlytical_logo.png',
                      height: 200,
                      fit: BoxFit.contain,
                      // width: SizeConfig.blockSizeHorizontal * 50,
                    ),
                  ],
                ),

                Container(height: 50.0),

                Container(
                  // color: Colors.red,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Text('Email ID',
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _emailTextfield(context),
                      Container(height: 10.0),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Text('Password',
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _passwordTextfield(context),
                      Container(height: 10.0),
                      _forgotPassword(),
                      Container(height: 50.0),
                      _loginButton(context),
                      Container(height: 40.0),
                      // _facebookButton(context),
                    ],
                  ),
                ),
                _dontHaveAnAccount(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _appIcon() {
    return Image.asset(
      'assets/images/greenlogo.png',
      height: 110,
      width: 200,
    );
  }

  Widget _emailTextfield(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: CustomtextField(
        controller: _emailController,
        maxLines: 1,
        textInputAction: TextInputAction.next,
        // hintText: 'EMAIL',
        // prefixIcon: Container(
        //   margin: EdgeInsets.all(10.0),
        //   child: Icon(
        //     Icons.person,
        //     color: Colors.white,
        //     size: 28.0,
        //   ),
        // ),
      ),
    );
  }

  Widget _passwordTextfield(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: CustomtextField(
        controller: _passwordController,
        maxLines: 1,
        textInputAction: TextInputAction.next,
        // hintText: 'PASSWORD',
        // prefixIcon: Container(
        //   margin: EdgeInsets.all(10.0),
        //   child: Icon(
        //     Icons.lock,
        //     color: Colors.white,
        //     size: 28.0,
        //   ),
        // ),
      ),
    );
  }

  Widget _forgotPassword() {
    return Padding(
      padding: const EdgeInsets.only(right: 32),
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ForgetPass()),
            );
          },
          child: Text.rich(
            TextSpan(
              text: 'Forget Password?',
              style: TextStyle(
                letterSpacing: 1.0,
                fontSize: 15,
                color: Color(0xFF1E3C72),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return SizedBox(
      height: 55,
      width: MediaQuery.of(context).size.width - 105,
      child: CustomButtom(
        title: 'SIGN IN',
        color: Colors.white,
        onPressed: () {
          _apiCall(context);
          print('Button is pressed');
        },
      ),
    );
  }

  // Widget _facebookButton(BuildContext context) {
  //   return SizedBox(
  //     height: 55,
  //     width: MediaQuery.of(context).size.width - 170,
  //     child: RaisedButton(
  //       color: Color(0XFF3b5998),
  //       child: Row(
  //         children: <Widget>[
  //           Text(
  //             'Play this song',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         ],
  //       ),
  //       onPressed: () {},
  //       shape: RoundedRectangleBorder(
  //         borderRadius: new BorderRadius.circular(35.0),
  //         //  side: BorderSide(color: Colors.red)
  //       ),
  //     ),
  //   );
  // }

  Widget _dontHaveAnAccount(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "New Member? ",
        style: TextStyle(
          letterSpacing: 1.5,
          fontSize: 16,
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(
            recognizer: new TapGestureRecognizer()
              ..onTap = () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => SignUp(),
                    ),
                  ),
            text: 'Sign Up',
            style: TextStyle(
              color: Color(0xFF1E3C72),
            ),
          ),
        ],
      ),
    );
  }

  void _apiCall(BuildContext context) {
    closeKeyboard();

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

    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      pr.show();
      loginBloc.loginSink(_emailController.text, _passwordController.text).then(
        (userResponse) async {
          if (userResponse.responseCode == Strings.responseSuccess) {
            String userResponseStr = json.encode(userResponse);
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.setString(
                SharedPreferencesKey.LOGGED_IN_USERRDATA, userResponseStr);
            // Loader().hideIndicator(context);
            loginBloc.dispose();
            pr.hide();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => TabbarScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          } else {
            pr.hide();
            loginerrorDialog(
                context, "Make sure you have entered right credential");
          }
        },
      );
    } else {
      loginerrorDialog(context, "Please enter your credential to login");
    }
  }
}
