import 'package:flutter/material.dart';
import 'package:happy_hearts_pet_care_services/constant/sizeconfig.dart';

import 'favourite_list.dart';

class FavouriteRest extends StatefulWidget {
  @override
  _FavouriteRestState createState() => _FavouriteRestState();
}

class _FavouriteRestState extends State<FavouriteRest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0XFF003F4F),

      body: Column(
        children: [
          header(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: FavouriteRestaurentList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget header() {
    return Container(
      height: SizeConfig.blockSizeVertical * 12,
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
                  padding: const EdgeInsets.only(top: 25, left: 20),
                  child: Row(
                    children: [
                      Text(
                        "Wishlist",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
