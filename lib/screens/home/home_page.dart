import 'dart:ui';

import 'package:chat_flutter/models/jasaList.dart';
import 'package:chat_flutter/models/jasaUserData.dart';
import 'package:chat_flutter/models/user.dart';
import 'package:chat_flutter/screens/cards/jasaCard.dart';
import 'package:chat_flutter/screens/chats/chats_page.dart';
import 'package:chat_flutter/services/database.dart';
import 'package:chat_flutter/shared/bottomnavbar.dart';
import 'package:chat_flutter/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_flutter/Component/defaultElements.dart';
import 'package:chat_flutter/Models/ShoeListModel.dart';
import 'package:chat_flutter/Models/categoriesModel.dart';
import 'package:chat_flutter/screens/cards/itemsCard.dart';
import 'package:provider/provider.dart';

final AuthService _auth = AuthService();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  List<JasaUserData> jasaList;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<List<JasaUserData>>(
      stream: DatabaseService(uid: user.uid).jasaLists,
      builder: (context, snapshot) {
        List<Widget> children;
              // print('has data ' + snapshot1.hasData.toString());
              if(snapshot.hasError){
                return Text(snapshot.error.toString());
              }
              else if(snapshot.hasData){
                jasaList = snapshot.data;
                // print(jasauser.obj2);
                return Scaffold(
                  backgroundColor: DefaultElements.kdefaultbgcolor,
                  bottomNavigationBar: BottomNavBar(),
                  body: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildAppBar(),
                          // buildProductSection(),
                          SizedBox(
                            height: 20,
                          ),
                          buildCategoriesSection(context),
                          SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: GridView.builder(
                                itemCount: jasaList.length,
                                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                ),
                                itemBuilder: (context, index) => JasaCards(
                                  shoeListModel: shoeListModel[index],
                                  index: index,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              }
              else{
                return CircularProgressIndicator();
              }
        
      }
    );
  }

  buildAppBar() {
    return Container(
      color: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 30, 40, 10),
        child: Row(
          children: [
            IconButton(
              icon: SvgPicture.asset(
                "assets/icons/chat.svg",
                height: 25,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatsPage()),
                );
              },
            ),
            // SvgPicture.asset(
            //   "assets/icons/love.svg",
            //   height: 25,
            // ),
            Expanded(
              child: Container(),
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "KEN",
                    style: TextStyle(
                      color: DefaultElements.kprimarycolor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
                TextSpan(
                  text: "CAN",
                  style: TextStyle(
                    color: DefaultElements.ksecondrycolor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
            ),
            Expanded(
              child: Container(),
            ),
            IconButton(
              icon: SvgPicture.asset(
                "assets/icons/arrow.svg",
                height: 25,
              ),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }

  Padding buildProductSection() {
    return Padding(
      padding: EdgeInsets.only(left: 25, top: 10, right: 25),
      child: Row(
        children: [
          Text(
            "Our Product",
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Text(
            "Sort by",
            style: TextStyle(
              color: DefaultElements.knavbariconcolor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            size: 15,
            color: DefaultElements.knavbariconcolor,
          )
        ],
      ),
    );
  }

  buildCategoriesSection(BuildContext context) {
    return Container(
      height: 35,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: categoriesModel.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                width: 90,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      selectedIndex == index
                          ? BoxShadow(
                              color: DefaultElements.knavbariconcolor,
                              blurRadius: 10,
                              offset: Offset(0, -1))
                          : BoxShadow()
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "${categoriesModel[index].image}",
                      height: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "${categoriesModel[index].title}",
                      style: TextStyle(
                        color: selectedIndex == index
                            ? DefaultElements.kprimarycolor
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// class BottomNavBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: 70,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: DefaultElements.knavbariconcolor,
//             blurRadius: 10,
//             offset: Offset(0, -1),
//           )
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           SvgPicture.asset(
//             "assets/icons/home.svg",
//             height: 30,
//             color: DefaultElements.kprimarycolor,
//           ),
//           SvgPicture.asset(
//             "assets/icons/heart.svg",
//             height: 30,
//             color: DefaultElements.knavbariconcolor,
//           ),
//           Stack(
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   print("Cart");
//                 },
//                 child: Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: DefaultElements.kprimarycolor,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: DefaultElements.knavbariconcolor,
//                         offset: Offset(0, -1),
//                         blurRadius: 8.0,
//                       )
//                     ],
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(18),
//                     child: SvgPicture.asset(
//                       "assets/icons/cart.svg",
//                       color: DefaultElements.ksecondrycolor,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 left: 45,
//                 bottom: 45,
//                 top: 0,
//                 right: 0,
//                 child: Container(
//                   height: 18,
//                   width: 18,
//                   decoration: BoxDecoration(
//                     color: DefaultElements.kdefaultredcolor,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Center(
//                     child: Text(
//                       "2",
//                       style: TextStyle(
//                           color: Colors.white, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//           SvgPicture.asset(
//             "assets/icons/list.svg",
//             height: 30,
//             color: DefaultElements.knavbariconcolor,
//           ),
//           SvgPicture.asset(
//             "assets/icons/person.svg",
//             height: 30,
//             color: DefaultElements.knavbariconcolor,
//           ),
//         ],
//       ),
//     );
//   }
// }
