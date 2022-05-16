// import 'package:flutter/material.dart';
// import 'package:happy_hearts_pet_care_services/constant/global.dart';
// import 'package:happy_hearts_pet_care_services/constant/sizeconfig.dart';
// import 'package:happy_hearts_pet_care_services/screens/drawer.dart';
// import 'package:share/share.dart';

// class ShareApp extends StatefulWidget {
//   @override
//   DemoAppState createState() => DemoAppState();
// }

// class DemoAppState extends State<ShareApp> {
//   initState() {
//     Share.share(
//       text,
//       // subject: subject,
//     );

//     super.initState();
//   }

//   String text = 'www.test.com'.toString();
//   String subject = '';

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return MaterialApp(
//       title: 'Share Plugin Demo',
//       home: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Color(0XFF1A5361),
//           // title: Text("Hello Appbar"),
//           leading: GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => FullScreenDrawer()),
//               );
//             },
//             child: Container(
//                 height: 100,
//                 width: 100,
//                 child: Image.asset(
//                   'assets/images/menuicon.png',
//                 )),
//           ),
//         ),
//         body: Container(
//           height: double.infinity,
//           width: double.infinity,
//           color: Color(0XFF003F4F),
//           child: Align(
//             alignment: Alignment.center,
//             child: Stack(
//               children: <Widget>[
//                 Container(
//                   alignment: Alignment.center,
//                   child: Text(
//                     'Share Gharba App',
//                     style: TextStyle(fontSize: 25, color: Colors.white),
//                   ),
//                 ),
//                 Container(
//                   alignment: Alignment.center,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 120),
//                     child: Container(
//                       alignment: Alignment.center,
//                       height: SizeConfig.safeBlockVertical * 8,
//                       width: SizeConfig.safeBlockHorizontal * 40,
//                       child: RaisedButton(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         color: Color(0XFF106C6F),
//                         child: Row(
//                           children: <Widget>[
//                             Expanded(
//                               child: Center(
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(top: 5),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: <Widget>[
//                                       Text(
//                                         'Share',
//                                         style: TextStyle(
//                                             fontSize: 20,
//                                             fontStyle: FontStyle.normal,
//                                             color: Colors.white),
//                                       ),
//                                       Text(
//                                         'شارك',
//                                         style: TextStyle(
//                                             fontSize: 15,
//                                             fontStyle: FontStyle.normal,
//                                             color: Colors.white,
//                                             fontFamily: 'arabic'),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Icon(
//                               Icons.share,
//                               color: Colors.white,
//                               size: 30.0,
//                             ),
//                           ],
//                         ),
//                         onPressed: text.isEmpty
//                             ? null
//                             : () {
//                                 // A builder is used to retrieve the context immediately
//                                 // surrounding the RaisedButton.
//                                 //
//                                 // The context's `findRenderObject` returns the first
//                                 // RenderObject in its descendent tree when it's not
//                                 // a RenderObjectWidget. The RaisedButton's RenderObject
//                                 // has its position and size after it's built.
//                                 final RenderBox box =
//                                     context.findRenderObject();
//                                 Share.share(text,
//                                     subject: subject,
//                                     sharePositionOrigin:
//                                         box.localToGlobal(Offset.zero) &
//                                             box.size);
//                               },
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
