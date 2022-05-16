import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:happy_hearts_pet_care_services/block/signup_bloc.dart';
import 'package:happy_hearts_pet_care_services/constant/global.dart';
import 'package:happy_hearts_pet_care_services/constant/sizeconfig.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'login.dart';
import 'package:happy_hearts_pet_care_services/strings/strings.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class Item {
  const Item(
    this.name,
  );
  final String name;
}

class _SignUpState extends State<SignUp> {
  ProgressDialog pr;

  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // ignore: unused_field
  final TextEditingController _numberController = TextEditingController();

  String dropDownname;

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
        left: 20.0,
        right: 20.0,
      ),
      child: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // SizedBox(
                //   height: 100,
                // ),
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

                Container(height: 10.0),
                Container(
                  // color: Colors.red,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Text('User Name',
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
                      _userTextfield(context),
                      Container(height: 10.0),
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
                      Container(height: 50.0),
                      // _phoneTextfield(context),
                      // Container(height: 10.0),
                      // _petTextfield(context),

                      _loginButton(context),
                      Container(height: 40.0),
                      // _facebookButton(context),
                    ],
                  ),
                ),
                _dontHaveAnAccount(context),
                Container(height: 50.0),
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

  Widget _userTextfield(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: CustomtextField(
        controller: _unameController,
        maxLines: 1,
        textInputAction: TextInputAction.next,
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
      ),
    );
  }

  Widget _emailTextfield(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: CustomtextField(
        controller: _emailController,
        maxLines: 1,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  // Widget _phoneTextfield(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 30, right: 30),
  //     child: CustomtextField(
  //       controller: _numberController,
  //       maxLines: 1,
  //       textInputAction: TextInputAction.next,
  //       hintText: 'Phone Number',
  //       prefixIcon: Container(
  //         margin: EdgeInsets.all(10.0),
  //         child: Image.asset(
  //           Images.phone,
  //           height: 15,
  //           width: 15,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _petTextfield(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 8, right: 8),
  //     child: Container(
  //       decoration: new BoxDecoration(
  //         gradient: new LinearGradient(
  //           colors: [
  //             const Color(0xFFB677B4),
  //             const Color(0xFF8A63BF),
  //           ],
  //           begin: FractionalOffset.centerLeft,
  //           end: FractionalOffset.centerRight,
  //         ),
  //       ),
  //       width: double.infinity,
  //       child: Center(
  //         child: DropdownButtonFormField<Item>(
  //           hint: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Text("Select item"),
  //           ),
  //           icon: Icon(
  //             Icons.arrow_drop_down,
  //             color: Colors.white,
  //             size: 30.0,
  //           ),
  //           value: selectedUser,
  //           onChanged: (Item Value) {
  //             setState(() {
  //               selectedUser = Value;
  //               dropDownname = selectedUser.name;
  //             });
  //           },
  //           items: users.map((Item user) {
  //             return DropdownMenuItem<Item>(
  //               value: user,
  //               child: Row(
  //                 children: <Widget>[
  //                   SizedBox(
  //                     width: 15,
  //                   ),
  //                   Text(
  //                     user.name,
  //                     style: TextStyle(color: Colors.black),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           }).toList(),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _loginButton(BuildContext context) {
    return SizedBox(
      height: 55,
      width: MediaQuery.of(context).size.width - 105,
      child: CustomButtom(
        title: 'SIGNUP',
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
        text: "Already have an account? ",
        style: TextStyle(
          fontSize: 15,
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
        children: <TextSpan>[
          TextSpan(
            recognizer: new TapGestureRecognizer()
              ..onTap = () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => Login(),
                    ),
                  ),
            text: ' Sign in',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Color(0xFF1E3C72),
            ),
          ),
        ],
      ),
    );
  }

  void _signup(BuildContext context) {
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

    if (_unameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _emailController.text.isNotEmpty) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (regex.hasMatch(_emailController.text) &&
          _passwordController.text.length > 4) {
        pr.show();
        // Loader().showIndicator(context);

        signupBloc
            .signupSink(
          _emailController.text,
          _passwordController.text,
          _unameController.text,
        )
            .then(
          (userResponse) {
            if (userResponse.responseCode == Strings.responseSuccess) {
              // String userResponseStr = json.encode(userResponse);
              // preferences.setString(
              //     SharedPreferencesKey.LOGGED_IN_USERRDATA,
              //     userResponseStr);
              pr.hide();
              Toast.show("USER REGISTER SUCCESSFULLY", context,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  duration: Toast.LENGTH_LONG,
                  gravity: Toast.BOTTOM);
              signupBloc.dispose();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
              //
              // Navigator.of(context).pushAndRemoveUntil(
              //   MaterialPageRoute(
              //     builder: (context) => TabbarScreen(),
              //   ),
              //   (Route<dynamic> route) => false,
              // );
            } else if (userResponse.responseCode == '0') {
              pr.hide();
              loginerrorDialog(context, "Email id already registered");
            } else {
              pr.hide();
              loginerrorDialog(
                  context, "Make sure you have entered right credential");
            }
          },
        );
      } else {
        loginerrorDialog(
            context, "Make sure you have entered right credential");
      }
    } else {
      loginerrorDialog(context, "Please enter valid credential to sign up");
    }
  }
}
