import 'package:chat_flutter/data.dart';
import 'package:chat_flutter/models/jasaUserData.dart';
import 'package:chat_flutter/models/user.dart';
import 'package:chat_flutter/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_flutter/Component/defaultElements.dart';
import 'package:chat_flutter/Models/ShoeListModel.dart';
import 'package:chat_flutter/shared/DetailScreen.dart';
import 'package:provider/provider.dart';

class JasaCards extends StatelessWidget {
  final ShoeListModel shoeListModel;

  final int index;

  const JasaCards({Key key, this.shoeListModel, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final List<String> jasaPictures = [];

    _convertPicturesObj(List<Object> obj){
      for(int i = 0; i < obj.length; i++){
        jasaPictures.add(obj[i].toString());
      }
    }

    return StreamBuilder<List<JasaUserData>>(
      stream: DatabaseService(uid: user.uid).jasaLists,
      builder: (context, snapshot) {

        if(snapshot.hasError){
                return Text(snapshot.error.toString());
              }
              else if(snapshot.hasData){
                List<JasaUserData> jasaList = snapshot.data;
                
                // print(jasauser.obj2);
                 return SingleChildScrollView(
                   child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: GestureDetector(
                          onTap: () {
                            _convertPicturesObj(jasaList[index].obj2);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                          jasaPictures: jasaPictures,
                                          price: jasaList[index].price,
                                          shoeName: jasaList[index].name,
                                          jasaUserId: jasaList[index].jasaUserId,
                                          rating: shoeListModel.rating,
                                          // showpersentage: shoeListModel.showpersentage,
                                          // activeheart: shoeListModel.activeheart,
                                          jasaDescription: jasaList[index].description,
                                          showcasebgcolor: shoeListModel.showcasebgcolor,
                                          lightShowcasebgcolor:
                                              shoeListModel.lightShowcasebgcolor,
                                        )));
                            print("Navigate to Detail Paage");
                          },
                          child: Container(
                            // now we dont want this fix height and width it was for demo
                            // height: 220,
                            // width: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                    color: DefaultElements.knavbariconcolor,
                                    offset: Offset(0, -1),
                                    blurRadius: 10)
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: 8,
                                    left: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      // shoeListModel.showpersentage
                                      //     ? Padding(
                                      //         padding: const EdgeInsets.only(
                                      //             top: 8, right: 8, left: 8),
                                      //         child: Container(
                                      //           height: 30,
                                      //           width: 50,
                                      //           decoration: BoxDecoration(
                                      //             color: DefaultElements.ksecondrycolor,
                                      //             borderRadius: BorderRadius.circular(10),
                                      //           ),
                                      //           child: Center(
                                      //             child: Text(
                                      //               "${shoeListModel.persentage}",
                                      //               style: TextStyle(
                                      //                   fontWeight: FontWeight.bold,
                                      //                   fontSize: 16),
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       )
                                      //     : Container(),
                                      // Expanded(
                                      //   child: Container(),
                                      // ),
                                      // Padding(
                                      //   padding: EdgeInsets.only(top: 5, right: 5, left: 5),
                                      //   child: Container(
                                      //     height: 30,
                                      //     width: 50,
                                      //     decoration: BoxDecoration(
                                      //       color: shoeListModel.activeheart
                                      //           ? DefaultElements.kdefaultredcolor
                                      //           : Colors.transparent,
                                      //       shape: BoxShape.circle,
                                      //     ),
                                      //     child: Center(
                                      //       child: SvgPicture.asset(
                                      //         "assets/icons/heart.svg",
                                      //         height: 20,
                                      //         color: shoeListModel.activeheart
                                      //             ? Colors.white
                                      //             : DefaultElements.knavbariconcolor,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ),
                                Image.network(
                                  "${jasaList[index].obj2[0].toString()}",
                                ),
                                // Stack(
                                //   children: [
                                //     Container(
                                //       height: 120,
                                //       width: 120,
                                //       decoration: BoxDecoration(
                                //         color: shoeListModel.showcasebgcolor,
                                //         shape: BoxShape.circle,
                                //       ),
                                //       child: Padding(
                                //         padding: EdgeInsets.all(8),
                                //         child: Container(
                                //           height: 120,
                                //           width: 120,
                                //           decoration: BoxDecoration(
                                //               color: shoeListModel.showcasebgcolor,
                                //               shape: BoxShape.circle,
                                //               border:
                                //                   Border.all(color: Colors.white, width: 2)),
                                //         ),
                                //       ),
                                //     ),
                                //     Positioned(
                                //       top: 20,
                                //       right: 5,
                                //       left: 0,
                                //       child: Hero(
                                //         tag: "${jasaList[0].obj2.toString()}",
                                //         child: CircleAvatar(
                                //           radius: 40,
                                //           backgroundImage: NetworkImage(jasaList[0].obj2.toString()),
                                //         )
                                //       ),
                                //     )
                                //   ],
                                // ),
                                Text(
                                  "${jasaList[index].name}",
                                  style: TextStyle(
                                    color: DefaultElements.kprimarycolor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${"Rp " + jasaList[index].price}",
                                  style: TextStyle(
                                    color: DefaultElements.kprimarycolor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
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
}

