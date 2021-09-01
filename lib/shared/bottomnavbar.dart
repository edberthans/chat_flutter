import 'package:chat_flutter/dashboard/dashboard.dart';
import 'package:chat_flutter/dashboard/verificationDocument.dart';
import 'package:chat_flutter/profile/profile.dart';
import 'package:chat_flutter/screens/home/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_flutter/Component/defaultElements.dart';
import 'package:chat_flutter/models/ShoeListModel.dart';
import 'package:chat_flutter/models/categoriesModel.dart';
import 'package:chat_flutter/screens/cards/itemsCard.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: DefaultElements.knavbariconcolor,
            blurRadius: 10,
            offset: Offset(0, -1),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(
            "assets/icons/home.svg",
            height: 30,
            color: DefaultElements.kprimarycolor,
          ),
          // SvgPicture.asset(
          //   "assets/icons/heart.svg",
          //   height: 30,
          //   color: DefaultElements.knavbariconcolor,
          // ),
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dashboard()),
                  );
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: DefaultElements.kprimarycolor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: DefaultElements.knavbariconcolor,
                        offset: Offset(0, -1),
                        blurRadius: 8.0,
                      )
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: SvgPicture.asset(
                      "assets/icons/list.svg",
                      color: DefaultElements.ksecondrycolor,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 45,
                bottom: 45,
                top: 0,
                right: 0,
                child: Container(
                  height: 18,
                  width: 18,
                  // decoration: BoxDecoration(
                  //   color: DefaultElements.kdefaultredcolor,
                  //   shape: BoxShape.circle,
                  // ),
                  // child: Center(
                  //   child: Text(
                  //     "2",
                  //     style: TextStyle(
                  //         color: Colors.white, fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                ),
              )
            ],
          ),
          // IconButton(
          //   icon: SvgPicture.asset(
          //     "assets/icons/list.svg",
          //     height: 30,
          //     color: DefaultElements.knavbariconcolor,
          //   ),
          //   onPressed: () {
          //     null;
          //   },
          // ),
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/person.svg",
              height: 30,
              color: DefaultElements.knavbariconcolor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Profile()),
              );
            },
          ),
        ],
      ),
    );
  }
}